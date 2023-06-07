package kr.happyjob.study.employee.service;

import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.happyjob.study.accounting.model.FileModel;
import kr.happyjob.study.common.comnUtils.FileUtilCho;
import kr.happyjob.study.employee.dao.EmpMgtDao;
import kr.happyjob.study.employee.model.EmpMgtModel;


@Service
public class EmpMgtServiceImpl implements EmpMgtService {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	// Get class name for logger
	private final String className = this.getClass().toString();
	
	@Value("${fileUpload.rootPath}")
	private String rootPath;
	
	@Value("${fileUpload.logicalrootPath}")
	private String logicalrootPath;
	
	@Value("${fileUpload.profilePath}")
	private String profilePath;
	
	@Autowired
	EmpMgtDao empMgtDao;
	
	/* 사원 목록 조회 */
	public List<EmpMgtModel> empMgtList(Map<String, Object> paramMap) throws Exception {
	
	return empMgtDao.empMgtList(paramMap);
	
}
	
	/* 사원 목록 인원 수 조회 */
	public int countEmpMgtList(Map<String, Object> paramMap) throws Exception {
		
		return empMgtDao.countEmpMgtList(paramMap);
	}

	/* 퇴직 처리 */
	public void retireEmp(Map<String, Object> paramMap) throws Exception{
		empMgtDao.retireEmp(paramMap);
	}

	/*휴직 처리*/
	@Override
	public void leaveEmp(Map<String, Object> paramMap) throws Exception{
		empMgtDao.leaveEmp(paramMap);
	}
	
	/*복직 처리*/
	@Override
	public void comebackEmp(Map<String, Object> paramMap) throws Exception {
		empMgtDao.comebackEmp(paramMap);
	}

	/*사원 상세 조회*/
	@Override
	public EmpMgtModel empMgtDet(Map<String, Object> paramMap) throws Exception {
		return empMgtDao.empMgtDet(paramMap);
	}
	
	/*사원 정보 수정*/
	@Override
	public int updateEmp(Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;

		// 파일저장
		String itemFilePath = profilePath + File.separator; // 업로드 실제 경로 조립
															// (무나열생성)
		FileUtilCho fileUtil = new FileUtilCho(multipartHttpServletRequest, rootPath, itemFilePath);
		Map<String, Object> fileInfo = fileUtil.uploadFilesHan(); // 실제 업로드 처리
		
			paramMap.put("loginID", paramMap.get("detLoginId"));
			
		// 승진
		int beforeRankCd = Integer.parseInt(String.valueOf(empMgtDao.beforeRankcd(paramMap))); //정보수정할 사원의 기존 직급코드 가져오기
		int afterRankCd = Integer.parseInt(String.valueOf(paramMap.get("detRankCd")));
			if (beforeRankCd != afterRankCd) { //승진or 강등할 경우 승진내역테이블에 insert (승진할 수록 직급코드 down)
				empMgtDao.insertPromo(paramMap);
			}
		
		if (fileInfo == null || fileInfo.size() == 0) { 
			
			//업데이트 파일이 없을 때 사원 정보만 수정
			return empMgtDao.updateEmp(paramMap);
			
		} else {
			// 업데이트 파일이 있을 때 
			

			EmpMgtModel filecdno = empMgtDao.empMgtDet(paramMap);
			
			paramMap.put("filecd", filecdno.getFile_cd()); // 파일코드 얻어오기
			paramMap.put("fileno", filecdno.getFile_no());
			paramMap.put("beforefilenm", filecdno.getFile_name()); //파일네임 얻어오기
			
			
			if (filecdno.getFile_name() != null) { // 파일 네임이 null일 경우(회원가입만 한 상태)
				
				FileModel filedetail = empMgtDao.getfiledetail(paramMap);
				File exitfile = new File(filedetail.getFile_madd());

				exitfile.delete();
				
				fileInfo.put("file_nadd", logicalrootPath + File.separator + itemFilePath + fileInfo.get("file_nm"));
				paramMap.put("fileInfo", fileInfo);

				paramMap.put("file_name", fileInfo.get("file_nm"));
				paramMap.put("file_size", fileInfo.get("file_size"));
				paramMap.put("file_madd", fileInfo.get("file_loc"));
				paramMap.put("file_type", fileInfo.get("fileExtension"));

				if (fileInfo.get("file_nm") != null || !"".equals((String) fileInfo.get("file_nm"))) {
					paramMap.put("file_nadd",
							logicalrootPath + File.separator + itemFilePath + fileInfo.get("file_nm"));
				} else {
					paramMap.put("file_nadd", null);
				}

				// 파일 테이블 update
				empMgtDao.profileUpdate(paramMap);
	
				// 사원정보 테이블 update
				return empMgtDao.updateEmp(paramMap);
				
			} else { // 기존 파일이  있는 경우
				fileInfo.put("file_nadd", logicalrootPath + File.separator + itemFilePath + fileInfo.get("file_nm"));
				paramMap.put("fileInfo", fileInfo);

				paramMap.put("file_name", fileInfo.get("file_nm"));
				paramMap.put("file_size", fileInfo.get("file_size"));
				paramMap.put("file_madd", fileInfo.get("file_loc"));
				paramMap.put("file_type", fileInfo.get("fileExtension"));

				if (fileInfo.get("file_nm") != null || !"".equals((String) fileInfo.get("file_nm"))) {
					paramMap.put("file_nadd",
							logicalrootPath + File.separator + itemFilePath + fileInfo.get("file_nm"));
				} else {
					paramMap.put("file_nadd", null);
				}

				// 파일 테이블 update
				empMgtDao.profileUpdate(paramMap);
	
				// 사원정보 테이블 update
				return empMgtDao.updateEmp(paramMap);
			
			}
		}

	}
	
	/*연봉 입력*/
	@Override
	public void insertNego(Map<String, Object> paramMap) throws Exception {
		empMgtDao.insertNego(paramMap);
		
	}

	/*연봉 수정*/
	@Override
	public void updateNego(Map<String, Object> paramMap) throws Exception {
		empMgtDao.updateNego(paramMap);
		
	}
    
	
}
