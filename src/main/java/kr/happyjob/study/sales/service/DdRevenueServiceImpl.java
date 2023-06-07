package kr.happyjob.study.sales.service;


import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.sales.dao.DdRevenueDao;
import kr.happyjob.study.sales.model.DdRevenueModel;

@Service
public class DdRevenueServiceImpl implements DdRevenueService {
		
	@Autowired
	DdRevenueDao ddRevenueDao;
	

	/*일별주문조회 리스트*/
	@Override
	public List<DdRevenueModel> ddRevenueList(Map<String, Object> paramMap) throws Exception {
		
		return ddRevenueDao.ddRevenueList(paramMap);
	}


	/*일별주문 리스트 카운트*/
	@Override
	public int countRevenueList(Map<String, Object> paramMap) throws Exception {
		
		return ddRevenueDao.countRevenueList(paramMap);
	}


	/*일별매출/한달간 누적매출*/
	@Override
	public List<DdRevenueModel> ddRevChart(Map<String, Object> paramMap) throws Exception {
		
		return ddRevenueDao.ddRevChart(paramMap);
	}

	/*일자별 품목별 매출*/
	@Override
	public List<DdRevenueModel> ddRevProductChart(Map<String, Object> paramMap) throws Exception {

		return ddRevenueDao.ddRevProductChart(paramMap);
	}
	 

		
}
