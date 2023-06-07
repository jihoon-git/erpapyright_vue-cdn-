package kr.happyjob.study.business.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.business.dao.EmpSalePlanDao;
import kr.happyjob.study.business.model.EmpSalePlanModel;

@Service
public class EmpSalePlanServiceImpl implements EmpSalePlanService{

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	// Get class name for logger
	private final String className = this.getClass().toString();
	
	@Autowired
	EmpSalePlanDao empsaleplandao;

	/** 영업계획 리스트 */
	public List<EmpSalePlanModel> empsaleplanlist(Map<String, Object> paramMap) throws Exception {
		return empsaleplandao.empsaleplanlist(paramMap);
	}

	/** 영업계획 리스트 카운트 */
	public int countempsaleplan(Map<String, Object> paramMap) throws Exception {
		return empsaleplandao.countempsaleplan(paramMap);
	}

	/** 영업계획 저장 */
	public void newempsaleplan(Map<String, Object> paramMap) throws Exception {
		empsaleplandao.newempsaleplan(paramMap);
	}

	/** 영업계획 번호 체크 */
	public int plannocheck(Map<String, Object> paramMap) throws Exception {
		return empsaleplandao.plannocheck(paramMap);
		
	}
	
}
