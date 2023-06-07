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
import kr.happyjob.study.employee.model.TaApproveModel;
import kr.happyjob.study.employee.service.TaApproveService;;

@Controller  //나 컨트롤러임
@RequestMapping("/employee/")
public class TaApproveController {
	
	@Autowired
	TaApproveService taApproveService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	
	
	/**
	 * 근태 관리 초기화면
	 */
	@RequestMapping("taapprove.do")
	public String taapprove(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".taapprove");  ///꼭 적어 줘야함!!
		logger.info("   - paramMap : " + paramMap);
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		model.addAttribute("userType", (String) session.getAttribute("userType"));
		
		logger.info("+ End " + className + ".taapprove");  ///꼭 적어 줘야함!!

		return "employee/taapprove/taapprove";		///꼭 적어 줘야함!!
	}
	
	
	
	/**
	 * 근태 관리 목록 조회
	 */
	@RequestMapping("taapprovelist.do")
	public String taapprovelist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".taapprovelist");
		logger.info("   - paramMap : " + paramMap);
		
		// 1     0
		// 2     10
		// 3     20		
		
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));	//paramMap.get("pageSize");페이지를  숫자로 바꾸준거임
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));	//paramMap.get("cpage"); 를 페이지를  숫자로 바꾸준거임
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<TaApproveModel> taapprovelist = taApproveService.taapprovelist(paramMap);
		
		int counttaApprovelist = taApproveService.counttaApprovelist(paramMap);
		
		model.addAttribute("taapprovelist", taapprovelist);
		model.addAttribute("counttaApprovelist", counttaApprovelist);
		
		logger.info("+ End " + className + ".taapprovelist");

		return "employee/taapprove/taapprovelist";
	}	
	
	
	/**
	 * 근태 관리 상세 조회
	 */
	@RequestMapping("detailone.do")
	@ResponseBody
	public Map<String, Object> detailone(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".detailone");
		logger.info("   - paramMap : " + paramMap);		
				
		TaApproveModel detailone = taApproveService.detailone(paramMap);
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		returnmap.put("detailone", detailone); 
		
		
		logger.info("+ End " + className + ".detailone");

		return returnmap;
	}
	
	
	/**
	 *  근태 승인/반려 업데이트
	 */
	@RequestMapping("taapproveupdate.do")
	@ResponseBody
	public Map<String, Object> taapproveupdate(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".taapproveupdate");
		logger.info("   - paramMap : " + paramMap);		
		
		paramMap.put("loginId", (String) session.getAttribute("loginId"));
		
		String action = (String) paramMap.get("action");
		
		int result = 0;
		
		if("U".equals(action)) {
			result = taApproveService.taapprovewupdate(paramMap);
		} 
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		if(result == 1){
			returnmap.put("result", "SUCCESS");
		} else {
			returnmap.put("result", "FAIL");
		}
		
		
		logger.info("+ End " + className + ".taapproveupdate");

		return returnmap;
	}			
	
}