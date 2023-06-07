package kr.happyjob.study.business.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.business.model.BizPartnerModel;
import kr.happyjob.study.hwang.model.HnoticeModel;

public interface BizPartnerDao {

	/** 거래처 목록 조회 */
	public List<BizPartnerModel> clientlist(Map<String, Object> paramMap) throws Exception;		//메소드 이름이 쿼리문 아이디가 됨
	
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
}
