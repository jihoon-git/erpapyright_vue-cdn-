package kr.happyjob.study.accounting.controller;

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
import kr.happyjob.study.accounting.service.AccTitleService;
import kr.happyjob.study.hwang.model.HnoticeModel;

@Controller
@RequestMapping("/accounting/")
public class AccTitleController {
	
	@Autowired
	AccTitleService accTitleService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	
	
	/**
	 * 계정과목 관리 초기화면
	 */
	@RequestMapping("acctitle.do")
	public String accTitle(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".accTitle");
		logger.info("   - paramMap : " + paramMap);
		
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		
		logger.info("+ End " + className + ".accTitle");

		return "accounting/accountTitle/acctitle";
	}
	
	/**
	 * 계정과목 관리 초기화면 vue
	 */
	@RequestMapping("vueAcctitle.do")
	public String vueAcctitle(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".accTitle");
		logger.info("   - paramMap : " + paramMap);
		
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		
		logger.info("+ End " + className + ".accTitle");

		return "accounting/accountTitle/vueAcctitle";
	}
	
	/**
	 * 계정과목 목록
	 */
	@RequestMapping("acctitlelist.do")
	public String acctitlelist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".acctitlelist");
		logger.info("   - paramMap : " + paramMap);
		
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<AccTitleModel> accTitlelist = accTitleService.accTitlelist(paramMap);
		
		int countAcctitlelist = accTitleService.countAcctitlelist(paramMap);
		
		model.addAttribute("accTitlelist", accTitlelist);
		model.addAttribute("countAcctitlelist", countAcctitlelist);
		
		logger.info("+ End " + className + ".acctitlelist");

		return "accounting/accountTitle/acctitlelist";
	}	
	
	/**
	 * 계정과목 목록 vue - vueAcctitle.jsp에서 listcallback을 String to json
	 */
	@ResponseBody
	@RequestMapping("vueAcctitlelist.do")
	public Map<String,Object> vueAcctitlelist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".acctitlelist");
		logger.info("   - paramMap : " + paramMap);
		
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<AccTitleModel> accTitlelist = accTitleService.accTitlelist(paramMap);
		
		int countAcctitlelist = accTitleService.countAcctitlelist(paramMap);
		
		model.addAttribute("accTitlelist", accTitlelist);
		model.addAttribute("countAcctitlelist", countAcctitlelist);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("accTitlelist", accTitlelist);
		resultMap.put("countAcctitlelist", countAcctitlelist);
		
		logger.info("+ End " + className + ".acctitlelist");
		
		return resultMap;
	}	
	
	/**
	 * 계정과목 상세조회
	 */
	@RequestMapping("detailacc.do")
	@ResponseBody
	public Map<String, Object> detailacc(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".detailacc");
		logger.info("   - paramMap : " + paramMap);		
				
		AccTitleModel detailacc = accTitleService.detailacc(paramMap);
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		returnmap.put("detailacc", detailacc);
		
		
		logger.info("+ End " + className + ".detailacc");

		return returnmap;
	}
	
	/**
	 * 계정과목 등록
	 */
	@RequestMapping("accTitlesave.do")
	@ResponseBody
	public Map<String, Object> accTitlesave(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".accTitlesave");
		logger.info("   - paramMap : " + paramMap);		
		
		paramMap.put("loginId", (String) session.getAttribute("loginId"));
		
		String action = (String) paramMap.get("action");
		
		//
		
		int accTitlenmck = accTitleService.accTitlenmck(paramMap);
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		if(accTitlenmck == 0){
			if("I".equals(action)) {
				accTitleService.accTitlesave(paramMap);
				returnmap.put("result", "SUCCESS");
			}
		}  else if("U".equals(action) &&  accTitlenmck == 1) {
			accTitleService.accTitleupdate(paramMap);
			returnmap.put("result", "SUCCESS");
		} else if("D".equals(action) &&  accTitlenmck == 1) {
			accTitleService.accTitledelete(paramMap);
			returnmap.put("result", "SUCCESS");
		} else if(accTitlenmck > 1){
			returnmap.put("result", "FAILNM");
		} else {
			AccTitleModel detailacc = accTitleService.detailacc(paramMap);
			if(((String)paramMap.get("account_cd")).equals(detailacc.getAccount_cd())){
					
					returnmap.put("result", "FAILCD");
					
					
				} else if(((String)paramMap.get("account_name")).equals(detailacc.getAccount_name())){
					
					returnmap.put("result", "FAILNM");
					
				} 
		}
		logger.info("+ End " + className + ".accTitlesave");

		return returnmap;
	}
	
}
