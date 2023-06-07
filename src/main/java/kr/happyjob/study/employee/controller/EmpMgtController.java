package kr.happyjob.study.employee.controller;

import java.io.File;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.happyjob.study.accounting.model.FileModel;
import kr.happyjob.study.common.comnUtils.ComnCodUtil;
import kr.happyjob.study.employee.model.EmpMgtModel;
import kr.happyjob.study.employee.service.EmpMgtService;
import kr.happyjob.study.hwang.model.HnoticeModel;

@Controller
@RequestMapping("/employee/")
public class EmpMgtController {
	
	@Autowired
	EmpMgtService empMgtService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	
	
	/**
	 * 사원 목록 조회 초기화면
	 */
	@RequestMapping("empMgt.do")
	public String empMgt(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		// 로그
		logger.info("+ Start " + className + ".empMgt");
		logger.info("   - paramMap : " + paramMap);
		
		logger.info("+ End " + className + ".empMgt");

		return "/employee/empManagement/empManagement";
	}
	
	/**
	 * 사원 목록 조회 초기화면 vue
	 */
	@RequestMapping("vueEmpMgt.do")
	public String vueEmpMgt(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		// 로그
		logger.info("+ Start " + className + ".vueEmpMgt");
		logger.info("   - paramMap : " + paramMap);
		
		logger.info("+ End " + className + ".vueEmpMgt");
		
		return "/employee/empManagement/vueEmpManagement";
	}
	
	/**
	 * 사원 목록
	 */
	@RequestMapping("empMgtList.do")
	public String empMgtList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".empMgtList");
		logger.info("   - paramMap : " + paramMap);
		
		// 페이지네이션
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		// 사원 목록 조회
		List<EmpMgtModel> empMgtList = empMgtService.empMgtList(paramMap);
		
		// 사원 목록 인원수
		int countEmpMgtList = empMgtService.countEmpMgtList(paramMap);
		
		model.addAttribute("empMgtList", empMgtList);
		model.addAttribute("countEmpMgtList", countEmpMgtList);
		
		logger.info("+ End " + className + ".empMgtList");

		return "/employee/empManagement/empManagementList";
	}	
	
	/**
	 * 사원 목록 vue
	 */
	@RequestMapping("vueEmpMgtList.do")
	@ResponseBody
	public Map<String, Object> vueEmpMgtList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".vueEmpMgtList");
		logger.info("   - paramMap : " + paramMap);
		
		// 페이지네이션
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		
		// 사원 목록 조회
		List<EmpMgtModel> empMgtList = empMgtService.empMgtList(paramMap);
		
		// 사원 목록 인원수
		int countEmpMgtList = empMgtService.countEmpMgtList(paramMap);
		
		returnMap.put("empMgtList", empMgtList);
		returnMap.put("countEmpMgtList", countEmpMgtList);
		
		logger.info("+ End " + className + ".vueEmpMgtList");
		
		return returnMap;
	}	
		
	/* 퇴직 처리 */
	@RequestMapping("retireEmp.do")
	@ResponseBody
	public Map<String, Object> retireEmp(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		
		logger.info("+ Start " + className + ".retireEmp");
		logger.info("   - paramMap : " + paramMap);
		
		String result = "SUCCESS";
		String resultMsg = "퇴직 처리 되었습니다.";
		
		empMgtService.retireEmp(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("result",result);
		resultMap.put("resultMsg", resultMsg);
		
		logger.info("+ End " + className + ".retireEmp");
		
		return resultMap;
	}
	
	/* 휴직 처리 */
	@RequestMapping("leaveEmp.do")
	@ResponseBody
	public Map<String, Object> leaveEmp(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		
		logger.info("+ Start " + className + ".leaveEmp");
		logger.info("   - paramMap : " + paramMap);
		
		String result = "SUCCESS";
		String resultMsg = "휴직 처리 되었습니다.";
		
		empMgtService.leaveEmp(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("result",result);
		resultMap.put("resultMsg", resultMsg);
		
		logger.info("+ End " + className + ".leaveEmp");
		
		return resultMap;
	}
	
	/* 복직 처리 */
	@RequestMapping("comebackEmp.do")
	@ResponseBody
	public Map<String, Object> comebackEmp(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		
		logger.info("+ Start " + className + ".comebackEmp");
		logger.info("   - paramMap : " + paramMap);
		
		String result = "SUCCESS";
		String resultMsg = "복직 처리 되었습니다.";
		
		empMgtService.comebackEmp(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("result",result);
		resultMap.put("resultMsg", resultMsg);
		
		logger.info("+ End " + className + ".comebackEmp");
		
		return resultMap;
	}
	
	/*사원 상세 조회*/
	@RequestMapping("empMgtDet.do")
	@ResponseBody
	public Map<String, Object> empMgtDet(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".empMgtDet");
		logger.info("   - paramMap : " + paramMap);
		
		String result = "SUCCESS";
		String resultMsg = "조회 성공";
		
		EmpMgtModel empMgtDet = empMgtService.empMgtDet(paramMap);
		logger.info("   - empMgtDet : " + empMgtDet);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("result", result);
		resultMap.put("resultMsg", resultMsg);
		
		resultMap.put("empMgtDet", empMgtDet);
		
		logger.info("+ End " + className + ".empMgtDet");
		
		return resultMap;
	}
	
	/*사원 정보 수정*/
	@RequestMapping("updateEmp.do")
	@ResponseBody
	public Map<String, Object> updateEmp(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
				HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".updateEmp");
		logger.info("   - paramMap : " + paramMap);
		
		paramMap.put("promoName", (String) session.getAttribute("userNm"));

		String result = "SUCCESS";
		String resultMsg = "사원 정보가 수정되었습니다.";
		
		//이메일 주소 합치기
//		paramMap.put("email", (String)paramMap.get("mail1") + "@" + (String)paramMap.get("mail2"));
		//전화 번호 합치기
		paramMap.put("hp", (String)paramMap.get("hp1") + "-" + (String)paramMap.get("hp2") + "-" + (String)paramMap.get("hp3"));
		
		empMgtService.updateEmp(paramMap, request);
			
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("result",result);
		resultMap.put("resultMsg", resultMsg);
		
		logger.info("+ End " + className + ".updateEmp");
		
		return resultMap;
	}
	
	/*연봉 입력*/
	@RequestMapping("insertNego.do")
	@ResponseBody
	public Map<String, Object> insertNego(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		
		logger.info("+ Start " + className + ".insertNego");
		logger.info("   - paramMap : " + paramMap);
		
		String result = "SUCCESS";
		String resultMsg = "연봉이 입력 되었습니다.";
		
		empMgtService.insertNego(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("result",result);
		resultMap.put("resultMsg", resultMsg);
		
		logger.info("+ End " + className + ".insertNego");
		
		return resultMap;
	}
	
	/*연봉 수정*/
	@RequestMapping("updateNego.do")
	@ResponseBody
	public Map<String, Object> updateNego(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		
		logger.info("+ Start " + className + ".updateNego");
		logger.info("   - paramMap : " + paramMap);
		
		String result = "SUCCESS";
		String resultMsg = "연봉이 수정 되었습니다.";
		
		empMgtService.updateNego(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("result",result);
		resultMap.put("resultMsg", resultMsg);
		
		logger.info("+ End " + className + ".updateNego");
		
		return resultMap;
	}
	
}


