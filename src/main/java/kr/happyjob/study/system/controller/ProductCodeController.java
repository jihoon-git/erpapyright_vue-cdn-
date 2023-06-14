package kr.happyjob.study.system.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

import kr.happyjob.study.system.model.ProductCodeModel;
import kr.happyjob.study.system.service.ProductCodeService;


@Controller
@RequestMapping("/system/")
public class ProductCodeController {
	
	@Autowired
	ProductCodeService productCodeService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	// 제품 대분류 초기화면
	@RequestMapping("productCode.do")
	public String productCode(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".productCode");
		logger.info("   - paramMap : " + paramMap);
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		
		logger.info("+ End " + className + ".productCode");

		return "system/productCode/productCode";
	}
	
	// Vue 제품 대분류 초기화면
	@RequestMapping("vueProductCode.do")
	public String vueProductCode(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".vueProductCode");
		logger.info("   - paramMap : " + paramMap);
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		
		logger.info("+ End " + className + ".vueProductCode");

		return "system/productCode/vueProductCode";
	}	
	
	// 제품 대분류 조회
	@RequestMapping("productCodeList.do")
	public String productCodelist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".productCodelist");
		logger.info("   - paramMap : " + paramMap);
		
		// 1     0
		// 2     10
		// 3     20		
		
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<ProductCodeModel> productCodelist = productCodeService.productCodelist(paramMap);
		
		int countproductlist = productCodeService.countproductlist(paramMap);
		
		model.addAttribute("productCodelist", productCodelist);
		model.addAttribute("countproductlist", countproductlist);
		
		logger.info("+ End " + className + ".productCodelist");

		return "system/productCode/productCodeList";
	}
	
	// Vue 제품 대분류 조회
	@RequestMapping("vueProductCodeList.do")
	@ResponseBody
	public Map<String, Object> vueProductCodeList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".vueProductCodeList");
		logger.info("   - paramMap : " + paramMap);
		
		// 페이징 처리 1페이지 0부터 , 2페이지 10부터		
		
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		Map<String, Object> returnMap = new HashMap<String, Object>();
		
		List<ProductCodeModel> productCodelist = productCodeService.productCodelist(paramMap);
		
		int countproductlist = productCodeService.countproductlist(paramMap);
		
		returnMap.put("productCodelist", productCodelist);
		returnMap.put("countproductlist", countproductlist);
		
		logger.info("+ End " + className + ".vueProductCodeList");

		return returnMap;
	}	
	
	// 제품 대분류 상세 조회
	@RequestMapping("detailproductcode.do")
	@ResponseBody
	public Map<String, Object> detailproductcode(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".detailproductcode");
		logger.info("   - paramMap : " + paramMap);		
				
		ProductCodeModel detailproductcode = productCodeService.detailproductcode(paramMap);
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		returnmap.put("detailproductcode", detailproductcode);
		
		
		logger.info("+ End " + className + ".detailproductcode");

		return returnmap;
	}
	
	@RequestMapping("productcodeinsert.do")
	@ResponseBody
	public Map<String, Object> productcodeinsert(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".productcodeinsert");
		logger.info("   - paramMap : " + paramMap);		
		
		paramMap.put("loginId", (String) session.getAttribute("loginId"));
		
		String action = (String) paramMap.get("action");
		
		int detailproductcodeCnt = productCodeService.detailproductcodeCnt(paramMap);
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		if(detailproductcodeCnt == 0){
			if("I".equals(action)) {
				productCodeService.productcodeinsert(paramMap);
				returnmap.put("result", "SUCCESS");
			} 
		} else if("U".equals(action) && detailproductcodeCnt == 1){
			productCodeService.productcodeupdate(paramMap);
			returnmap.put("result", "SUCCESS");
		} else if("D".equals(action) && detailproductcodeCnt == 1){
			productCodeService.productcodedelete(paramMap);
			returnmap.put("result", "SUCCESS");
		} else if(detailproductcodeCnt > 1){
				returnmap.put("result", "FAILNAME");
		} else {
			ProductCodeModel detailproductcode = productCodeService.detailproductcode(paramMap);
			if(((String)paramMap.get("detail_name")).equals(detailproductcode.getDetail_name())){
				returnmap.put("result", "FAILNAME");
			} else if(((String)paramMap.get("detail_code")).equals(detailproductcode.getDetail_code())){
				returnmap.put("result", "FAILCODE");
			} 
		}
		logger.info("+ End " + className + ".productcodeinsert");

		return returnmap;
	}
	
	
	
	
	
	
	/**
	 * 공지사항 관리 초기화면
	 *//*
	@RequestMapping("hnotice.do")
	public String hnotice(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".hnotice");
		logger.info("   - paramMap : " + paramMap);
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		
		logger.info("+ End " + className + ".hnotice");

		return "hwang/hnotice";
	}
	
	@RequestMapping("hnoticelist.do")
	public String hnoticelist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".hnoticelist");
		logger.info("   - paramMap : " + paramMap);
		
		// 1     0
		// 2     10
		// 3     20		
		
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<HnoticeModel> hnoticelist = hnoticeService.hnoticelist(paramMap);
		
		int counthnoticelist = hnoticeService.counthnoticelist(paramMap);
		
		model.addAttribute("hnoticelist", hnoticelist);
		model.addAttribute("counthnoticelist", counthnoticelist);
		
		logger.info("+ End " + className + ".hnoticelist");

		return "hwang/hnoticelist";
	}	
		
	@RequestMapping("hnoticesave.do")
	@ResponseBody
	public Map<String, Object> hnoticesave(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".hnoticesave");
		logger.info("   - paramMap : " + paramMap);		
		
		paramMap.put("loginId", (String) session.getAttribute("loginId"));
		
		String action = (String) paramMap.get("action");
		
		if("I".equals(action)) {
			hnoticeService.hnoticenewsave(paramMap);
		} else if("U".equals(action)) {
			hnoticeService.hnoticenewupdate(paramMap);
		} else if("D".equals(action)) {
			hnoticeService.hnoticenewdelete(paramMap);
		}
		
		
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		
		
		logger.info("+ End " + className + ".hnoticesave");

		return returnmap;
	}		
	
	@RequestMapping("detailone.do")
	@ResponseBody
	public Map<String, Object> detailone(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".detailone");
		logger.info("   - paramMap : " + paramMap);		
				
		HnoticeModel detailone = hnoticeService.detailone(paramMap);
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		returnmap.put("detailone", detailone);
		
		
		logger.info("+ End " + className + ".detailone");

		return returnmap;
	}
	
	@RequestMapping("hnoticesavefile.do")
	@ResponseBody
	public Map<String, Object> hnoticesavefile(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".hnoticesavefile");
		logger.info("   - paramMap : " + paramMap);		
		
		paramMap.put("loginId", (String) session.getAttribute("loginId"));
		
		String action = (String) paramMap.get("action");
		
		if("I".equals(action)) {
			hnoticeService.hnoticenewsavefile(paramMap, request);
		} else if("U".equals(action)) {
			hnoticeService.hnoticenewupdatefile(paramMap, request);
		} else if("D".equals(action)) {
			hnoticeService.hnoticenewdeletefile(paramMap);
		}
		
		
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		
		
		logger.info("+ End " + className + ".hnoticesavefile");

		return returnmap;
	}	
	
	@RequestMapping("hnoticefiledownaload.do")
	public void hnoticefiledownaload(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".hnoticefiledownaload");
		logger.info("   - paramMap : " + paramMap);		
		
		HnoticeModel detailone = hnoticeService.detailone(paramMap);
		
		String filename = detailone.getFile_name();
		String filemadd = detailone.getFile_madd();
		
        byte fileByte[] = FileUtils.readFileToByteArray(new File(filemadd));
		
	    response.setContentType("application/octet-stream");
	    response.setContentLength(fileByte.length);
	    response.setHeader("Content-Disposition", "attachment; fileName=\"" + URLEncoder.encode(filename,"UTF-8")+"\";");
	    response.setHeader("Content-Transfer-Encoding", "binary");
	    response.getOutputStream().write(fileByte);
		
		logger.info("+ End " + className + ".hnoticefiledownaload");

		return;
	}	*/
	
	
	
}
