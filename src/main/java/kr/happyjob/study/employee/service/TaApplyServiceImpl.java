package kr.happyjob.study.employee.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import kr.happyjob.study.employee.dao.TaApplyDao;
import kr.happyjob.study.employee.model.TaApplyModel;


@Service
public class TaApplyServiceImpl implements TaApplyService {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	// Get class name for logger
	private final String className = this.getClass().toString();
	
	@Autowired
	TaApplyDao taApplyDao;
	
	/* 근태 목록 조회 */
	public List<TaApplyModel> taApplylist(Map<String, Object> paramMap) throws Exception{
		
		return taApplyDao.taApplylist(paramMap);
	};	
	
	/* 근태 목록 카운트 조회 */
	public int counttaApplylist(Map<String, Object> paramMap) throws Exception{
		
		return taApplyDao.counttaApplylist(paramMap);
	};
	
	/* 총 휴가 및 남은 휴가 조회 */
	public List<TaApplyModel> total_rest(Map<String, Object> paramMap) throws Exception{
		
		return taApplyDao.total_rest(paramMap);
	}
	
	/* 근태 신청시 조회 */
	public TaApplyModel rest_info(Map<String, Object> paramMap) throws Exception{
		
		return taApplyDao.rest_info(paramMap);
	}
	
	/* 근태 신청 */
	public int taApplysave(Map<String, Object> paramMap) throws Exception{
		
		return taApplyDao.taApplysave(paramMap);
	}
	
	/* 반려사유 조회*/
	public TaApplyModel rest_reject(Map<String, Object> paramMap) throws Exception{
		
		return taApplyDao.rest_reject(paramMap);
	}
	
}
