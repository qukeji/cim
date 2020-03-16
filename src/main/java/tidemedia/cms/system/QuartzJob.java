package tidemedia.cms.system;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;

import tidemedia.cms.system.Log;

/**
 * @author haoyingshuang@tidemedia.com
 */
public class QuartzJob extends Table{

	private int id;//主键
	private int status;//线程是否启状态的标志位，1：启动，0：关闭
	private String title = "";// 方案名称
	
	private String jobtime = "";//调度机制表达式
	private String program = "";//调度程序
	private String remark = "";//备注
	private String createdate = "";//创建日期
	private int type = 0;//调度类型 0为普通调度（可删，可编辑），1为系统调度（名称及程序不能编辑，时间机制可以编辑，不可删除）
	private Integer ActionUser = 0;//操作者id
	
	public QuartzJob(int id) throws SQLException, MessageException {
		String Sql = "select * from quartz_manager where id=" + id;
		ResultSet Rs = executeQuery(Sql);
		if (Rs.next()) {
			setId(id);
			setStatus(Rs.getInt("Status"));
			setType(Rs.getInt("Type"));
			setTitle(convertNull(Rs.getString("Title")));
			setProgram(convertNull(Rs.getString("Program")));
			setJobtime(convertNull(Rs.getString("Jobtime")));
			setRemark(convertNull(Rs.getString("Remark")));
			closeRs(Rs);
		} else {
			closeRs(Rs);
		}
	}
	
	public QuartzJob() throws MessageException, SQLException {
		super();
	}

	public void Add() throws SQLException, MessageException {
		String Sql = "";

		Sql = "insert into quartz_manager(Title,Jobtime,Program,Remark,Status,Type,CreateDate) values(";
		Sql += "'" + SQLQuote(title) + "'";
		Sql += ",'" + SQLQuote(jobtime) + "'";
		Sql += ",'" + SQLQuote(program) + "'";
		Sql += ",'" + SQLQuote(remark) + "'";
		Sql += "," + status;
		Sql += "," + type;
		Sql += ",now()";
		Sql += ")";
		//System.out.println("sql==="+Sql);
		id = executeUpdate_InsertID(Sql);
		new Log().ScheduleLog(LogAction.schedule_add, title, id, ActionUser);
	}
	
	public void Delete(int id) throws SQLException, MessageException {
		try{
			QuartzUtil.closeJob(id);
		}catch(Exception e){
		}
		String Sql = "select * from quartz_manager where id=" + id;
		String title = "";
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next()){
			title = convertNull(Rs.getString("Title"));
		}
		Sql = "delete from quartz_manager where id=" + id;
		executeUpdate(Sql);
		closeRs(Rs);
		new Log().ScheduleLog(LogAction.schedule_delete, title, id, ActionUser);
	}

	public void Update(int id,int type_) throws SQLException, 
		MessageException, ParseException, ClassNotFoundException {
		try {
			QuartzUtil.closeJob(id);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String Sql = "";
		Sql = "update quartz_manager set ";
		Sql += "Jobtime='" + SQLQuote(jobtime) + "'";
		if(type_!=1){
			Sql += ",Title='" + SQLQuote(title) + "'";
			Sql += ",Program='" + SQLQuote(program) + "'";
		}
		Sql += ",Remark='" + SQLQuote(remark) + "'";
		Sql += ",Status=" + status;
		Sql += " where id=" + id;
		executeUpdate(Sql);
		new Log().ScheduleLog(LogAction.schedule_edit, title, id, ActionUser);
		Log.SystemLog("调度管理", "编辑调度任务："+type_+title);
	}
	
	public boolean canAdd() {
		return false;
	}

	public boolean canUpdate() {
		return false;
	}
	public boolean canDelete() {
		return false;
	}

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getCreatedate() {
		return createdate;
	}
	public void setCreatedate(String createdate) {
		this.createdate = createdate;
	}
	public String getProgram() {
		return program;
	}
	public void setProgram(String program) {
		this.program = program;
	}

	public String getJobtime() {
		return jobtime;
	}
	public void setJobtime(String jobtime) {
		this.jobtime = jobtime;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	@Override
	public void Update() throws SQLException, MessageException {
		// TODO Auto-generated method stub
	}


	
	public Integer getActionUser() {
		return ActionUser;
	}

	public void setActionUser(Integer actionUser) {
		ActionUser = actionUser;
	}
	
}
