package kr.happyjob.study.accounting.controller;

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

import kr.happyjob.study.accounting.model.AccountSlipModel;
import kr.happyjob.study.accounting.model.AccSlipDetaileModel;
import kr.happyjob.study.accounting.model.DetileAccountListModel;
import kr.happyjob.study.accounting.model.MidProductListModel;
import kr.happyjob.study.accounting.model.ProductListModel;
import kr.happyjob.study.accounting.service.AccountSlipService;
import kr.happyjob.study.business.model.BizPartnerModel;

@Controller
@RequestMapping("/accounting/")
public class AccountSlipController {
	
	@Autowired
	AccountSlipService accountSlipService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	
	
	/**
	 * 회계전표 초기화면
	 */
	@RequestMapping("accSlipF.do")
	public String hnotice(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className+".accSlipF");
		logger.info("   - paramMap : " + paramMap+".accSlipF");
		
		logger.info("+ End " + className+".accSlipF");

		return "accounting/accountSlip/accSlipF";
	}
	
	/**
	 * 회계전표 초기화면 vue
	 */
	@RequestMapping("vueAccSlipF.do")
	public String vueAccSlipF(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className+".accSlipF");
		logger.info("   - paramMap : " + paramMap+".accSlipF");
		
		logger.info("+ End " + className+".accSlipF");

		return "accounting/accountSlip/vueAccSlipF";
	}
	
	/**
	 * 회계전표 리스트 
	 */
	@RequestMapping("accSlipFList.do")
	public String accSlipFList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className+".accSlipFList");
		logger.info("   - paramMap : " + paramMap+".accSlipFList");
		
		
		int pageSize = Integer.parseInt((String)paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String)paramMap.get("cpage"));
		int pageindex = (cpage-1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<AccountSlipModel> accSlipFList = accountSlipService.accountSlipList(paramMap);
		
		int totalCnt = accountSlipService.accountSlipListTotalCnt(paramMap);
		
		model.addAttribute("accSlipFList", accSlipFList);
		model.addAttribute("totalCnt", totalCnt);
		model.addAttribute("userNm", (String)session.getAttribute("userNm"));
		model.addAttribute("loginId", (String)session.getAttribute("loginId"));
		
		logger.info("+ End " + className+".accSlipFList");

		return "accounting/accountSlip/accSlipFList";
	}
	
	/**
	 * 회계전표 리스트 vue - string to json
	 */
	@ResponseBody
	@RequestMapping("vueAccSlipFList.do")
	public Map<String, Object> vueAccSlipFList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className+".accSlipFList");
		logger.info("   - paramMap : " + paramMap+".accSlipFList");
		
		
		int pageSize = Integer.parseInt((String)paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String)paramMap.get("cpage"));
		int pageindex = (cpage-1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<AccountSlipModel> accSlipFList = accountSlipService.accountSlipList(paramMap);
		
		int totalCnt = accountSlipService.accountSlipListTotalCnt(paramMap);
		
		model.addAttribute("accSlipFList", accSlipFList);
		model.addAttribute("totalCnt", totalCnt);
		model.addAttribute("userNm", (String)session.getAttribute("userNm"));
		model.addAttribute("loginId", (String)session.getAttribute("loginId"));
		
		//추가내용
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("accSlipFList", accSlipFList);
		resultMap.put("totalCnt", totalCnt);
		resultMap.put("userNm", session.getAttribute("userNm"));
		resultMap.put("loginId", session.getAttribute("loginId"));
		
		logger.info("+ End " + className+".accSlipFList");
		
		return resultMap;
	}
	
	/**
	 * 거래처 리스트
	 */
	@RequestMapping("clientlist.do")
	@ResponseBody
	public Map<String, Object> clientlist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".clientlist");
		logger.info("   - paramMap : " + paramMap);
		
		List<BizPartnerModel> clientlist = accountSlipService.clientlist(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
				
		resultMap.put("clientlist", clientlist);

		logger.info("+ End " + className + ".clientlist");

		return resultMap;
	}
	
	/**
	 * 계정과목 리스트
	 */
	@RequestMapping("detileAccountList.do")
	@ResponseBody
	public Map<String, Object> detileAccountList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".detileAccountList");
		logger.info("   - paramMap : " + paramMap);
		
		List<DetileAccountListModel> detileAccountList = accountSlipService.detileAccountList(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("detileAccountList", detileAccountList);
		
		logger.info("+ End " + className + ".detileAccountList");
		
		return resultMap;
	}
	
	/**
	 * 제품 리스트
	 */
	@RequestMapping("productList.do")
	@ResponseBody
	public Map<String, Object> productList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".productList");
		logger.info("   - paramMap : " + paramMap);
		
		List<ProductListModel> productList = accountSlipService.productList(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("productList", productList);
		
		logger.info("+ End " + className + ".productList");
		
		return resultMap;
	}
	
	/**
	 * 제품 리스트
	 */
	@RequestMapping("midProductList.do")
	@ResponseBody
	public Map<String, Object> midProductList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".productList");
		logger.info("   - paramMap : " + paramMap);
		
		List<MidProductListModel> midProductList = accountSlipService.midProductList(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("midProductList", midProductList);
		
		logger.info("+ End " + className + ".midProductList");
		
		return resultMap;
	}

	/**
	 * 회계전표 단건 조회
	 */
	@RequestMapping("accSlipDetaile.do")
	@ResponseBody
	public Map<String, Object> accSlipDetaile(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".accSlipDetaile");
		logger.info("   - paramMap : " + paramMap);
		
		List<AccSlipDetaileModel> accSlipDetaile = accountSlipService.accSlipDetaile(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("accSlipDetaile", accSlipDetaile);
		
		logger.info("+ End " + className + ".accSlipDetaile");
		
		return resultMap;
	}

}
