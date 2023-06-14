package kr.happyjob.study.business.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.happyjob.study.business.model.ProductModel;
import kr.happyjob.study.business.service.ProductService;



@Controller
@RequestMapping("/business/")
public class ProductController {
	
	@Autowired
	ProductService productService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	
	
	/**
	 * 회계전표 초기화면
	 */
	@RequestMapping("product.do")
	public String oEManagement(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className+".product");
		logger.info("   - paramMap : " + paramMap);
		
		logger.info("+ End " + className+".product");

		return "business/product/product";
	}
	
	/**
	 * 제품 리스트 
	 */
	@RequestMapping("productList.do")
	public String productList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className+".productList");
		logger.info("   - paramMap : " + paramMap+".productList");
		
		
		int pageSize = Integer.parseInt((String)paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String)paramMap.get("cpage"));
		int pageindex = (cpage-1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<ProductModel> productList = productService.productList(paramMap);
		
		int totalCnt = productService.productListCnt(paramMap);
		
		model.addAttribute("productList", productList);
		model.addAttribute("totalCnt", totalCnt);
		model.addAttribute("userNm", (String)session.getAttribute("userNm"));
		model.addAttribute("loginId", (String)session.getAttribute("loginId"));
		
		logger.info("+ End " + className+".productList");

		return "business/product/productList";
	}
	/**
	 * 제품 상세검색
	 */
	@RequestMapping("productDetaile.do")
	@ResponseBody
	public Map<String, Object> productDetaile(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className+".productDetaile");
		logger.info("   - paramMap : " + paramMap+".productDetaile");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		ProductModel productDetaile = productService.productDetaile(paramMap);
		
		resultMap.put("productDetaile", productDetaile);
		
		logger.info("+ End " + className+".productDetaile");
		
		return resultMap;
	}

	/**
	 * 제품 수량 추가 
	 */
	@RequestMapping("insertStock.do")
	@ResponseBody
	public Map<String, Object> insertStock(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className+".insertStock");
		logger.info("   - paramMap : " + paramMap+".insertStock");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		int success = productService.insertStock(paramMap);
		
		if(success == 1){
			resultMap.put("result", "SUCCESS");
		} else {
			resultMap.put("result", "FAILE");
		}
		
		logger.info("+ End " + className+".insertStock");
		
		return resultMap;
	}
	
	/**
	 * 제품 대,중,소 추가 
	 */
	@RequestMapping("newProductTypesInsert.do")
	@ResponseBody
	public Map<String, Object> newProductTypesInsert(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className+".newProductTypesInsert");
		logger.info("   - paramMap : " + paramMap+".newProductTypesInsert");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		int success = productService.newProductTypesInsert(paramMap);
		
		if(success == 1){
			resultMap.put("result", "SUCCESS");
		} else if(success == 2){
			resultMap.put("result", "FAILETYPE");
		} else if(success == 3){
			resultMap.put("result", "FAILEPRODUCT");
		} else {
			resultMap.put("result", "FAILE");
		}
		
		logger.info("+ End " + className+".newProductTypesInsert");
		
		return resultMap;
	}
	
	
	
	
	/** vue
	 * 회계전표 초기화면
	 */
	@RequestMapping("vueProduct.do")
	public String vueProduct(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className+".vueProduct");
		logger.info("   - paramMap : " + paramMap);
		
		logger.info("+ End " + className+".vueProduct");

		return "business/product/vueProduct";
	}
	
	/**
	 * 제품 리스트 
	 */
	@RequestMapping("vueProductList.do")
	@ResponseBody
	public Map<String, Object> vueProductList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className+".vueProductList");
		logger.info("   - paramMap : " + paramMap+".vueProductList");
		
		
		int pageSize = Integer.parseInt((String)paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String)paramMap.get("cpage"));
		int pageindex = (cpage-1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<ProductModel> productList = productService.productList(paramMap);
		
		int totalCnt = productService.productListCnt(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("productList", productList);
		resultMap.put("totalCnt", totalCnt);
		resultMap.put("userNm", (String)session.getAttribute("userNm"));
		resultMap.put("loginId", (String)session.getAttribute("loginId"));
		
		logger.info("+ End " + className+".vueProductList");

		return resultMap;
	}
	/**
	 * 제품 상세검색
	 */
	@RequestMapping("vueProductDetaile.do")
	@ResponseBody
	public Map<String, Object> vueProductDetaile(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className+".vueProductDetaile");
		logger.info("   - paramMap : " + paramMap+".vueProductDetaile");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		ProductModel vueProductDetaile = productService.productDetaile(paramMap);
		
		resultMap.put("vueProductDetaile", vueProductDetaile);
		
		logger.info("+ End " + className+".vueProductDetaile");
		
		return resultMap;
	}

	/**
	 * 제품 수량 추가 
	 */
	@RequestMapping("vueProductInsertStock.do")
	@ResponseBody
	public Map<String, Object> vueProductInsertStock(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className+".vueProductInsertStock");
		logger.info("   - paramMap : " + paramMap+".vueProductInsertStock");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		int success = productService.insertStock(paramMap);
		
		if(success == 1){
			resultMap.put("result", "SUCCESS");
		} else {
			resultMap.put("result", "FAILE");
		}
		
		logger.info("+ End " + className+".vueProductInsertStock");
		
		return resultMap;
	}
	
	/**
	 * 제품 대,중,소 추가 
	 */
	@RequestMapping("vuenewProductTypesInsert.do")
	@ResponseBody
	public Map<String, Object> vuenewProductTypesInsert(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className+".vuenewProductTypesInsert");
		logger.info("   - paramMap : " + paramMap+".vuenewProductTypesInsert");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		int success = productService.newProductTypesInsert(paramMap);
		
		if(success == 1){
			resultMap.put("result", "SUCCESS");
		} else if(success == 2){
			resultMap.put("result", "FAILETYPE");
		} else if(success == 3){
			resultMap.put("result", "FAILEPRODUCT");
		} else {
			resultMap.put("result", "FAILE");
		}
		
		logger.info("+ End " + className+".vuenewProductTypesInsert");
		
		return resultMap;
	}
	
}
