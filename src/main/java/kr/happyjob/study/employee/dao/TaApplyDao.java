package kr.happyjob.study.employee.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.employee.model.TaApplyModel;


public interface TaApplyDao {

	/* 근태신청 목록 조회 */
	public List<TaApplyModel> taApplylist(Map<String, Object> paramMap) throws Exception;		//메소드 이름이 쿼리문 아이디가 됨	
	
	/* 근태 목록 카운트 조회 */
	public int counttaApplylist(Map<String, Object> paramMap) throws Exception;
	
	/* 총 휴가 및 남은 휴가 조회 */
	public List<TaApplyModel> total_rest(Map<String, Object> paramMap) throws Exception;
	
	/* 근태 신청 */
	public int taApplysave(Map<String, Object> paramMap) throws Exception;
		
	/* 근태 신청시 조회 */
	public TaApplyModel rest_info(Map<String, Object> paramMap) throws Exception;
	
	/* 반려사유 조회*/
	public TaApplyModel rest_reject(Map<String, Object> paramMap) throws Exception;
	
}
