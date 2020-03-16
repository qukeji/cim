package tidemedia.cms.report;

import java.util.ArrayList;

public class ReportList {
	private String channelName = "";
	private int		channelId;
	private String userName = "";
	private int 	userId=0;
	private String department = "";
	private int countToday;
	private int countYesterday;
	private int countWeek;
	private int countMonth;
	private int countYear;
	private int countTotal;
	private int total;
	private int groupId;
	private String groupName="";
	private  ArrayList dayCounts;

	public int getGroupId() {
		return groupId;
	}

	public void setGroupId(int groupId) {
		this.groupId = groupId;
	}

	public String getGroupName() {
		return groupName;
	}

	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}

	public String getChannelName() {
		return channelName;
	}

	public void setChannelName(String channelName) {
		this.channelName = channelName;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public int getCountToday() {
		return countToday;
	}

	public void setCountToday(int countToday) {
		this.countToday = countToday;
	}

	public int getCountYesterday() {
		return countYesterday;
	}

	public void setCountYesterday(int countYesterday) {
		this.countYesterday = countYesterday;
	}

	public int getCountWeek() {
		return countWeek;
	}

	public void setCountWeek(int countWeek) {
		this.countWeek = countWeek;
	}

	public int getCountMonth() {
		return countMonth;
	}

	public void setCountMonth(int countMonth) {
		this.countMonth = countMonth;
	}

	public int getCountYear() {
		return countYear;
	}

	public void setCountYear(int countYear) {
		this.countYear = countYear;
	}

	public int getCountTotal() {
		return countTotal;
	}

	public void setCountTotal(int countTotal) {
		this.countTotal = countTotal;
	}

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public int getChannelId() {
		return channelId;
	}

	public void setChannelId(int channelId) {
		this.channelId = channelId;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public ArrayList getDayCounts() {
		return dayCounts;
	}

	public void setDayCounts(ArrayList dayCounts) {
		this.dayCounts = dayCounts;
	}
	

}
