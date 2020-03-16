package tidemedia.tcenter.controller.content;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.*;
import tidemedia.cms.user.UserGroup;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.util.CommonUtil;
import tidemedia.cms.util.TideJson;
import tidemedia.cms.util.Util;
import tidemedia.tcenter.base.ResultJson;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@RestController
@Api(tags = {"默认内容页"})
public class DocumentController {

    private static final Logger logger = LoggerFactory.getLogger(DocumentController.class);

    @GetMapping(value = "/content/document")
    @ApiOperation(value = "默认内容页", notes = "默认内容页")
    public ModelAndView document(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap)  {
        ModelAndView modelAndView = new ModelAndView();

        UserInfo userinfo_session = null;
        try {
            userinfo_session = new UserInfo();

        userinfo_session = (UserInfo)request.getSession().getAttribute("CMSUserInfo");

        String	uri						= request.getRequestURI();
        long	begin_time				= System.currentTimeMillis();
        int		ChannelID				= CommonUtil.getIntParameter(request,"ChannelID");
        int		ItemID					= CommonUtil.getIntParameter(request,"ItemID");
        int		RecommendItemID			= CommonUtil.getIntParameter(request,"RecommendItemID");
        int		RecommendChannelID		= CommonUtil.getIntParameter(request,"RecommendChannelID");
        String	RecommendTarget			= CommonUtil.getParameter(request,"RecommendTarget");
        int		RecommendOutItemID		= CommonUtil.getIntParameter(request,"ROutItemID");
        int		RecommendOutChannelID	= CommonUtil.getIntParameter(request,"ROutChannelID");
        /*云资源采用*/
        int		CloudItemID				= CommonUtil.getIntParameter(request,"CloudItemID");
        int		CloudChannelID			= CommonUtil.getIntParameter(request,"CloudChannelID");
        String	ROutTarget				= CommonUtil.getParameter(request,"ROutTarget");
        int		parentGlobalID			= CommonUtil.getIntParameter(request,"pid");
        int ContinueNewDocument			= CommonUtil.getIntParameter(request,"ContinueNewDocument");
        int NoCloseWindow				= CommonUtil.getIntParameter(request,"NoCloseWindow");
        String From						= CommonUtil.getParameter(request,"From");
        int IsDialog					= CommonUtil.getIntParameter(request,"IsDialog");//如果是弹出窗口，值设为1
        int Parent						= CommonUtil.getIntParameter(request,"Parent");//如果设置了Parent,就设置Parent字段的值
        String transfer_article			= CommonUtil.getParameter(request,"transfer_article");//一键转载url
        int GlobalID					= 0;
        String QRcode					= "";
        String title = "";
        ChannelPrivilege cp = new ChannelPrivilege();

        if(!cp.hasRight(userinfo_session,ChannelID,2))
        {
            response.sendRedirect("../close_pop.jsp");
            // update 20190925
//            modelAndView.setViewName("../close_pop.jsp");
            return modelAndView;
        }

        Document item = null;
        Channel channel = CmsCache.getChannel(ChannelID);
        if(channel.getDocumentProgram().length()>0 && uri.endsWith("/content/document.jsp") ){
            String url = channel.getDocumentProgram()+"?ChannelID="+ChannelID+"&ItemID="+ItemID+"&ROutTarget="+ROutTarget+"&ROutChannelID="+RecommendOutChannelID+"&ROutItemID="+RecommendOutItemID+"&RecommendItemID="+RecommendItemID+"&RecommendChannelID="+RecommendChannelID+"&RecommendTarget="+RecommendTarget+"&CloudItemID="+CloudItemID+"&CloudChannelID="+CloudChannelID;
            response.sendRedirect(url);
        }
        if(channel.isVideoChannel())
        {
            response.sendRedirect("../video/document.jsp?ItemID="+ItemID+"&ChannelID="+ChannelID);
//            modelAndView.setViewName("../video/document.jsp?ItemID="+ItemID+"&ChannelID="+ChannelID);
            // update 20190925
            return modelAndView;
        }

        if(ItemID>0)
        {
            item = CmsCache.getDocument(ItemID,ChannelID);

            //解决同步问题，2012.09.19
            if(item.getChannel().getId()!=ChannelID)
            {
                ChannelID = item.getChannel().getId();
                item = CmsCache.getDocument(ItemID,ChannelID);
                channel = CmsCache.getChannel(ChannelID);
            }
        }

        if(item!=null)
        {
            GlobalID = item.getGlobalID();
            QRcode ="";
            title = item.getTitle();
        }
        ArrayList fieldGroupArray = channel.getFieldGroupInfo();
        String SiteAddress = channel.getSite().getUrl();

        String check2 = "";

        boolean editCategory = false;

        if(channel.isTableChannel() && channel.getType2()==8) editCategory = true;

        String userGroup = "";

        try
        {
            userGroup = new UserGroup(userinfo_session.getGroup()).getName();
        }
        catch(Exception e){}

        TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
        String inner_url = "",outer_url="";
        if(photo_config != null)
        {
            int sys_channelid_image = photo_config.getInt("channelid");
            Site img_site = CmsCache.getChannel(sys_channelid_image).getSite();
            inner_url = img_site.getUrl();
            outer_url = img_site.getExternalUrl();
        }

        int ApproveScheme = channel.getApproveScheme();//是否配置了审核方案
        int Version = channel.getVersion();//是否开启了版本功能


        ApproveAction approve = new ApproveAction(GlobalID,0);//最近一次审核操作
        int id_aa = approve.getId();//审核操作id
        int approveId = approve.getApproveId();//审核环节id
        int action	= approve.getAction();//是否通过
        int end = approve.getEndApprove();//是否终审

        int data_approve = 0;//是否显示右侧审核栏
        int data_yl = 0;//是否为审核预览

        if(id_aa!=0){//说明已提交审核
            data_approve = 1;//是否显示右侧审核栏
            data_yl = 0;//是否为审核预览
        }

//        modelMap.addAttribute("item", item);
        ArrayList<Map> list = new ArrayList<>();
        if (item!=null && item.getTotalPage() > 1) {
            for (int i = 2; i<item.getTotalPage(); i ++) {
                item.setCurrentPage(i);
                HashMap<String, Object> map = new HashMap<>();
                map.put("i", i);


                String content = Util.JSQuote(item.getContent());
                map.put("content", content);

                list.add(map);
                map = null;
            }
            modelMap.addAttribute("list", list);
        }
//        modelMap.addAttribute("list", list);
//        String content = Util.JSQuote(item.getContent());
//        modelMap.addAttribute("content", content);
        modelMap.addAttribute("ParentChannelPath", channel.getParentChannelPath());
        modelMap.addAttribute("userinfo_session", userinfo_session);

        logger.info("userinfo_session " + userinfo_session.getName());

        modelMap.addAttribute("userGroup", userGroup);
        modelMap.addAttribute("ChannelID", ChannelID);
        modelMap.addAttribute("QRcode", QRcode);
        modelMap.addAttribute   ("fieldGroupArray_size", fieldGroupArray.size());
        modelMap.addAttribute("begin_time", begin_time/1000);
        modelMap.addAttribute("SiteAddress", SiteAddress);
        modelMap.addAttribute("GlobalID", GlobalID);
        modelMap.addAttribute("inner_url", inner_url);
        modelMap.addAttribute("outer_url", outer_url);
        modelMap.addAttribute("ChannelID", ChannelID);
        modelMap.addAttribute("NoCloseWindow", NoCloseWindow);
        modelMap.addAttribute("cp", cp);
        boolean hasRight = cp.hasRight(userinfo_session, ChannelID, 3);
        modelMap.addAttribute("hasRight", hasRight);
        modelMap.addAttribute("IsDialog", IsDialog);
        modelMap.addAttribute("RecommendItemID", RecommendItemID);
        modelMap.addAttribute("RecommendChannelID", RecommendChannelID);
        modelMap.addAttribute("RecommendTarget", RecommendTarget);
        modelMap.addAttribute("RecommendOutItemID", RecommendOutItemID);
        modelMap.addAttribute("RecommendOutChannelID", RecommendOutChannelID);
        modelMap.addAttribute("CloudChannelID", CloudChannelID);
        modelMap.addAttribute("CloudItemID", CloudItemID);
        modelMap.addAttribute(transfer_article, transfer_article);
        modelMap.addAttribute("transfer_article_length", transfer_article.length());
        modelMap.addAttribute("channelParentChannelPath", channel.getParentChannelPath());
        modelMap.addAttribute("item", item);
//        modelMap.addAttribute("itemTitle", item.getTitle());

//        logger.info("内容页面 itemTitle :" + item.getTitle());

        ArrayList<Map> list1 = new ArrayList<>();
        for (int i = 0; i<fieldGroupArray.size(); i++) {
            HashMap<Object, Object> map = new HashMap<>();
            FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(i);
            map.put("i", i);
            map.put("fieldGroup", fieldGroup);
            list1.add(map);
            map = null;
        }
        modelMap.addAttribute("list1", list1);
        int vercount = (!QRcode.equals(""))?fieldGroupArray.size()+2:fieldGroupArray.size()+1;
        modelMap.addAttribute("Version", Version);
        modelMap.addAttribute("vercount", vercount);
        String ParentChannelPath = channel.getParentChannelPath().replaceAll(">", " / ");
        modelMap.put("ParentChannelPath", ParentChannelPath);
        modelMap.addAttribute("ApproveScheme", ApproveScheme);
        modelMap.addAttribute("action", action);
        modelMap.addAttribute("id_aa", id_aa);
        modelMap.addAttribute("ItemID", ItemID);
        modelMap.addAttribute("end", end);
        int size = channel.getChannelTemplates(2).size();
        modelMap.put("size", size);

        ArrayList<Map> list2 = new ArrayList<>();
        int j = 0;
        do{
            HashMap<String, Object> map = new HashMap<>();



            String  padding="";
            FieldGroup fieldGroup = null;//字段分组
            int fieldGroupID = 0;
            if(fieldGroupArray.size()>0)
            {
                fieldGroup = (FieldGroup) fieldGroupArray.get(j);
                fieldGroupID = fieldGroup.getId();
            }
            map.put("fieldGroup", fieldGroup);


            String url = "";
            if(fieldGroupArray.size()>0 && fieldGroup.getUrl().length()>0)
            {
                url = fieldGroup.getUrl();
                url = url.replace("$globalid",GlobalID+"");
                url = url.replace("$itemid",ItemID+"");
                url = url.replace("$channelid",ChannelID+"");
                boolean b = url.contains("?");
                String c = "";
                if(!url.contains("itemid="))
                    c += "&itemid=" + ItemID;
                if(!url.contains("globalid="))
                    c += "&globalid=" + GlobalID;
                c += "&channelid=" + ChannelID+"&fieldgroup="+(j+1);
                url += ((b)?"":"?") + c;
            }
            if(fieldGroupID>0 && !fieldGroup.getUrl().equals(""))
            {
                padding="clear-padding";
            }else{
                padding="";
            }

            map.put("url", url);
            map.put("j", j);
            map.put("padding", padding);
            map.put("fieldGroupID", fieldGroupID);
            String fieldGroupUrl = fieldGroup.getUrl();
            map.put("fieldGroupUrl", fieldGroupUrl);

            if(fieldGroupID>0 && !fieldGroup.getUrl().equals("")){
            } else {
                Field field_title = channel.getFieldByFieldName("Title");
                map.put("field_title", field_title);
                int length = field_title.getJS().length();
                map.put("length", length);

                if(editCategory){
                    map.put("editCategory_bol", true);

                    ArrayList categorys = channel.listAllSubChannels(Channel.Category_Type);
                    ArrayList<Object> list3 = new ArrayList<>();
                    if(categorys!=null && categorys.size()>0){
                        map.put("categorys_isExist", true);
                        for(int i = 0;i<categorys.size();i++){
                            HashMap<Object, Object> map1 = new HashMap<>();
                            Channel subcategory = (Channel)categorys.get(i);
                            map1.put("subcategory", subcategory);
                            String bol = (item != null && subcategory.getId() == item.getCategoryID()) ? "selected" : "";
                            map1.put("bol", bol);
                            list3.add(map1);

                            map.put("list3", list3);
                            map1 = null;
                        }
                    } else {
                        map.put("categorys_isExist", false);
                    }
                }else{
                    map.put("editCategory_bol", false);
                }
            }

            ArrayList arraylist = channel.getFieldsByGroup(fieldGroupID,j);
            int jj = 0;
            ArrayList<Map> list4 = new ArrayList<>();
            for (int i = 0; i < arraylist.size(); i++) {
                HashMap<String, Object> map1 = new HashMap<>();

                Field field = (Field) arraylist.get(i);
                map1.put("field", field);

                if (channel.isShowField(field.getName()) && field.getIsHide() == 0) {
                    if (field.getDisableBlank() == 1) {
                        check2 += "	if(isEmpty(document.form." + field.getName() + ",'请输入" + field.getDescription() + ".'))";
                        check2 += "	return false;";
                    }
                    if(field.getName().equalsIgnoreCase("Content")){
                        map1.put("nameEqualsContent", true);
                    }else{
                        map1.put("nameEqualsContent", false);
                    }

                    String displayHtml_ = field.getDisplayHtml_(item != null ? item.getPublishDate() : Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
                    String displayHtml_1 = channel.getFieldByFieldName("Weight").getDisplayHtml_(item != null ? item.getWeight() + "" : "");
                    map1.put("displayHtml_", displayHtml_);
                    map1.put("displayHtml_1", displayHtml_1);

                    String displayHtml_2 = field.getDisplayHtml_(item != null ? item.getValue(field.getName()) : "");
                    map1.put("displayHtml_2", displayHtml_2);

                    String displayHtml2018 = field.getDisplayHtml2018(item);
                    map1.put("displayHtml2018", displayHtml2018);

                } else {
                    map1.put("nameEqualsContent", false);
                }

//                if(field.getFieldType().equals("label")){
//
//                } else {
//
//                }


                if(item!=null){
                    item.setCurrentPage(1);
                    String currcontent = Util.JSQuote(item.getContent().replaceAll(outer_url, inner_url));
                    map1.put("currcontent", currcontent);
                }

                list4.add(map1);
                map1 = null;
            }
            modelMap.addAttribute("list4", list4);



            list2.add(map);
            map = null;

            j++;
        }while(j < fieldGroupArray.size());
        modelMap.addAttribute("list2", list2);
        modelMap.addAttribute("data_approve", data_approve);
        modelMap.addAttribute("data_yl", data_yl);

        String title1 = item != null ? Util.HTMLEncode(item.getValue("Title")) : "";
        modelMap.addAttribute("title1", title1);
        modelMap.addAttribute("editCategory", editCategory);

        modelMap.addAttribute("j", j);
        modelMap.addAttribute("fieldGroupArraySize;", fieldGroupArray.size()+1);
        modelMap.addAttribute("From;", From);
        modelMap.addAttribute("parentGlobalID;", parentGlobalID);
        modelMap.addAttribute("ContinueNewDocument;", ContinueNewDocument);

        boolean jsLength = channel.getDocumentJS().length() > 0;
        modelMap.addAttribute("jsLength", jsLength);

        String documentJS = channel.getDocumentJS();
        modelMap.addAttribute("documentJS", documentJS);
        modelMap.addAttribute("Parent", Parent);



        } catch (MessageException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        modelAndView.addAllObjects(modelMap);
        modelAndView.setViewName("document2019");

        return modelAndView;
    }

    @RequestMapping("/content/document/fastlook")
    @ApiOperation(value = "快速查看接口", notes="快速查看接口")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "ChannelID", value = "频道id", paramType = "query", required = true, dataType = "int"),
            @ApiImplicitParam(name = "ItemID", value = "稿件id", paramType = "query", required = true, dataType = "int")
    })
    public ResultJson fastSearch(@RequestParam("ChannelID") int channelId, @RequestParam("ItemID") int itemId) throws SQLException, MessageException {
        if (channelId == 0||itemId == 0) {
            return ResultJson.error("channelId和itemId不能为0");
        }
        JSONArray jsonArray = new JSONArray();
        Document document = CmsCache.getDocument(itemId, channelId);
        String sql = "select * from field_desc where ChannelID = " + channelId + " and IsHide = 0";
        TableUtil tu = new TableUtil();
        ResultSet resultSet = tu.executeQuery(sql);
        while (resultSet.next()) {
            String fieldName = resultSet.getString("FieldName");
            Field field = new Field(fieldName, channelId);
            String fieldValue = document.getValue(fieldName);
            String fieldType = resultSet.getString("FieldType");
            if (fieldType.equals("switch")) {
                if (fieldValue.equals("0"))
                    fieldValue = "关";
                if (fieldValue.equals("1"))
                    fieldValue = "开";
            } else if (fieldType.equals("radio")) {
                ArrayList<String[]> fieldoptions = field.getFieldOptions();
                for (int k = 0; k < fieldoptions.size(); k++) {
                    String[] ss = fieldoptions.get(k);
                    if (fieldValue.equals(ss[1])) {
                        fieldValue = ss[0];
                        break;
                    }
                }
            }else if(fieldType.equals("checkbox")){
                ArrayList<String[]> fieldoptions = field.getFieldOptions();
                String[] arr = Util.StringToArray(fieldValue,",");
                for (int k = 0; k < fieldoptions.size(); k++) {
                    String[] ss =  fieldoptions.get(k);
                    if (Util.StringInArray(arr, ss[1])) {
                        if(fieldValue.length()==0)
                            fieldValue += ss[0];
                        else
                            fieldValue += "、"+ss[0];
                    }
                }
            }
            JSONObject object = new JSONObject();
            object.put("fieldName",fieldName);
            object.put("fieldValue",fieldValue);
            object.put("fieldType",fieldType);
            jsonArray.add(object);
        }
        tu.closeRs(resultSet);
        return ResultJson.success(jsonArray);
    }
}
