package tidemedia.cms.system;

public class Action {
	/**添加文档,包括点击保存或保存并发布**/
	public static final int document_add = 1;
	/**修改文档,包括点击保存或保存并发布**/
	public static final int document_update = 2;
	/**修改文档，,包括点击保存或保存并发布，但状态没有变化**/
	public static final int document_update_2 = 3;
	/**修改文档，,包括点击保存或保存并发布，状态发生变化**/
	public static final int document_update_3 = 4;
	/**状态变化，比如撤稿，审核，发布**/
	public static final int document_status = 5;
	/**删除文档**/
	public static final int document_delete = 6;
	/**发布进程发布了文档**/
	public static final int document_publish_item = 7;
}