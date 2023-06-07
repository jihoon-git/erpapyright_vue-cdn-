package kr.happyjob.study.business.service;

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

import kr.happyjob.study.business.dao.ProductDao;
import kr.happyjob.study.business.model.ProductModel;
import kr.happyjob.study.common.comnUtils.FileUtilCho;

@Service
public class ProductServiceImpl implements ProductService {

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
	ProductDao productDao;

	/** 제품 목록 조회 */
	@Override
	public List<ProductModel> productList(Map<String, Object> paramMap) throws Exception {
		logger.info("+ Start " + className+".productList");
		logger.info("   - paramMap : " + paramMap+".productList");
		
		List<ProductModel> productList = productDao.productList(paramMap);
		
		logger.info("+ End " + className+".productList");
		
		return productList;
	}
	
	/** 제품 목록 총갯수 */
	@Override
	public int productListCnt(Map<String, Object> paramMap) throws Exception {
		logger.info("+ Start " + className+".productListCnt");
		logger.info("   - paramMap : " + paramMap+".productListCnt");
		
		int productListCnt = productDao.productListCnt(paramMap);
		
		logger.info("+ End " + className+".productListCnt");
		
		return productListCnt;
	}
	
	/** 제품 수량 추가 */
	@Override
	public int insertStock(Map<String, Object> paramMap) throws Exception {
		logger.info("+ Start " + className+".insertStock");
		logger.info("   - paramMap : " + paramMap+".insertStock");
		
		int insertStock = productDao.insertStock(paramMap);
		
		logger.info("+ End " + className+".insertStock");
		
		return insertStock;
	}
	
	/** 제품상세조회 */
	@Override
	public ProductModel productDetaile(Map<String, Object> paramMap) throws Exception {
		logger.info("+ Start " + className+".insertStock");
		logger.info("   - paramMap : " + paramMap+".insertStock");
		
		ProductModel productDetaile = productDao.productDetaile(paramMap);
		
		logger.info("+ End " + className+".insertStock");
		
		return productDetaile;
	}
	
	/** 제품 대,중,소 추가 */
	@Override
	public int newProductTypesInsert(Map<String, Object> paramMap) throws Exception {
		logger.info("+ Start " + className+".newProductTypesInsert");
		logger.info("   - paramMap : " + paramMap+".newProductTypesInsert");
		
		String action = (String)paramMap.get("action");
		
		int newProductTypesInsert = 0;
		
		if("L".equals(action)){
			newProductTypesInsert = productDao.insertDetail_code(paramMap);
		} else if("M".equals(action)){ 
			ProductModel productDetaile = productDao.productTypeDetaile(paramMap);
			if(productDetaile != null && productDetaile.getProduct_name().equals((String)paramMap.get("mProduct_name"))){
				newProductTypesInsert = 2;
			} else {
				newProductTypesInsert = productDao.insertPreductType(paramMap); 
			} 
		} else {
			ProductModel productDetaile = productDao.productDetaile(paramMap);
			if(productDetaile != null && productDetaile.getProduct_name().equals((String)paramMap.get("product_name"))){
				newProductTypesInsert = 3;
			} else {
				newProductTypesInsert = productDao.insertPreduct(paramMap);
			}
		}
		
		logger.info("+ End " + className+".newProductTypesInsert");
		
		return newProductTypesInsert;
	}
	
}
