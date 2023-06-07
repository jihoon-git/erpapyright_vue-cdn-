package kr.happyjob.study.employee.model;

public class EmpPaymentModel {
	private String pay_date; // 지급날짜
	private String dept; // 부서
	private String rank; // 직급
    private int emp_no; // 사번
    private String name; // 사원명
    private int year_pay; // 연봉
    private int month_pay; // 기본급(세전월급)
    private int ins_n; // 국민연금
    private int ins_h; // 건강보험
    private int ins_e; //고용보험
    private int ins_i; //산재보험
    private int tax; // 소득세(부가세)
    private int extra; // 비고금액(개인지출비용)
    private int total; // 실급여(세후월급)
    private String pay_yn; // 지급여부
    private String sloginID; // 개인id
    
	private String nego_date; // 협상날짜
    private String detail_code; // 디테일 코드
    private String group_code; // 그룹코드
    private String detail_name; //디테일 이름
    private String dept_cd; // 부서_공통코드
    private String rank_cd; // 직급_공통코드
    private int exp_spent; // 지출금액
    private String yn_date; // 승인반려일자
    private String exp_yn; // 승인 y값
    private int salary_no; // 급여정보번호
    private String salary_date; // 급여지급일
    private String st_date; // 직원_입사일
    private String ed_date; // 직원_입사일
    private String lvst_date; // 직원_입사일
    private String lved_date; // 직원_입사일
    private String payyn; // 지급완료,대기
    private int exp_no; //
    
    private String laccount_cd;
    private String account_cd;
    private String exp_name;
    
    // 개인급여리스트
    private int oneno;
	private String onedate;
	private int oneypay;
    private int onempay;
    private int onenins;
    private int onehins;
    private int oneiins;
    private int oneeins;
    private int onetax;
    private int oneextra;
    private int onerpay;
    private int oneeno;
    private String onenm;
    private String onedept;
    private String onerank;
    
    
	public String getPay_date() {
		return pay_date;
	}
	public void setPay_date(String pay_date) {
		this.pay_date = pay_date;
	}
	public String getDept() {
		return dept;
	}
	public void setDept(String dept) {
		this.dept = dept;
	}
	public String getRank() {
		return rank;
	}
	public void setRank(String rank) {
		this.rank = rank;
	}
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
	public int getYear_pay() {
		return year_pay;
	}
	public void setYear_pay(int year_pay) {
		this.year_pay = year_pay;
	}
	public int getMonth_pay() {
		return month_pay;
	}
	public void setMonth_pay(int month_pay) {
		this.month_pay = month_pay;
	}
	public int getIns_n() {
		return ins_n;
	}
	public void setIns_n(int ins_n) {
		this.ins_n = ins_n;
	}
	public int getIns_h() {
		return ins_h;
	}
	public void setIns_h(int ins_h) {
		this.ins_h = ins_h;
	}
	public int getIns_e() {
		return ins_e;
	}
	public void setIns_e(int ins_e) {
		this.ins_e = ins_e;
	}
	public int getIns_i() {
		return ins_i;
	}
	public void setIns_i(int ins_i) {
		this.ins_i = ins_i;
	}
	public int getTax() {
		return tax;
	}
	public void setTax(int tax) {
		this.tax = tax;
	}
	public int getExtra() {
		return extra;
	}
	public void setExtra(int extra) {
		this.extra = extra;
	}
	public int getTotal() {
		return total;
	}
	public void setTotal(int total) {
		this.total = total;
	}
	public String getPay_yn() {
		return pay_yn;
	}
	public void setPay_yn(String pay_yn) {
		this.pay_yn = pay_yn;
	}
	public String getNego_date() {
		return nego_date;
	}
	public void setNego_date(String nego_date) {
		this.nego_date = nego_date;
	}
	public String getDetail_code() {
		return detail_code;
	}
	public void setDetail_code(String detail_code) {
		this.detail_code = detail_code;
	}
	public String getGroup_code() {
		return group_code;
	}
	public void setGroup_code(String group_code) {
		this.group_code = group_code;
	}
	public String getDetail_name() {
		return detail_name;
	}
	public void setDetail_name(String detail_name) {
		this.detail_name = detail_name;
	}
	public String getDept_cd() {
		return dept_cd;
	}
	public void setDept_cd(String dept_cd) {
		this.dept_cd = dept_cd;
	}
	public String getRank_cd() {
		return rank_cd;
	}
	public void setRank_cd(String rank_cd) {
		this.rank_cd = rank_cd;
	}
	public int getExp_spent() {
		return exp_spent;
	}
	public void setExp_spent(int exp_spent) {
		this.exp_spent = exp_spent;
	}
	public String getYn_date() {
		return yn_date;
	}
	public void setYn_date(String yn_date) {
		this.yn_date = yn_date;
	}
	public String getExp_yn() {
		return exp_yn;
	}
	public void setExp_yn(String exp_yn) {
		this.exp_yn = exp_yn;
	}
	public int getSalary_no() {
		return salary_no;
	}
	public void setSalary_no(int salary_no) {
		this.salary_no = salary_no;
	}
	public String getSalary_date() {
		return salary_date;
	}
	public void setSalary_date(String salary_date) {
		this.salary_date = salary_date;
	}
	public String getSt_date() {
		return st_date;
	}
	public void setSt_date(String st_date) {
		this.st_date = st_date;
	}
	public String getEd_date() {
		return ed_date;
	}
	public void setEd_date(String ed_date) {
		this.ed_date = ed_date;
	}
	public String getPayyn() {
		return payyn;
	}
	public void setPayyn(String payyn) {
		this.payyn = payyn;
	}
	public int getOneno() {
		return oneno;
	}
	public void setOneno(int oneno) {
		this.oneno = oneno;
	}
	public String getOnedate() {
		return onedate;
	}
	public void setOnedate(String onedate) {
		this.onedate = onedate;
	}
	public int getOneypay() {
		return oneypay;
	}
	public void setOneypay(int oneypay) {
		this.oneypay = oneypay;
	}
	public int getOnempay() {
		return onempay;
	}
	public void setOnempay(int onempay) {
		this.onempay = onempay;
	}
	public int getOnenins() {
		return onenins;
	}
	public void setOnenins(int onenins) {
		this.onenins = onenins;
	}
	public int getOnehins() {
		return onehins;
	}
	public void setOnehins(int onehins) {
		this.onehins = onehins;
	}
	public int getOneiins() {
		return oneiins;
	}
	public void setOneiins(int oneiins) {
		this.oneiins = oneiins;
	}
	public int getOneeins() {
		return oneeins;
	}
	public void setOneeins(int oneeins) {
		this.oneeins = oneeins;
	}
	public int getOnetax() {
		return onetax;
	}
	public void setOnetax(int onetax) {
		this.onetax = onetax;
	}
	public int getOneextra() {
		return oneextra;
	}
	public void setOneextra(int oneextra) {
		this.oneextra = oneextra;
	}
	public int getOnerpay() {
		return onerpay;
	}
	public void setOnerpay(int onerpay) {
		this.onerpay = onerpay;
	}
	public int getOneeno() {
		return oneeno;
	}
	public void setOneeno(int oneeno) {
		this.oneeno = oneeno;
	}
	public String getOnenm() {
		return onenm;
	}
	public void setOnenm(String onenm) {
		this.onenm = onenm;
	}
	public String getOnedept() {
		return onedept;
	}
	public void setOnedept(String onedept) {
		this.onedept = onedept;
	}
	public String getOnerank() {
		return onerank;
	}
	public void setOnerank(String onerank) {
		this.onerank = onerank;
	}
    public String getSloginID() {
		return sloginID;
	}
	public void setSloginID(String sloginID) {
		this.sloginID = sloginID;
	}
	public String getLvst_date() {
		return lvst_date;
	}
	public void setLvst_date(String lvst_date) {
		this.lvst_date = lvst_date;
	}
	public String getLved_date() {
		return lved_date;
	}
	public void setLved_date(String lved_date) {
		this.lved_date = lved_date;
	}
	public int getExp_no() {
		return exp_no;
	}
	public void setExp_no(int exp_no) {
		this.exp_no = exp_no;
	}
	public String getLaccount_cd() {
		return laccount_cd;
	}
	public void setLaccount_cd(String laccount_cd) {
		this.laccount_cd = laccount_cd;
	}
	public String getAccount_cd() {
		return account_cd;
	}
	public void setAccount_cd(String account_cd) {
		this.account_cd = account_cd;
	}
	public String getExp_name() {
		return exp_name;
	}
	public void setExp_name(String exp_name) {
		this.exp_name = exp_name;
	}
    
	
 
	
	
}
