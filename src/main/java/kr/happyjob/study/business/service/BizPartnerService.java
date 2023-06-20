package kr.happyjob.study.business.service;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.business.model.BizPartnerModel;


public interface BizPartnerService {

	/** 거래처 목록 조회 */
	public List<BizPartnerModel> clientlist(Map<String, Object> paramMap) throws Exception;
	
	/** 거래처 목록 카운트 조회 */
	public int countclientlist(Map<String, Object> paramMap) throws Exception;
	
	/** 거래처 상세 조회 */
	public BizPartnerModel clientdetail(Map<String, Object> paramMap) throws Exception;
	
	/** 거래처 저장 */
	public int clientsave(Map<String, Object> paramMap) throws Exception;
	
	/** 거래처 업데이트 */
	public int clientupdate(Map<String, Object> paramMap) throws Exception;
	
	/** 거래처 삭제 */
	public int clientdelete(Map<String, Object> paramMap) throws Exception;

	/** 사업자번호 중복 체크 */
	public int checkPermitNo(BizPartnerModel model) throws Exception;
}
