<%@ page import="tidemedia.cms.system.*,org.json.*,java.sql.*,tidemedia.cms.base.*,java.io.*,tidemedia.cms.util.*,java.util.*,java.net.URLEncoder"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%!
	public JSONArray listFile_json(tidemedia.cms.user.UserInfo userinfo_session) throws SQLException,JSONException, MessageException, UnsupportedEncodingException
	{

		JSONArray array = new JSONArray();

		int sitenumber = 0;
		String icon = "../images/tree/16_channel_site_icon.png";

		String sql = "select count(*) from channel where Parent=-1 and Type=5";

		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);
		if (rs.next())
		  sitenumber = rs.getInt(1);
		tu.closeRs(rs);

		sql = "select Site,id from channel where Parent=-1 and Type=5 order by OrderNumber,id";

		TableUtil tu1 = new TableUtil();
		rs = tu1.executeQuery(sql);
		while (rs.next())
		{
			JSONObject o = new JSONObject();

			int SiteId = rs.getInt("Site");
			if(userinfo_session.isSiteAdministrator())
			{
				if(!userinfo_session.getSite().equals(SiteId+""))
					continue;
			}

			Site site = CmsCache.getSite(SiteId);
				
			int channelID = rs.getInt("id");
			Channel channel = CmsCache.getChannel(channelID);

			//当前登录用户绑定了租户,站点不是公共站点,用户无站点权限，
			if(userinfo_session.getCompany()!=0&&(!channel.getApplication().equals("publishsite"))&&(userinfo_session.getCompany()!=site.getCompany())){
				continue ;
			}

			if (site != null)
			{
				String Name = Util.JSQuote(convertNull(site.getName()));

				o.put("name",Name);
				o.put("folderName","/");
				o.put("icon",icon);
				o.put("siteId",SiteId);

				if (sitenumber == 1)
				{
					o.put("load",0);

					String RealPath = Util.JSQuote(convertNull(site.getSiteFolder()));

					File file = new File(site.getSiteFolder());
					File[] files = file.listFiles();
					Arrays.sort(files);

					if (files != null)
					{
						JSONArray array1 = new JSONArray();

						for (int i = 0; i < files.length; ++i)
						{
						
							JSONObject o1 = new JSONObject();

							String FolderName = Util.JSQuote(files[i].getName());

							if ((files[i].isDirectory()) && (!(files[i].getName().equals("cms"))) && (!(files[i].getName().equalsIgnoreCase("WEB-INF"))))
							{
								if (Util.isHasSubFolder(site.getSiteFolder() + "/" + FolderName))
								{
									o.put("load",1);
								}
								else
								{
									o.put("load",0);
								}
								o1.put("folderName",FolderName);
								o1.put("id",SiteId);
								o1.put("name",Name);
								o1.put("icon",icon);
								array1.put(o1);
							}
						}
						o.put("child",array1);
					}
				}	
				else{
					o.put("load",1);
				}
				array.put(o);
			}
		}
		tu1.closeRs(rs);		
		return array;
	}
%>
<%
long begin_time = System.currentTimeMillis();
JSONArray o2 = listFile_json(userinfo_session);
out.println(o2);
%>
