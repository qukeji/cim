<%@ page import="tidemedia.cms.util.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				org.json.*,
				java.io.*,
				java.util.*,
				java.sql.ResultSet,
				java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%
/*
新建编辑活动*/
try {
	out.print((handleDate(request).toString()));
} catch (Exception e) {
	JSONObject  jsonObject = new JSONObject();
	jsonObject.put("code","500");
	jsonObject.put("message","异常:"+e.toString());
	out.println(jsonObject.toString());
	e.printStackTrace();
}
%>
<%!
    public JSONObject handleDate(HttpServletRequest request) throws Exception{
        JSONObject jsonObject = new JSONObject();
        if("POST".equals(request.getMethod())){
            BufferedReader streamReader = new BufferedReader( new InputStreamReader(request.getInputStream()));
            StringBuilder responseStrBuilder = new StringBuilder();
            String inputStr;
            while ((inputStr = streamReader.readLine()) != null) responseStrBuilder.append(inputStr);
            JSONObject json = new JSONObject(responseStrBuilder.toString());
            jsonObject = enteringDate(json);
        }else{
            jsonObject.put("message","请求方式不对");
            jsonObject.put("code",500);
        }
        return jsonObject;
    }

    public JSONObject enteringDate(JSONObject data) throws Exception {
        JSONObject reJson = new JSONObject();

		int  company_id =0;//聚现企业编号
        if(data.has("company_id")){
            company_id = data.getInt("company_id");
        }

		//获取聚现信息
        String sys_config = CmsCache.getParameterValue("sync_juxian_live");
        JSONObject ConfigObject = new JSONObject(sys_config);

		//cms多站点
        JSONArray SiteList = ConfigObject.getJSONArray("list");
        if(SiteList.length()==0){
            reJson.put("code",500);
            reJson.put("message","同步站点库不存在");
            return reJson;
        }
		//获取cms多站点下对应的媒体号频道
		String CurrentSourceChannel = "";
        for (int i = 0; i < SiteList.length(); i++) {
            JSONObject SiteObject = SiteList.getJSONObject(i);
            int SiteId = SiteObject.getInt("site");

            // 判断该文章所属校园号是否有通过审核
			boolean company_exist = false;
			TableUtil tu_company = new TableUtil();
            String sql_company = "select * from channel_company_s" + SiteId + "_info where company_id="+company_id+" and status=1 ";
            ResultSet rs_company = tu_company.executeQuery(sql_company);
            if (rs_company.next()) {
                company_exist = true;
            }
            tu_company.closeRs(rs_company);

            // 校园号已通过审核
            if (company_exist) {
                // 获取媒体号内容管理频道id
				int sourcechannelid = 0;
                TableUtil tu_source = new TableUtil();
                String sql_source = "select id from channel  where SerialNo='company_s" + SiteId + "_source' ";
                ResultSet rs_source = tu_source.executeQuery(sql_source);
                if(rs_source.next()) {
                    sourcechannelid = rs_source.getInt("id");
                }
                tu_source.closeRs(rs_source);

				//获取企业对应的内容稿池频道
				Channel ch = CmsCache.getChannel(sourcechannelid);
                ArrayList<Channel> ListChannel = ch.listAllSubChannels();// 取下面全部子频道
                for (Channel chone : ListChannel) {
					if(!chone.getExtra2().startsWith("{")){
						continue;
					}
                    JSONObject jsonEx = new JSONObject(chone.getExtra2());
					//企业编号 终端用户
                    if((jsonEx.has("company")&&(jsonEx.getInt("company")==company_id))||(jsonEx.has("user")&&(jsonEx.getInt("user")==data.getInt("uid")))){
						if(!CurrentSourceChannel.equals("")){
							CurrentSourceChannel += ",";
						}
                        CurrentSourceChannel += chone.getId();
                    }
                }
            }
        }

		if(CurrentSourceChannel.equals("")){
            reJson.put("code",500);
            reJson.put("message","同步库不存在");
            return reJson;
        }
		String[] CurrentSourceChannels = CurrentSourceChannel.split(",");
		for(int j=0;j<CurrentSourceChannels.length;j++){
			int CurrentSourceChannel_id = Integer.parseInt(CurrentSourceChannels[j]);//媒体号频道id
			
			//当前时间
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			long lt = new Long(data.getString("modify_date"));
			Date date = new Date(lt*1000);
			String dateStr = simpleDateFormat.format(date);
			//数据入库
			HashMap map = new HashMap();
			map.put("Title", data.getString("title"));
			map.put("juxian_companyid", data.getString("company_id"));
			map.put("ModifiedDate", dateStr);
			map.put("juxian_user", data.getString("user"));
			map.put("Photo4", data.getString("photo"));
			map.put("live_shareurl",  data.getString("app_url"));
			map.put("state", data.getString("state"));
			map.put("juxian_liveid",data.getString("id"));
			map.put("doc_type","4");

            TableUtil tu_exist = new TableUtil();
          
            String sql_exist = "select * from "+CmsCache.getChannel(CurrentSourceChannel_id).getTableName()+" where Active=1 and Category="+CurrentSourceChannel_id+" and juxian_companyid="+company_id+" and juxian_liveid="+data.getString("id");
            System.out.println("sql_exist:"+sql_exist);
            ResultSet rs_exist = tu_exist.executeQuery(sql_exist);
			ItemUtil it = new ItemUtil();
			if (rs_exist.next()) {
				int globalid = rs_exist.getInt("globalid");
				String ModifyDate = rs_exist.getString("ModifiedDate");
				Long ts = new Long(ModifyDate);
				Long tm = new Long(data.getLong("modify_date"));
				if (ts <tm){
					map.put("ModifiedDate", tm+"");
					System.out.println("存在:"+sql_exist);
					System.out.println("存在globalid:"+globalid);
					System.out.println("CurrentSourceChannel_id:"+CurrentSourceChannel_id);
					it.updateItemByGid(CurrentSourceChannel_id,map,globalid,0);
					reJson.put("code",200);
					reJson.put("message","更新成功");
					if(rs_exist.getInt("status")==1){
						//发布
						Document document = new Document();
						document.Approve(rs_exist.getString("id"),CurrentSourceChannel_id);
					}
				}else{
					System.out.println("数据库数据修改时间小于数据修改时间:");
					reJson.put("code",200);
					reJson.put("message","数据库数据修改时间小于数据修改时间");
				}
			}else{
			    System.out.println("bu存在:"+sql_exist);
				map.put("juxian_type",3+"");
				it.addItemGetGlobalID(CurrentSourceChannel_id, map);
				reJson.put("code",200);
				reJson.put("message","创建成功");
			}
			tu_exist.closeRs(rs_exist);
        }
        return reJson;
    }
%>


