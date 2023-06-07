package kr.happyjob.study.employee.dao;

import java.util.List;
import java.util.Map;


import kr.happyjob.study.employee.model.EmpPaymentModel;

public interface EmpPaymentDao {

	/** 급여처리 목록 조회 */
	public List<EmpPaymentModel> empPaylist(Map<String, Object> paramMap) throws Exception;
	
	/** 급여처리 목록 limit 없는 조회 */
	public List<EmpPaymentModel> empPaynolist(Map<String, Object> paramMap) throws Exception;
	
	/** 급여처리 목록 총 카운트 조회 */
	public int cntempPaylist(Map<String, Object> paramMap) throws Exception;
	
	/** 개인 급여 목록 조회 */
	public List<EmpPaymentModel> empOnelist(Map<String, Object> paramMap) throws Exception;
	
	/** 개인 급여 목록 총 카운트 조회 */
	public int cntempOnelist(Map<String, Object> paramMap) throws Exception;
	
	/** 급여 저장  급여tb*/
	public int empsave(Map<String, Object> paramMap) throws Exception;
	
	/** 급여 저장 지출tb  */
	public int empsave_exp(Map<String, Object> paramMap) throws Exception;
	
	/** 급여 일괄저장 급여tb */
	public int empsaveall(Map<String, Object> paramMap) throws Exception;
	/** 급여 일괄저장 지출tb */
	public int empsave_expall(Map<String, Object> paramMap) throws Exception;
	
	
	
}
