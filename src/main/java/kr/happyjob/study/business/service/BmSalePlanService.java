package kr.happyjob.study.business.service;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.business.model.BmSalePlanModel;


public interface BmSalePlanService {

	/** 공지사항 목록 조회 */
	public List<BmSalePlanModel> bmsaleplanlist(Map<String, Object> paramMap) throws Exception;

	public int countbmsaleplan(Map<String, Object> paramMap) throws Exception;
	
	
}
