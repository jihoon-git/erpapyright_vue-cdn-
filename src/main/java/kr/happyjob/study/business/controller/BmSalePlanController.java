package kr.happyjob.study.business.controller;

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

import kr.happyjob.study.business.model.BmSalePlanModel;
import kr.happyjob.study.business.service.BmSalePlanService;

@Controller
@RequestMapping("/business/")
public class BmSalePlanController {
	
	@Autowired
	BmSalePlanService bmsaleplanservice;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	
	
	/**
	 * 영업실적 조회 초기화면
	 */
	@RequestMapping("bmSalePlan.do")
	public String hnotice(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".bmSalePlan");
		logger.info("   - paramMap : " + paramMap);
		
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		model.addAttribute("userType",(String) session.getAttribute("userType"));
		
		logger.info("+ End " + className + ".bmSalePlan");

		return "business/bmSalePlan/bmSalePlan";
	}
	
	/**
	 * 영업실적 조회 전체 리스트
	 */
	@RequestMapping("bmsaleplanlist.do")
	public String bmsaleplanlist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".bmsalelist");
		logger.info("   - paramMap : " + paramMap);
		
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage-1) * pageSize;
		
		String userType = (String) paramMap.get("userType");
		
		paramMap.put("pageSize", pageSize);
		paramMap.put("pageindex", pageindex);
		
		List<BmSalePlanModel> bmsaleplanlist = bmsaleplanservice.bmsaleplanlist(paramMap);
		int countbmsaleplan = bmsaleplanservice.countbmsaleplan(paramMap);
		
		model.addAttribute("bmsaleplanlist", bmsaleplanlist);
		model.addAttribute("countbmsaleplan", countbmsaleplan);
		
		
		logger.info("+ End " + className + ".bmsalelist");

		return "business/bmSalePlan/bmsaleplanlist";
	}

}
