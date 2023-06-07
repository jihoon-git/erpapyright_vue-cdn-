package kr.happyjob.study.business.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.business.model.BmSalePlanModel;

public interface BmSalePlanDao {

	/** 영업실적 조회 */
	public List<BmSalePlanModel> bmsaleplanlist(Map<String, Object> paramMap) throws Exception;		//메소드 이름이 쿼리문 아이디가 됨

	public int countbmsaleplan(Map<String, Object> paramMap) throws Exception;
}
