package kr.happyjob.study.sales.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.sales.model.DdRevenueModel;

public interface DdRevenueDao {
	
	/*일별주문조회 리스트*/
	List<DdRevenueModel> ddRevenueList(Map<String, Object> paramMap);


	/*일별주문 리스트 카운트*/
	int countRevenueList(Map<String, Object> paramMap);


	/*일별매출/한달간 누적매출*/
	List<DdRevenueModel> ddRevChart(Map<String, Object> paramMap);

	/*일자별 품목별 매출*/
	List<DdRevenueModel> ddRevProductChart(Map<String, Object> paramMap);
	
	
}
