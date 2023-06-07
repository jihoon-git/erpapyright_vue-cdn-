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

import kr.happyjob.study.common.comnUtils.ComnCodUtil;
import kr.happyjob.study.business.service.EstManagementService;
import kr.happyjob.study.business.model.EstManagementModel;

@Controller
@RequestMapping("/business/")
public class EstManagementController {
	
	@Autowired
	EstManagementService estManagementService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	
	
	/**
	 * 견적서 초기화면
	 */
	@RequestMapping("estManagement.do")
	public String estManagement(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".estManagement");
		logger.info("   - paramMap : " + paramMap);
		
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		
		logger.info("+ End " + className + ".estManagement");

		return "business/estManagement/estManagement";
	}
	
	/**
	 * 견적서 초기화면 vue
	 */
	@RequestMapping("vueEstManagement.do")
	public String vueEstManagement(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".vueEstManagement");
		logger.info("   - paramMap : " + paramMap);
		
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		
		logger.info("+ End " + className + ".vueEstManagement");
		
		return "business/estManagement/vueEstManagement";
	}
	
	/**
	 * 견적서 목록화면
	 */
	@RequestMapping("estmanagementlist.do")
	public String estmanagementlist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".estmanagementlist");
		logger.info("   - paramMap : " + paramMap);
		
		// 페이징 처리 1페이지 0부터 , 2페이지 10부터
		
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<EstManagementModel> estmanagementlist = estManagementService.estmanagementlist(paramMap);
		
		int cntestmanagementlist = estManagementService.cntestmanagementlist(paramMap);
		
		model.addAttribute("estmanagementlist", estmanagementlist);
		model.addAttribute("cntestmanagementlist", cntestmanagementlist);
		
		logger.info("+ End " + className + ".estmanagementlist");

		return "business/estManagement/estManagementlist";
	}
	
	/**
	 *  견적서 목록 화면 vue
	 */
	@RequestMapping("vueEstmanagementlist.do")
	@ResponseBody
	public Map<String, Object> vueEstmanagementlist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".vueEstmanagementlist");
		logger.info("   - paramMap : " + paramMap);
		
		// 페이징 처리 1페이지 0부터 , 2페이지 10부터
		
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		Map<String, Object> returnMap = new HashMap<String, Object>();
		
		List<EstManagementModel> estmanagementlist = estManagementService.estmanagementlist(paramMap);
		
		int cntestmanagementlist = estManagementService.cntestmanagementlist(paramMap);
		
		returnMap.put("estmanagementlist", estmanagementlist);
		returnMap.put("cntestmanagementlist", cntestmanagementlist);
		
		logger.info("+ End " + className + ".vueEstmanagementlist");
		
		return returnMap;
	}
	
	/**
	 * 견적서 상세조회
	 */
	@RequestMapping("estdetail.do")
	@ResponseBody
	public Map<String, Object> estdetail(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".estdetail");
		logger.info("   - paramMap : " + paramMap);		
		
		EstManagementModel estdetail =  estManagementService.estdetail(paramMap);
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("estdetail", estdetail);
		returnmap.put("result", "SUCCESS");
		
		logger.info("+ End " + className + ".estdetail");

		return returnmap;
	}	
	
	/**
	 * 제품선택시 값 저장하는 용도
	 */
	@RequestMapping("savechange.do")
	@ResponseBody
	public Map<String, Object> savechange(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".savechange");
		logger.info("   - paramMap : " + paramMap);
		
		EstManagementModel savechange =  estManagementService.savechange(paramMap);
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("savechange", savechange);
		returnmap.put("result", "SUCCESS");
		
		logger.info("+ End " + className + ".savechange");

		return returnmap;
	}
		
	/**
	 * 견적서 저장
	 */
	@RequestMapping("estsave.do")
	@ResponseBody
	public Map<String, Object> estsave(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".estsave");
		logger.info("   - paramMap : " + paramMap);	
		
		paramMap.put("loginId", (String) session.getAttribute("loginId"));
		
		estManagementService.estsave(paramMap);
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		
		
		logger.info("+ End " + className + ".estsave");

		return returnmap;
	}
	
	/**
	 * 견적서 삭제
	 */
	@RequestMapping("estdelete.do")
	@ResponseBody
	public Map<String, Object> estdelete(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".estdelete");
		logger.info("   - paramMap : " + paramMap);	
		
		paramMap.put("loginId", (String) session.getAttribute("loginId"));
		
		estManagementService.estdelete(paramMap);
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		
		logger.info("+ End " + className + ".estdelete");

		return returnmap;
	}
	
	
}
