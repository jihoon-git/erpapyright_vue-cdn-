package kr.happyjob.study.accounting.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import kr.happyjob.study.accounting.model.BmDvModel;
import kr.happyjob.study.accounting.model.FileModel;

public interface BmDvService {

	/** 지출결의서 목록 조회 */
	public List<BmDvModel> expenselist(Map<String, Object> paramMap) throws Exception;

	/** 지출결의서 목록 카운트 */
	public int countexpenselist(Map<String, Object> paramMap) throws Exception;

	/** 지출결의서 저장 
	 * @param multiFile */
	public int expensenewsave(Map<String, Object> paramMap, HttpServletRequest request, List<MultipartFile> multiFile) throws Exception;

	/** 파일 넘버 확인 */
	public int filenocheck(Map<String, Object> paramMap) throws Exception;

	/** 지출결의서 상세보기 */
	public BmDvModel expensedetail(Map<String, Object> paramMap) throws Exception;

	/** 지출결의서 업데이트 
	 * @param multiFile */
	public int expenseupdate(Map<String, Object> paramMap, HttpServletRequest request, List<MultipartFile> multiFile) throws Exception;

	/** 승인 반려 저장 */
	public int approvalexpense(Map<String, Object> paramMap) throws Exception;

	/** 파일 정보 확인 */
	public List<FileModel> detailfile(Map<String, Object> paramMap) throws Exception;

	/** 지출결의서 삭제 */
	public int expensedelete(Map<String, Object> paramMap) throws Exception;

	/** 파일 상세사항 */
	public FileModel detailfileone(Map<String, Object> paramMap) throws Exception;

	/** 지출결의서 승인 되는 순간 회계정보에도 추가 */
	public void newaccount(Map<String, Object> paramMap) throws Exception;

}
