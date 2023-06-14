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
import kr.happyjob.study.employee.model.TaApplyModel;
import kr.happyjob.study.employee.service.TaApplyService;
import kr.happyjob.study.hwang.model.HnoticeModel;


@Controller
@RequestMapping("/employee/")
public class TaApplyController {
	
	@Autowired
	TaApplyService taApplyService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	/* 근태신청조회 초기화면  */
	@RequestMapping("empTaApply.do")
	public String taApply(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".taApply");
		logger.info("   - paramMap : " + paramMap);
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		
		logger.info("+ End " + className + ".taApply");

		return "employee/empTaApply/empTaApply";
	}
	
	/* 근태신청조회 초기화면  */
	@RequestMapping("vueEmpTaApply.do")
	public String vueTaapply(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".taApply");
		logger.info("   - paramMap : " + paramMap);
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		
		logger.info("+ End " + className + ".taApply");

		return "employee/empTaApply/vueEmpTaApply";
	}
	
	/* 근태신청 조회 */
	@RequestMapping("empTaApplylist.do")
	public String taApplylist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".taApplylist");
		logger.info("   - paramMap : " + paramMap);
		
		
		// 페이징 처리 1페이지 0부터 , 2페이지 10부터
		
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		// 근태 목록 조회
		List<TaApplyModel> taApplylist = taApplyService.taApplylist(paramMap);
		model.addAttribute("taApplylist", taApplylist);
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		
		// 근태 목록 카운트 조회
		int counttaApplylist = taApplyService.counttaApplylist(paramMap);		
		model.addAttribute("counttaApplylist", counttaApplylist);		
		
		logger.info("+ End " + className + ".taApplylist");

		return "employee/empTaApply/empTaApplylist";
	}	
	
	// 총 휴가 및 남은 휴가 조회
	@RequestMapping("empTaApplylist2.do")
	public String totallist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".taApplylist");
		logger.info("   - paramMap : " + paramMap);
				
		// 총 휴가 및 남은 휴가 조회
		List<TaApplyModel> total_rest = taApplyService.total_rest(paramMap);
		System.out.println(total_rest);
		model.addAttribute("total_rest", total_rest);
		
		logger.info("+ End " + className + ".taApplylist");

		return "employee/empTaApply/empTaApplylist2";
	}
	
	// 근태신청 
	@RequestMapping("taApplysave.do")
	@ResponseBody
	public Map<String, Object> taApplysave(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".taApplysave");
		logger.info("   - paramMap : " + paramMap);		
		
		paramMap.put("loginId", (String) session.getAttribute("loginId"));		
		
		taApplyService.taApplysave(paramMap);		
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");		
		
		logger.info("+ End " + className + ".taApplysave");

		return returnmap;
	}
	
	// 근태신청시 조회 
	@RequestMapping("restinfo.do")
	@ResponseBody
	public Map<String, Object> rest_info(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".rest_info");
		logger.info("   - paramMap : " + paramMap);		
		
		paramMap.put("loginId", (String) session.getAttribute("loginId"));		
		
		TaApplyModel rest_info = taApplyService.rest_info(paramMap);	
			
		Map<String, Object> returnmap = new HashMap<String, Object>();
			
		returnmap.put("rest_info", rest_info);
						
		logger.info("+ End " + className + ".rest_info");

		return returnmap;
		}
	
	// 반려사유 조회
	@RequestMapping("rest_reject.do")
	@ResponseBody
	public Map<String, Object> rest_reject(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".rest_reject_rsn");
		logger.info("   - paramMap : " + paramMap);		
		
		
		TaApplyModel rest_reject =  taApplyService.rest_reject(paramMap);	
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("rest_reject", rest_reject);		
		
		logger.info("+ End " + className + ".rest_reject");

		return returnmap;
	}	

	/////////////////////////////////////////////////////////////////////////////////
	
	/* 근태신청 조회 */
	@RequestMapping("empTaApplylistvue.do")
	@ResponseBody
	public Map<String, Object> taApplylistvue(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".taApplylist");
		logger.info("   - paramMap : " + paramMap);
		
		
		// 페이징 처리 1페이지 0부터 , 2페이지 10부터
		
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		paramMap.put("loginId", (String)session.getAttribute("loginId"));
		
		// 근태 목록 조회
		List<TaApplyModel> taApplylist = taApplyService.taApplylist(paramMap);
		
//		model.addAttribute("taApplylist", taApplylist);
//		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		// 총 휴가 및 남은 휴가 조회
		List<TaApplyModel> total_rest = taApplyService.total_rest(paramMap);
		// 근태 목록 카운트 조회
		int counttaApplylist = taApplyService.counttaApplylist(paramMap);		
		//model.addAttribute("counttaApplylist", counttaApplylist);		
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("taApplylist", taApplylist);
		resultMap.put("counttaApplylist", counttaApplylist);
		resultMap.put("total_rest", total_rest);
			
		logger.info("+ End " + className + ".taApplylist");

		return resultMap;
	}	
	
	// 총 휴가 및 남은 휴가 조회
	@RequestMapping("empTaApplylist2vue.do")
	@ResponseBody
	public Map<String, Object> totallistvue(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".taApplylist");
		logger.info("   - paramMap : " + paramMap);
		
		
		
				
		// 총 휴가 및 남은 휴가 조회
		List<TaApplyModel> total_rest = taApplyService.total_rest(paramMap);
		System.out.println(total_rest);
		
		paramMap.put("total_rest", total_rest);
	
		
		Map<String, Object> resultMap2 = new HashMap<String, Object>();
		
		//model.addAttribute("total_rest", total_rest);
		//resultMap2.put("total_rest", total_rest);
		
		logger.info("+ End " + className + ".taApplylist");

		return resultMap2;
	}
	
}
