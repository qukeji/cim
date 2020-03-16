package tidemedia.tcenter.entity.company;

import tidemedia.cms.base.MessageException;

import java.io.Serializable;
import java.sql.SQLException;

/**
 * 租户请求
 *
 */
public class CompanyRequestEntity implements Serializable {
	private static final long serialVersionUID = 1L;
	/**
	 * id
	 */

	private int		id;
	/**
	 * 租户编号
	 */
	private int		companyId;
	/**
	 * 租户名称
	 */
	private String  companyName;
	/**
	 * 产品编号
	 */
	private int 	productId;
	/**
	 * 产品名称
	 */
	private String 	productName;
	/**
	 * 状态 0：未开通，1：开通
	 */
	private int status;
	/**
	 * 申请日期
	 */
	private String requestDate;
	/**
	 * 开通日期
	 */
	private String openDate;
	/**
	 * 产品权限
	 */
	private String 	products;
	/**
	 * 当前操作用户
	 */
	private int UserId;



	public CompanyRequestEntity() throws MessageException, SQLException {
		super();
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getCompanyId() {
		return companyId;
	}

	public void setCompanyId(int companyId) {
		this.companyId = companyId;
	}

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}

	public int getProductId() {
		return productId;
	}

	public void setProductId(int productId) {
		this.productId = productId;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public String getRequestDate() {
		return requestDate;
	}

	public void setRequestDate(String requestDate) {
		this.requestDate = requestDate;
	}

	public String getOpenDate() {
		return openDate;
	}

	public void setOpenDate(String openDate) {
		this.openDate = openDate;
	}

	public String getProducts() {
		return products;
	}

	public void setProducts(String products) {
		this.products = products;
	}

	public int getUserId() {
		return UserId;
	}

	public void setUserId(int userId) {
		UserId = userId;
	}
}
