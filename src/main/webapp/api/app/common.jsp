<%@ page import="tidemedia.cms.system.*,
                tidemedia.cms.base.*,
                tidemedia.cms.util.*,
                tidemedia.cms.user.*,
                java.util.*,
                java.text.SimpleDateFormat,
                org.json.JSONObject,
                java.text.ParseException,
                java.util.regex.Pattern,
                 java.util.regex.Matcher,
                java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%

  
   int Site = 53;
   HashMap<String ,Object> TIDE = new HashMap<String,Object>();
    //JSONObject TIDE=new JSONObject();

    /*表名配置开始*/
    //公用表
    TIDE.put("code","channel_code");                 //cms注册验证码
    TIDE.put("cms_resource","channel_s3_a_a");       //cms资源栏目
    TIDE.put("cms_button","channel_s3_a_b");         //cms按钮内容管理
    TIDE.put("cms_comment","channel_comment");       //cms评论
    TIDE.put("cms_collect","channel_collect");       //cms收藏表
    TIDE.put("cms_register","channel_register");      //cms注册用户
    TIDE.put("cms_yzm","channel_code");                 //cms验证码
    TIDE.put("cms_history","channel_s3_c");             //cms阅读历史
    TIDE.put("cms_sns_topic","channel_sns_topic");      //cms话题提交
    TIDE.put("cms_community_topic","channel_s53_community_topic");              //社区主体内容
    TIDE.put("cms_community_slidemanger","channel_community_slidemanger");  //话题轮播图
    TIDE.put("cms_praise","channel_praise");                        //点赞
    TIDE.put("cms_community_comment","channel_community_comment");  //话题评论
    TIDE.put("cms_history_new","channel_history");              //阅读历史
    TIDE.put("cms_community_zan","channel_community_zan");      //社区话题点赞
    TIDE.put("cms_photo","channel_photo");                      //图片库
    TIDE.put("cms_community_watch","channel_community_watch");  //话题关注记录
    TIDE.put("cms_community_userwatch","channel_community_userwatch");  //好友关注记录
    TIDE.put("cms_community_checkmodel","channel_community_checkmodel");//社区帖子、评论审核模式
    TIDE.put("cms_messagefeedback","channel_messagefeedback");  //意见反馈
    TIDE.put("cms_channel","channel");                          //channel表
    TIDE.put("cms_item_snap","item_snap");                      //item_snap表
    TIDE.put("cms_company_source","company_s3_source");         //企业内容稿池标识名
    TIDE.put("cms_docpraise","channel_docpraise");                //文章点赞
    TIDE.put("cms_checkmodel","channel_checkmodel");              //评论/贴子审核设置

    //非公用表
    TIDE.put("cms_community_s_category_start","channel_community_s");                       //话题管理头部
    TIDE.put("cms_community_s_category_end","_category");                                    //话题管理尾部
    TIDE.put("cms_resource_start","channel_s");                                              //cms资源栏目头部
    TIDE.put("cms_resource_end","_a_a");                                                     //cms资源栏目尾部
    TIDE.put("cms_common_start","channel_s");                                                //cms评论栏目头部
    TIDE.put("cms_common_end","_f");                                                          //cms评论栏目尾部
    TIDE.put("cms_community_s_levelrule_start","channel_community_s");                        //积分规则设置头部
    TIDE.put("cms_community_s_levelrule_end","_levelrule");                                     //积分规则设置尾部
    TIDE.put("cms_community_s_level_start","channel_community_s");                              //社区等级制度头部
    TIDE.put("cms_community_s_level_end","_level");                                             //社区等级制度尾部
    TIDE.put("cms_community_s_score_start","channel_community_s");                              //社区积分记录头部
    TIDE.put("cms_community_s_score_end","_score");                                             //社区积分记录尾部
    TIDE.put("cms_community_s_message_start","channel_community_s");                            //消息管理头部
    TIDE.put("cms_community_s_message_end","_message");                                         //消息管理尾部
    TIDE.put("cms_s_baoliao_start","channel_s");                                                //用户爆料头部
    TIDE.put("cms_s_baoliao_end","_baoliao");                                                   //用户爆料尾部
    TIDE.put("cms_s_manager_start","channel_company_s");                                        //企业号管理头部
    TIDE.put("cms_s_manager_end","_manager");                                                   //企业号管理尾部
    TIDE.put("cms_category_s_manager_start","channel_company_s");                               //自定义栏目管理头部、评论审核模式
    TIDE.put("cms_category_s_manager_end","_manager");                                          //自定义栏目管理尾部
    TIDE.put("cms_category_s_personinfo_start","channel_company_s");                            //用户栏目信息管理头部
    TIDE.put("cms_category_s_personinfo_end","_personinfo");                                     //用户栏目信息管理尾部
    TIDE.put("cms_company_s_source_start","channel_company_s");                                  //企业内容管理稿池管理头部

    TIDE.put("cms_company_s_source_end","_source");                                             //企业内容管理稿池管理头部
    TIDE.put("cms_s_token_start","channel_s");                                                  //直播防盗链管理头部
    TIDE.put("cms_s_token_end","_token");                                                       //直播防盗链管理尾部
    TIDE.put("cms_s_config_start","channel_s");                                        //App配置管理头部
    TIDE.put("cms_s_config_end","_config");//App配置管理尾部
    TIDE.put("cms_community_s_recommend_start","channel_community_s");                  //主页推荐模块头部
    TIDE.put("cms_community_s_recommend_end","_recommend");                             //主页推荐模块尾部
    TIDE.put("cms_s_push_start","channel_s");                                           //信息推送头部
    TIDE.put("cms_s_push_end","_push");                                                 //信息推送尾部
    TIDE.put("cms_s_messagedelete_start","channel_s");                                  //信息推送头部
    TIDE.put("cms_s_messagedelete_end","_messagedelete");                               //信息推送尾部

    /*表名配置结束*/

    /*频道编号配置开始*/
    TIDE.put("cms_history_id",14193);                                           //cms阅读历史
    TIDE.put("cms_community_comment_channel",14272);                            //社区评论channelid
    TIDE.put("cms_praise_channel",14269);                                       //点赞channelid
    TIDE.put("cms_messagefeedback_channel",14268);                              //意见反馈channelid
    TIDE.put("cms_history_channel",14262);                                      //阅读历史channelid
    TIDE.put("cms_register_channel",14263);                                     //注册用户channelid
    TIDE.put("cms_community_zan_channel",14315);                                //社区话点赞channelid
    TIDE.put("cms_community_watch_channel",14323);                              //社区话题关注记录channelid
    TIDE.put("cms_community_userwatch_channel",14331);                          //好友关注记录channelid
    TIDE.put("cms_community_score_channel_","cms_community_score_channel_");     //社区积分记录channelid                                         //信息推送尾部
    TIDE.put("cms_community_score_channel_3",14335);                             //3客户端社区积分记录channelid
    TIDE.put("cms_community_score_channel_24",14411);                            //24客户端社区积分记录channelid
    TIDE.put("cms_photo_channel",14145);                                         //图片库channelid
    TIDE.put("cms_community_topic_channel",14271);                               //社区动态channelid
    TIDE.put("cms_resource_channel",15894);                                      //栏目管理channelid
    TIDE.put("cms_compnay_source_channel",15913);                                //媒体号内容管理channelid
    /*频道编号配置结束*/

    //TP系统配置
    //juxian金币表配置
    TIDE.put("channel_cms_golddetail","channel_s"+Site+"_golddetail");                  //金币明细
    TIDE.put("channel_cms_goldaddition","channel_s"+Site+"_goldaddition");              //金币加成
    TIDE.put("channel_cms_golddetail_serialno","s"+Site+"_golddetail");				  //金币明细频道标识
     /*app注册登录配置开始*/
    TIDE.put("app_user_channelid",14263);
    
     /*app注册登录配置结束*/

	

     /*IP端口号配置开始*/
    TIDE.put("share_path","/a/a/wap_content.shtml");    	//分享链接的频道路径+目标文件名                            
    TIDE.put("pic_path","http://jushi-yanshi.tidemedia.com");      //图片预览地址
    TIDE.put("pic_abs_path","/web/tcenter20_html");            //cms地址
    TIDE.put("cms_ip","http://127.0.0.1");
    TIDE.put("cms_port","888");                         //cms地址端口
    TIDE.put("preview_address","http://101.200.83.135:32774");  //互动信息管理预览地址和端口
    TIDE.put("live_url","http://hls.qguiyang.com");             //直播服务端域名
    TIDE.put("public_address","http://101.201.28.123:8888");    //公网地址和端口
    
    






%>




