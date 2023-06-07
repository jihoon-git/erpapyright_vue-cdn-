package kr.happyjob.study.employee.controller;

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

import kr.happyjob.study.accounting.model.AccTitleModel;
import kr.happyjob.study.employee.model.EmpGradeModel;
import kr.happyjob.study.employee.service.EmpGradeService;

@Controller
@RequestMapping("/employee/")
public class EmpGradeController {
	
	@Autowired
	EmpGradeService empGradeService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	
	
	/**
	 * 승진내역 관리 초기화면
	 */
	@RequestMapping("empGrade.do")
	public String empGrade(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".empGrade");
		logger.info("   - paramMap : " + paramMap);
		
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		
		logger.info("+ End " + className + ".empGrade");

		return "employee/empGrade/empGrade";
	}
	
	/**
	 * 승진내역 목록
	 */
	@RequestMapping("empGradelist.do")
	public String empGradelist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".empGradelist");
		logger.info("   - paramMap : " + paramMap);
		
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<EmpGradeModel> empGradelist = empGradeService.empGradelist(paramMap);
		
		int countEmpgradelist = empGradeService.countEmpgradelist(paramMap);
		
		model.addAttribute("empGradelist", empGradelist);
		model.addAttribute("countEmpgradelist", countEmpgradelist);
		
		logger.info("+ End " + className + ".empGradelist");

		return "employee/empGrade/empGradelist";
	}	
	
	/**
	 * 승진내역 상세조회
	 */
	@RequestMapping("detailEmp.do")
	public String detailEmp (Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".detailEmp");
		logger.info("   - paramMap : " + paramMap);
		
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<EmpGradeModel> detailEmp = empGradeService.detailEmp(paramMap);
		
		int countEmpdetail = empGradeService.countEmpdetail(paramMap);
		
		model.addAttribute("detailEmp", detailEmp);
		model.addAttribute("countEmpdetail", countEmpdetail);
		
		logger.info("+ End " + className + ".detailEmp");

		return "employee/empGrade/empGradedetail";
	}
	
	/**
	 * 승진내역 등록
	 */
	@RequestMapping("empGradesave.do")
	@ResponseBody
	public Map<String, Object> empGradesave(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".empGradesave");
		logger.info("   - paramMap : " + paramMap);		
		
		paramMap.put("loginId", (String) session.getAttribute("loginId"));
		
		empGradeService.empGradesave(paramMap);
		
				
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		
		
		logger.info("+ End " + className + ".empGradesave");

		return returnmap;
	}
	
}
