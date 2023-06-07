package kr.happyjob.study.employee.service;

import java.util.List;





import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.happyjob.study.employee.model.TaApproveModel;;

public interface TaApproveService {

	/** 근태관리 목록 조회 */
	public List<TaApproveModel> taapprovelist(Map<String, Object> paramMap) throws Exception;
	
	/** 근태관리 목록 카운트 조회 */
	public int counttaApprovelist(Map<String, Object> paramMap) throws Exception;
	
	/** 근태관리 상세 조회 */
	public TaApproveModel detailone(Map<String, Object> paramMap) throws Exception;
	
	/** 근태 승인/반려 업데이트 */
	public int taapprovewupdate(Map<String, Object> paramMap) throws Exception;
	
	
}
