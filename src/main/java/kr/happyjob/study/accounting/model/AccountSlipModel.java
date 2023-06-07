package kr.happyjob.study.accounting.model;

public class AccountSlipModel {

	private int account_no;
	private int exp_no;
	private String order_cd;
	private String contAccount_cd;
	private String contAccount_name;
	private String contUserName;
	private String contClient_name;
	private String contContract_date;
	private int contTotal_price;
	private String expYn_date;
	private String exptAccount_cd;
	private String exptaccount_name;
	private String exptClient_name;
	private String exptUserName;
	private int expt_spent;
	
	
	public int getAccount_no() {
		return account_no;
	}
	public void setAccount_no(int account_no) {
		this.account_no = account_no;
	}
	public int getExp_no() {
		return exp_no;
	}
	public void setExp_no(int exp_no) {
		this.exp_no = exp_no;
	}
	public String getOrder_cd() {
		return order_cd;
	}
	public void setOrder_cd(String order_cd) {
		this.order_cd = order_cd;
	}
	public String getContAccount_cd() {
		return contAccount_cd;
	}
	public void setContAccount_cd(String contAccount_cd) {
		this.contAccount_cd = contAccount_cd;
	}
	public String getContAccount_name() {
		return contAccount_name;
	}
	public void setContAccount_name(String contaccount_name) {
		this.contAccount_name = contaccount_name;
	}
	public String getContUserName() {
		return contUserName;
	}
	public void setContUserName(String contUserName) {
		this.contUserName = contUserName;
	}
	public String getContClient_name() {
		return contClient_name;
	}
	public void setContClient_name(String contClient_name) {
		this.contClient_name = contClient_name;
	}
	public String getContContract_date() {
		return contContract_date;
	}
	public void setContContract_date(String contContract_date) {
		this.contContract_date = contContract_date;
	}
	public int getContTotal_price() {
		return contTotal_price;
	}
	public void setContTotal_price(int contTotal_price) {
		this.contTotal_price = contTotal_price;
	}
	public String getExpYn_date() {
		return expYn_date;
	}
	public void setExpYn_date(String expYn_date) {
		this.expYn_date = expYn_date;
	}
	public String getExptAccount_cd() {
		return exptAccount_cd;
	}
	public void setExptAccount_cd(String exptAccount_cd) {
		this.exptAccount_cd = exptAccount_cd;
	}
	public String getExptaccount_name() {
		return exptaccount_name;
	}
	public void setExptaccount_name(String exptaccount_name) {
		this.exptaccount_name = exptaccount_name;
	}
	public String getExptClient_name() {
		return exptClient_name;
	}
	public void setExptClient_name(String exptClient_name) {
		this.exptClient_name = exptClient_name;
	}
	public String getExptUserName() {
		return exptUserName;
	}
	public void setExptUserName(String exptUserName) {
		this.exptUserName = exptUserName;
	}
	public int getExpt_spent() {
		return expt_spent;
	}
	public void setExpt_spent(int expt_spent) {
		this.expt_spent = expt_spent;
	}
	
	
}
