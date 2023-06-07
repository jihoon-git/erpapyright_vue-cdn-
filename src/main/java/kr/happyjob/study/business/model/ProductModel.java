package kr.happyjob.study.business.model;

public class ProductModel {

	private int product_no;
	private String lcategory_cd;
	private String lcategory_name;
	private String mcategory_cd;
	private String mcategory_name;
	private String product_name;
	private int price;
	private int stock;
	
	
	public int getProduct_no() {
		return product_no;
	}
	public void setProduct_no(int product_no) {
		this.product_no = product_no;
	}
	public String getLcategory_cd() {
		return lcategory_cd;
	}
	public void setLcategory_cd(String lcategory_cd) {
		this.lcategory_cd = lcategory_cd;
	}
	public String getLcategory_name() {
		return lcategory_name;
	}
	public void setLcategory_name(String lcategory_name) {
		this.lcategory_name = lcategory_name;
	}
	public String getMcategory_cd() {
		return mcategory_cd;
	}
	public void setMcategory_cd(String mcategory_cd) {
		this.mcategory_cd = mcategory_cd;
	}
	public String getMcategory_name() {
		return mcategory_name;
	}
	public void setMcategory_name(String mcategory_name) {
		this.mcategory_name = mcategory_name;
	}
	public String getProduct_name() {
		return product_name;
	}
	public void setProduct_name(String product_name) {
		this.product_name = product_name;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public int getStock() {
		return stock;
	}
	public void setStock(int stock) {
		this.stock = stock;
	}
	
	
}
