package kr.happyjob.study.system.model;

public class NoticeModel {

	public int getNotice_no() {
		return notice_no;
	}
	public void setNotice_no(int notice_no) {
		this.notice_no = notice_no;
	}
	public String getLoginID() {
		return loginID;
	}
	public void setLoginID(String loginID) {
		this.loginID = loginID;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public String getNotice_title() {
		return notice_title;
	}
	public void setNotice_title(String notice_title) {
		this.notice_title = notice_title;
	}
	public String getNotice_date() {
		return notice_date;
	}
	public void setNotice_date(String notice_date) {
		this.notice_date = notice_date;
	}
	public String getNotice_det() {
		return notice_det;
	}
	public void setNotice_det(String notice_det) {
		this.notice_det = notice_det;
	}
	public String getFile_name() {
		return file_name;
	}
	public void setFile_name(String file_name) {
		this.file_name = file_name;
	}
	public int getFile_size() {
		return file_size;
	}
	public void setFile_size(int file_size) {
		this.file_size = file_size;
	}
	public String getFile_nadd() {
		return file_nadd;
	}
	public void setFile_nadd(String file_nadd) {
		this.file_nadd = file_nadd;
	}
	public String getFile_madd() {
		return file_madd;
	}
	public void setFile_madd(String file_madd) {
		this.file_madd = file_madd;
	}
	private int notice_no;
	private String loginID;
	private String writer;
	private String notice_title;
	private String notice_date;
	private String notice_det;
	private String file_name;
	private int file_size;
	private String file_nadd;
	private String file_madd;
	
	
}
