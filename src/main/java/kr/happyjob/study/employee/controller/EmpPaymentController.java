package kr.happyjob.study.employee.controller;

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
import kr.happyjob.study.employee.service.EmpPaymentService;
import kr.happyjob.study.employee.model.EmpPaymentModel;

@Controller
@RequestMapping("/employee/")
public class EmpPaymentController {
	
	@Autowired
	EmpPaymentService empPaymentService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	
	
	/**
	 * 급여지급 초기화면
	 */
	@RequestMapping("empPayment.do")
	public String empPayment(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".empPayment");
		logger.info("   - paramMap : " + paramMap);
		
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		
		logger.info("+ End " + className + ".empPayment");

		return "employee/empPayment/empPayment";
	}
	
	/**
	 * 급여지급 초기화면
	 */
	@RequestMapping("vueEmpPayment.do")
	public String vueEmpPayment(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".vueEmpPayment");
		logger.info("   - paramMap : " + paramMap);
		
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		
		logger.info("+ End " + className + ".vueEmpPayment");
		
		return "employee/empPayment/vueEmpPayment";
	}
	
	/**
	 * 급여지급 처리 목록화면
	 */
	@RequestMapping("empPaylist.do")
	public String empPaylist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".empPaylist");
		logger.info("   - paramMap : " + paramMap);
		
		// 페이징 처리
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<EmpPaymentModel> empPaylist = empPaymentService.empPaylist(paramMap);
		List<EmpPaymentModel> empPaynolist = empPaymentService.empPaynolist(paramMap);
		
		int check = 0;
		
		for (int i = 0; i < empPaynolist.size(); i++) {
			if("y".equals(empPaynolist.get(i).getPay_yn())){
				check = check + 1;
			}
		
		}
		logger.info("   - check : " + check);
		
		int cntempPaylist = empPaymentService.cntempPaylist(paramMap);
		
		
		model.addAttribute("checkyn", check);
			
		model.addAttribute("empPaylist", empPaylist);
		model.addAttribute("cntempPaylist", cntempPaylist);
		
		logger.info("+ End " + className + ".empPaylist");

		return "employee/empPayment/empPaymentlist";
	}
	
	/**
	 * 급여지급 처리 목록화면 vue
	 */
	@RequestMapping("vueEmpPaylist.do")
	@ResponseBody
	public Map<String, Object> vueEmpPaylist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".vueEmpPaylist");
		logger.info("   - paramMap : " + paramMap);
		
		// 페이징 처리
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		
		List<EmpPaymentModel> empPaylist = empPaymentService.empPaylist(paramMap);
		List<EmpPaymentModel> empPaynolist = empPaymentService.empPaynolist(paramMap);
		
		int check = 0;
		
		for (int i = 0; i < empPaynolist.size(); i++) {
			if("y".equals(empPaynolist.get(i).getPay_yn())){
				check = check + 1;
			}
			
		}
		logger.info("   - check : " + check);
		
		int cntempPaylist = empPaymentService.cntempPaylist(paramMap);
		
		
		returnMap.put("checkyn", check);
		
		returnMap.put("empPaylist", empPaylist);
		returnMap.put("cntempPaylist", cntempPaylist);
		
		logger.info("+ End " + className + ".vueEmpPaylist");
		
		return returnMap;
	}
	
	/**
	 * 개인급여 목록화면
	 */
	@RequestMapping("emponelist.do")
	public String emponelist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".emponelist");
		logger.info("   - paramMap : " + paramMap);
		
		// 페이징 처리
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<EmpPaymentModel> empOnelist = empPaymentService.empOnelist(paramMap);
		
		int cntempOnelist = empPaymentService.cntempOnelist(paramMap);
		
		model.addAttribute("empOnelist", empOnelist);
		model.addAttribute("cntempOnelist", cntempOnelist);
		
		logger.info("+ End " + className + ".emponelist");

		return "employee/empPayment/empOnelist";
	}
	
	/**
	 * 개인급여 목록화면 vue
	 */
	@RequestMapping("vueEmpOneList.do")
	@ResponseBody
	public Map<String, Object> vueEmpOneList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".vueEmpOneList");
		logger.info("   - paramMap : " + paramMap);
		
		// 페이징 처리
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<EmpPaymentModel> empOnelist = empPaymentService.empOnelist(paramMap);
		
		int cntempOnelist = empPaymentService.cntempOnelist(paramMap);
		
		returnMap.put("empOnelist", empOnelist);
		returnMap.put("cntempOnelist", cntempOnelist);
		
		logger.info("+ End " + className + ".vueEmpOneList");
		
		return returnMap;
	}
	
	
	/**
	 * 급여 저장
	 */
	@RequestMapping("empsave.do")
	@ResponseBody
	public Map<String, Object> empsave(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".empsave");
		logger.info("   - paramMap : " + paramMap);
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		paramMap.put("userNm", (String) session.getAttribute("userNm"));
		
		empPaymentService.empsave(paramMap);
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		returnmap.put("result", "SUCCESS");
		
		logger.info("+ End " + className + ".empsave");

		return returnmap;
	}
	
	/**
	 * 급여 다중 저장
	 */
	@RequestMapping("empsaveall.do")
	@ResponseBody
	public Map<String, Object> empsaveall(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".empsaveall");
		logger.info("   - paramMap : " + paramMap);
		
		paramMap.put("userNm", (String) session.getAttribute("userNm"));
		
		empPaymentService.empsave_expall(paramMap);
		empPaymentService.empsaveall(paramMap);
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		returnmap.put("result", "SUCCESS");
		
		logger.info("+ End " + className + ".empsaveall");

		return returnmap;
	}
	
	
}
