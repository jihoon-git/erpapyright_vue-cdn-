package kr.happyjob.study.employee.dao;

import java.util.List;
import java.util.Map;


import kr.happyjob.study.employee.model.EmpPayHistModel;

public interface EmpPayHistDao {	
	
	/** 개인 급여 조회 */
	public List<EmpPayHistModel> empHislist(Map<String, Object> paramMap) throws Exception;
	
	/** 개인 급여 카운트 조회 */
	public int cntempHislist(Map<String, Object> paramMap) throws Exception;
	
	/** 급여 상세 조회 */
	public EmpPayHistModel empHisdetail(Map<String, Object> paramMap) throws Exception;
	
	
	
}
