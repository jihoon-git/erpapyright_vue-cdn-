package kr.happyjob.study.hwang.controller;

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
import kr.happyjob.study.hwang.model.HnoticeModel;
import kr.happyjob.study.hwang.service.HnoticeService;

@Controller
@RequestMapping("/hwang/")
public class HnoticeController {
	
	@Autowired
	HnoticeService hnoticeService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	
	
	/**
	 * 공지사항 관리 초기화면
	 */
	@RequestMapping("hnotice.do")
	public String hnotice(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".hnotice");
		logger.info("   - paramMap : " + paramMap);
		
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		
		logger.info("+ End " + className + ".hnotice");

		return "hwang/hnotice";
	}
	
	@RequestMapping("hnoticelist.do")
	public String hnoticelist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".hnoticelist");
		logger.info("   - paramMap : " + paramMap);
		
		
		// 페이징 처리 1페이지 0부터 , 2페이지 10부터
		
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<HnoticeModel> hnoticelist = hnoticeService.hnoticelist(paramMap);
		
		int counthnoticelist = hnoticeService.counthnoticelist(paramMap);
		
		model.addAttribute("hnoticelist", hnoticelist);
		model.addAttribute("counthnoticelist", counthnoticelist);
		
		logger.info("+ End " + className + ".hnoticelist");

		return "hwang/hnoticelist";
	}	
		
	@RequestMapping("hnoticesave.do")
	@ResponseBody
	public Map<String, Object> hnoticesave(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".hnoticesave");
		logger.info("   - paramMap : " + paramMap);		
		
		paramMap.put("loginId", (String) session.getAttribute("loginId"));
		
		String action = (String) paramMap.get("action");
		
		if("I".equals(action)) {
			hnoticeService.hnoticenewsave(paramMap);
		} else if ("U".equals(action)){
			hnoticeService.hnoticenewupdate(paramMap);
		}
		
		
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		
		
		logger.info("+ End " + className + ".hnoticesave");

		return returnmap;
	}		
	
	
	@RequestMapping("detailone.do")
	@ResponseBody
	public Map<String, Object> detailone(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".detailone");
		logger.info("   - paramMap : " + paramMap);		
		
		
		HnoticeModel detailone =  hnoticeService.detailone(paramMap);
		
		
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		
		
		logger.info("+ End " + className + ".hnoticesave");

		return returnmap;
	}	
	
}
