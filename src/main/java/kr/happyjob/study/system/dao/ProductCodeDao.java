package kr.happyjob.study.system.dao;

import java.util.List;
import java.util.Map;


import kr.happyjob.study.system.model.ComnCodUtilModel;
import kr.happyjob.study.system.model.ComnDtlCodModel;
import kr.happyjob.study.system.model.ComnGrpCodModel;
import kr.happyjob.study.system.model.NoticeModel;
import kr.happyjob.study.system.model.ProductCodeModel;

public interface ProductCodeDao {
	
	// 제품 대분류 조회
	public List<ProductCodeModel> productCodelist(Map<String, Object> paramMap) throws Exception;
	
	// 제품 대분류 갯수 조회
	public int countproductlist(Map<String, Object> paramMap) throws Exception;
	
	// 제품 대분류 상세 조회
	public ProductCodeModel detailproductcode(Map<String, Object> paramMap) throws Exception;
	
	// 제품 대분류 상세 갯수 조회
	public int detailproductcodeCnt(Map<String, Object> paramMap) throws Exception;
	
	// 제품 대분류 추가
	public int productcodeinsert(Map<String, Object> paramMap) throws Exception;
	
	// 제품 대분류 수정
	public int productcodeupdate(Map<String, Object> paramMap) throws Exception;
	
	// 제품 대분류 삭제
	public int productcodedelete(Map<String, Object> paramMap) throws Exception;
	
	
	
	
	
	
	
	

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
	public HnoticeModel detailone(Map<String, Object> paramMap) throws Exception;*/
}
