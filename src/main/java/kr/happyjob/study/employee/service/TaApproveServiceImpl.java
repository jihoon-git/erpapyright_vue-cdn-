package kr.happyjob.study.employee.service;

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

import kr.happyjob.study.employee.model.TaApproveModel;
import kr.happyjob.study.common.comnUtils.FileUtilCho;
import kr.happyjob.study.employee.dao.TaApproveDao;

import kr.happyjob.study.employee.service.TaApproveService;

@Service
public class TaApproveServiceImpl implements TaApproveService {

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
	TaApproveDao taApproveDao;
	
	/** 근태관리 목록 조회 */
	public List<TaApproveModel> taapprovelist(Map<String, Object> paramMap) throws Exception {
		
		return taApproveDao.taapprovelist(paramMap);
	};

	/** 근태관리 목록 카운트 조회 */
	public int counttaApprovelist(Map<String, Object> paramMap) throws Exception {
		
		return taApproveDao.counttaApprovelist(paramMap);
	};
	
	/** 근태관리 상세 조회 */
	public TaApproveModel detailone(Map<String, Object> paramMap) throws Exception {
		return taApproveDao.detailone(paramMap);
	};

	/** 근태 승인/반려 업데이트 */
	public int taapprovewupdate(Map<String, Object> paramMap) throws Exception {
		return taApproveDao.taapprovewupdate(paramMap);
	};

   
}
