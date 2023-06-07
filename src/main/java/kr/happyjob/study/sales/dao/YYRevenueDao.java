package kr.happyjob.study.sales.dao;

import java.util.List;
import java.util.Map;


import kr.happyjob.study.sales.model.YYRevenueModel;

public interface YYRevenueDao {

	/** 년매출 조회 */
	public YYRevenueModel yearList(Map<String, Object> paramMap) throws Exception;
	
	
	
}
