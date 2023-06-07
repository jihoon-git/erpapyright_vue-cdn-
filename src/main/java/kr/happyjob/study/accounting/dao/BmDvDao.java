package kr.happyjob.study.accounting.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.accounting.model.BmDvModel;
import kr.happyjob.study.accounting.model.FileModel;

public interface BmDvDao {

	/** 지출결의서 목록 조회 */
	public List<BmDvModel> expenselist(Map<String, Object> paramMap) throws Exception;		//메소드 이름이 쿼리문 아이디가 됨

	/** 지출결의서 목록 카운트 */
	public int countexpenselist(Map<String, Object> paramMap) throws Exception;

	/** 파일 넘버 확인용 */
	public int filenocheck(Map<String, Object> paramMap) throws Exception;

	/** 지출결의서 저장 */
	public int expensenewsave(Map<String, Object> paramMap) throws Exception;

	/** 파일 저장 */
	public void filenewsave(Map<String, Object> paramMap) throws Exception;

	/** 지출결의서 상세보기 */
	public BmDvModel expensedetail(Map<String, Object> paramMap) throws Exception;

	/** 지출결의서 업데이트 */
	public int expenseupdate(Map<String, Object> paramMap) throws Exception;

	/** 파일 정보 */
	public List<FileModel> getfiledetail(Map<String, Object> paramMap) throws Exception;

	/** 파일 업데이트 */
	public int fileupdate(Map<String, Object> paramMap) throws Exception;

	/**지출결의서 파일 업데이트 */
	public int expensefileupdate(Map<String, Object> paramMap) throws Exception;

	/** 승인 반려 저장 */
	public int approvalexpense(Map<String, Object> paramMap) throws Exception;

	/** 지출결의서 파일 삭제 */
	public int deletefile(Map<String, Object> paramMap) throws Exception;

	/** 지출결의서 삭제 */
	public int expensedelete(Map<String, Object> paramMap) throws Exception;

	/** 파일 코드 체크 */
	public int filecdcheck(Map<String, Object> paramMap) throws Exception;

	/** 파일 상세보기 하나 */
	public FileModel detailfileone(Map<String, Object> paramMap) throws Exception;

	/** 회계 정보에 추가 */
	public void newaccount(Map<String, Object> paramMap) throws Exception;

	/** 파일 있는 지출결의서 저장 */
	public int expensefilenewsave(Map<String, Object> paramMap);

	/** 파일 삭제하기 위해서 지출결의서 데이터의 파일 cd, no 제거 */
	public void filecdnoremove(Map<String, Object> paramMap);

}
