/*
 * (c) Copyright 2001 MyCorporation.
 * All Rights Reserved.
 */
package tidemedia.cms.base;

/**
 * @version 	1.0
 * @liyonghai@163.net
 */
public class PageControl {

	/*
	 * @see Object#Object()
	 */
	/**
	 * Constructor for PageControl.
	 */
	public PageControl() {
		super();
	}
	
	public int currentPage;
	//当前页数，从1开始
	public int maxPages;
	//最大页数
	public int rowsPerPage;
	//每页计录数
	public int rowsCount;
	//总共计录数

	/**
	 * Gets the maxPages.
	 * @return Returns a int
	 */
	public int getMaxPages() {
		return maxPages;
	}

	/**
	 * Method setMaxPages.
	 * @param maxPages
	 */

	public void setMaxPages(int maxPages) {
		this.maxPages = maxPages;
	}

	/**
	 * Gets the currentPage.
	 * @return Returns a int
	 */
	public int getCurrentPage() {
		return currentPage;
	}

	/**
	 * Sets the currentPage.
	 * @param currentPage The currentPage to set
	 */
	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}

	/**
	 * Gets the rowsPerPage.
	 * @return Returns a int
	 */
	public int getRowsPerPage() {
		return rowsPerPage;
	}

	/**
	 * Sets the rowsPerPage.
	 * @param rowsPerPage The rowsPerPage to set
	 */
	public void setRowsPerPage(int rowsPerPage) {
		this.rowsPerPage = rowsPerPage;
	}

	/**
	 * Gets the rowsCount.
	 * @return Returns a int
	 */
	public int getRowsCount() {
		//纪录行数
		return rowsCount;
	}

	/**
	 * Gets the currentRowsCount.
	 * @return Returns a int
	 */
	public int getCurrentRowsCount() {
		if(currentPage * rowsPerPage<=rowsCount)
			return currentPage * rowsPerPage;
		else
			return rowsCount;
	}

	/**
	 * Sets the rowsCount.
	 * @param rowsCount The rowsCount to set
	 */
	public void setRowsCount(int rowsCount) {
		this.rowsCount = rowsCount;
	}
	
	public boolean hasPrevious()
	{
		//是否有前一页
		if(currentPage>1)
			return true;
		else
			return false;
	}
	
	public boolean hasNext()
	{
		//是否有后一页
		if(currentPage<maxPages)
			return true;
		else
			return false;
	}

}
