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

import kr.happyjob.study.business.model.ContractDetaileModel;
import kr.happyjob.study.business.model.OEManagementModel;
import kr.happyjob.study.business.service.OEManagementService;


@Controller
@RequestMapping("/business/")
public class OEManagementController {
	
	@Autowired
	OEManagementService oEManagementService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	
	
	/**
	 * 수주관리 초기화면
	 */
	@RequestMapping("oeManagement.do")
	public String oEManagement(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className+".oEManagement");
		logger.info("   - paramMap : " + paramMap);
		
		logger.info("+ End " + className+".oEManagement");

		return "business/oEManagement/oEManagement";
	}
	/**
	 * 수주관리 초기화면 vue
	 */
	@RequestMapping("vueOeManagement.do")
	public String vueOeManagement(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className+".vueOeManagement");
		logger.info("   - paramMap : " + paramMap);
		
		logger.info("+ End " + className+".vueOeManagement");
		
		return "business/oEManagement/vueOeManagement";
	}
	
	/**
	 * 수주 리스트 
	 */
	@RequestMapping("oEManagementList.do")
	public String oEManagementList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className+".oEManagementList");
		logger.info("   - paramMap : " + paramMap+".oEManagementList");
		
		
		int pageSize = Integer.parseInt((String)paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String)paramMap.get("cpage"));
		int pageindex = (cpage-1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<OEManagementModel> oEManagementList = oEManagementService.oEManagementList(paramMap);
		
		int totalCnt = oEManagementService.oEManagementListCnt(paramMap);
		
		model.addAttribute("oEManagementList", oEManagementList);
		model.addAttribute("totalCnt", totalCnt);
		model.addAttribute("userNm", (String)session.getAttribute("userNm"));
		model.addAttribute("loginId", (String)session.getAttribute("loginId"));
		
		logger.info("+ End " + className+".oEManagementList");

		return "business/oEManagement/oEManagementList";
	}
	
	/**
	 * 수주 리스트 vue
	 */
	@RequestMapping("vueOeManagementList.do")
	@ResponseBody
	public Map<String, Object> vueOeManagementList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className+".vueOeManagementList");
		logger.info("   - paramMap : " + paramMap+".vueOeManagementList");
		
		
		int pageSize = Integer.parseInt((String)paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String)paramMap.get("cpage"));
		int pageindex = (cpage-1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		
		List<OEManagementModel> oEManagementList = oEManagementService.oEManagementList(paramMap);
		
		int totalCnt = oEManagementService.oEManagementListCnt(paramMap);
		
		returnMap.put("oEManagementList", oEManagementList);
		returnMap.put("totalCnt", totalCnt);
		returnMap.put("userNm", (String)session.getAttribute("userNm"));
		returnMap.put("loginId", (String)session.getAttribute("loginId"));
		
		logger.info("+ End " + className+".vueOeManagementList");
		
		return returnMap;
	}
	
	/**
	 * 수주 리스트 
	 */
	@RequestMapping("oEManagementListJson.do")
	@ResponseBody
	public Map<String, Object> oEManagementListJson(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className+".oEManagementListJson");
		logger.info("   - paramMap : " + paramMap+".oEManagementListJson");
		
		List<OEManagementModel> oEManagementList = oEManagementService.oEManagementList(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("oEManagementList", oEManagementList);
		
		logger.info("+ End " + className+".oEManagementListJson");
		
		return resultMap;
	}
	
	/**
	 * 수주 단건 조회
	 */
	@RequestMapping("contractDetaile.do")
	@ResponseBody
	public Map<String, Object> contractDetaile(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".contractDetaile");
		logger.info("   - paramMap : " + paramMap);
		
		List<ContractDetaileModel> contractDetaile = oEManagementService.contractDetaile(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
				
		resultMap.put("contractDetaile", contractDetaile);

		logger.info("+ End " + className + ".contractDetaile");

		return resultMap;
	}

	/**
	 * 수주 등록
	 */
	@RequestMapping("contractSave.do")
	@ResponseBody
	public Map<String, Object> contractSave(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".contractSave");
		logger.info("   - paramMap : " + paramMap);
		
		int index = Integer.parseInt((String)paramMap.get("index"));
		
		
		paramMap.put("index", index+1);
		paramMap.put("loginID", (String)session.getAttribute("loginId"));
		
		ContractDetaileModel contractDetaile= oEManagementService.selectKey(paramMap);

		paramMap.put("contract_no", contractDetaile.getContract_no());
		paramMap.put("order_cd", contractDetaile.getOrder_cd());
		
		oEManagementService.orderSave(paramMap);
		oEManagementService.prcductUpdate(paramMap);
		oEManagementService.contractUpdate(paramMap);
		oEManagementService.accuntInfo(paramMap);
		oEManagementService.bSalePlanUpdate(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("contractDetaile", "OK");
		
		logger.info("+ End " + className + ".contractSave");
		
		return resultMap;
	}

}
