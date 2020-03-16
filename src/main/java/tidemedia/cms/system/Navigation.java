package tidemedia.cms.system;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;

/*
 * tcenter快捷导航
 * */
public class Navigation extends Table{

	private int		id;
	private String 	Title = "";//标题
	private String 	Href = "";//链接地址
	private int 	Parent=0; //父编号
	private int 	Level=0; //层级
	private int 	hasNextLevel=0; //是否存在子导航
	private int		newpage = 0;//是否弹出新页面
	private int 	UserId=0; //当前操作用户
	private int    ordernumber=0; //排序
	public Navigation() throws MessageException, SQLException {
		super();
	}

	public Navigation(int id) throws SQLException, MessageException
	{
		
		TableUtil tu_user = new TableUtil("user");
		String Sql = "select id,Title,Href,Parent,Level,hasNextLevel,newpage,ordernumber from navigation where id="+id;
		ResultSet Rs = tu_user.executeQuery(Sql);
		if(Rs.next())
		{
			setId(id);
			setTitle(convertNull(Rs.getString("Title")));
			setHref(convertNull(Rs.getString("Href")));
			setParent(Rs.getInt("Parent"));
			setLevel(Rs.getInt("Level"));
			setHasNextLevel(Rs.getInt("hasNextLevel"));
			setNewpage(Rs.getInt("newpage"));
			setOrdernumber(Rs.getInt("ordernumber"));
		}
		tu_user.closeRs(Rs);		
	}
	
	public void Add() throws SQLException, MessageException {
		String Sql = "";
		
		if(Title.equals(""))
			throw new MessageException("导航标题不能为空.");
		
		TableUtil tu_user = new TableUtil("user");
		
		Sql = "insert into navigation (";
		Sql += "Title,Href,Parent,Level,hasNextLevel,newpage,ordernumber";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Title) + "'";
		Sql += ",'" + SQLQuote(Href) + "'";
		Sql += "," + Parent + "";
		Sql += "," + Level + "";
		Sql += "," + hasNextLevel + "";
		Sql += "," + newpage + "";
		Sql += "," + ordernumber + "";
		Sql += ")";
		
		int insertid = tu_user.executeUpdate_InsertID(Sql);
		
		setId(insertid);
				
		new Log().NavigationLog(LogAction.navigation_add, SQLQuote(Title), id, UserId);
	}
	
	public void Update() throws SQLException, MessageException {
		String Sql = "";
		
		if(Title.equals(""))
			throw new MessageException("导航标题不能为空.");
		
		TableUtil tu_user = new TableUtil("user");
		
		Sql = "update navigation set ";
		Sql += "Title='" + SQLQuote(Title) + "'";
		Sql += ",Href='" + SQLQuote(Href) + "'";
		if(Parent!=0){
			Sql += ",Parent=" + Parent + "";
		}
		if(Level!=0){
			Sql += ",Level=" + Level + "";
		}
		if(hasNextLevel!=0){
			Sql += ",hasNextLevel=" + hasNextLevel + "";	
		}	
		Sql += ",newpage=" + newpage + "";
		Sql += " where id="+id;
		
		tu_user.executeUpdate(Sql);

		new Log().NavigationLog(LogAction.navigation_edit, Title, id, UserId);
	}

	public void Delete(int id) throws SQLException, MessageException {
		
		Navigation n = new Navigation(id);
		int hasNextLevel = n.getHasNextLevel();//是否有子导航
		int Parent = n.getParent();//父导航
		
		if(hasNextLevel==0){//无子导航，直接删除
			TableUtil tu_user = new TableUtil("user");
			String Sql = "delete from navigation where id="+id;
			tu_user.executeUpdate(Sql);	
		}else{	
			//有子导航，遍历删除
			TableUtil tu = new TableUtil("user");
			ResultSet rs = null;
			deleteInfo(rs,id);
			tu.closeRs(rs);
		}
		
		//检查更新删除信息后 更新父的hasNextLevel字段
		TableUtil tu_check = new TableUtil("user");
		String sql_check = "select * from navigation where Parent="+Parent;
		ResultSet rs_check = tu_check.executeQuery(sql_check);
		if(!rs_check.next())
		{
			TableUtil tu_update = new TableUtil("user");
			String sql_update = "update navigation set hasNextLevel=0 where id="+Parent;
			tu_update.executeUpdate(sql_update);
		}
		tu_check.closeRs(rs_check);
				
		new Log().NavigationLog(LogAction.navigation_delete, n.getTitle(), id, UserId);
		
	}
	
	public void deleteInfo(ResultSet rs, int Parent) throws SQLException, MessageException
	{

		TableUtil tu3 = new TableUtil("user");
		String sql3 = "delete from navigation where id="+Parent;
		tu3.executeUpdate(sql3);

		TableUtil tu2 = new TableUtil("user");
		String sql2 = "select * from navigation where Parent="+Parent;
		
		rs = tu2.executeQuery(sql2);
		while(rs.next())
		{
			int itemid = rs.getInt("id");
			deleteInfo(rs,itemid);
		}
		
	}
	//导航列表
	public JSONArray NavigationList(int parent) throws SQLException, MessageException, JSONException
	{
		JSONArray arr = new JSONArray();
		
		TableUtil tu_user = new TableUtil("user");
		String Sql = "select id,Title,Href,Parent,Level,hasNextLevel,newpage,ordernumber from navigation where " +
				"Parent="+parent+" order by ordernumber desc ";
		ResultSet Rs = tu_user.executeQuery(Sql);
		while(Rs.next())
		{
			JSONObject obj = new JSONObject();
			obj.put("id", Rs.getInt("id"));
			obj.put("Title",convertNull(Rs.getString("Title")));
			obj.put("Href", convertNull(Rs.getString("Href")));
			obj.put("Parent",Rs.getInt("Parent"));
			obj.put("Level", Rs.getInt("Level"));
			obj.put("hasNextLevel", Rs.getInt("hasNextLevel"));
			obj.put("newpage", Rs.getInt("newpage"));
			obj.put("ordernumber", Rs.getInt("ordernumber"));
			arr.put(obj);
		}
		tu_user.closeRs(Rs);
		
		return arr;		
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTitle() {
		return Title;
	}

	public void setTitle(String title) {
		Title = title;
	}

	public String getHref() {
		return Href;
	}

	public void setHref(String href) {
		Href = href;
	}

	public int getParent() {
		return Parent;
	}

	public void setParent(int parent) {
		Parent = parent;
	}

	public int getLevel() {
		return Level;
	}

	public void setLevel(int level) {
		Level = level;
	}

	public int getHasNextLevel() {
		return hasNextLevel;
	}

	public void setHasNextLevel(int hasNextLevel) {
		this.hasNextLevel = hasNextLevel;
	}

	public int getNewpage() {
		return newpage;
	}

	public void setNewpage(int newpage) {
		this.newpage = newpage;
	}

	public int getUserId() {
		return UserId;
	}

	public void setUserId(int userId) {
		UserId = userId;
	}

	public int getOrdernumber() {
		return ordernumber;
	}

	public void setOrdernumber(int ordernumber) {
		this.ordernumber = ordernumber;
	}

	@Override
	public boolean canAdd() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean canDelete() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean canUpdate() {
		// TODO Auto-generated method stub
		return false;
	}
}
