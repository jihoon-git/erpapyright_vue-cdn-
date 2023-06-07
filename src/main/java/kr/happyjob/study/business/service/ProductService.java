package kr.happyjob.study.business.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.happyjob.study.business.model.ProductModel;

public interface ProductService {

	/** 제품 목록 조회 */
	public List<ProductModel> productList(Map<String, Object> paramMap) throws Exception;
	
	/** 제품 목록 총갯수 조회 */
	public int productListCnt(Map<String, Object> paramMap) throws Exception;
	
	/** 제품 수량 추가 */
	public int insertStock(Map<String, Object> paramMap) throws Exception;
	
	/** 제품상세조회 */
	public ProductModel productDetaile(Map<String, Object> paramMap) throws Exception;
	
	/** 제품 대,중,소 추가 */
	public int newProductTypesInsert(Map<String, Object> paramMap) throws Exception;
	
}
