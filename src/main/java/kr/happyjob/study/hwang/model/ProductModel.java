package kr.happyjob.study.hwang.model;

public class ProductModel {

	private int product_no;
    private String lcategory_name;
    private String company;
    private String product_name;
    private int price;
    private int stock;
    
    
	public int getProduct_no() {
		return product_no;
	}
	public void setProduct_no(int product_no) {
		this.product_no = product_no;
	}
	public String getLcategory_name() {
		return lcategory_name;
	}
	public void setLcategory_name(String lcategory_name) {
		this.lcategory_name = lcategory_name;
	}
	public String getCompany() {
		return company;
	}
	public void setCompany(String company) {
		this.company = company;
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
