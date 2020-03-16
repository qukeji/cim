<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
        <%@ page contentType="text/html;charset=utf-8" %>
        <%@ include file="../../config1.jsp"%>
        <%
            //问政详情
        %>
        <%!
            public HashMap<String,Object> politicList(int id){
                HashMap <String,Object> map=new HashMap<String,Object>();
                try{
                    if (id==0){
                        map.put("status",500);
                        map.put("message","缺少参数");
                    }else {
                        //arr保存问政回复内容数组
                        JSONArray arr = new JSONArray();
                        Document doc = new Document(id);
                        String title=doc.getTitle();
                        int Status2=doc.getIntValue("Status2");
                        
                        String status_="";
                        if(Status2==0){
                            status_="待办理";
                        }else if (Status2==1){
                            status_="办理中";
                        }else if (Status2==2){
                            status_="已办理";
                        }
                        int Type=1;
                        String Type_="";
                        if (Type==1){
                            Type_="投诉";
                        }else if (Type==2){
                            Type_="咨询";
                        }else if (Type==3){
                            Type_="问题";
                        }else  if (Type==4){
                            Type_="建议";
                        }else if(Type==5){
                            Type_="反馈";
                        }
                        
                        JSONObject o = new JSONObject();
                        o.put("Title",title);
                        o.put("Status2",status_);
                        o.put("type",Type_);
                        o.put("CreateDate",doc.getCreateDate());
                        //部门名称
                        //int channelId = doc.getChannelID();
                        //String channelName = CmsCache.getChannel(doc.getChannelID()).getName();
                        int categoryID = doc.getCategoryID();
                        String channelName = CmsCache.getChannel(categoryID).getName();
                        if(categoryID==0){
                            channelName = CmsCache.getChannel(doc.getChannelID()).getName();
                        }
                        o.put("channelName",channelName);  
                        o.put("ModifiedDate",doc.getModifiedDate());
                        o.put("Summary",doc.getSummary());
                        o.put("evaluation",doc.getIntValue("evaluation"));
                        //o.put("id",doc.getId());
                        
                        //获取回复内容和问题
                        TideJson politicsreason = CmsCache.getParameter("politicsreason").getJson();//问题详情接口信息
                        int channelid = politicsreason.getInt("politicsreasonid");//问题详情编号信息
                        Channel channel1 = CmsCache.getChannel(channelid);
                        String sql1="select handler,operation,reason,Summary,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,CreateDate from "+channel1.getTableName()+" where active=1 and parent="+id+" ORDER BY CreateDate asc";
                        TableUtil tu = new TableUtil();
                        ResultSet rs1 = tu.executeQuery(sql1);    
                        while(rs1.next()){
                            JSONObject o2 = new JSONObject();
                            String  Reason=convertNull(rs1.getString("reason"));
                            String  handler=convertNull(rs1.getString("handler"));
                            int operation=rs1.getInt("operation");
                            String operationDesc = "";
                            if(operation==1){
                                operationDesc="提交";
                            }else if(operation==2){
                                operationDesc="审核未通过";
                            }else if(operation==3){
                                operationDesc="转交";
                            }else if(operation==4){
                                operationDesc="平台回复";
                            }else if(operation==5){
                                operationDesc="退回";
                            }else if(operation==6){
                                operationDesc="开始办理";
                            }else if(operation==7){
                                operationDesc="回复";
                            }else if(operation==8){
                                operationDesc="结束";
                            }else if(operation==9){
                                operationDesc="用户回复";
                            }
	                        String ModifiedDate	= convertNull(rs1.getString("ModifiedDate"));
	                        ModifiedDate=Util.FormatDate("yyyy-MM-dd HH:mm",ModifiedDate);

                            
                            if(Reason!=""){
                                o2.put("reason",Reason);
                                o2.put("operation",operationDesc);
                                o2.put("handler",handler);
                                o2.put("ModifiedDate",ModifiedDate);
                                arr.put(o2);
                            }
                         }
                        
                        o.put("reply",arr);
                        map.put("status", 200);
                        map.put("message", "成功");
                        map.put("result",o);
                    }  
                }catch (Exception e){
                    map.put("status",500);
                    map.put("message","程序异常");
                }

                return map;
            }
        %>

        <%
			String callback=getParameter(request,"callback");

            JSONObject json = new JSONObject();
           

            int id = getIntParameter(request,"id");
            int data_type = getIntParameter(request,"data_type");
            int status=getIntParameter(request,"status2");
            if(data_type==0) data_type=2 ;

            HashMap<String, Object> map = politicList(id);
            json = new JSONObject(map);
            out.println(callback+"("+json.toString()+")");
        %>
