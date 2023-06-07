package kr.happyjob.study.system.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.happyjob.study.system.model.NoticeModel;;

public interface NoticeService {

	/* 곻지사항 목록 조회 */
	public List<NoticeModel> noticelist(Map<String, Object> paramMap) throws Exception;
	
	/* 공지사항 목록 카운트 조회 */
	public int countnoticelist(Map<String, Object> paramMap) throws Exception;
	
	/* 공지사항 등록 */
	public int noticenewsave(Map<String, Object> paramMap) throws Exception;
	
	/* 곻지사항 상세 조회  */
	public NoticeModel detailone(Map<String, Object> paramMap) throws Exception;
	
	/* 곻지사항 수정  */
	public int noticenewupdate(Map<String, Object> paramMap) throws Exception;
	
	/* 곻지사항 삭제  */
	public int noticenewdelete(Map<String, Object> paramMap) throws Exception;
	
	/* 곻지사항 저장 파일  */
	public int noticenewsavefile(Map<String, Object> paramMap, HttpServletRequest request) throws Exception;
	
	/* 곻지사항 수정 파일  */
	public int noticenewupdatefile(Map<String, Object> paramMap, HttpServletRequest request) throws Exception;
	
	/* 곻지사항 삭제 파일  */
	public int noticenewdeletefile(Map<String, Object> paramMap) throws Exception;
	
	
	
	
	
	/** 곻지사항 목록 조회 *//*
	public List<HnoticeModel> hnoticelist(Map<String, Object> paramMap) throws Exception;
	
	*//** 곻지사항 목록 카운트 조회 *//*
	public int counthnoticelist(Map<String, Object> paramMap) throws Exception;	
	
	*//** 곻지사항 저장 *//*
	public int hnoticenewsave(Map<String, Object> paramMap) throws Exception;	
	
	*//** 곻지사항 수정 *//*
	public int hnoticenewupdate(Map<String, Object> paramMap) throws Exception;
	
	*//** 곻지사항 삭제 *//*
	public int hnoticenewdelete(Map<String, Object> paramMap) throws Exception;
	
	*//** 곻지사항 상세 조회 *//*
	public HnoticeModel detailone(Map<String, Object> paramMap) throws Exception;
	
	
	*//** 곻지사항 저장 파일 *//*
	public int hnoticenewsavefile(Map<String, Object> paramMap, HttpServletRequest request) throws Exception;
	
	*//** 곻지사항 수정 파일 *//*
	public int hnoticenewupdatefile(Map<String, Object> paramMap, HttpServletRequest request) throws Exception;
	
	*//** 곻지사항 삭제 파일 *//*
	public int hnoticenewdeletefile(Map<String, Object> paramMap) throws Exception;*/
	
	
}
