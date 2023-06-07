package kr.happyjob.study.hwang.dao;

import java.util.List;
import java.util.Map;


import kr.happyjob.study.hwang.model.HnoticeModel;

public interface HnoticeDao {

	/** 공지사항 목록 조회 */
	public List<HnoticeModel> hnoticelist(Map<String, Object> paramMap) throws Exception;		//메소드 이름이 쿼리문 아이디가 됨
	
	/** 공지사항 목록 카운트 조회 */
	public int counthnoticelist(Map<String, Object> paramMap) throws Exception;
	
	/** 공지사항 저장 */
	public int hnoticenewsave(Map<String, Object> paramMap) throws Exception;
	
	
	/** 공지사항 수정 */
	public int hnoticenewupdate(Map<String, Object> paramMap) throws Exception;
	
	/** 공지사항 상세 조회 */
	public HnoticeModel detailone (Map<String, Object> paramMap) throws Exception;
	
	
}
