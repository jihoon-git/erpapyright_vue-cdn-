package kr.happyjob.study.business.dao;

import java.util.List;
import java.util.Map;


import kr.happyjob.study.business.model.EstManagementModel;

public interface EstManagementDao {

	/** 견적서 목록 조회 */
	public List<EstManagementModel> estmanagementlist(Map<String, Object> paramMap) throws Exception;
	
	/** 견적서 목록 총 카운트 조회 */
	public int cntestmanagementlist(Map<String, Object> paramMap) throws Exception;
	
	/** 견적서 상세조회 */
	public EstManagementModel estdetail(Map<String, Object> paramMap) throws Exception;
	
	/** 견적서 저장 */
	public int estsave(Map<String, Object> paramMap) throws Exception;
	/** 견적서 삭제 */
	public int estdelete(Map<String, Object> paramMap) throws Exception;
	
	/** 제품 선택시 값 저장 */
	public EstManagementModel savechange(Map<String, Object> paramMap) throws Exception;
	
}
