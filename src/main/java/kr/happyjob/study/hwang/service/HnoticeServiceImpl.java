package kr.happyjob.study.hwang.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.hwang.model.HnoticeModel;
import kr.happyjob.study.hwang.dao.HnoticeDao;
import kr.happyjob.study.hwang.service.HnoticeService;

@Service
public class HnoticeServiceImpl implements HnoticeService {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	// Get class name for logger
	private final String className = this.getClass().toString();
	
	@Autowired
	HnoticeDao hnoticeDao;
	
	/** 공지사항 목록 조회 */
	public List<HnoticeModel> hnoticelist(Map<String, Object> paramMap) throws Exception{
		
		return hnoticeDao.hnoticelist(paramMap);
	};
	
	/** 공지사항 목록 카운트 조회 */
	public int counthnoticelist(Map<String, Object> paramMap) throws Exception{
		return hnoticeDao.counthnoticelist(paramMap);
	};
	
	/** 공지사항 신규저장 */
	public int hnoticenewsave(Map<String, Object> paramMap) throws Exception{
		return hnoticeDao.hnoticenewsave(paramMap);
	};
	
	/** 공지사항 수정 */
	public int hnoticenewupdate(Map<String, Object> paramMap) throws Exception {
		return hnoticeDao.hnoticenewupdate(paramMap);
	};
	
	/** 공지사항 상세 조회 */
	public HnoticeModel detailone (Map<String, Object> paramMap) throws Exception{
		return hnoticeDao.detailone(paramMap);
	};
}
