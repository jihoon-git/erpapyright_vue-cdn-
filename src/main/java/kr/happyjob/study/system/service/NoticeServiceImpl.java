package kr.happyjob.study.system.service;

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

import kr.happyjob.study.system.model.NoticeModel;
import kr.happyjob.study.common.comnUtils.FileUtilCho;
import kr.happyjob.study.system.dao.NoticeDao;

import kr.happyjob.study.system.service.NoticeService;

@Service
public class NoticeServiceImpl implements NoticeService {

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
	NoticeDao noticeDao;
	
	/* 곻지사항 목록 조회 */
	public List<NoticeModel> noticelist(Map<String, Object> paramMap) throws Exception{
		
		return noticeDao.noticelist(paramMap);
	}
	
	/* 곻지사항 목록 카운트 조회  */
	public int countnoticelist(Map<String, Object> paramMap) throws Exception {
		
		return noticeDao.countnoticelist(paramMap);
	}
		
	/* 곻지사항 신규저장  */
	public int noticenewsave(Map<String, Object> paramMap) throws Exception {
		paramMap.put("fileyn", "N");
		
		return noticeDao.noticenewsave(paramMap);
	}
	
	/* 곻지사항 상세 조회  */
	public NoticeModel detailone(Map<String, Object> paramMap) throws Exception {
		
		return noticeDao.detailone(paramMap);
	}
	
	/* 곻지사항 수정  */
	public int noticenewupdate(Map<String, Object> paramMap) throws Exception {
		paramMap.put("fileyn", "N");
		return noticeDao.noticenewupdate(paramMap);
	}
	
	/* 곻지사항 삭제  */
	public int noticenewdelete(Map<String, Object> paramMap) throws Exception {
		return noticeDao.noticenewdelete(paramMap);
	}
	
	/* 곻지사항 저장 파일  */
	public int noticenewsavefile(Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
		
		// rootPath X:\\FileRepository       noticePath : notice    X:\\FileRepository\notice\a.jpg    
		// File.separator      window : \    linux : /
		
		
		//파일저장
		String itemFilePath = noticePath + File.separator; // 업로드 실제 경로 조립 (무나열생성)
		FileUtilCho fileUtil = new FileUtilCho(multipartHttpServletRequest, rootPath, itemFilePath);
		Map<String, Object> fileInfo = fileUtil.uploadFiles(); // 실제 업로드 처리
		
		fileInfo.put("file_nadd",logicalrootPath + File.separator + itemFilePath + fileInfo.get("file_nm"));
		paramMap.put("fileInfo", fileInfo);
		
		
		// map.put("file_nm", file_nm);
        // map.put("file_size", file_Size);
        // map.put("file_loc", file_loc);
        // map.put("fileExtension", fileExtension);
		
		//#{file_name}   
        //, #{file_size}
        //, #{file_nadd}  
        //, #{file_madd} 	
		
		paramMap.put("file_name", fileInfo.get("file_nm"));
		paramMap.put("file_size", fileInfo.get("file_size"));
		paramMap.put("file_madd", fileInfo.get("file_loc"));
		
		if(fileInfo.get("file_nm") != null || !"".equals((String) fileInfo.get("file_nm"))) {
			paramMap.put("file_nadd", logicalrootPath + File.separator + itemFilePath + fileInfo.get("file_nm"));
		} else {
			paramMap.put("file_nadd",null);
		}		
		
		// logicalrootPath    /serverfile/     itemFilePath    notice/     /serverfile/notice/1.png
		
		paramMap.put("fileyn", "Y");
		
		return noticeDao.noticenewsave(paramMap);
		
	}
	
    public int noticenewupdatefile(Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
		
		// rootPath X:\\FileRepository       noticePath : notice    X:\\FileRepository\notice\a.jpg    
		// File.separator      window : \    linux : /
		
		paramMap.put("notice_no", paramMap.get("noticeno"));		
		
		NoticeModel detailone = noticeDao.detailone(paramMap);
		
		if(detailone.getFile_name() != null) {
			File exitfiel = new File(detailone.getFile_madd());
			
			exitfiel.delete();
		}
		
		//파일저장
		String itemFilePath = noticePath + File.separator; // 업로드 실제 경로 조립 (무나열생성)
		FileUtilCho fileUtil = new FileUtilCho(multipartHttpServletRequest, rootPath, itemFilePath);
		Map<String, Object> fileInfo = fileUtil.uploadFiles(); // 실제 업로드 처리
		
		fileInfo.put("file_nadd",logicalrootPath + File.separator + itemFilePath + fileInfo.get("file_nm"));
		paramMap.put("fileInfo", fileInfo);
		
		
		// map.put("file_nm", file_nm);
        // map.put("file_size", file_Size);
        // map.put("file_loc", file_loc);
        // map.put("fileExtension", fileExtension);
		
		//#{file_name}   
        //, #{file_size}
        //, #{file_nadd}  
        //, #{file_madd} 		
		
		paramMap.put("file_name", fileInfo.get("file_nm"));
		paramMap.put("file_size", fileInfo.get("file_size"));
		paramMap.put("file_madd", fileInfo.get("file_loc"));
		
		if(fileInfo.get("file_nm") != null || !"".equals((String) fileInfo.get("file_nm"))) {
			paramMap.put("file_nadd", logicalrootPath + File.separator + itemFilePath + fileInfo.get("file_nm"));
		} else {
			paramMap.put("file_nadd",null);
		}
				
		// logicalrootPath    /serverfile/     itemFilePath    notice/     /serverfile/notice/1.png
		
		paramMap.put("fileyn", "Y");
		
		return noticeDao.noticenewupdate(paramMap);
		
	}

    public int noticenewdeletefile(Map<String, Object> paramMap) throws Exception {
		
		paramMap.put("notice_no", paramMap.get("noticeno"));  		
		
		NoticeModel detailone = noticeDao.detailone(paramMap);
		
		if(detailone.getFile_name() != null) {
			File exitfiel = new File(detailone.getFile_madd());
			
			exitfiel.delete();
		}
				
		return noticeDao.noticenewdelete(paramMap);
		
	}
    
    
    
    
	
	
	
	
	
	/*
	*//** 곻지사항 목록 조회 *//*
	public List<HnoticeModel> hnoticelist(Map<String, Object> paramMap) throws Exception {
		
		return hnoticeDao.hnoticelist(paramMap);
		
	}
	
	*//** 곻지사항 목록 카운트 조회 *//*
	public int counthnoticelist(Map<String, Object> paramMap) throws Exception {
		
		return hnoticeDao.counthnoticelist(paramMap);
	}
	
	*//** 곻지사항 신규저장  *//*
	public int hnoticenewsave(Map<String, Object> paramMap) throws Exception {
		paramMap.put("fileyn", "N");
		
		return hnoticeDao.hnoticenewsave(paramMap);
	}
	
	*//** 곻지사항 수정 *//*
	public int hnoticenewupdate(Map<String, Object> paramMap) throws Exception {
		paramMap.put("fileyn", "N");
		return hnoticeDao.hnoticenewupdate(paramMap);
	}
	
	*//** 곻지사항 삭제 *//*
	public int hnoticenewdelete(Map<String, Object> paramMap) throws Exception {
		return hnoticeDao.hnoticenewdelete(paramMap);
	}
	
	
	*//** 곻지사항 상세 조회 *//*
	public HnoticeModel detailone(Map<String, Object> paramMap) throws Exception {
		return hnoticeDao.detailone(paramMap);
	}
	
	
	*//** 곻지사항 저장 파일 *//*
	public int hnoticenewsavefile(Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
		
		// rootPath X:\\FileRepository       noticePath : notice    X:\\FileRepository\notice\a.jpg    
		// File.separator      window : \    linux : /
		
		
		//파일저장
		String itemFilePath = noticePath + File.separator; // 업로드 실제 경로 조립 (무나열생성)
		FileUtilCho fileUtil = new FileUtilCho(multipartHttpServletRequest, rootPath, itemFilePath);
		Map<String, Object> fileInfo = fileUtil.uploadFiles(); // 실제 업로드 처리
		
		fileInfo.put("file_nadd",logicalrootPath + File.separator + itemFilePath + fileInfo.get("file_nm"));
		paramMap.put("fileInfo", fileInfo);
		
		
		// map.put("file_nm", file_nm);
        // map.put("file_size", file_Size);
        // map.put("file_loc", file_loc);
        // map.put("fileExtension", fileExtension);
		
		//#{file_name}   
        //, #{file_size}
        //, #{file_nadd}  
        //, #{file_madd} 
		
		
		
		paramMap.put("file_name", fileInfo.get("file_nm"));
		paramMap.put("file_size", fileInfo.get("file_size"));
		paramMap.put("file_madd", fileInfo.get("file_loc"));
		
		if(fileInfo.get("file_nm") != null || !"".equals((String) fileInfo.get("file_nm"))) {
			paramMap.put("file_nadd", logicalrootPath + File.separator + itemFilePath + fileInfo.get("file_nm"));
		} else {
			paramMap.put("file_nadd",null);
		}
		
		
		// logicalrootPath    /serverfile/     itemFilePath    notice/     /serverfile/notice/1.png
		
		paramMap.put("fileyn", "Y");
		
		return hnoticeDao.hnoticenewsave(paramMap);
		
	}
	
    public int hnoticenewupdatefile(Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
		
		// rootPath X:\\FileRepository       noticePath : notice    X:\\FileRepository\notice\a.jpg    
		// File.separator      window : \    linux : /
		
		paramMap.put("notice_no", paramMap.get("noticeno"));   
		
		
		HnoticeModel detailone = hnoticeDao.detailone(paramMap);
		
		if(detailone.getFile_name() != null) {
			File exitfiel = new File(detailone.getFile_madd());
			
			exitfiel.delete();
		}
		
		//파일저장
		String itemFilePath = noticePath + File.separator; // 업로드 실제 경로 조립 (무나열생성)
		FileUtilCho fileUtil = new FileUtilCho(multipartHttpServletRequest, rootPath, itemFilePath);
		Map<String, Object> fileInfo = fileUtil.uploadFiles(); // 실제 업로드 처리
		
		fileInfo.put("file_nadd",logicalrootPath + File.separator + itemFilePath + fileInfo.get("file_nm"));
		paramMap.put("fileInfo", fileInfo);
		
		
		// map.put("file_nm", file_nm);
        // map.put("file_size", file_Size);
        // map.put("file_loc", file_loc);
        // map.put("fileExtension", fileExtension);
		
		//#{file_name}   
        //, #{file_size}
        //, #{file_nadd}  
        //, #{file_madd} 
		
		
		
		paramMap.put("file_name", fileInfo.get("file_nm"));
		paramMap.put("file_size", fileInfo.get("file_size"));
		paramMap.put("file_madd", fileInfo.get("file_loc"));
		
		if(fileInfo.get("file_nm") != null || !"".equals((String) fileInfo.get("file_nm"))) {
			paramMap.put("file_nadd", logicalrootPath + File.separator + itemFilePath + fileInfo.get("file_nm"));
		} else {
			paramMap.put("file_nadd",null);
		}
		
		
		// logicalrootPath    /serverfile/     itemFilePath    notice/     /serverfile/notice/1.png
		
		paramMap.put("fileyn", "Y");
		
		return hnoticeDao.hnoticenewupdate(paramMap);
		
	}

    public int hnoticenewdeletefile(Map<String, Object> paramMap) throws Exception {
		
		paramMap.put("notice_no", paramMap.get("noticeno"));  		
		
		HnoticeModel detailone = hnoticeDao.detailone(paramMap);
		
		if(detailone.getFile_name() != null) {
			File exitfiel = new File(detailone.getFile_madd());
			
			exitfiel.delete();
		}
				
		return hnoticeDao.hnoticenewdelete(paramMap);
		
	}*/
    
    
	
}
