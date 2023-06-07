package kr.happyjob.study.sales.service;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.sales.model.YYRevenueModel;


public interface YYRevenueService {

	/** 년매출 조회 */
	public YYRevenueModel yearList(Map<String, Object> paramMap) throws Exception;

	/** 년매출 조회 */
	//public List<YYRevenueModel> yearList(Map<String, Object> paramMap) throws Exception;
	
}
