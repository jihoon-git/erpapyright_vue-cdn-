package kr.happyjob.study.business.controller;

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

import kr.happyjob.study.business.model.EmpSalePlanModel;
import kr.happyjob.study.business.service.EmpSalePlanService;

@Controller
@RequestMapping("/business/")
public class EmpSalePlanController {

	@Autowired
	EmpSalePlanService empsaleplanservice;

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();

	/**
	 * 영업계획 초기화면
	 */
	@RequestMapping("empSalePlan.do")
	public String empSalePlan(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".empSalePlan");
		logger.info("   - paramMap : " + paramMap);

		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		model.addAttribute("userType", (String) session.getAttribute("userType"));

		logger.info("+ End " + className + ".empSalePlan");

		return "business/empSalePlan/empSalePlan";
	}

	/**
	 * 영업계획 리스트 출력
	 */
	@RequestMapping("empsaleplanlist.do")
	public String empsaleplanlist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".empsaleplanlist");
		logger.info("   - paramMap : " + paramMap);

		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int pageIndex = (cpage - 1) * pageSize;

		paramMap.put("pageSize", pageSize);
		paramMap.put("pageIndex", pageIndex);

		List<EmpSalePlanModel> empsaleplanlist = empsaleplanservice.empsaleplanlist(paramMap);
		int countempsaleplan = empsaleplanservice.countempsaleplan(paramMap);

		model.addAttribute("empsaleplanlist", empsaleplanlist);
		model.addAttribute("countempsaleplan", countempsaleplan);

		logger.info("+ End " + className + ".empsaleplanlist");

		return "business/empSalePlan/empsaleplanlist";
	}

	/**
	 * 신규 영업계획 등록
	 */
	@RequestMapping("newempsaleplan.do")
	@ResponseBody
	public Map<String, Object> newempsaleplan(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".newempsaleplan");
		logger.info("   - paramMap : " + paramMap);
		int client = Integer.parseInt((String) paramMap.get("client"));
		int product =Integer.parseInt((String) paramMap.get("product"));
		int amount =Integer.parseInt((String) paramMap.get("amount"));
		
		paramMap.put("client", client);
		paramMap.put("product", product);
		paramMap.put("amount", amount);
		int checkno = empsaleplanservice.plannocheck(paramMap);
		logger.info("   - checkno : " + checkno);
		
		if(checkno == 0){
			empsaleplanservice.newempsaleplan(paramMap);
			
			Map<String, Object> returnmap = new HashMap<String, Object>();
			
			returnmap.put("RESULT","SUCCESS");

			logger.info("+ End " + className + ".newempsaleplan");

			return returnmap;
			
		} else{
			
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("RESULT","FAILE");

		logger.info("+ End " + className + ".newempsaleplan");

		return returnmap;
		}
		
		
	}
	
	/**
	 * 영업계획 초기화면
	 */
	@RequestMapping("vueEmpSalePlan.do")
	public String vueEmpSalePlan(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".vueEmpSalePlan");
		logger.info("   - paramMap : " + paramMap);

		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		model.addAttribute("userType", (String) session.getAttribute("userType"));

		logger.info("+ End " + className + ".vueEmpSalePlan");

		return "business/empSalePlan/vueEmpSalePlan";
	}

	/**
	 * 영업계획 리스트 출력
	 */
	@RequestMapping("vueEmpSalePlanlist.do")
	@ResponseBody
	public Map<String, Object> vueEmpSalePlanlist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".vueEmpSalePlanlist");
		logger.info("   - paramMap : " + paramMap);

		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int pageIndex = (cpage - 1) * pageSize;
		String loginID = (String) session.getAttribute("loginId");

		paramMap.put("pageSize", pageSize);
		paramMap.put("pageIndex", pageIndex);
		paramMap.put("loginID", loginID);

		List<EmpSalePlanModel> vueEmpSalePlanlist = empsaleplanservice.empsaleplanlist(paramMap);
		int countempsaleplan = empsaleplanservice.countempsaleplan(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("vueEmpSalePlanlist", vueEmpSalePlanlist);
		resultMap.put("countempsaleplan", countempsaleplan);
		resultMap.put("loginId", (String) session.getAttribute("loginId"));
		resultMap.put("userNm", (String) session.getAttribute("userNm"));
		resultMap.put("userType",(String) session.getAttribute("userType"));

		
		logger.info("+ End " + className + ".vueEmpSalePlanlist");

		return resultMap;
	}

	/**
	 * 신규 영업계획 등록
	 */
	@RequestMapping("newVueEmpSalePlan.do")
	@ResponseBody
	public Map<String, Object> newVueEmpSalePlan(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".newVueEmpSalePlan");
		logger.info("   - paramMap : " + paramMap);
		int client = Integer.parseInt((String) paramMap.get("client"));
		int product =Integer.parseInt((String) paramMap.get("product"));
		int amount =Integer.parseInt((String) paramMap.get("amount"));
		
		paramMap.put("client", client);
		paramMap.put("product", product);
		paramMap.put("amount", amount);
		int checkno = empsaleplanservice.plannocheck(paramMap);
		logger.info("   - checkno : " + checkno);
		
		if(checkno == 0){
			empsaleplanservice.newempsaleplan(paramMap);
			
			Map<String, Object> returnmap = new HashMap<String, Object>();
			
			returnmap.put("RESULT","SUCCESS");

			logger.info("+ End " + className + ".newVueEmpSalePlan");

			return returnmap;
			
		} else{
			
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("RESULT","FAILE");

		logger.info("+ End " + className + ".newVueEmpSalePlan");

		return returnmap;
		}
		
		
	}

}
