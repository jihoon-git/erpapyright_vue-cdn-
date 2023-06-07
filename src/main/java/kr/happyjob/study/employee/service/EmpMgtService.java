package kr.happyjob.study.employee.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.happyjob.study.employee.model.EmpMgtModel;

public interface EmpMgtService {

	/* 사원 목록 조회 */
	public List<EmpMgtModel> empMgtList(Map<String, Object> paramMap) throws Exception;

	/* 사원 목록 인원 수 조회 */
	public int countEmpMgtList(Map<String, Object> paramMap) throws Exception;

	/* 퇴직 처리 */
	public void retireEmp(Map<String, Object> paramMap) throws Exception;

	/*휴직 처리*/
	public void leaveEmp(Map<String, Object> paramMap) throws Exception;

	/*복직 처리*/
	public void comebackEmp(Map<String, Object> paramMap) throws Exception;
	
	/*사원 상세 조회*/
	public EmpMgtModel empMgtDet(Map<String, Object> paramMap) throws Exception;

	/*사원 정보 수정*/
	public int updateEmp(Map<String, Object> paramMap, HttpServletRequest request) throws Exception;

	/*연봉 입력*/
	public void insertNego(Map<String, Object> paramMap) throws Exception;

	/*연봉 수정*/
	public void updateNego(Map<String, Object> paramMap) throws Exception;


	
	
}
