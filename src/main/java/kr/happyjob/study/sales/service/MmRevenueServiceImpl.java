package kr.happyjob.study.sales.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.sales.dao.MmRevenueDao;
import kr.happyjob.study.sales.model.MmRevenueModel;

@Service
public class MmRevenueServiceImpl implements MmRevenueService {
		
	@Autowired
	MmRevenueDao mmRevenueDao;
	
	/** 월별 매출 목록 조회 */
	public List<MmRevenueModel> mmRevenuelist(Map<String, Object> paramMap) throws Exception {
		
		return mmRevenueDao.mmRevenuelist(paramMap);
		
	}
	
	/** 상반기 매출 목록 조회  */
	public List<MmRevenueModel> mmRevenuelist1(Map<String, Object> paramMap) throws Exception {
		
		return mmRevenueDao.mmRevenuelist1(paramMap);
		
	}
	
	/** 하반기 매출 목록 조회  */
	public List<MmRevenueModel> mmRevenuelist2(Map<String, Object> paramMap) throws Exception {
	
		return mmRevenueDao.mmRevenuelist2(paramMap);
		
	}	
}
