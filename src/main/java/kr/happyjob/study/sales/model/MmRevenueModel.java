package kr.happyjob.study.sales.model;

public class MmRevenueModel {
	
	private String ym_date; 
    private int order_amt;
    private int outgo;
    private int sales_exp;
    private int sales_profit;
    private double profit_rate;

	
	public String getYm_date() {
		return ym_date;
	}
	public void setYm_date(String ym_date) {
		this.ym_date = ym_date;
	}
	public int getOrder_amt() {
		return order_amt;
	}
	public void setOrder_amt(int order_amt) {
		this.order_amt = order_amt;
	}
	public int getOutgo() {
		return outgo;
	}
	public void setOutgo(int outgo) {
		this.outgo = outgo;
	}
	public int getSales_exp() {
		return sales_exp;
	}
	public void setSales_exp(int sales_exp) {
		this.sales_exp = sales_exp;
	}
	public int getSales_profit() {
		return sales_profit;
	}
	public void setSales_profit(int sales_profit) {
		this.sales_profit = sales_profit;
	}
	public double getProfit_rate() {
		return profit_rate;
	}
	public void setProfit_rate(double profit_rate) {
		this.profit_rate = profit_rate;
	}
    
    

	
	
	
}
