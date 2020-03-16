<%@ page import="java.sql.*,tidemedia.cms.base.*,java.util.Calendar"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!
void AddNumber(TableUtil t,String Data,String TableName,String CompareField,String AddField) throws SQLException,MessageException
{
    String Sql="Select * From " + TableName + " Where " + CompareField + "='" + t.SQLQuote(Data) + "'";
	ResultSet Rs = t.executeQuery(Sql);
	if(Rs.next())
	{
		int id = Rs.getInt("id");
		Sql = "update " + TableName + " set " + AddField + "=" + AddField + "+1 where id=" + id;
		//System.out.println(Sql);
		t.executeUpdate(Sql);
	}
	else
	{
		Sql = "insert into " + TableName + " (" + CompareField + "," + AddField + ") values('" + t.SQLQuote(Data) + "',1)";
		t.executeUpdate(Sql);
	}
	t.closeRs(Rs);
}
%>
<%
String IP = request.getRemoteAddr();
//String Referer = request.getHeader("Referer");
String Referer = getParameter(request,"Referer");
String PageName = getParameter(request,"PageName");
String Sql = "";
ResultSet Rs;
TableUtil tu = new TableUtil();

if(Referer==null || Referer.equals(""))
	Referer = "";//直接输入或书签导入

int Width = getIntParameter(request,"Width");
int Height = getIntParameter(request,"Height");
String Screen = "";
if(Width==0 || Height==0)
	Screen = "";//其它
else
	Screen = Width + "x" + Height;

String _System = getParameter(request,"System");
String Browser = getParameter(request,"Browser");
/*
       java.util.Enumeration e = request.getHeaderNames();
        while (e.hasMoreElements()) {
            String name = (String)e.nextElement();
            String value = request.getHeader(name);
            out.println(name + " = " + value);
        }
*/
%>
<%
		Sql = "insert into counter_visit (";
		
		Sql += "IP,Browser,System,Screen,Referer,PageName,VisitDate";
		Sql += ") values(";
		Sql += "'" + tu.SQLQuote(IP) + "'";
		Sql += ",'" + tu.SQLQuote(Browser) + "'";
		Sql += ",'" + tu.SQLQuote(_System) + "'";
		Sql += ",'" + tu.SQLQuote(Screen) + "'";
		Sql += ",'" + tu.SQLQuote(Referer) + "'";
		Sql += ",'" + tu.SQLQuote(PageName) + "'";
		Sql += ",now()";
		
		Sql += ")";
		//System.out.println(Sql);
		tu.executeUpdate(Sql);

java.util.Calendar nowDate = new java.util.GregorianCalendar();
int year = nowDate.get(Calendar.YEAR);
int month = nowDate.get(Calendar.MONTH) + 1;
int day = nowDate.get(Calendar.DATE);
int hour = nowDate.get(Calendar.HOUR_OF_DAY);
int yearweek = nowDate.get(Calendar.WEEK_OF_YEAR);
int week = nowDate.get(Calendar.DAY_OF_WEEK);

Sql = "select TotalNumber,StartDate,OldHour,OldDay,OldMonth,HourNumber,DayNumber,MonthNumber,HourMaxNumber,DayMaxNumber,MonthMaxNumber from counter_info_list";
Rs = tu.executeQuery(Sql);
if(Rs.next())
{
	int TotalNumber = Rs.getInt("TotalNumber");
	String StartDate = convertNull(Rs.getString("StartDate"));
	String OldHour = convertNull(Rs.getString("OldHour"));
	String OldDay = convertNull(Rs.getString("OldDay"));
	String OldMonth = convertNull(Rs.getString("OldMonth"));
	int HourNumber = Rs.getInt("HourNumber");
	int DayNumber = Rs.getInt("DayNumber");
	int MonthNumber = Rs.getInt("MonthNumber");
	int HourMaxNumber = Rs.getInt("HourMaxNumber");
	int DayMaxNumber = Rs.getInt("DayMaxNumber");
	int MonthMaxNumber = Rs.getInt("MonthMaxNumber");

	Sql = "update counter_info_list set TotalNumber="+(TotalNumber+1);
	if(StartDate.equals(""))
		Sql += ",StartDate=now()";

	if(OldHour.equals(year+"-"+month+"-"+day+" "+hour+":00:00"))
	{
		Sql += ",HourNumber=HourNumber+1";
	}
	else
	{
		Sql += ",HourNumber=1,OldHour='"+(year+"-"+month+"-"+day+" "+hour+":00:00")+"'";
	}
	if(OldDay.equals(year+"-"+month+"_"+day))
	{
		Sql += ",DayNumber=DayNumber+1";
	}
	else
	{
		Sql += ",DayNumber=1,OldDay='"+(year+"-"+month+"-"+day)+"'";
	}
	if(OldMonth.equals(year+"-"+month))
	{
		Sql += ",MonthNumber=MonthNumber+1";
	}
	else
	{
		Sql += ",MonthNumber=1,OldMonth='"+(year+"-"+month)+"'";
	}
	if(HourNumber+1>HourMaxNumber)
		Sql += ",HourMaxNumber="+(HourNumber+1)+",HourMaxTime='"+(year+"-"+month+"-"+day+" "+hour+":00:00")+"'";
	if(DayNumber+1>DayMaxNumber)
		Sql += ",DayMaxNumber="+(DayNumber+1)+",DayMaxDate='"+(year+"-"+month+"-"+day)+"'";
	if(MonthNumber+1>MonthMaxNumber)
		Sql += ",MonthMaxNumber="+(MonthNumber+1)+",MonthMaxDate='"+(year+"-"+month)+"'";

	tu.executeUpdate(Sql);

}
tu.closeRs(Rs);

AddNumber(tu,_System,"counter_system","System","SystemNumber");
AddNumber(tu,Screen,"counter_screen","Screen","ScreenNumber");
AddNumber(tu,Referer,"counter_referer","Referer","RefererNumber");
AddNumber(tu,Browser,"counter_browser","Browser","BrowserNumber");
AddNumber(tu,year+"","counter_stat_year","Year","Month"+month);
AddNumber(tu,year+"-"+month,"counter_stat_month","Month","Day"+day);
AddNumber(tu,"Total","counter_stat_month","Month","Day"+day);
AddNumber(tu,year+"-"+yearweek,"counter_stat_week","Week","Week"+week);
AddNumber(tu,"Total","counter_stat_week","Week","Week"+week);
AddNumber(tu,"Total","counter_stat_day","Day","Hour"+(hour+1));
AddNumber(tu,year+"-"+month+"-"+day,"counter_stat_day","Day","Hour"+(hour+1));

%>
