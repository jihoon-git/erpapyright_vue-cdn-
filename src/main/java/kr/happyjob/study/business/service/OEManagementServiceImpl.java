package kr.happyjob.study.business.service;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.happyjob.study.business.dao.OEManagementSeDao;
import kr.happyjob.study.business.model.ContractDetaileModel;
import kr.happyjob.study.business.model.OEManagementModel;
import kr.happyjob.study.common.comnUtils.FileUtilCho;

@Service
public class OEManagementServiceImpl implements OEManagementService {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	// Get class name for logger
	private final String className = this.getClass().toString();
	
	@Value("${fileUpload.rootPath}")
	private String rootPath;
	
	@Value("${fileUpload.logicalrootPath}")
	private String logicalrootPath;
	
	@Value("${fileUpload.noticePath}")
	private String noticePath;

	@Autowired
	OEManagementSeDao oEManagementSeDao;

	/** 수주 목록 조회 */
	@Override
	public List<OEManagementModel> oEManagementList(Map<String, Object> paramMap) throws Exception {
		logger.info("+ Start " + className+".oEManagementList");
		logger.info("   - paramMap : " + paramMap+".oEManagementList");
		
		List<OEManagementModel> oEManagementList = oEManagementSeDao.oEManagementList(paramMap);
		
		logger.info("+ End " + className+".oEManagementList");
		
		return oEManagementList;
	}
	
	/** 수주 목록 카운트 조회 */
	@Override
	public int oEManagementListCnt(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		logger.info("+ Start " + className+".accountSlipListTotalCnt");
		logger.info("   - paramMap : " + paramMap+".accountSlipListTotalCnt");
		int totalCnt = oEManagementSeDao.oEManagementListCnt(paramMap);
		logger.info("+ End " + className+".accountSlipListTotalCnt");
		return totalCnt;
	}

	/** 수주 단건 조회 */
	@Override
	public List<ContractDetaileModel> contractDetaile(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		return oEManagementSeDao.contractDetaile(paramMap);
	}

	/** selectKey생성 */
	@Override
	public ContractDetaileModel selectKey(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		return oEManagementSeDao.selectKey(paramMap);
	}
	
	/** 수주등록 */
	@Override
	public int orderSave(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		
		int ok = oEManagementSeDao.orderSave(paramMap);
		
		return ok;
	}
	
	/** 제품 재고 수정 */
	@Override
	public int prcductUpdate(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		return oEManagementSeDao.prcductUpdate(paramMap);
	}
	
	/** 계약서 상태 수정 */
	@Override
	public int contractUpdate(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		return oEManagementSeDao.contractUpdate(paramMap);
	}
	
	/** 회계정보 등록 */
	@Override
	public int accuntInfo(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		return oEManagementSeDao.accuntInfo(paramMap);
	}
	
	/** 영업실적 수정 */
	@Override
	public int bSalePlanUpdate(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		return oEManagementSeDao.bSalePlanUpdate(paramMap);
	}
	
}
