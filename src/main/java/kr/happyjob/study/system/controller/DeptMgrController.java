package kr.happyjob.study.system.controller;

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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.happyjob.study.login.model.LgnInfoModel;
import kr.happyjob.study.system.model.DeptMgrModel;
import kr.happyjob.study.system.service.DeptMgrService;

@Controller
@RequestMapping("/system/")
public class DeptMgrController {
	
	@Autowired
	DeptMgrService deptMgrService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	
	
	/**
	 * 부서 관리 초기화면
	 */
	@RequestMapping("deptMgr.do")
	public String deptMgr(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".deptMgr");
		logger.info("   - paramMap : " + paramMap);
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		
		logger.info("+ End " + className + ".deptMgr");

		return "system/deptMgr/deptMgr";
	}
	/**
	 * 부서 관리 초기화면 vue
	 */
	@RequestMapping("vueDeptMgr.do")
	public String vueDeptMgr(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".deptMgr");
		logger.info("   - paramMap : " + paramMap);
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		
		logger.info("+ End " + className + ".deptMgr");

		return "system/deptMgr/vueDeptMgr";
	}
	
	// 목록조회
	@RequestMapping("deptlist.do")
	public String deptlist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".deptlist");
		logger.info("   - paramMap : " + paramMap);
		
		// 1     0
		// 2     10
		// 3     20		
		
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<DeptMgrModel> deptlist = deptMgrService.deptlist(paramMap);
		
		int countdeptlist = deptMgrService.countdeptlist(paramMap);
		
		model.addAttribute("deptlist", deptlist);
		model.addAttribute("countdeptlist", countdeptlist);
		
		logger.info("+ End " + className + ".deptlist");

		return "system/deptMgr/deptList";
	}
	
	// 목록조회 vue : callAjax string to json
		@ResponseBody
		@RequestMapping("vueDeptlist.do")
		public Map<String, Object>  vueDeptlist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
				HttpServletResponse response, HttpSession session) throws Exception {
			
			logger.info("+ Start " + className + ".deptlist");
			logger.info("   - paramMap : " + paramMap);
			
			// 1     0
			// 2     10
			// 3     20		
			
			int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
			int cpage = Integer.parseInt((String) paramMap.get("cpage"));
			int pageindex = (cpage - 1) * pageSize;
			
			paramMap.put("pageindex", pageindex);
			paramMap.put("pageSize", pageSize);
			
			List<DeptMgrModel> deptlist = deptMgrService.deptlist(paramMap);
			
			int countdeptlist = deptMgrService.countdeptlist(paramMap);
			
			model.addAttribute("deptlist", deptlist);
			model.addAttribute("countdeptlist", countdeptlist);
			
//			return json 
			Map<String, Object> returnmap = new HashMap<String, Object>();
			returnmap.put("deptlist", deptlist);
			returnmap.put("countdeptlist", countdeptlist);
			
			logger.info("+ End " + className + ".deptlist");

			return returnmap;
		}
		
	/*부서 정보 저장*/
	@RequestMapping("deptsave.do")
	@ResponseBody
	public Map<String, Object> deptsave(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".deptsave");
		logger.info("   - paramMap : " + paramMap);		
		
		paramMap.put("loginId", (String) session.getAttribute("loginId"));
		
		String action = (String) paramMap.get("action");
		
		if("I".equals(action)) {
			deptMgrService.deptnewsave(paramMap);
		} else if("U".equals(action)) {
			deptMgrService.deptnewupdate(paramMap);
		} else if("D".equals(action)) {
			deptMgrService.deptnewdelete(paramMap);
		}
		
		
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		
		
		logger.info("+ End " + className + ".deptsave");

		return returnmap;
	}		
	
	/*부서 상세 조회*/
	@RequestMapping("detaildept.do")
	@ResponseBody
	public Map<String, Object> detaildept(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".detaildept");
		logger.info("   - paramMap : " + paramMap);		
				
		DeptMgrModel detaildept = deptMgrService.detaildept(paramMap);
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		returnmap.put("detaildept", detaildept);
		
		
		logger.info("+ End " + className + ".detaildept");

		return returnmap;
	}
	
	/*부서 인원 카운트*/
	@RequestMapping("countindept.do")
	@ResponseBody
	public Map<String, Object> countindept(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".countindept");
		logger.info("   - paramMap : " + paramMap);		
				
		int countindept = deptMgrService.countindept(paramMap);
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		returnmap.put("countindept", countindept);
		
		
		logger.info("+ End " + className + ".countindept");

		return returnmap;
	}
	
	   /*부서명  중복 체크*/
	   @RequestMapping(value="/check_dept.do", method=RequestMethod.POST)
	   @ResponseBody
	   public int check_dept(DeptMgrModel model) throws Exception{
		   
		   logger.info("+ Start " + className + ".check_dept");
		   int result = deptMgrService.check_dept(model);
		   logger.info("+ End " + className + ".check_dept");
		   return result;
	   }	
	
	

}
