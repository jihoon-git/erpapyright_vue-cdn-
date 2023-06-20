package kr.happyjob.study.business.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.business.dao.BizPartnerDao;
import kr.happyjob.study.business.model.BizPartnerModel;

@Service
public class BizPartnerServiceImpl implements BizPartnerService {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	// Get class name for logger
	private final String className = this.getClass().toString();
	
	@Autowired
	BizPartnerDao bpDao;
	
	/** 거래처 목록 조회 */
	public List<BizPartnerModel> clientlist(Map<String, Object> paramMap) throws Exception{
		return bpDao.clientlist(paramMap);
	}
	
	/** 거래처 목록 카운트 조회 */
	public int countclientlist(Map<String, Object> paramMap) throws Exception{
		return bpDao.countclientlist(paramMap);
	}
	
	/** 거래처 상세 조회 */
	public BizPartnerModel clientdetail(Map<String, Object> paramMap) throws Exception{
		return bpDao.clientdetail(paramMap);
	}
	
	/** 거래처 저장 */
	public int clientsave(Map<String, Object> paramMap) throws Exception{
		return bpDao.clientsave(paramMap);
	}
	
	/** 거래처 업데이트 */
	public int clientupdate(Map<String, Object> paramMap) throws Exception{
		return bpDao.clientupdate(paramMap);
	}
	
	/** 거래처 삭제 */
	public int clientdelete(Map<String, Object> paramMap) throws Exception{
		return bpDao.clientdelete(paramMap);
	}

	/** 사업자번호 중복 체크 */
	public int checkPermitNo(BizPartnerModel model) throws Exception{
		return bpDao.checkPermitNo(model);
	}
}
