<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.MessageException,
				tidemedia.cms.publish.*,
				java.sql.*,
				java.io.*"%>
<%@ page import="tidemedia.cms.base.TableUtil" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.awt.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    //终端调度分租户
%>
<%
    int		ChannelID	=	getIntParameter(request,"ChannelID");
    int		ItemID		=	getIntParameter(request,"ItemID");
    int		GlobalID	=	getIntParameter(request,"GlobalID");
    JSONObject json=new JSONObject();
    int  company= userinfo_session.getCompany();
    String message="";
    String wheresql=" where 1=1 ";
    if (company!=0){
        wheresql+=" and company="+company;//根据租户查询
        wheresql+=" and parent=16179";//查询所有
    }else{
        if (ChannelID!=0){
            wheresql+=" and id="+ChannelID;//根据频道查询
        }
    }

    if (company==0&&ChannelID==0){
        message="不是租户请填写需要具体调度频道";
        json.put("msg",message);
        out.print(json);
        return ;
    }

    TableUtil tu=new TableUtil();
    String sql = "select id, Name ,company from channel "+wheresql;
    ResultSet rs=tu.executeQuery(sql);
    JSONArray array=new JSONArray();
    int channelid=0;
    String name="";
    System.out.println("哈哈哈哈姓名："+sql);
    while (rs.next()){
        JSONObject jsonObject=new JSONObject();
        channelid=rs.getInt("id");
        int company2=rs.getInt("company");
        name=rs.getString("Name");
        jsonObject.put("id",channelid);
        jsonObject.put("company",company2);
        jsonObject.put("name",name);

    }
    System.out.println(channelid+"哈哈哈哈"+"姓名："+name);
    Channel ch = CmsCache.getChannel(channelid);

    ArrayList<Integer> list= ch.getChildChannelIDs();//是否有子频道
    String tabel="";//查询表
    String SiteAddress="";
    //没有子频道 查询当前频道的第一篇文章
    if (channelid>0&&list.size()==0){
        tabel =ch.getTableName();
        SiteAddress = ch.getSite().getExternalUrl();
        System.out.println("无子频道");

    }
    //如果有子频道，默认查询子频道第一个文章
    if (channelid>0&&list.size()>0){
        ch=CmsCache.getChannel(list.get(1));

        tabel =ch.getTableName();
        System.out.println("有子频道");
    }
    String itemsql="select * from "+tabel+" where Category="+channelid;
    System.out.println(itemsql);
    TableUtil tu_item=new TableUtil();
    ResultSet rs_item=tu_item.executeQuery(itemsql);
    String herf="";
    String herf3="";
    if (rs_item.next()){
        int  herf2= rs_item.getInt("GlobalID");
        Document document=new Document(herf2);
        herf= document.getFullHref();
        out.print(document.getTitle());
    }
    if(herf.equals("")){
        message="没有配置调度程序";
        json.put("msg",message);
        out.print(json);
        return ;
    }
    String Address=SiteAddress+herf;
%>
<script language=javascript>
    this.location = "<%=Address%>";
</script>
