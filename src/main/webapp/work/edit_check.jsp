<%@ page import="tidemedia.cms.system.*,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%@ include file="../approve/approve_config.jsp"%>
<%
    int itemId = getIntParameter(request,"itemid");
    int channelId = getIntParameter(request,"channelid");
    System.out.println("channelId="+channelId);
    Channel channel=CmsCache.getChannel(channelId);
    Document doc=CmsCache.getDocument(itemId,channelId);
    int GlobalID = doc.getGlobalID();
    int status = doc.getStatus();
    
    String approve_status = "未提交审核";
    ApproveAction approve = new ApproveAction(GlobalID,0);//最近一次审核操作
	int id_aa = approve.getId();//审核操作id
	int approveId = approve.getApproveId();//审核环节id
	int action	= approve.getAction();//是否通过
	int end = approve.getEndApprove();//是否终审
	int editables = 0;
	
	JSONObject json1 = null;
	//if(id_aa!=0){//说明已配置审核环节
		ApproveItems ai = new ApproveItems(approveId);//审核环节
		if(approveId==0){//审核环节编号为0，此文章状态为提交审核
		    json1 = ai.getApproveName(channel.getApproveScheme());
			approve_status = json1.get("ApproveName")+"待审核";
			editables = (int) json1.get("Editable");
		}else{
		    json1 = ai.getApproveName(0);
			approve_status = json1.get("ApproveName")+"待审核";
			editables = (int) json1.get("Editable");
			int endLink = (int)json1.get("endLink");
			int type = ai.getType();
			String userIds = ai.getUsers();

			if(!userIds.equals("")){
				String[] users = userIds.split(",");
				JSONObject json = getUserNames(users,getAction(GlobalID),GlobalID,ai.getId());
				int size = json.getInt("size");
				if(type==1){//并签要判断其他人是否审核通过
					if(size>0){
						approve_status = approve.getApproveName()+"待审核";
					}
					//确保最后环节为并签时有用户审核通过导致稿件不可编辑
					if(endLink == 1){
						editables = 2;
					}
				}
			}

			if(action==1){//未通过
				approve_status = approve.getApproveName()+"驳回";
			}
			if(action==0&&end==1){
				approve_status = approve.getApproveName()+"通过";
			}
		}

	//}
	
	JSONObject json2 = new JSONObject();
	int result = 0;
	if(id_aa==0||action==1||editables==1){//未提交审核、审核被驳回、审核通过允许编辑
		result = 0;
	}else if(end==1&&action==0&&status==1){//终审通过不允许再次编辑
		result = 4;
	}else if(editables==0){//审核环节不允许编辑
		result = 1;
	}
	json2.put("result",result);
	json2.put("status",status);
	out.println(json2);
%>
