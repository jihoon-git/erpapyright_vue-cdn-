package kr.happyjob.study.accounting.service;

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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.happyjob.study.accounting.dao.BmDvDao;
import kr.happyjob.study.accounting.model.BmDvModel;
import kr.happyjob.study.accounting.model.FileModel;

@Service
public class BmDvServiceImpl implements BmDvService {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();

	@Value("${fileUpload.rootPath}")
	private String rootPath;

	@Value("${fileUpload.logicalrootPath}")
	private String logicalrootPath;

	@Value("${fileUpload.expensePath}")
	private String expensePath;

	@Autowired
	BmDvDao bmdvdao;

	/** 지출결의서 목록 조회 */
	public List<BmDvModel> expenselist(Map<String, Object> paramMap) throws Exception {

		return bmdvdao.expenselist(paramMap);
	}

	/** 지출결의서 목록 카운트 */
	public int countexpenselist(Map<String, Object> paramMap) throws Exception {
		return bmdvdao.countexpenselist(paramMap);
	}

	/** 지출결의서 저장 */
	public int expensenewsave(Map<String, Object> paramMap, HttpServletRequest request, List<MultipartFile> multiFile)
			throws Exception {
		
		// 파일저장
		String itemFilePath = expensePath + File.separator; // 업로드 실제 경로 조립
															// (무나열생성)
		// 실제 업로드 처리

		
		logger.info("   - multiFile.size() : " + multiFile.get(0).getOriginalFilename());
		// 파일 유무에 따라 파일 저장 작업을 나눔
		if (multiFile.get(0).getOriginalFilename() == null || multiFile.get(0).getOriginalFilename() == "") {
			return bmdvdao.expensenewsave(paramMap);
		} else {
			int filec = bmdvdao.filecdcheck(paramMap);
			paramMap.put("filec", filec);
			paramMap.put("filecd", filec);

			for (int i = 0; i < multiFile.size(); i++) {
				
				String savefilename = this.uploadFile(rootPath + File.separator + itemFilePath,  multiFile.get(i).getOriginalFilename(), multiFile.get(i).getBytes());

				paramMap.put("file_name", multiFile.get(i).getOriginalFilename());
				paramMap.put("file_size", multiFile.get(i).getSize());
				paramMap.put("file_madd",
						rootPath + File.separator + itemFilePath + savefilename);
				paramMap.put("file_type", multiFile.get(i).getOriginalFilename()
						.substring(multiFile.get(i).getOriginalFilename().lastIndexOf(".") + 1));

				if (multiFile.get(i).getOriginalFilename() != null
						|| !multiFile.get(i).getOriginalFilename().equals("")) {
					paramMap.put("file_nadd",
							logicalrootPath + File.separator + itemFilePath + savefilename);
				} else {
					paramMap.put("file_nadd", null);
				}

				logger.info("   - paramMapImpl : " + paramMap);

				File finalsave = new File((String) paramMap.get("file_madd"));
				multiFile.get(i).transferTo(finalsave);

				bmdvdao.filenewsave(paramMap);

			}

			logger.info("   - Dao paramMap : " + paramMap);

			return bmdvdao.expensefilenewsave(paramMap);
		}

	}

	/** 파일 넘버 확인 용 */
	public int filenocheck(Map<String, Object> paramMap) throws Exception {
		return bmdvdao.filenocheck(paramMap);
	}

	/** 지출결의서 상세보기 */
	public BmDvModel expensedetail(Map<String, Object> paramMap) throws Exception {
		return bmdvdao.expensedetail(paramMap);
	}

	/** 지출결의서 업데이트 */
	public int expenseupdate(Map<String, Object> paramMap, HttpServletRequest request, List<MultipartFile> multiFile)
			throws Exception {
		String itemFilePath = expensePath + File.separator;
		
		paramMap.put("null", null);

		logger.info("   - itemFilePath : " + itemFilePath);
		paramMap.put("expno", paramMap.get("regexpno"));

		BmDvModel filecdno = bmdvdao.expensedetail(paramMap);
		paramMap.put("filecd", filecdno.getFile_cd());
		
		bmdvdao.filecdnoremove(paramMap);

		if (multiFile.get(0).getOriginalFilename() == null || multiFile.get(0).getOriginalFilename() == "") {
			return bmdvdao.expenseupdate(paramMap);
		} else {

			if (filecdno.getFile_cd() != 0) {
				List<FileModel> filedetail = bmdvdao.getfiledetail(paramMap);
				for (int i1 = 0; i1 < filedetail.size(); i1++) {
					File exitfile = new File(filedetail.get(i1).getFile_madd());

					logger.info("   - filedetail : " + filedetail.get(i1));
					paramMap.put("fileno", filedetail.get(i1).getFile_no());
					exitfile.delete();
					bmdvdao.deletefile(paramMap);
				}
			}
			
			int filec = bmdvdao.filecdcheck(paramMap);
			paramMap.put("filecd", filec);
			for (int i = 0; i < multiFile.size(); i++) {
				logger.info("   - Impl paramMap : " + paramMap);
				String savefilename = this.uploadFile(rootPath + File.separator + itemFilePath,  multiFile.get(i).getOriginalFilename(), multiFile.get(i).getBytes());

				paramMap.put("file_name", multiFile.get(i).getOriginalFilename());
				paramMap.put("file_size", multiFile.get(i).getSize());
				paramMap.put("file_madd",
						rootPath + File.separator + itemFilePath + savefilename);
				paramMap.put("file_type", multiFile.get(i).getOriginalFilename()
						.substring(multiFile.get(i).getOriginalFilename().lastIndexOf(".") + 1));

				if (multiFile.get(i).getOriginalFilename() != null
						|| !multiFile.get(i).getOriginalFilename().equals("")) {
					paramMap.put("file_nadd",
							logicalrootPath + File.separator + itemFilePath + savefilename);
				} else {
					paramMap.put("file_nadd", null);
				}

				logger.info("   - paramMapImpl : " + paramMap);

				File finalsave = new File((String) paramMap.get("file_madd"));
				multiFile.get(i).transferTo(finalsave);

				bmdvdao.filenewsave(paramMap);

			}

		}
		return bmdvdao.expenseupdate(paramMap);
	}

	/** 승인 반려 저장 */
	public int approvalexpense(Map<String, Object> paramMap) throws Exception {
		 return bmdvdao.approvalexpense(paramMap);
	}

	/** 파일 정보 추출 */
	public List<FileModel> detailfile(Map<String, Object> paramMap) throws Exception {
		return bmdvdao.getfiledetail(paramMap);
	}

	/** 지출결의서 삭제 */
	public int expensedelete(Map<String, Object> paramMap) throws Exception {

		paramMap.put("expno", paramMap.get("regexpno"));

		logger.info("   - paramMapserviceimpl : " + paramMap);

		BmDvModel filecdno = bmdvdao.expensedetail(paramMap);

		if (filecdno.getFile_cd() != 0) {
			paramMap.put("filecd", filecdno.getFile_cd());

			List<FileModel> filedetail = bmdvdao.getfiledetail(paramMap);
			for (int i = 0; i < filedetail.size(); i++) {
				File exitfile = new File(filedetail.get(i).getFile_madd());
				exitfile.delete();
			}

			bmdvdao.expensedelete(paramMap);

			return bmdvdao.deletefile(paramMap);

		} else {
			return bmdvdao.expensedelete(paramMap);
		}
	}

	/** 파일 상세보기 하나 */
	public FileModel detailfileone(Map<String, Object> paramMap) throws Exception {
		return bmdvdao.detailfileone(paramMap);
	}

	/** 회계정보에도 추가 */
	public void newaccount(Map<String, Object> paramMap) throws Exception {
		bmdvdao.newaccount(paramMap);

	}
	
	/** 파일 중복명 제거 */
	private String uploadFile(String fullpath, String originalName, byte[] fileData) throws Exception{
		UUID uuid = UUID.randomUUID();
		String savedName = uuid.toString()+"_"+originalName;
		
		File target = new File(fullpath, savedName);
		
		FileCopyUtils.copy(fileData, target);
		
		return savedName;
	}

}
