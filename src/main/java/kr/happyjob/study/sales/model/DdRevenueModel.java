package kr.happyjob.study.sales.model;


public class DdRevenueModel {
	
	public String contract_date;
	public String client_name;
	public String product_name;
	public int price;
	public int product_amt;
	public int amt_price;
	public int tax;
	public int total_price;
	public int sum_sales;
	public int cumsum_sales;
	public int sum_p_sales;
	
	
	public int getSum_p_sales() {
		return sum_p_sales;
	}
	public void setSum_p_sales(int sum_p_sales) {
		this.sum_p_sales = sum_p_sales;
	}
	public int getProduct_amt() {
		return product_amt;
	}
	public void setProduct_amt(int product_amt) {
		this.product_amt = product_amt;
	}
	public int getSum_sales() {
		return sum_sales;
	}
	public void setSum_sales(int sum_sales) {
		this.sum_sales = sum_sales;
	}
	public int getCumsum_sales() {
		return cumsum_sales;
	}
	public void setCumsum_sales(int cumsum_sales) {
		this.cumsum_sales = cumsum_sales;
	}
	public String getContract_date() {
		return contract_date;
	}
	public void setContract_date(String contract_date) {
		this.contract_date = contract_date;
	}
	public String getClient_name() {
		return client_name;
	}
	public void setClient_name(String client_name) {
		this.client_name = client_name;
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
	public int getAmt_price() {
		return amt_price;
	}
	public void setAmt_price(int amt_price) {
		this.amt_price = amt_price;
	}
	public int getTax() {
		return tax;
	}
	public void setTax(int tax) {
		this.tax = tax;
	}
	public int getTotal_price() {
		return total_price;
	}
	public void setTotal_price(int total_price) {
		this.total_price = total_price;
	}

	
}
