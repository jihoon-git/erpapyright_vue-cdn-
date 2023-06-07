package kr.happyjob.study.employee.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.employee.model.EmpPayHistModel;
import kr.happyjob.study.employee.dao.EmpPayHistDao;
import kr.happyjob.study.employee.service.EmpPayHistService;
@Service
public class EmpPayHistServiceImpl implements EmpPayHistService {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	// Get class name for logger
	private final String className = this.getClass().toString();
	
	@Autowired
	EmpPayHistDao empPayHistDao;
	
	/** 개인 급여 조회 */
	public List<EmpPayHistModel> empHislist(Map<String, Object> paramMap) throws Exception{
		return empPayHistDao.empHislist(paramMap);
	};
	
	/** 개인 급여 카운트 조회 */
	public int cntempHislist(Map<String, Object> paramMap) throws Exception{
		return empPayHistDao.cntempHislist(paramMap);
	};
	
	/** 급여 상세 조회 */
	public EmpPayHistModel empHisdetail(Map<String, Object> paramMap) throws Exception{
		
		return empPayHistDao.empHisdetail(paramMap);
	};
	
	
}
