package kr.happyjob.study.system.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.happyjob.study.system.model.ProductCodeModel;



public interface ProductCodeService{

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
		
}
