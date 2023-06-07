package kr.happyjob.study.business.model;

public class OEManagementModel {

	private int contract_no;
	private String estimate_cd;
	private String order_cd;
	private String client_name;
	private int product_no;
	private String product_name;
	private int product_amt;
	private int tax;
	private int price;
	private int amt_price;
	private int total_price;
	
	
	public int getContract_no() {
		return contract_no;
	}
	public void setContract_no(int contract_no) {
		this.contract_no = contract_no;
	}
	public String getEstimate_cd() {
		return estimate_cd;
	}
	public void setEstimate_cd(String estimate_cd) {
		this.estimate_cd = estimate_cd;
	}
	public String getOrder_cd() {
		return order_cd;
	}
	public void setOrder_cd(String order_cd) {
		this.order_cd = order_cd;
	}
	public String getClient_name() {
		return client_name;
	}
	public void setClient_name(String client_name) {
		this.client_name = client_name;
	}
	public int getProduct_no() {
		return product_no;
	}
	public void setProduct_no(int product_no) {
		this.product_no = product_no;
	}
	public String getProduct_name() {
		return product_name;
	}
	public void setProduct_name(String product_name) {
		this.product_name = product_name;
	}
	public int getProduct_amt() {
		return product_amt;
	}
	public void setProduct_amt(int product_amt) {
		this.product_amt = product_amt;
	}
	public int getTax() {
		return tax;
	}
	public void setTax(int tax) {
		this.tax = tax;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public int getAmt_price() {
		return amt_price;
	}
	public void setAmt_price(int amt_price) {
		this.amt_price = amt_price;
	}
	public int getTotal_price() {
		return total_price;
	}
	public void setTotal_price(int total_price) {
		this.total_price = total_price;
	}
	
}
