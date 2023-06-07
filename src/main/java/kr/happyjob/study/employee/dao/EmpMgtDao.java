package kr.happyjob.study.employee.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.accounting.model.FileModel;
import kr.happyjob.study.employee.model.EmpMgtModel;
import kr.happyjob.study.hwang.model.HnoticeModel;
import kr.happyjob.study.system.model.ComnCodUtilModel;
import kr.happyjob.study.system.model.ComnDtlCodModel;
import kr.happyjob.study.system.model.ComnGrpCodModel;

public interface EmpMgtDao {

	/* 사원 목록 조회 */
	public List<EmpMgtModel> empMgtList(Map<String, Object> paramMap) throws Exception;
	
	/* 사원 목록 인원 수 조회 */
	public int countEmpMgtList(Map<String, Object> paramMap) throws Exception;

	/*퇴직 처리*/
	public void retireEmp(Map<String, Object> paramMap)throws Exception;

	/*휴직 처리*/
	public void leaveEmp(Map<String, Object> paramMap) throws Exception;

	/*복직 처리*/
	public void comebackEmp(Map<String, Object> paramMap) throws Exception;
	
	/*사원 상세 조회*/
	public EmpMgtModel empMgtDet(Map<String, Object> paramMap) throws Exception;

	/*사원 정보 수정*/
	public int updateEmp(Map<String, Object> paramMap) throws Exception;

	/*연봉 입력*/
	public void insertNego(Map<String, Object> paramMap) throws Exception;

	/*연봉 수정*/
	public void updateNego(Map<String, Object> paramMap) throws Exception;

	/*사원 사진 파일 update*/
	public void profileUpdate(Map<String, Object> paramMap) throws Exception;

	/*파일 정보 추출*/
	public FileModel getfiledetail(Map<String, Object> paramMap) throws Exception;

	/*이전 직급 번호 가져오기*/
	public String beforeRankcd(Map<String, Object> paramMap) throws Exception;

	/*승진 처리*/
	public void insertPromo(Map<String, Object> paramMap) throws Exception;


}
