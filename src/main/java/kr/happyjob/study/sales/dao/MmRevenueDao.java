package kr.happyjob.study.sales.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.sales.model.MmRevenueModel;

public interface MmRevenueDao {

	/** 월별 매출 목록 조회 */
	public List<MmRevenueModel> mmRevenuelist(Map<String, Object> paramMap) throws Exception;
	
	/** 상반기 매출 목록 조회  */
	public List<MmRevenueModel> mmRevenuelist1(Map<String, Object> paramMap) throws Exception;
	
	/** 하반기 매출 목록 조회  */
	public List<MmRevenueModel> mmRevenuelist2(Map<String, Object> paramMap) throws Exception;
		
}
