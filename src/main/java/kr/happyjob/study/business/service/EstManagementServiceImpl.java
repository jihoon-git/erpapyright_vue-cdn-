package kr.happyjob.study.business.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.business.model.EstManagementModel;
import kr.happyjob.study.business.dao.EstManagementDao;
import kr.happyjob.study.business.service.EstManagementService;

@Service
public class EstManagementServiceImpl implements EstManagementService {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	// Get class name for logger
	private final String className = this.getClass().toString();
	
	@Autowired
	EstManagementDao estManagementDao;
	
	/** 견적서 목록 조회 */
	public List<EstManagementModel> estmanagementlist(Map<String, Object> paramMap) throws Exception{
		
		return estManagementDao.estmanagementlist(paramMap);
	};
	
	/** 견적서 목록 총 카운트 조회 */
	public int cntestmanagementlist(Map<String, Object> paramMap) throws Exception{
		
		return estManagementDao.cntestmanagementlist(paramMap);
	}
	
	/** 견적서 상세조회 */
	public EstManagementModel estdetail(Map<String, Object> paramMap) throws Exception{
		return estManagementDao.estdetail(paramMap);
	};
	
	/** 견적서 저장 */
	public int estsave(Map<String, Object> paramMap) throws Exception{
		
		return estManagementDao.estsave(paramMap);
	};
	
	/** 견적서 삭제 */
	public int estdelete(Map<String, Object> paramMap) throws Exception{
		return estManagementDao.estdelete(paramMap);
	};
	
	/** 제품 선택시 값 저장 */
	public EstManagementModel savechange(Map<String, Object> paramMap) throws Exception{
		
		return estManagementDao.savechange(paramMap);
	};
	
	
}
