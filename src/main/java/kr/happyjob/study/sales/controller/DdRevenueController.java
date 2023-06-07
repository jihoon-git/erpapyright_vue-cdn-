package kr.happyjob.study.sales.controller;

import java.util.List;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;
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

import kr.happyjob.study.sales.model.DdRevenueModel;
import kr.happyjob.study.sales.service.DdRevenueService;

@Controller
@RequestMapping("/sales/")
public class DdRevenueController {
	
	@Autowired
	DdRevenueService ddRevenueService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	

	/**
	 *  일별 매출 현황 초기 화면
	 */
	@RequestMapping("ddRevenue.do")
	public String ddRevenue(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		// 로그
		logger.info("+ Start " + className + ".ddRevenue");
		logger.info("   - paramMap : " + paramMap);
		
		
		//날짜 형식 설정
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		//한국 시간 설정
		Calendar ca1= Calendar.getInstance(Locale.KOREA);
		
		// 오늘
        String revToday = sdf.format(ca1.getTime());

		model.addAttribute("today", revToday);
		
		logger.info("+ End " + className + ".ddRevenue");
		
		return "/sales/ddRevenue/ddRevenue";
	}
	
	/**
	 * 일별매출목록 조회
	 */
	@RequestMapping("ddRevenueList.do")
	public String ddRevenueList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".ddRevenueList");
		logger.info("   - paramMap : " + paramMap);


		int currentPage = Integer.parseInt((String)paramMap.get("currentPage"));	// 현재 페이지 번호
		int pageSize = Integer.parseInt((String)paramMap.get("pageSize"));			// 페이지 사이즈
		int pageIndex = (currentPage-1)*pageSize;									// 페이지 시작 row 번호

		paramMap.put("pageIndex", pageIndex);
		paramMap.put("currentPage", currentPage);
		paramMap.put("pageSize", pageSize);
		
		// 일별주문조회 리스트
		List<DdRevenueModel> ddRevenueList = ddRevenueService.ddRevenueList(paramMap);
		model.addAttribute("ddRevenueList", ddRevenueList);

		// 일별주문 리스트 카운트
		int totalCount = ddRevenueService.countRevenueList(paramMap);
		model.addAttribute("totalCntddRevenue", totalCount);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("currentPageddRevenue",currentPage);

		logger.info("+ End " + className + ".ddRevenueList");


		return "/sales/ddRevenue/ddRevenueList";
	}	


	/**
	 * 일별매출/한달간 누적매출
	 */
	@RequestMapping("ddRevChart.do")
	public String ddRevChart(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".ddRevChart");
		logger.info("   - paramMap : " + paramMap);

		List<DdRevenueModel> ddRevChartModel = ddRevenueService.ddRevChart(paramMap);
		model.addAttribute("ddRevChartModel", ddRevChartModel);

		logger.info("+ End " + className + ".ddRevChart");

		return "/sales/ddRevenue/ddRevChart";
	}
	
	/**
	 * 일별매출/한달간 누적매출
	 */
	@RequestMapping("ddRevProductChart.do")
	public String ddRevProductChart(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".ddRevProductChart");
		logger.info("   - paramMap : " + paramMap);
		
		List<DdRevenueModel> ddRevProductChartModel = ddRevenueService.ddRevProductChart(paramMap);
		model.addAttribute("ddRevProductChartModel", ddRevProductChartModel);
		
		logger.info("+ End " + className + ".ddRevChart");
		
		return "/sales/ddRevenue/ddRevProductChart";
	}
	
}
