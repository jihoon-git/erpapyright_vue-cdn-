package kr.happyjob.study.employee.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.employee.dao.EmpGradeDao;
import kr.happyjob.study.employee.model.EmpGradeModel;

@Service
public class EmpGradeServiceImpl implements EmpGradeService {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	// Get class name for logger
	private final String className = this.getClass().toString();

	
	@Autowired
	EmpGradeDao empGradeDao;
	
	/** 승진내역 목록 조회 */
	public List<EmpGradeModel> empGradelist(Map<String, Object> paramMap) throws Exception{
		return empGradeDao.empGradelist(paramMap);
	};
	
	
	/** 승진내역 목록 카운트 조회 */
	public int countEmpgradelist(Map<String, Object> paramMap) throws Exception{
		return empGradeDao.countEmpgradelist(paramMap);
	};
	
	/** 승진내역 상세 조회 */
	public List<EmpGradeModel> detailEmp(Map<String, Object> paramMap) throws Exception{
		return empGradeDao.detailEmp(paramMap);
	};
	
	/** 승진내역 상세 목록 카운트 조회 */
	public int countEmpdetail(Map<String, Object> paramMap) throws Exception{
		return empGradeDao.countEmpdetail(paramMap);
	};
	
	/** 승진내역 저장 */
	public int empGradesave(Map<String, Object> paramMap) throws Exception{
		empGradeDao.updateRank(paramMap);		// 유저 테이블 직급 update
		return empGradeDao.empGradesave(paramMap);
	};
	
	/** 승진내역 삭제 */
	public int empGradedelete(Map<String, Object> paramMap) throws Exception{
		return empGradeDao.empGradedelete(paramMap);
	};
}
