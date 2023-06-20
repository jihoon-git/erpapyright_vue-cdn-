package kr.happyjob.study.business.controller;

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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.happyjob.study.business.model.BizPartnerModel;
import kr.happyjob.study.business.service.BizPartnerService;
import kr.happyjob.study.system.model.DeptMgrModel;

@Controller
@RequestMapping("/business/")
public class BizPartnerController {
	
	@Autowired
	BizPartnerService bpService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	
	
	/**
	 * 거래처 관리 초기화면
	 */
	@RequestMapping("bizPartner.do")
	public String bizPartner(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".bizPartner");
		logger.info("   - paramMap : " + paramMap);
		
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		model.addAttribute("userType", (String) session.getAttribute("userType"));
		
		logger.info("+ End " + className + ".bizPartner");

		return "business/BizPartner/bizPartner";
	}
	
	/**
	 * 거래처 관리 초기화면
	 */
	@RequestMapping("vueBizPartner.do")
	public String vueBizpartner(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".bizPartner");
		logger.info("   - paramMap : " + paramMap);
		
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		model.addAttribute("userType", (String) session.getAttribute("userType"));
		
		logger.info("+ End " + className + ".bizPartner");

		return "business/BizPartner/vueBizPartner";
	}
	
	
	
	/**
	 * 거래처 리스트
	 */
	@RequestMapping("clientlist.do")
	public String clientlist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".clientlist");
		logger.info("   - paramMap : " + paramMap);
		
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<BizPartnerModel> clientlist = bpService.clientlist(paramMap);
		int countclientlist = bpService.countclientlist(paramMap);
		
		model.addAttribute("clientlist", clientlist);
		model.addAttribute("countclientlist", countclientlist);
		
		logger.info("+ End " + className + ".clientlist");

		return "business/BizPartner/bizPartnerlist";
	}
	
	/**
	 * 거래처 디테일
	 */
	@RequestMapping("clientdetail.do")
	@ResponseBody
	public Map<String, Object> clientdetail(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".clientdetail");
		logger.info("   - paramMap : " + paramMap);		
	
		BizPartnerModel clientdetail = bpService.clientdetail(paramMap);
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		returnmap.put("clientdetail", clientdetail);
		
		logger.info("+ End " + className + ".clientdetail");

		return returnmap;
	}
	
	/**
	 * 거래처 저장, 업데이트, 삭제
	 */
	@RequestMapping("clientsave.do")
	@ResponseBody
	public Map<String, Object> clientsave(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".clientsave");
		logger.info("   - paramMap : " + paramMap);	
		
		String action = (String) paramMap.get("action");
		
		if("I".equals(action)) {
			bpService.clientsave(paramMap);
		} else if("U".equals(action)) {
			bpService.clientupdate(paramMap);
		} else if("D".equals(action)) {
			bpService.clientdelete(paramMap);
		}
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		
		logger.info("+ End " + className + ".clientsave");

		return returnmap;
	}

	/**
	 * 거래처 리스트
	 */
	@RequestMapping("clientlistvue.do")
	@ResponseBody
	public Map<String, Object>  clientlistvue(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
							 HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".clientlist");
		logger.info("   - paramMap : " + paramMap);

		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;

		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);

		List<BizPartnerModel> clientlist = bpService.clientlist(paramMap);
		int countclientlist = bpService.countclientlist(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();

		//model.addAttribute("clientlist", clientlist);
		//model.addAttribute("countclientlist", countclientlist);

		resultMap.put("clientlist", clientlist);
		resultMap.put("countclientlist", countclientlist);

		logger.info("+ End " + className + ".clientlist");

		return resultMap;
	}
	
	   /*사업자번호  중복 체크*/
	   @RequestMapping(value="/checkPermitNo.do", method=RequestMethod.POST)
	   @ResponseBody
	   public int checkPermitNo(BizPartnerModel model) throws Exception{
		   
		   logger.info("+ Start " + className + ".checkPermitNo");
		   int result = bpService.checkPermitNo(model);
		   logger.info("+ End " + className + ".checkPermitNo");
		   return result;
	   }
}
