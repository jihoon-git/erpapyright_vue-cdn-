package kr.happyjob.study.business.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.business.model.ContractDetaileModel;
import kr.happyjob.study.business.model.OEManagementModel;

public interface OEManagementSeDao {

	/** 수주 목록 조회 */
	public List<OEManagementModel> oEManagementList(Map<String, Object> paramMap);
	
	/** 수주 목록 카운트 조회 */
	public int oEManagementListCnt(Map<String, Object> paramMap);
	
	/** 수주 단건 조회 */
	public List<ContractDetaileModel> contractDetaile(Map<String, Object> paramMap) throws Exception;

	/** selectKey생성 */
	public ContractDetaileModel selectKey(Map<String, Object> paramMap) throws Exception;
	
	/** 수주등록 */
	public int orderSave(Map<String, Object> paramMap) throws Exception;
	
	/** 제품 재고 수정 */
	public int prcductUpdate(Map<String, Object> paramMap) throws Exception;
	
	/** 계약서 상태 수정 */
	public int contractUpdate(Map<String, Object> paramMap) throws Exception;
	
	/** 회계정보 등록 */
	public int accuntInfo(Map<String, Object> paramMap) throws Exception;
	
	/** 영업실적 수정 */
	public int bSalePlanUpdate(Map<String, Object> paramMap) throws Exception;
	
}
