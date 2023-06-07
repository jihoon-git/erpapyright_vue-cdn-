package kr.happyjob.study.accounting.service;

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

import kr.happyjob.study.accounting.dao.AccountSlipDao;
import kr.happyjob.study.accounting.model.AccountSlipModel;
import kr.happyjob.study.accounting.model.AccSlipDetaileModel;
import kr.happyjob.study.accounting.model.DetileAccountListModel;
import kr.happyjob.study.accounting.model.MidProductListModel;
import kr.happyjob.study.accounting.model.ProductListModel;
import kr.happyjob.study.business.model.BizPartnerModel;
import kr.happyjob.study.common.comnUtils.FileUtilCho;

@Service
public class AccountSlipServiceImpl implements AccountSlipService {

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
	AccountSlipDao accountSlipDao;

	/** 회계전표 목록 조회 */
	@Override
	public List<AccountSlipModel> accountSlipList(Map<String, Object> paramMap) throws Exception {
		logger.info("+ Start " + className+".accSlipFList");
		logger.info("   - paramMap : " + paramMap+".accSlipFList");
		
		List<AccountSlipModel> accountSlipList = accountSlipDao.accountSlipList(paramMap);
		
		logger.info("+ End " + className+".accSlipFList");
		
		return accountSlipList;
	}
	
	/** 회계전표 목록 카운트 조회 */
	@Override
	public int accountSlipListTotalCnt(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		logger.info("+ Start " + className+".accountSlipListTotalCnt");
		logger.info("   - paramMap : " + paramMap+".accountSlipListTotalCnt");
		int totalCnt = accountSlipDao.accountSlipListTotalCnt(paramMap);
		logger.info("+ End " + className+".accountSlipListTotalCnt");
		return totalCnt;
	}

	/** 거래처리스트 */
	@Override
	public List<BizPartnerModel> clientlist(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		return accountSlipDao.clientlist(paramMap);
	}
	
	/** 계정과목리스트 */
	@Override
	public List<DetileAccountListModel> detileAccountList(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		
		return accountSlipDao.detileAccountList(paramMap);
	}
	
	/** 제품리스트 */
	@Override
	public List<ProductListModel> productList(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		return accountSlipDao.productList(paramMap);
	}
	
	/** 제품 중분류 목록 */
	@Override
	public List<MidProductListModel> midProductList(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		return accountSlipDao.midProductList(paramMap);
	}
	
	/** 회계전표 단건 조회 */
	@Override
	public List<AccSlipDetaileModel> accSlipDetaile(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		return accountSlipDao.accSlipDetaile(paramMap);
	}
	
}
