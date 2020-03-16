<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*,
				java.text.SimpleDateFormat,
				javax.crypto.*,
				java.security.Key,
				java.io.*,
				java.net.*,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	/**
	 * 用户媒体审核更新到数据库
	 *
	 */

	TideJson tidejson = CmsCache.getParameter("juxian_api").getJson();
	String token = tidejson.getString("juxian_token");//父企业token
	String parentid = tidejson.getString("juxian_id");//父企业id
	String url = tidejson.getString("register_url");//	Cms注册接口地址
	String userUrl = tidejson.getString("user_register_url");//	Cms 注册终端用户接口地址
	String keyStr = token.substring(2);//密钥：企业access_token去掉开头两位
	String aes = "";
	//获取聚融接口
	String jurong = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/tcenter/api/jurong/v1.0/";

	String channel_SerialNo="register";//用户注册信息频道标识
	Channel channel1=CmsCache.getChannel(channel_SerialNo);
	String tablename1 = channel1.getTableName();
	int id = getIntParameter(request,"id");
	String itemid = getParameter(request,"itemid");
	System.out.println("itemid："+itemid);
	String[] itemid_ = itemid.split(",");
	System.out.println("itemid_.length："+itemid_.length);
	Channel channel = CmsCache.getChannel(id);
	String tablename = channel.getTableName();
	TableUtil tu = new TableUtil();
	JSONObject json = new JSONObject();
	String sql = "";
	String phone = "";
	String username = "";
	String passwd = "";
	int jushi_userid = 0;
	int type = 0;
	for(int i=0;i<itemid_.length;i++){
		Document doc = CmsCache.getDocument( Integer.parseInt(itemid_[i]),id);
		jushi_userid = doc.getIntValue("jushi_userid");
		int juxian_userid = doc.getIntValue("juxian_userid");
		int company_id = doc.getIntValue("company_id");
		type = doc.getIntValue("Type");
		if(jushi_userid==0){//为后台新建企业
			if(type==0&&juxian_userid==0){//个人类型未填写juxian_userid
				json.put("status","失败");
				json.put("message","请填写聚现用户id");
				out.println(json);
				return;
			}
			if(type==1&&company_id==0){//企业类型未填写company_id
				json.put("status","失败");
				json.put("message","请填写企业id");
				out.println(json);
				return;
			}
			sql = "update "+ tablename+" set Status1=1 where id in(" + itemid + ") and Status1=0";
			tu.executeUpdate(sql);
			json.put("status","success");
			json.put("message","修改成功");
			out.println(json);
			return;
		}
		Document doc1 = CmsCache.getDocument(jushi_userid,channel1.getId());
		phone = doc1.getValue("phone");
		username = doc1.getTitle();
		//passwd =StringUtils.getMD5(doc1.getValue("password"));//密码双md5加密
		passwd = doc1.getValue("password");//数据库密码已加密，不需要再次处理
		System.out.println("原始次:"+passwd);
		if (passwd.equals("")){
			passwd="123456";
			System.out.println("第一次:"+passwd);
			passwd=StringUtils.getMD5(StringUtils.getMD5(passwd));//
			System.out.println("第一次:"+passwd);
		}
		aes = phone+parentid;//加密字符串为手机号+企业编号
		token = Util.AES_Encrypt(keyStr,"",aes);
		if(type==0){
			url = userUrl+"?phone="+URLEncoder.encode(phone)+"&passwd="+URLEncoder.encode(passwd)+"&username="+URLEncoder.encode(username)+
					"&uid="+URLEncoder.encode(doc.getValue("jushi_userid"))+"&company_id="+URLEncoder.encode(parentid)+"&token=" + URLEncoder.encode(token)+"&code=" + URLEncoder.encode(doc.getValue("company_code"));
			/*url = userUrl+"?phone="+phone+"&passwd="+passwd+"&username="+username+
					"&uid="+doc.getValue("jushi_userid")+"&company_id="+parentid+"&token=" + token;*/
			System.out.println("type=0url:"+url);
		}else if(type ==1){
			url = url+"?phone="+URLEncoder.encode(phone)+"&passwd="+URLEncoder.encode(passwd)+"&name="+URLEncoder.encode(doc.getTitle())+
					"&token=" + URLEncoder.encode(token)+"&jurong="+URLEncoder.encode(jurong)+"&id="+URLEncoder.encode(parentid);
			System.out.println("type=1url:"+url);
		}
		String result = connectHttpUrl(url,"utf-8");
		System.out.println("调用结果:"+result);
		JSONObject jsonresult = new JSONObject(result);
		System.out.println("调用结果jsonresult:"+result);
		if(jsonresult.getInt("code")==200){
			sql = "update "+ tablename+" set juxian_userid=" +((JSONObject)jsonresult.get("result")).getInt("uid") + " , company_id=" +((JSONObject)jsonresult.get("result")).getInt("id") +" where id =" + itemid_[i] ;
			System.out.println("更新sql："+sql);
			tu.executeUpdate(sql);
			sql = "update "+ tablename+" set Status1=1 where id in(" + itemid + ") and Status1=0";
			tu.executeUpdate(sql);
			json.put("status","success");
			json.put("message","修改成功");
			out.println(json);
		}else if(jsonresult.getInt("code")==500){
			json.put("status","失败");
			json.put("message",jsonresult.getString("message"));
			out.println(json);
		}

	}




%>
<%!
	public static String connectHttpUrl(String url,String charset)
	{
		String content = "";
		String sCurrentLine = "";
		URL l_url;
		try {
			if(charset.length()==0) charset = "utf-8";
			l_url = new URL(url);
			HttpURLConnection con = (HttpURLConnection) l_url.openConnection();
			HttpURLConnection.setFollowRedirects(true);
			con.setConnectTimeout(60000);//连接超时,1分钟,防止网络异常，程序僵死
			con.setReadTimeout(60000);//读操作超时,1分钟
			con.setInstanceFollowRedirects(true);//支持重定向
			con.connect();
			InputStream l_urlStream = con.getInputStream();
			BufferedReader l_reader = new BufferedReader(new InputStreamReader(l_urlStream,charset));
			while ((sCurrentLine = l_reader.readLine()) != null)
			{
				content+=sCurrentLine + "\r\n";
			}
		} catch (MalformedURLException e) {
			System.out.println("cann't connect " + url);
			e.printStackTrace(System.out);
		} catch (IOException e) {
			System.out.println("cann't connect " + url);
			e.printStackTrace(System.out);
		}

		return content;
	}
%>
