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
import kr.happyjob.study.employee.service.EmpPayHistService;
import kr.happyjob.study.employee.model.EmpPayHistModel;

@Controller
@RequestMapping("/employee/")
public class EmpPayHistController {
	
	@Autowired
	EmpPayHistService empPayHistService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	
	
	/**
	 * 급여지급 초기화면
	 */
	@RequestMapping("empPayHist.do")
	public String empPayHist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".empPayHist");
		logger.info("   - paramMap : " + paramMap);
		
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		
		logger.info("+ End " + className + ".empPayHist");

		return "employee/empPayment/empPayHist";
	}
	
	
	/**
	 * 개인급여 목록화면
	 */
	@RequestMapping("empPayHistlist.do")
	public String empPayHistlist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".empPayHistlist");
		logger.info("   - paramMap : " + paramMap);
		
		paramMap.put("loginId", (String) session.getAttribute("loginId"));
		
		// 페이징 처리
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<EmpPayHistModel> empHislist = empPayHistService.empHislist(paramMap);
		
		int cntempHislist = empPayHistService.cntempHislist(paramMap);
		
		model.addAttribute("empHislist", empHislist);
		model.addAttribute("cntempHislist", cntempHislist);
		
		logger.info("+ End " + className + ".empPayHistlist");

		return "employee/empPayment/empPayHistlist";
	}
	
	/**
	 * 개인급여 상세조회
	 */
	@RequestMapping("empPayHistdetail.do")
	@ResponseBody
	public Map<String, Object> empPayHistdetail(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".empPayHistdetail");
		logger.info("   - paramMap : " + paramMap);
		
		EmpPayHistModel empHisdetail = empPayHistService.empHisdetail(paramMap);
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("empHisdetail", empHisdetail);
		returnmap.put("result", "SUCCESS");
		
		logger.info("+ End " + className + ".empPayHistdetail");

		return returnmap;
	}
	
	
	
		
		


	
}
