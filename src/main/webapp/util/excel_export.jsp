<%@ page import="java.io.File,java.sql.*,tidemedia.cms.system.*,java.util.ArrayList,tidemedia.cms.base.*,tidemedia.cms.util.*,java.util.HashMap,org.json.JSONObject,tidemedia.cms.excel.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config.jsp"%><%!
	public static HashMap ClearFile(HashMap map) throws MessageException,SQLException{
		HashMap map_result=new HashMap();
		if(map!=null){
					//flag_exist_Template=true;
					String FileName=(String)map.get("excelname");
					String excelfolder=(String)map.get("excel_folder");
					//每次下载前自动检索/temp/目录下的excel文件，删除24小时以前内容
			
					long now_date = System.currentTimeMillis() / 1000;
						File file = new File(excelfolder);
						File[] filelist = file.listFiles();
						for (File ff : filelist) {
							if (ff.getName().startsWith("excel_")) {
								String name = ff.getName();
								long long_date = ff.lastModified()/1000;
				
								if (long_date < now_date - 86400) {
									ff.delete();
									}
								}
							}
				 	
					map_result.put("filename",FileName);
					map_result.put("message","");
				}else{
					map_result.put("message","excel文件生成出现错误,请查看系统日志。");
				}
		return map_result;
	}
	public ChannelTemplate getChannelTemplate(int ChannelID,String Template_flag)throws Exception{
		ChannelTemplate channeltemplate=new ChannelTemplate();
		try{
			
			Channel channel=CmsCache.getChannel(ChannelID);
			if(Template_flag==null||Template_flag.equals("")){
				channeltemplate=channel.getChannelTemplates(3,"excel");//3为附加页模板    excel为导出excel的专用模板标识
				
			}else{
				channeltemplate=channel.getChannelTemplates(3,Template_flag);//3为附加页模板    excel为导出excel的专用模板标识
				
			}
			
		}catch(Exception e){
			return channeltemplate;
		}
		return channeltemplate;
		
	}
%><%
		String tomcatPath = request.getRealPath("/");//获取tomcat所在目录
		int ChannelID=getIntParameter(request,"channelid");//频道编号
		String Html_txt=getParameter(request,"content");//HTML代码 直接用于生成Excel
        int templatefileid=getIntParameter(request,"templatefileid");//模板文件编号
		String Template_flag=getParameter(request,"label");//模板标识（为空则默认判断标识为excel的模板，不为空则按此标识判断）
		int id=0;//模板ID
		int active=0;//模板状态  0为禁止  1为启用
		
		HashMap map_result=new HashMap();//返回值map对象
		HashMap map=new HashMap();//获取后台程序返回值
		ChannelTemplate channeltemplate=new ChannelTemplate();
		boolean flag_exist_Template =false;   //频道中是否存在符合要求的模板
		
		channeltemplate=getChannelTemplate(ChannelID,Template_flag);//根据频道ID以及模板标识取出对应频道的模板对象
			id=channeltemplate.getId();//模板ID
			active=channeltemplate.getActive();//模板状态
				  
			tidemedia.cms.excel.ExcelDriver exceldriver=new tidemedia.cms.excel.ExcelDriver();
			if((id!=0||templatefileid!=0)&&ChannelID>0&&active==0){
				
				String newfilename=exceldriver.getflag_random()+".shtml";//获取随机文件名
				String fullname="";
				fullname=exceldriver.templateMerge(ChannelID,newfilename,channeltemplate,"utf-8",tomcatPath,templatefileid);
				if(!"".equals(fullname)){
					map=exceldriver.exportExcell(fullname,userinfo_session.getId(),tomcatPath,"");//生成excel并删除模板文件然后下载
					map_result=ClearFile(map);
				}else{
					map_result.put("message","excel模板有错误,请查看系统日志。");
				}
			}else if(Html_txt!=null&&!Html_txt.equals("")){
				map=exceldriver.exportExcell("",userinfo_session.getId(),tomcatPath,Html_txt);//生成excel并删除模板文件然后下载
				map_result=ClearFile(map);
			}else{
				map_result.put("message","没有找到对应的excel模板");
			}
		
		JSONObject json=new JSONObject(map_result);
		String result_str=json.toString();
		out.println(result_str);
%>
