package kr.happyjob.study.system.controller;

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

import kr.happyjob.study.common.comnUtils.ComnCodUtil;
import kr.happyjob.study.system.model.NoticeModel;
import kr.happyjob.study.system.service.NoticeService;;

@Controller
@RequestMapping("/system/")
public class NoticeController {
	
	@Autowired
	NoticeService noticeService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	// 공지사항 초기화면
	@RequestMapping("notice.do")
	public String notice(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".hnotice");
		logger.info("   - paramMap : " + paramMap);
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		
		logger.info("+ End " + className + ".hnotice");

		return "system/notice/notice";
	}
	
	// 공지사항 목록 조회
	@RequestMapping("noticelist.do")
	public String noticelist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
			
		logger.info("+ Start " + className + ".noticelist");
		logger.info("   - paramMap : " + paramMap);
		
		// 1     0
		// 2     10
		// 3     20		
		
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<NoticeModel> noticelist = noticeService.noticelist(paramMap);
		
		int countnoticelist = noticeService.countnoticelist(paramMap);
		
		model.addAttribute("noticelist", noticelist);
		model.addAttribute("countnoticelist", countnoticelist);
		
		logger.info("+ End " + className + ".noticelist");

		return "system/notice/noticelist";
	}
	
	// 공지사항 등록
	@RequestMapping("noticesave.do")
	@ResponseBody
	public Map<String, Object> noticesave(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".noticesave");
		logger.info("   - paramMap : " + paramMap);		
		
		paramMap.put("loginId", (String) session.getAttribute("loginId"));
		
		String action = (String) paramMap.get("action");
		
		if("I".equals(action)) {
			noticeService.noticenewsave(paramMap);
		} else if("U".equals(action)) {
			noticeService.noticenewupdate(paramMap);
		} else if("D".equals(action)) {
			noticeService.noticenewdelete(paramMap);
		}
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		
		
		logger.info("+ End " + className + ".noticesave");

		return returnmap;
	}
	
	// 상세조회
	@RequestMapping("detailone.do")
	@ResponseBody
	public Map<String, Object> detailone(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".detailone");
		logger.info("   - paramMap : " + paramMap);		
				
		NoticeModel detailone = noticeService.detailone(paramMap);
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		returnmap.put("detailone", detailone);
		
		
		logger.info("+ End " + className + ".detailone");

		return returnmap;
	}
	
	// 파일 저장
	@RequestMapping("noticesavefile.do")
	@ResponseBody
	public Map<String, Object> noticesavefile(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".noticesavefile");
		logger.info("   - paramMap : " + paramMap);		
		
		paramMap.put("loginId", (String) session.getAttribute("loginId"));
		
		String action = (String) paramMap.get("action");
		
		if("I".equals(action)) {
			noticeService.noticenewsavefile(paramMap, request);
		} else if("U".equals(action)) {
			noticeService.noticenewupdatefile(paramMap, request);
		} else if("D".equals(action)) {
			noticeService.noticenewdeletefile(paramMap);
		}		
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		
		
		logger.info("+ End " + className + ".noticesavefile");

		return returnmap;
	}	
	
	// 파일 다운로드
	@RequestMapping("noticefiledownaload.do")
	public void noticefiledownaload(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".noticefiledownaload");
		logger.info("   - paramMap : " + paramMap);		
		
		NoticeModel detailone = noticeService.detailone(paramMap);
		
		String filename = detailone.getFile_name();
		String filemadd = detailone.getFile_madd();
		
        byte fileByte[] = FileUtils.readFileToByteArray(new File(filemadd));
		
	    response.setContentType("application/octet-stream");
	    response.setContentLength(fileByte.length);
	    response.setHeader("Content-Disposition", "attachment; fileName=\"" + URLEncoder.encode(filename,"UTF-8")+"\";");
	    response.setHeader("Content-Transfer-Encoding", "binary");
	    response.getOutputStream().write(fileByte);
		
		logger.info("+ End " + className + ".noticefiledownaload");

		return;
	}
	
	
	
	
	
	
	// vue 공지사항 초기화면
		@RequestMapping("vueNotice.do")
		public String vueNotice(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
				HttpServletResponse response, HttpSession session) throws Exception {
			
			logger.info("+ Start " + className + ".vueNotice");
			logger.info("   - paramMap : " + paramMap);
			
			model.addAttribute("loginId", (String) session.getAttribute("loginId"));
			model.addAttribute("userNm", (String) session.getAttribute("userNm"));
			
			logger.info("+ End " + className + ".vueNotice");

			return "system/notice/vueNotice";
		}
		
		// vue 공지사항 목록 조회
		@RequestMapping("vueNoticeList.do")
		@ResponseBody
		public Map<String, Object> vueNoticelist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
				HttpServletResponse response, HttpSession session) throws Exception {
				
			logger.info("+ Start " + className + ".vueNoticeList");
			logger.info("   - paramMap : " + paramMap);
			
			// 1     0
			// 2     10
			// 3     20		
			
			int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
			int cpage = Integer.parseInt((String) paramMap.get("cpage"));
			int pageindex = (cpage - 1) * pageSize;
			
			paramMap.put("pageindex", pageindex);
			paramMap.put("pageSize", pageSize);
			
			List<NoticeModel> vueNoticelist = noticeService.noticelist(paramMap);
			
			int countnoticelist = noticeService.countnoticelist(paramMap);
			
			Map<String, Object> returnmap = new HashMap<String, Object>();
			
			returnmap.put("vueNoticelist", vueNoticelist);
			returnmap.put("countnoticelist", countnoticelist);		
			
			logger.info("+ End " + className + ".vueNoticeList");

			return returnmap;
		}
		
		// vue 공지사항 등록
		@RequestMapping("vueNoticeListSave.do")
		@ResponseBody
		public Map<String, Object> vueNoticelistsave(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
				HttpServletResponse response, HttpSession session) throws Exception {
			
			logger.info("+ Start " + className + ".vueNoticeListSave");
			logger.info("   - paramMap : " + paramMap);		
			
			paramMap.put("loginId", (String) session.getAttribute("loginId"));
			
			String action = (String) paramMap.get("action");
			
			if("I".equals(action)) {
				noticeService.noticenewsave(paramMap);
			} else if("U".equals(action)) {
				noticeService.noticenewupdate(paramMap);
			} else if("D".equals(action)) {
				noticeService.noticenewdelete(paramMap);
			}
			
			Map<String, Object> returnmap = new HashMap<String, Object>();
			
			returnmap.put("result", "SUCCESS");
			
			
			
			logger.info("+ End " + className + ".vueNoticeListSave");

			return returnmap;
		}
		
		// vue 상세조회
		@RequestMapping("vueNoticeDetailone.do")
		@ResponseBody
		public Map<String, Object> vueNoticeDetailone(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
				HttpServletResponse response, HttpSession session) throws Exception {
			
			logger.info("+ Start " + className + ".vueNoticeDetailone");
			logger.info("   - paramMap : " + paramMap);		
					
			NoticeModel detailone = noticeService.detailone(paramMap);
			
			Map<String, Object> returnmap = new HashMap<String, Object>();
			
			returnmap.put("result", "SUCCESS");
			returnmap.put("detailone", detailone);
			returnmap.put("loginId", (String) session.getAttribute("loginId"));
			
			logger.info("+ End " + className + ".vueNoticeDetailone");

			return returnmap;
		}
		
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * 공지사항 관리 초기화면
	 *//*
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
		
		// 1     0
		// 2     10
		// 3     20		
		
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
		} else if("U".equals(action)) {
			hnoticeService.hnoticenewupdate(paramMap);
		} else if("D".equals(action)) {
			hnoticeService.hnoticenewdelete(paramMap);
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
				
		HnoticeModel detailone = hnoticeService.detailone(paramMap);
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		returnmap.put("detailone", detailone);
		
		
		logger.info("+ End " + className + ".detailone");

		return returnmap;
	}
	
	@RequestMapping("hnoticesavefile.do")
	@ResponseBody
	public Map<String, Object> hnoticesavefile(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".hnoticesavefile");
		logger.info("   - paramMap : " + paramMap);		
		
		paramMap.put("loginId", (String) session.getAttribute("loginId"));
		
		String action = (String) paramMap.get("action");
		
		if("I".equals(action)) {
			hnoticeService.hnoticenewsavefile(paramMap, request);
		} else if("U".equals(action)) {
			hnoticeService.hnoticenewupdatefile(paramMap, request);
		} else if("D".equals(action)) {
			hnoticeService.hnoticenewdeletefile(paramMap);
		}
		
		
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("result", "SUCCESS");
		
		
		logger.info("+ End " + className + ".hnoticesavefile");

		return returnmap;
	}	
	
	@RequestMapping("hnoticefiledownaload.do")
	public void hnoticefiledownaload(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".hnoticefiledownaload");
		logger.info("   - paramMap : " + paramMap);		
		
		HnoticeModel detailone = hnoticeService.detailone(paramMap);
		
		String filename = detailone.getFile_name();
		String filemadd = detailone.getFile_madd();
		
        byte fileByte[] = FileUtils.readFileToByteArray(new File(filemadd));
		
	    response.setContentType("application/octet-stream");
	    response.setContentLength(fileByte.length);
	    response.setHeader("Content-Disposition", "attachment; fileName=\"" + URLEncoder.encode(filename,"UTF-8")+"\";");
	    response.setHeader("Content-Transfer-Encoding", "binary");
	    response.getOutputStream().write(fileByte);
		
		logger.info("+ End " + className + ".hnoticefiledownaload");

		return;
	}	*/
	
	
	
}
