package kr.happyjob.study.business.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.business.model.BizPartnerModel;
import kr.happyjob.study.business.model.EmpSalePlanModel;
import kr.happyjob.study.hwang.model.HnoticeModel;

public interface EmpSalePlanDao {

	/** 영업계획 리스트 */
	public List<EmpSalePlanModel> empsaleplanlist(Map<String, Object> paramMap) throws Exception;

	/** 영업계획 리스트 카운트 */
	public int countempsaleplan(Map<String, Object> paramMap) throws Exception;

	/** 신규 영업 계획 등록 */
	public void newempsaleplan(Map<String, Object> paramMap)throws Exception;

	/** 영업 게획 번호 체크 */
	public int plannocheck(Map<String, Object> paramMap) throws Exception;
	
}
