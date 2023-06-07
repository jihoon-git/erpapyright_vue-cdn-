package kr.happyjob.study.employee.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.employee.model.EmpGradeModel;

public interface EmpGradeDao {
	
	/** 승진내역 목록 조회 */
	public List<EmpGradeModel> empGradelist(Map<String, Object> paramMap) throws Exception;

	/** 승진내역 목록 카운트 조회 */
	public int countEmpgradelist(Map<String, Object> paramMap) throws Exception;
	
	/** 승진내역 상세 조회 */
	public List<EmpGradeModel> detailEmp(Map<String, Object> paramMap) throws Exception;
	
	/** 승진내역 상세 목록 카운트 조회 */
	public int countEmpdetail(Map<String, Object> paramMap) throws Exception;
	
	/** 승진내역 저장 */
	public int empGradesave(Map<String, Object> paramMap) throws Exception;
	
	/** 승진내역 삭제 */
	public int empGradedelete(Map<String, Object> paramMap) throws Exception;
	
	/** 유저 테이블 직급 update */
	public void updateRank(Map<String, Object> paramMap) throws Exception;
	
}
