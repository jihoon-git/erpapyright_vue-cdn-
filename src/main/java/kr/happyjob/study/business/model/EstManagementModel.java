package kr.happyjob.study.business.model;

public class EstManagementModel {
 
	private int contract_no; //계약번호
	private String order_cd; //수주코드
	private String estimate_cd; //견적서 코드
	private String loginID; //작성자아이디
	private String client_name; // 거래처이름
	private String contract_date; //작성일
	private String product_name; //제품이름
	private int tax; //부가세
	private int price; //단가
	private int amt_price; //공급가액
	private String lcategory_cd; //대분류코드
	private String mcategory_cd; //중분류코드
	private int product_no; //제품번호
	private int product_amt; //수량
	private int stock; //제품 남은 수량
	private String state; //제품 남은 수량
	
	private String clnm; //거래처이름
	private String clno; //거래처사업자등록번호
	private String clmnm; //거래처담당자
	private String claddr; //거래처주소
	private String cldaddr; //거래처나머지주소
	private String clmhp; //거래처담당자번호
	private String cnm; //본사이름
	private String cno; //본사사업자등록번호
	private String cmnm; //본사담당자
	private String caddr; //본사주소
	private String cdaddr; //본사나머지주소
	private String cmhp; //본사담당자번호
	private int total_price; //합계금액
	
	public int getContract_no() {
		return contract_no;
	}
	public void setContract_no(int contract_no) {
		this.contract_no = contract_no;
	}
	public String getOrder_cd() {
		return order_cd;
	}
	public void setOrder_cd(String order_cd) {
		this.order_cd = order_cd;
	}
	public String getLoginID() {
		return loginID;
	}
	public void setLoginID(String loginID) {
		this.loginID = loginID;
	}
	public String getClient_name() {
		return client_name;
	}
	public void setClient_name(String client_name) {
		this.client_name = client_name;
	}
	public String getContract_date() {
		return contract_date;
	}
	public void setContract_date(String contract_date) {
		this.contract_date = contract_date;
	}
	public String getProduct_name() {
		return product_name;
	}
	public void setProduct_name(String product_name) {
		this.product_name = product_name;
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
	public String getLcategory_cd() {
		return lcategory_cd;
	}
	public void setLcategory_cd(String lcategory_cd) {
		this.lcategory_cd = lcategory_cd;
	}
	public String getMcategory_cd() {
		return mcategory_cd;
	}
	public void setMcategory_cd(String mcategory_cd) {
		this.mcategory_cd = mcategory_cd;
	}
	public int getProduct_no() {
		return product_no;
	}
	public void setProduct_no(int product_no) {
		this.product_no = product_no;
	}
	public int getProduct_amt() {
		return product_amt;
	}
	public void setProduct_amt(int product_amt) {
		this.product_amt = product_amt;
	}
	public String getClnm() {
		return clnm;
	}
	public void setClnm(String clnm) {
		this.clnm = clnm;
	}
	public String getClno() {
		return clno;
	}
	public void setClno(String clno) {
		this.clno = clno;
	}
	public String getClmnm() {
		return clmnm;
	}
	public void setClmnm(String clmnm) {
		this.clmnm = clmnm;
	}
	public String getCladdr() {
		return claddr;
	}
	public void setCladdr(String claddr) {
		this.claddr = claddr;
	}
	public String getCldaddr() {
		return cldaddr;
	}
	public void setCldaddr(String cldaddr) {
		this.cldaddr = cldaddr;
	}
	public String getClmhp() {
		return clmhp;
	}
	public void setClmhp(String clmhp) {
		this.clmhp = clmhp;
	}
	public String getCnm() {
		return cnm;
	}
	public void setCnm(String cnm) {
		this.cnm = cnm;
	}
	public String getCno() {
		return cno;
	}
	public void setCno(String cno) {
		this.cno = cno;
	}
	public String getCmnm() {
		return cmnm;
	}
	public void setCmnm(String cmnm) {
		this.cmnm = cmnm;
	}
	public String getCaddr() {
		return caddr;
	}
	public void setCaddr(String caddr) {
		this.caddr = caddr;
	}
	public String getCdaddr() {
		return cdaddr;
	}
	public void setCdaddr(String cdaddr) {
		this.cdaddr = cdaddr;
	}
	public String getCmhp() {
		return cmhp;
	}
	public void setCmhp(String cmhp) {
		this.cmhp = cmhp;
	}
	public int getTotal_price() {
		return total_price;
	}
	public void setTotal_price(int total_price) {
		this.total_price = total_price;
	}
	public String getEstimate_cd() {
		return estimate_cd;
	}
	public void setEstimate_cd(String estimate_cd) {
		this.estimate_cd = estimate_cd;
	}
	public int getStock() {
		return stock;
	}
	public void setStock(int stock) {
		this.stock = stock;
	}
	
	
	
	
}
