package kr.happyjob.study.employee.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.employee.model.EmpPaymentModel;
import kr.happyjob.study.employee.dao.EmpPaymentDao;
import kr.happyjob.study.employee.service.EmpPaymentService;
@Service
public class EmpPaymentServiceImpl implements EmpPaymentService {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	// Get class name for logger
	private final String className = this.getClass().toString();
	
	@Autowired
	EmpPaymentDao empPaymentDao;
	
	/** 급여처리 목록 조회 */
	public List<EmpPaymentModel> empPaylist(Map<String, Object> paramMap) throws Exception{
		
		return empPaymentDao.empPaylist(paramMap);
	};
	
	/** 급여처리 목록 no limit 조회 */
	public List<EmpPaymentModel> empPaynolist(Map<String, Object> paramMap) throws Exception{
		
		return empPaymentDao.empPaynolist(paramMap);
	};
	
	
	/** 급여처리 목록 총 카운트 조회 */
	public int cntempPaylist(Map<String, Object> paramMap) throws Exception{
		
		return empPaymentDao.cntempPaylist(paramMap);
	}
	
	/** 개인 급여 목록 조회 */
	public List<EmpPaymentModel> empOnelist(Map<String, Object> paramMap) throws Exception{
		
		return empPaymentDao.empOnelist(paramMap);
	};
	
	/** 개인 급여 목록 총 카운트 조회 */
	public int cntempOnelist(Map<String, Object> paramMap) throws Exception{
		
		return empPaymentDao.cntempOnelist(paramMap);
	};
	
	/** 급여 저장 */
	public int empsave(Map<String, Object> paramMap) throws Exception{
		int emp = 0;
		
		if(empPaymentDao.empsave(paramMap) != 0 && empPaymentDao.empsave_exp(paramMap)!= 0){
			emp = 1;
		}
		return emp;
	};
	
	/** 급여 일괄저장 급여버전 */
	public int empsaveall(Map<String, Object> paramMap) throws Exception{
		
		return empPaymentDao.empsaveall(paramMap);
	};
	/** 급여 일괄저장 지출버전 */
	public int empsave_expall(Map<String, Object> paramMap) throws Exception{
		
		return empPaymentDao.empsave_expall(paramMap);
	};
	
}
