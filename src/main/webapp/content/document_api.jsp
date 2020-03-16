<%@ page import="tidemedia.cms.system.*,
				org.json.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				java.util.*,
				java.sql.*,
				tidemedia.cms.user.UserInfo,
				java.net.URLEncoder"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%!
public String getDisplayHtml2018(Field field,Document doc) throws SQLException, MessageException{

    String html = "";
    String value = (doc != null) ? doc.getValue(field.getName()) : field.getDefaultValue();
    String blank_class = "";
    if (field.getDisableBlank() == 1)
    {
      blank_class = "disable_blank";
    }

    if (field.getHtmlTemplate().length() > 0)
    {
      html = getDisplayHtmlTemplate2018(field,value);
      if (html.contains("$displayhtml"))
      {
        String html2 = "<div class=\"article-title mg-l-15 mg-b-15 pd-r-30\" id=\"tr_" + field.getName() + "\"><div class=\"row flex-row align-items-center\"><label class=\"left-fn-title wd-110 " + blank_class + "\" id='desc_" + field.getName() + "'>" + field.getDescription() + ":</label><label class=\"wd-500\" id=\"field_" + field.getName() + "\">" + field.getDisplayHtml_(value) + "</label></div></div>";

        html = html.replace("$displayhtml", html2);
      }
    }
    else
    {
      html = "<div class=\"article-title mg-l-15 mg-b-15 pd-r-30\" id=\"tr_" + field.getName() + "\"><div class=\"row flex-row align-items-center\"><label class=\"left-fn-title wd-110 \" id='desc_" + field.getName() + "'>" + field.getDescription() + ":</label>";

      html = html + "<label class=\"wd-500 " + blank_class + "\" id=\"field_" + field.getName() + "\">" + field.getDisplayHtml_(value) + "</label></div></div>";
    }

    return html;
}
public String getDisplayHtmlTemplate2018(Field field,String value){
    String html = "";

    html = field.getHtmlTemplate();
    html = html.replace("$Name", field.getName());
    html = html.replace("$Value", value);
    html = html.replace("$HtmlValue", Util.HTMLEncode(value));
    html = html.replace("$Description", field.getDescription());

    return html;
}

%>