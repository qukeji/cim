package tidemedia.cms.system;

public class LogAction {
	/**文档操作 从100-199**/
	public static final int document_add = 100;//添加文档
	public static final int document_edit = 101;//编辑文档
	public static final int document_delete = 102;//删除文档
	public static final int document_unpublish = 103;//撤稿
	public static final int document_order = 104;//排序
	public static final int document_publish = 105;//发布
	public static final int document_move = 106;//移动
	public static final int document_copy = 107;//复制
	public static final int document_recommend_out = 108;//推荐
	public static final int document_recommend_in = 109;//引用
	public static final int document_add_relation = 110;//添加相关文章 whl 2016.8.19 添加
	public static final int document_add_delete = 111;//删除相关文章whl 2016.8.19 添加
	
	/**视频操作 从150-199**/
	public static final int	video_add = 150;//上传视频
	
	/**频道操作 从200-299**/
	public static final int channel_add = 200;//新建频道
	public static final int channel_edit = 201;//编辑频道
	public static final int channel_delete = 202;//删除频道
	public static final int channel_publish = 203;//发布频道
	public static final int channel_publish1 = 204;//发布频道(子频道)
	public static final int channel_publish2 = 205;//发布频道(全部)
	public static final int channel_publish3 = 206;//发布频道(子频道,全部)
	public static final int channel_appl_examine = 207;//应用审核方案
	public static final int channel_del_examine = 208;//删除审核方案
	
	
	/**页面操作 从300-399**/
	public static final int page_add = 300;//新建页面
	public static final int page_edit = 301;//编辑页面属性
	public static final int page_delete = 302;//删除页面
	public static final int page_save = 303;//修改页面代码
	public static final int page_publish = 304;//发布页面
	
	/**模板操作 从400-499**/
	public static final int template_add = 400;//新建模板
	public static final int template_edit = 401;//编辑模板属性
	public static final int template_delete = 402;//删除模板
	public static final int template_edit_source = 403;//编辑模板内容
	public static final int template_bakup = 404;//模板备份
	public static final int template_bakup_del = 405;//删除模板备份
	public static final int template_bakup_download=406;//下载备份模板
	public static final int template_bakup_download_cacle=407;//取消下载备份模板
	
	/**站点操作 从500-599**/
	public static final int site_add = 500;//新建站点
	public static final int site_edit = 501;//编辑站点
	public static final int site_delete = 502;//删除站点
	
	/**发布进程操作 从600-699**/
	public static final int publish_scheme_add=600;//新建发布方案
	public static final int publish_scheme_edit=601;//编辑发布方案
	public static final int publish_scheme_start=602;//启动发布方案
	public static final int publish_scheme_stop=603;//停止发布方案
	public static final int publish_scheme_delete=604;//删除发布方案
	public static final int publish_scheme_test=605;//测试发布方案
	
	
	/**文件操作 从700-799**/
	public static final int file_add = 700;//添加文件
	public static final int file_edit = 701;//修改文件
	public static final int file_delete = 702;//删除文件
	public static final int folder_add = 703;//添加目录
	public static final int folder_edit = 704;//修改目录
	public static final int folder_delete = 705;//删除目录
	public static final int file_publish = 706;//发布文件
	public static final int	folder_publish = 707;//发布目录
	public static final int file_download = 708;//下载文件
	public static final int folder_download = 709;//下载目录
	public static final int download_cancel = 710;//取消下载
	public static final int backup_data=711;//数据备份
	public static final int download_data=722;//数据库下载
	public static final int download_data_cacle=723;//取消备份数据库下载
	public static final int delete_data=724;//删除数据库备份
	
	
	/**用户操作 从800-899**/
	public static final int user_add = 800;//添加用户
	public static final int user_edit = 801;//编辑用户
	public static final int user_setperm = 802;//设置权限
	public static final int user_delete = 803;//删除用户
	public static final int user_enable = 804;//开启聚融
	public static final int user_close = 805;//关闭聚融
	
	
	/**系统参数操作 从900-999**/
	/**其他操作 从1000-1099**/
	public static final int special_add = 1001;//创建专题
	
	/**审核方案操作 从1100-1199**/
	public static final int approve_scheme_add=1100;//新建发布方案
	public static final int approve_scheme_edit=1101;//编辑发布方案
	public static final int approve_scheme_start=1102;//启动发布方案
	public static final int approve_scheme_stop=1103;//停止发布方案
	public static final int approve_scheme_delete=1104;//删除发布方案
	
	/**租户操作 从1200-1299**/
	public static final int company_add=1200;//添加租户
	public static final int company_edit=1201;//编辑租户
	public static final int company_start=1202;//启动租户
	public static final int company_stop=1203;//停止租户
	public static final int company_delete=1204;//删除租户
	public static final int company_enable = 1205;//开启聚融
	public static final int company_close = 1206;//关闭聚融
	
	/**产品操作 从1300-1399**/
	public static final int product_add=1300;//添加产品
	public static final int product_edit=1301;//编辑产品
	public static final int product_start=1302;//启用产品
	public static final int product_stop=1303;//停止产品
	public static final int product_delete=1304;//删除产品
	public static final int product_license=1305;//更新许可证
	
	/**通知操作 从1400-1499**/
	public static final int notice_add=1400;//添加通知
	public static final int notice_edit=1401;//编辑通知
	public static final int notice_delete=1402;//删除通知

	/**调度日志 从1500-1599**/
	public static final int schedule_add=1500;//新建调度
	public static final int schedule_edit=1501;//编辑调度
	public static final int schedule_start=1502;//启动调度
	public static final int schedule_end=1503;//关闭调度
	public static final int schedule_delete=1504;//删除调度
	
	/**审核操作 从1600-1699**/
	public static final int approve_submit=1600;//提交审核
	public static final int approve_reject=1601;//审核驳回
	public static final int approve_pass=1602;//审核通过
	
	/**稿件置顶操作 从1700-1799**/
	public static final int document_top=1700;//置顶
	public static final int document_canceltop=1701;//取消置顶
	
	/**水印日志 从1800-1899**/
	public static final int watermark_add=1800;//新建水印 
	public static final int watermark_edit=1801;//编辑水印
	public static final int watermark_start=1802;//启动水印
	public static final int watermark_end=1803;//关闭水印
	public static final int watermark_delete=1804;//删除水印
	
	/**系统参数 从1900-1999**/
	public static final int parameter_add=1900;//新建系统参数
	public static final int parameter_edit=1901;//编辑系统参数
	public static final int parameter_delete=1902;//删除系统参数
	
	/**租户绑定解绑 从2000-2099**/
	public static final int user_company_add=2000;//绑定用户
	public static final int user_company_delete=2001;//解绑用户

	/**导航从2100-2199**/
	public static final int navigation_add=2100;//添加导航
	public static final int navigation_edit=2101;//编辑导航
	public static final int navigation_delete=2102;//删除导航

	/**系统日志使用**/
	public static final int systemlog_spider = 1;//采集
	
	/**获取日志中动作描述**/
	public static String getActionDesc(int action)
	{
		switch(action)
		{
			case 100:return "添加文档";
			case 101:return "编辑文档";
			case 102:return "删除文档";
			case 103:return "撤稿";
			case 104:return "排序";
			case 105:return "发布";
			case 106:return "移动文档";
			case 107:return "复制文档";
			case 108:return "推荐文档";
			case 109:return "引用文档";
			case 110:return "添加相关文章";
			case 111:return "删除相关文章";
			
			case 150:return "上传视频";
			
			case 200:return "新建频道";
			case 201:return "编辑频道";
			case 202:return "删除频道";
			case 203:return "发布频道";
			case 204:return "发布频道(子频道)";
			case 205:return "发布频道(全部)";
			case 206:return "发布频道(子频道,全部)";
			case 207:return "应用审核方案";
			case 208:return "删除审核方案";
			
			case 300:return "新建页面";
			case 301:return "编辑页面属性";
			case 302:return "删除页面";
			case 303:return "修改页面代码";
			case 304:return "发布页面";
			
			case 400:return "新建模板";
			case 401:return "编辑模板";
			case 402:return "删除模板";
			case 403:return "编辑模板内容";
			case 404:return "备份模板";
			case 405:return "删除备份模板";
			case 406:return "下载备份模板";
			case 407:return "取消下载备份模板";
			
			case 500:return "新建站点";
			case 501:return "编辑站点";
			case 502:return "删除站点";
			
			
			case 600:return "新建发布方案";
			case 601:return "编辑发布方案";
			case 602:return "启动发布方案";
			case 603:return "停止发布方案";
			case 604:return "删除发布方案";
			case 605:return "测试发布方案";
			
			case 700:return "添加文件";
			case 701:return "修改文件";
			case 702:return "删除文件";
			case 703:return "添加目录";
			case 704:return "修改目录";
			case 705:return "删除目录";
			case 706:return "发布文件";
			case 707:return "发布目录";
			case 708:return "下载文件";
			case 709:return "下载目录";
			case 710:return "取消下载";
			case 711:return "数据库备份";
			case 712:return "数据库下载";
			case 713:return "取消数据库库下载";
			case 714:return "删除数据库备份";
			
			case 800:return "添加用户";
			case 801:return "编辑用户";
			case 802:return "设置权限";
			case 803:return "删除用户";
			case 804:return "开启聚融";
			case 805:return "关闭聚融";
			/*
			case 601:return "新建模板";
			case 602:return "编辑模板";
			case 603:return "删除模板";
			*/
			case 1001:return "创建专题";
			
			case 1100:return "新建审核方案";
			case 1101:return "编辑审核方案";
			case 1102:return "启动审核方案";
			case 1103:return "停止审核方案";
			case 1104:return "删除审核方案";
			
			case 1200:return "新建租户";
			case 1201:return "编辑租户";
			case 1202:return "启动租户";
			case 1203:return "停止租户";
			case 1204:return "删除租户";
			case 1205:return "开启聚融";
			case 1206:return "关闭聚融";
			
			case 1300:return "新建产品";
			case 1301:return "编辑产品";
			case 1302:return "启用产品";
			case 1303:return "停止产品";
			case 1304:return "删除产品";
			case 1305:return "更新许可证";
			
			case 1400:return "新建通知";
			case 1401:return "编辑通知";
			case 1402:return "删除通知";
			
			case 1500:return "新建调度";
			case 1501:return "编辑调度";
			case 1502:return "启动调度";
			case 1503:return "关闭调度";
			case 1504:return "删除调度";
			
			case 1600:return "提交审核";
			case 1601:return "审核驳回";
			case 1602:return "审核通过";
			
			case 1700:return "置顶";
			case 1701:return "取消置顶";
			
			case 1800:return "新建水印";
			case 1801:return "编辑水印";
			case 1802:return "启动水印";
			case 1803:return "关闭水印";
			case 1804:return "删除水印";
			
			case 1900:return "新建系统参数";
			case 1901:return "编辑系统参数";
			case 1902:return "删除系统参数";
			
			case 2000:return "绑定";
			case 2001:return "解绑";

			case 2100:return "新建导航";
			case 2101:return "编辑导航";
			case 2102:return "删除导航";

			default:return "";
		}
	}
	
	/**获取系统日志来源描述**/
	public static String getSourceDesc(int type)
	{
		switch(type)
		{
			case 1:return "采集";
			
			default:return "";
		}
	}
}
