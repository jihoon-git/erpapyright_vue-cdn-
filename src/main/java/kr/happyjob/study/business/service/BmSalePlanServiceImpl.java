package kr.happyjob.study.business.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.business.dao.BmSalePlanDao;
import kr.happyjob.study.business.model.BmSalePlanModel;

@Service
public class BmSalePlanServiceImpl implements BmSalePlanService {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	// Get class name for logger
	private final String className = this.getClass().toString();
	
	@Autowired
	BmSalePlanDao bmsaleplandao;
	
	/** 공지사항 목록 조회 */
	public List<BmSalePlanModel> bmsaleplanlist(Map<String, Object> paramMap) throws Exception{
		
		return bmsaleplandao.bmsaleplanlist(paramMap);
	}

	@Override
	public int countbmsaleplan(Map<String, Object> paramMap) throws Exception {
		return bmsaleplandao.countbmsaleplan(paramMap);
	};
}
