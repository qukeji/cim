<%@page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.util.HashMap,
				org.json.JSONArray,
				org.json.JSONObject,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@ include file="../config1.jsp"%>
<%!
	public int channelid=16740;
	public float getFParameter(HttpServletRequest request,String str)
	{
		String tempstr = getParameter(request,str);
		if(tempstr.equals(""))
			return 0;
		else
			{
				float i = 0;
				try{
					i = Float.valueOf(tempstr);
				}catch(Exception e){}
				return i;
			}
	}
	//0 版面对应的文章不存在  1 该文章未绑定  2  该文章已绑定
	public  int isBind(int parentid,int globalid)throws MessageException, SQLException{	
		 ArrayList<Document> doclists = ItemUtil.listItems(channelid, " where active=1 and GlobalID="+globalid+" and Parent="+parentid+" and isBind=1");
		 ArrayList<Document> doclists2 = ItemUtil.listItems(channelid, " where active=1 and GlobalID="+globalid+" and Parent="+parentid+" and isBind=0");
		if(doclists.size()>0){
			return 2;
		}else{
			if(doclists2.size()>0){
			    return 1;
			}else{
                            return 0;
                        }
			
		} 		
	}
	public  boolean changeColumn(int globalid,float top,float low,float left,float right)throws MessageException,SQLException{
		String Table =CmsCache.getChannel(channelid).getTableName();
		String sql ="update "+Table+" set isBind=1";
		if(0!=top){
			sql+=" ,toplength="+top;
		}
		if(0!=low){
			sql+=",lowlength="+low;
		}
		if(0!=left){
			sql+=",leftlength="+left;
		}
		if(0!=right){
			sql+=",rightlength="+right;
		}
		sql+=" where GlobalID="+globalid;
                System.out.println("sql:"+sql);
		TableUtil tu = new TableUtil();
		int i =tu.executeUpdate(sql); 
                if(i>0){
                    return true;
                }else{
                    return false;
                }
		
	}


%>
<%

	int id = getIntParameter(request,"id");        //版面
	int docid = getIntParameter(request,"docid");  //具体文章
	float top = getFParameter(request,"top");
	float bottom = getFParameter(request,"bottom");
	float left = getFParameter(request,"left");
	float right = getFParameter(request,"right");
	JSONObject json =new JSONObject();
	int b=isBind(id,docid);
      System.out.println("bind:"+b);
	//为被绑定的才能编辑
	if(b==1){
                boolean flag =false;
                try{
		  flag =changeColumn(docid,top,bottom,left,right);
                }catch(Exception e){
                   e.printStackTrace();
                }
		if(flag){
			json.put("status",1);
			json.put("message","绑定成功");
		}else{
			json.put("status",0);
			json.put("message","绑定失败");
		}
	}else if(b==2){
		json.put("status",0);
		json.put("message","该文章已被绑定，请选择其他文章");
	}else {
		json.put("status",0);
		json.put("message","对应版面的文章不存在");
	}
	out.print(json);
%>

