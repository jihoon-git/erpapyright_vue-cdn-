package kr.happyjob.study.business.model;

public class EmpSalePlanModel {
	private String plan_date;
    private String client_name;
    private String mcname;
    private String pdname;
    private String product_name;
    private int goal_amt;
    private int now_amt;
    
	
	public String getClient_name() {
		return client_name;
	}
	public void setClient_name(String client_name) {
		this.client_name = client_name;
	}
	
	public String getPlan_date() {
		return plan_date;
	}
	public void setPlan_date(String plan_date) {
		this.plan_date = plan_date;
	}
	public String getProduct_name() {
		return product_name;
	}
	public void setProduct_name(String product_name) {
		this.product_name = product_name;
	}
	public String getMcname() {
		return mcname;
	}
	public void setMcname(String mcname) {
		this.mcname = mcname;
	}
	public String getPdname() {
		return pdname;
	}
	public void setPdname(String pdname) {
		this.pdname = pdname;
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
    
    
}
