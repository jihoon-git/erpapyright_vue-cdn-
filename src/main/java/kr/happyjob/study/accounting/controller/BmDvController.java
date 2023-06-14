package kr.happyjob.study.accounting.controller;

import java.io.File;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import org.springframework.web.multipart.MultipartFile;

import kr.happyjob.study.accounting.model.BmDvModel;
import kr.happyjob.study.accounting.model.FileModel;
import kr.happyjob.study.accounting.service.BmDvService;

@Controller
@RequestMapping("/accounting/")
public class BmDvController {

	@Autowired
	BmDvService bmdvservice;

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();

	/**
	 * 지출결의서 초기 화면
	 */
	@RequestMapping("bmDv.do")
	public String bmDv(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".bmDv");
		logger.info("   - paramMap : " + paramMap);

		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		model.addAttribute("userType", (String) session.getAttribute("userType"));

		logger.info("+ End " + className + ".bmDv");

		return "accounting/bmDv/bmDv";
	}
	
	/**
	 * Vue 지출결의서 초기 화면
	 */
	@RequestMapping("vueBmDv.do")
	public String vueBmDv(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".vueBmDv");
		logger.info("   - paramMap : " + paramMap);

		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		model.addAttribute("userType", (String) session.getAttribute("userType"));

		logger.info("+ End " + className + ".vueBmDv");

		return "accounting/bmDv/vueBmDv";
	}	

	/**
	 * 지출결의서 총 리스트
	 */
	@RequestMapping("expenselist.do")
	public String expenselist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".expenselist");
		logger.info("   - paramMap : " + paramMap);

		int pageSize = Integer.parseInt((String) paramMap.get("pagesize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageIndex = (cpage - 1) * pageSize;

		paramMap.put("pageSize", pageSize);
		paramMap.put("cpage", cpage);
		paramMap.put("pageIndex", pageIndex);

		List<BmDvModel> expenselist = bmdvservice.expenselist(paramMap);
		int countexpenselist = bmdvservice.countexpenselist(paramMap);

		model.addAttribute("expenselist", expenselist);
		model.addAttribute("countexpenselist", countexpenselist);

		logger.info("+ End " + className + ".expenselist");

		return "accounting/bmDv/bmDvlist";
	}
	
	/**
	 * Vue 지출결의서 총 리스트
	 */
	@RequestMapping("vueExpenselist.do")
	@ResponseBody
	public Map<String, Object> vueExpenselist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".vueExpenselist");
		logger.info("   - paramMap : " + paramMap);

		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageIndex = (cpage - 1) * pageSize;

		paramMap.put("pageSize", pageSize);
		paramMap.put("cpage", cpage);
		paramMap.put("pageIndex", pageIndex);
		Map<String, Object> resultMap = new HashMap<String, Object>();

		List<BmDvModel> expenselist = bmdvservice.expenselist(paramMap);
		int countexpenselist = bmdvservice.countexpenselist(paramMap);

		resultMap.put("expenselist", expenselist);
		resultMap.put("countexpenselist", countexpenselist);
		resultMap.put("loginId", (String) session.getAttribute("loginId"));
		resultMap.put("userNm", (String) session.getAttribute("userNm"));
		resultMap.put("userType",(String) session.getAttribute("userType"));
		
		
		logger.info("+ End " + className + ".vueExpenselist");

		return resultMap;
	}	

	/**
	 * 지출결의서 저장, 수정, 삭제
	 */
	@RequestMapping("expensesave.do")
	@ResponseBody
	public Map<String, Object> expensesave(Model model, @RequestParam Map<String, Object> paramMap,@RequestParam("regfile") List<MultipartFile> multiFile,
			HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".expensesave");
		logger.info("   - paramMap : " + paramMap);
		logger.info("   - request : " + request);

		String action = (String) paramMap.get("action");
		// 신규 저장
		if ("I".equals(action)) {
			bmdvservice.expensenewsave(paramMap, request, multiFile);
		} else if ("U".equals(action)) {
			bmdvservice.expenseupdate(paramMap, request, multiFile);
		} else if ("D".equals(action)){
			bmdvservice.expensedelete(paramMap);
			
		}

		Map<String, Object> returnmap = new HashMap<String, Object>();

		returnmap.put("result", "Success");

		logger.info("+ End " + className + ".expensesave");

		return returnmap;
	}

	/**
	 * 지출결의서 상세보기
	 */
	@RequestMapping("expensedetail.do")
	@ResponseBody
	public Map<String, Object> expensedetail(Model model, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".expensedetail");
		logger.info("   - paramMap : " + paramMap);
		logger.info("   - request : " + request);

		BmDvModel expensedetail = bmdvservice.expensedetail(paramMap);

		Map<String, Object> returnmap = new HashMap<String, Object>();

		returnmap.put("detailexpense", expensedetail);

		logger.info("+ End " + className + ".expensedetail");

		return returnmap;
	}

	/**
	 * 승인반려버전 지출결의서 저장
	 */
	@RequestMapping("approvalexpense.do")
	@ResponseBody
	public Map<String, Object> approvalexpense(Model model, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".approvalexpense");
		logger.info("   - paramMap : " + paramMap);
		logger.info("   - request : " + request);
		
		String approval = (String) paramMap.get("approval");
		
		if("y".equals(approval)){
			bmdvservice.newaccount(paramMap);
		}

		bmdvservice.approvalexpense(paramMap);

		Map<String, Object> returnmap = new HashMap<String, Object>();

		returnmap.put("result", "SUCCESS");

		logger.info("+ End " + className + ".approvalexpense");

		return returnmap;
	}

	/**
	 * 파일 데이터 추출
	 */
	@RequestMapping("detailfile.do")
	@ResponseBody
	public Map<String, Object> detailfile(Model model, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".detailfile");
		logger.info("   - paramMap : " + paramMap);
		logger.info("   - request : " + request);

		List<FileModel> filedetail = bmdvservice.detailfile(paramMap);

		Map<String, Object> returnmap = new HashMap<String, Object>();

		returnmap.put("filedetail", filedetail);

		logger.info("+ End " + className + ".detailfile");

		return returnmap;
	}

	/**
	 * 파일 다운로드
	 */
	@RequestMapping("expensefiledownload.do")
	@ResponseBody
	public void expensefiledownload(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".expensefiledownload");
		logger.info("   - paramMap : " + paramMap);
		logger.info("   - request : " + request);

		FileModel filedetail = bmdvservice.detailfileone(paramMap);

		String filename = filedetail.getFile_name();
		String filemadd = filedetail.getFile_madd();

		byte fileByte[] = FileUtils.readFileToByteArray(new File(filemadd));

		response.setContentType("application/octet-stream");
		response.setContentLength(fileByte.length);
		response.setHeader("Content-Disposition",
				"attachment; fileName=\"" + URLEncoder.encode(filename, "UTF-8") + "\";");
		response.setHeader("Content-Transfer-Encoding", "binary");
		response.getOutputStream().write(fileByte);

		logger.info("+ End " + className + ".expensefiledownload");

		return;
	}
	
}
