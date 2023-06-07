package kr.happyjob.study.accounting.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.accounting.model.AccTitleModel;

public interface AccTitleDao {
	
	/** 계정과목 목록 조회 */
	public List<AccTitleModel> accTitlelist(Map<String, Object> paramMap) throws Exception;

	/** 계정과목 목록 카운트 조회 */
	public int countAcctitlelist(Map<String, Object> paramMap) throws Exception;
	
	/** 계정과목 상세 조회 */
	public AccTitleModel detailacc(Map<String, Object> paramMap) throws Exception;
	
	/** 계정과목 저장 */
	public int accTitlesave(Map<String, Object> paramMap) throws Exception;
	
	/** 계정과목 수정 */
	public int accTitleupdate(Map<String, Object> paramMap) throws Exception;
	
	/** 계정과목 삭제 */
	public int accTitledelete(Map<String, Object> paramMap) throws Exception;
	
	/** 계정과목명 중복체크*/
	public int accTitlenmck(Map<String, Object> paramMap) throws Exception;
	
	
}
