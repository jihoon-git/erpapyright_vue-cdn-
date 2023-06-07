package kr.happyjob.study.accounting.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.accounting.dao.AccTitleDao;
import kr.happyjob.study.accounting.model.AccTitleModel;

@Service
public class AccTitleServiceImpl implements AccTitleService {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	// Get class name for logger
	private final String className = this.getClass().toString();

	
	@Autowired
	AccTitleDao accTitleDao;
	
	/** 계정과목 목록 조회 */
	public List<AccTitleModel> accTitlelist(Map<String, Object> paramMap) throws Exception{
		return accTitleDao.accTitlelist(paramMap);
	};
	
	
	/** 계정과목 목록 카운트 조회 */
	public int countAcctitlelist(Map<String, Object> paramMap) throws Exception{
		return accTitleDao.countAcctitlelist(paramMap);
	};
	
	/** 계정과목 상세 조회 */
	public AccTitleModel detailacc(Map<String, Object> paramMap) throws Exception{
		return accTitleDao.detailacc(paramMap);
	};
	
	/** 계정과목 저장 */
	public int accTitlesave(Map<String, Object> paramMap) throws Exception{
		return accTitleDao.accTitlesave(paramMap);
	};
	
	/** 계정과목 수정 */
	public int accTitleupdate(Map<String, Object> paramMap) throws Exception{
		return accTitleDao.accTitleupdate(paramMap);
	};
	
	/** 계정과목 삭제 */
	public int accTitledelete(Map<String, Object> paramMap) throws Exception{
		return accTitleDao.accTitledelete(paramMap);
	};
	
	/** 계정과목명 중복체크*/
	public int accTitlenmck(Map<String, Object> paramMap) throws Exception{
		return accTitleDao.accTitlenmck(paramMap);
	};
	
}
