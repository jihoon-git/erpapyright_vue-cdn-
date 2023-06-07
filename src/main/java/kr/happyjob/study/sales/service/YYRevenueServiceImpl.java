package kr.happyjob.study.sales.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.sales.model.YYRevenueModel;
import kr.happyjob.study.sales.dao.YYRevenueDao;
import kr.happyjob.study.sales.service.YYRevenueService;
@Service
public class YYRevenueServiceImpl implements YYRevenueService {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	// Get class name for logger
	private final String className = this.getClass().toString();
	
	@Autowired
	YYRevenueDao yYRevenueDao;
	
	/** 년매출 조회 */
	public YYRevenueModel yearList(Map<String, Object> paramMap) throws Exception{
		
		return yYRevenueDao.yearList(paramMap);
	};
	

}
