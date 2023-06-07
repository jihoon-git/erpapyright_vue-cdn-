package kr.happyjob.study.business.service;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.business.model.BizPartnerModel;
import kr.happyjob.study.business.model.EmpSalePlanModel;


public interface EmpSalePlanService {

	/** 영업계획 리스트 조회 */
	List<EmpSalePlanModel> empsaleplanlist(Map<String, Object> paramMap) throws Exception;

	/** 영업계획 리스트 카운트 */
	int countempsaleplan(Map<String, Object> paramMap) throws Exception;

	/** 영업계획 신규 등록 */
	void newempsaleplan(Map<String, Object> paramMap) throws Exception;

	/** 영업계획 체크 */
	int plannocheck(Map<String, Object> paramMap) throws Exception;
	
	}
