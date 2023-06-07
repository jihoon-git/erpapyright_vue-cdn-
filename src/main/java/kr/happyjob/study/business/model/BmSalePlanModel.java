package kr.happyjob.study.business.model;

public class BmSalePlanModel {
	
	private int emp_no;
	private String name;
	private String client_name;
    private int product_no;
    private String product_name;
    private String plan_date;
    private int goal_amt;
    private int now_amt;
    private int acvm_rate;
    private int plan_no;
	
	
    public int getEmp_no() {
		return emp_no;
	}
	public void setEmp_no(int emp_no) {
		this.emp_no = emp_no;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
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
	public String getPlan_date() {
		return plan_date;
	}
	public void setPlan_date(String plan_date) {
		this.plan_date = plan_date;
	}
	public int getGoal_amt() {
		return goal_amt;
	}
	public void setGoal_amt(int goal_amt) {
		this.goal_amt = goal_amt;
	}
	public int getNow_amt() {
		return now_amt;
	}
	public void setNow_amt(int now_amt) {
		this.now_amt = now_amt;
	}
	public int getAcvm_rate() {
		return acvm_rate;
	}
	public void setAcvm_rate(int acvm_rate) {
		this.acvm_rate = acvm_rate;
	}
	public int getPlan_no() {
		return plan_no;
	}
	public void setPlan_no(int plan_no) {
		this.plan_no = plan_no;
	}
	public String getClient_name() {
		return client_name;
	}
	public void setClient_name(String client_name) {
		this.client_name = client_name;
	}
	
	
	
}
