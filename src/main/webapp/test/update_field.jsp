<%@ page import="java.sql.*,tidemedia.cms.system.*,tidemedia.cms.base.*,tidemedia.cms.util.*,java.util.ArrayList"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config1.jsp"%>
<%

		//String oldsrc="http://123.125.148.27:5001";
		//String newsrc="http://114.112.56.222:5001";

		String old_src="http://115.29.150.217";
		String new_src="http://101.200.83.135";
		
		//String old_src1="http://58.135.108.36:81/";
		//String new_src1="http://www.tibet.cn/";
		
		//String Channel_="3,177,288,5703,5704,5706,5714,5715,5716,5717,7030,7033,7119,7707,7710,7711,7712,7750,9761,11648,11650,11651,11652,11663,11688,11731,11733,11734,11735,11746,11771,11772,11774,11775,11776,11787,11812,11813,11815,11816,11817,11828,11853,13097,13451,13457,13459,13460,13461,13472,13497,13498,13499,13500,13501,13503,13539,13933,13934,13939,13944,13950,13951,13952,13953,13954,13955,13993,13995,13997,13998,13999,14010,14035,14041,14042,14047,14052,14058,14059,14060,14061,14062,14063,14065,14066,14071,14076,14082,14083,14084,14085,14086,14087,14089,14090,14095,14100,14106,14107,14108,14109,14110,14111,14113,14114,14119,14124,14130,14131,14132,14133,14134,14135,14224,14227,14228,14229,14231,14239,14247,14250,14256,14257,22150,22151,22184,22186,22188,22246,22268,22279,22293,22318,22337,22363,22378,24371,25465,25468,25472,25588,25589,25651,26130,26140,28385,28393,28678,28680,28719,30474,30476,30478,30479,30480,30484,30488,30501,30503,30505,30513,30514,30516,30520,30521,30522,30529,30531,30532,30557,30632,30647,30673,30770,30771,30775,30784,30791,32534,32535,32536,32537,32538,32539,32540,32542,32543,32551,32554,32556,32557,32558,32569,32576,32577,32580,32648,32649,32678,32681,32682,32685,32688,32689,32700,32711,32722,32723,32752,32774,32780,32804,32809,32810,32831,32832,32837,32838,32841,32919,32921,32922,32925,32929,32931,32932,32935,32937,32939,32940,32943,32963,32965,32966,32967,32978,33003,33028,33033,33035,33036,33038,33039,33041,33042,33043,33049,33148,33179,33182,33183,33193,33195,33196,33197,33297,33299,33316,33339,34354,34355,34359,34360,34361,34362";
		//String Channel_="14145,14175,14188,14193,14198,14199,14212,14213,14214";
		String Channel_="14197";
		String[] Channel_group=Channel_.split(",");
		try{
		for(String id:Channel_group){
		TableUtil tu=new TableUtil();
		ResultSet rs=tu.executeQuery("select * from "+CmsCache.getChannel(Util.parseInt(id)).getTableName()+" where  active=1 ");
		//ResultSetMetaData   rsmd1 = rs.getMetaData();
		//int field_count=rsmd1.getColumnCount();
		ArrayList<Field> arr=new Channel(Util.parseInt(id)).getFieldInfo();
		while(rs.next()){
			int globalid=rs.getInt("id");
			boolean  flag_approve=false;
			for(Field fi:arr){
				String field_name=fi.getName();
				String value=rs.getString(field_name);//字段值
				//替换
				if(value!=null&&!value.equals("")){
					
					if(value.indexOf(old_src)!=-1){
						String new_field=value.replace(old_src, new_src);
						//new_field=new_field.replace(old_src1, new_src1);
						
						//flag_approve=true;
						TableUtil tu_=new TableUtil();
						String sql="update "+CmsCache.getChannel(Util.parseInt(id)).getTableName()+" set "+field_name+"='"+Util.SQLQuote(new_field)+"' where id="+globalid+"";
						//System.out.println("--------"+sql+"</br>");
						out.println("--------"+sql+"</br>");
						tu_.executeUpdate(sql);
					
					
					}
				
				}
			}
			/*if(flag_approve){
				Document doc=new Document(globalid);
				doc.setUser(187);
				doc.Approve(doc.getId()+"",doc.getChannelID());
				System.out.println("----发布了"+doc.getId()+"======"+doc.getChannelID());
			}
			*/
		}
		tu.closeRs(rs);
		}
		}catch(Exception e){
			out.println(e.toString());
		}
	/*
	
	
	int count=0;
	String Channel_="14341,14343,14344,14346,14381,14350,14407,14412";
	for(){
	TableUtil video=new TableUtil();
	String sql_video="select * from "+CmsCache.getChannel(8800).getTableName()+" where active=1  order by id desc";
	ResultSet rs=video.executeQuery(sql_video);
	while(rs.next()){
		count++;
		String Photo=rs.getString("photo");
		String Photo_new=Photo.replace(oldsrc,newsrc);
		int globalid=rs.getInt("globalid");
		TableUtil video_update=new TableUtil();
		String sql_update="update "+CmsCache.getChannel(8800).getTableName()+" set photo='"+Photo_new+"' where globalid="+globalid+" ";
		video_update.executeUpdate(sql_update);
		System.out.println("--------"+count);
	}
	video.closeRs(rs);
	}
	*/
	/*	
	TableUtil video=new TableUtil();
	String sql_video="select * from "+CmsCache.getChannel(15102).getTableName()+" where active=1 order by id desc";
	ResultSet rs=video.executeQuery(sql_video);
	while(rs.next()){
		count++;
		String Photo=rs.getString("photo");
		String Photo_new=Photo.replace(oldsrc,newsrc);
		int globalid=rs.getInt("globalid");
		TableUtil video_update=new TableUtil();
		String sql_update="update "+CmsCache.getChannel(15102).getTableName()+" set photo='"+Photo_new+"' where globalid="+globalid+" ";
		video_update.executeUpdate(sql_update);
		System.out.println("--------"+count);
	}
	video.closeRs(rs);
	*/
%>
