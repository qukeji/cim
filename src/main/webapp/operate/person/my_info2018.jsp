<%@ page import="java.sql.*,
				tidemedia.cms.user.UserInfo"%>

<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,java.util.Date,java.sql.*,	tidemedia.cms.user.UserInfo,
tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    int id = getIntParameter(request,"id");

    UserInfo userinfo = userinfo_session;

    String Message = "";
    String Submit = getParameter(request,"Submit");
    if(Submit.equals("Submit"))
    {

        String referer= request.getHeader("Referer");
        referer = convertNull(referer);
        String	Password		=	getParameter(request,"Password");
        //System.out.println("修改密码为------"+Password);
        String	Repassword		=	getParameter(request,"RePassword");
        String	Name		=	getParameter(request,"Name");
        String	Email		=	getParameter(request,"Email");
        String	Tel			=	getParameter(request,"Tel");
        String	Comment		=	getParameter(request,"Comment");

        userinfo.setName(Name);
        userinfo.setPassword(Password);
        userinfo.setEmail(Email);
        userinfo.setTel(Tel);
        userinfo.setComment(Comment);

        userinfo.setMessageType(2);
        userinfo.setActionUser(userinfo_session.getId());
        userinfo.Update();

        Message = "信息更新成功！";
    }
    int Flag = getIntParameter(request,"Flag");
    String time = CmsCache.getExpiresDateStr();
    long current = System.currentTimeMillis();
    time  = time.replaceAll("-","/");
    Date date = new Date(time);
    long ExpiresDate = date.getTime();
    long diff = (ExpiresDate - current)/1000; //秒
    String url = request.getRequestURL()+"";
    String base = url.replace(request.getRequestURI(),"");
    if(CmsCache.hasValidLicense()) diff = 1000000;
    String system_logo = CmsCache.getParameter("system_logo").getContent();

    String loc = "my_info2018.jsp";

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="Shortcut Icon" href="../../favicon.ico">
    <title>TideCMS</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link href="../../tcenter/lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../../tcenter/lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../../tcenter/lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../../tcenter/lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../../tcenter/lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <link href="../../tcenter/lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
    <link rel="stylesheet" href="../../tcenter/style/2018/bracket.css">
    <link rel="stylesheet" href="../../tcenter/style/2018/common.css">
    <style>
        .collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
        /* 密码样式*/
#tips {float:left;margin-top:10px;}
#tips span {float:left;width:50px;height:20px;color:#fff;overflow:hidden;background:#ccc;margin-right:2px;line-height:20px;text-align:center;}
#tips.s1 .active{background:#f30;}
#tips.s2 .active{background:#fc0;}
#tips.s3  .active{background:#cc0;}
#tips.s4 .active{background:#090;}
#Password{border:0;display: block;width: 230px;padding: .65rem .75rem;font-size: .875rem;line-height: 1.25;color: #495057;background-color: #fff;background-image: none;background-clip: padding-box;border: 1px solid rgba(0,0,0,.15);border-radius: 3px;transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;}
.left-fn-password{margin-top:-30px}

    </style>
    <script src="../../tcenter/lib/2018/jquery/jquery.js"></script>
    <script language="javascript">
      
        function check()
        {
            var result = "";
            //手机号绑定验证
            var phone = $("#phone").val();
            var code = $("#code").val();
            if(phone!=""){
                $.ajax({
                    type : "get",
                    url : "checkCode.jsp?code="+code+"&phone="+phone,
                    async:false,
                    success : function(data){
                        result = data.trim();
                    }
                });
            }

            if(result!=""){
                alert(result);
                $("#code").val("");
                return false;
            }


            var pwd = $("#Password").val();
            var repwd=$("#RePassword").val();
            if(pwd==""){
                alert("密码不能为空");
                $("#RePassword").val("");
                return false;
            }
            if(repwd==""){
                alert("请再次输入密码");
                $("#Password").val("");
                return false;
            }
            if(pwd!=repwd){
                alert("两次输入不一致");
                $("#Password").val("");
                $("#RePassword").val("");
                return false;
            }
            var uname = "<%=userinfo.getUsername()%>";
            var role = "<%=userinfo.getRoleName()%>";
            if(uname==pwd){
                alert("用户名密码不能相同");
                $("#Password").val("");
                $("#RePassword").val("");
                return false;
            }else{
                if(role=="系统管理员" && pwd.length<8){
                    alert("系统管理员的密码长度不能小于8位");
                    return false;
                }else if((role=="频道管理员" || role=="编辑" )&& pwd.length<6){
                    alert("频道管理员或编辑的密码长度不能少于6位");
                    return false;
                }else{
                    return true;
                }
            }
            return true;
        }

        function isEmpty(field,msg)
        {
            if(field.value == "")
            {
                alert(msg);
                field.focus();
                return true;
            }
            return false;
        }
        //获取验证码
        function getCode(){
            var phone = $("#phone").val();
            if(phone==""){
                alert("请输入手机号");
            }else{
                $.ajax({
                    type : "get",
                    url : "SingleSendSms.jsp?phone="+phone,
                    async:false,
                    dataType:"json",
                    success : function(data){
                        if(data.state==1){
                            alert("验证码发送成功");
                        }else{
                            alert("验证码发送失败");
                        }
                    }
                });
            }
        }
       
        function closed()
         
        {
          window.history.back(-1);
        }
    </script>
</head>
<body class="collapsed-menu email">
<div class="br-mainpanel br-mainpanel-file" id="js-source">

    <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
            <span class="breadcrumb-item active"><a class="breadcrumb-item" href="javascript:;">你的姓名:</a><%=userinfo.getName()%></span>
        </nav>
    </div><!-- br-pageheader -->

    <div class="br-pagebody pd-x-20 pd-sm-x-30">
        <form name="form" method="post" action="my_info2018.jsp" onSubmit="return check();">
            <div class="card bd-0 shadow-base">
                <table class="table mg-b-0" id="content-table">
                    <thead>
                    <tr>
                        <th class="tx-12-force tx-mont tx-medium" > </th>
                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down" style="padding-left:10px;text-align:center;"> </th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td  style="vertical-align: middle !important; text-align:right;">登录名:</td>
                        <td ><%=userinfo.getUsername()%></td>
                    </tr>
                    <tr>
                        <td  style="vertical-align: middle !important; text-align:right;">姓名：</a></td>
                        <td ><input class="form-control wd-230" placeholder="" type="text" name="Name" value="<%=userinfo.getName()%>"></td>
                    </tr>
                    <tr>
                        <td  style="vertical-align: middle !important; text-align:right;">电子邮件：</td>
                        <td ><input class="form-control wd-230" placeholder="" type="text" name="Email" value="<%=userinfo.getEmail()%>"></td>
                    </tr>
                    <tr>
                        <td style="vertical-align: middle !important; text-align:right;">电话：</td>
                        <td class="d-flex"><input class="form-control wd-230" placeholder="" type="text" name="Tel" value="<%=userinfo.getTel()%>" id="phone"></td>
                    </tr>
                    <tr>
                        <td style="vertical-align: middle !important; text-align:right;">验证码：</td>
                        <td class="d-flex"><input class="form-control wd-230" placeholder="" type="text" name="Code" value="" id="code">
                            <a href="javascript:getCode();" class="btn btn-info mg-l-20">获取验证码</a>
                        </td>
                    </tr>
                    <tr>
                        <td  style="vertical-align: middle !important; text-align:right;">备注：</td>
                        <td ><input class="form-control wd-230" placeholder="" type="text" name="Comment" value="<%=userinfo.getComment()%>"></td>
                    </tr>
                    <!-- 修改密码-->
                    <tr>
                        <td  style="vertical-align: middle !important; text-align:right;">新密码：</td>
                        <td ><input class="form-control wd-230" placeholder="" type="password" name="Password" id="Password" value="">
                             <div id="tips"> <span></span> <span></span> <span></span> <span></span> </div>
                        </td>
                    </tr>
                    <tr>
                        <td  style="vertical-align: middle !important; text-align:right;">再次输入新密码：</td>
                        <td ><input class="form-control wd-230" placeholder="" type="password" name="RePassword" id="RePassword" value=""></td>
                    </tr>
                    <tr>
                        <td style="vertical-align: middle !important; text-align:right;">角色：</td>
                        <td ><%=userinfo.getRoleName()%></td>
                    </tr>
                    <tr>
                        <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;"><button name="startButton" type="submit" class="btn btn-primary tx-size-xs" >确定</button></td>
                        <td class="hidden-xs-down"><a href="javascript:closed();" name="Submit2"   class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1" target="_blank">取消</a></td>
                        <input type="hidden" name="id" value="<%=id%>">
                        <input type="hidden" name="Submit" value="Submit">
                    </tr>
                    </tbody>
                </table>
            </div>
        </form>
    </div><!--列表-->
</div>
</body>
</html>
<script type="text/javascript">
//检测密码强度
 $("#Password").val('')
window.onload = function() {
  var oTips = document.getElementById("tips");
  var oInput =document.getElementById("Password")
  var aSpan = oTips.getElementsByTagName("span");
  var aStr = ["弱", "中", "强", "很强"];
  var i = 0;
  oInput.onkeyup = oInput.onfocus = oInput.onblur = function() {
    var index = checkStrong(this.value);
    this.className = index ? "correct": "error";
    oTips.className = "s" + index;
    for (i = 0; i < aSpan.length; i++) aSpan[i].className = aSpan[i].innerHTML = "";
    index && (aSpan[index - 1].className = "active", aSpan[index - 1].innerHTML = aStr[index - 1])
  }
  $("#Password").val('')
   // document.getElementById("username").focus();
};
function checkStrong(sValue) {
   var modes = 0;
   if (sValue.length == 2) return 1;
   if (sValue.length == 3) return 1;
   if (sValue.length == 4) return 1;
   if (sValue.length == 5) return 1;
   if (sValue.length == 6) return 1;
   if (/\d/.test(sValue)) modes++; //数字
   if (/[a-z]/.test(sValue)) modes++; //小写
   if (/[A-Z]/.test(sValue)) modes++; //大写  
   //if (/\W/.test(sValue)) modes++; //特殊字符
   if ( /[`~!@#$%^&*()_\-+=<>?:"{}|,.\/;'\\[\]·~！@#￥%……&*（）——\-+={}|《》？：“”【】、；‘’，。、]/im.test(sValue)) modes++; //特殊字符
   switch (modes) {
    case 1:
      return 1;
      break;
    case 2:
      return 2;
    case 3:
    case 4:
      return sValue.length < 12 ? 3 : 4
      break;
   }
  
 }

</script>
