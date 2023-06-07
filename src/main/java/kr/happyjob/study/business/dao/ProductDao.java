package kr.happyjob.study.business.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.business.model.ProductModel;


public interface ProductDao {

	/** 제품 목록 조회 */
	public List<ProductModel> productList(Map<String, Object> paramMap);
	
	/** 제품 목록 총갯수 조회 */
	public int productListCnt(Map<String, Object> paramMap);
	
	/** 제품 수량 추가 */
	public int insertStock(Map<String, Object> paramMap);
	
	/** 제품상세조회 */
	public ProductModel productDetaile(Map<String, Object> paramMap);
	
	/** 제품상세조회 */
	public ProductModel productTypeDetaile(Map<String, Object> paramMap);
	
	/** 제품 대분류 추가 */
	public int insertDetail_code(Map<String, Object> paramMap);
	
	/** 제품 중분류 추가 */
	public int insertPreductType(Map<String, Object> paramMap);
	
	/** 제품 소분류 추가 */
	public int insertPreduct(Map<String, Object> paramMap);
	
}
