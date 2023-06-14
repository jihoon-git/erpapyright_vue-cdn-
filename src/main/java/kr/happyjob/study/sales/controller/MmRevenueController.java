package kr.happyjob.study.sales.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
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
import org.springframework.web.bind.annotation.ResponseBody;

import kr.happyjob.study.sales.model.MmRevenueModel;
import kr.happyjob.study.sales.service.MmRevenueService;;

@Controller
@RequestMapping("/sales/")
public class MmRevenueController {
	
	@Autowired
	MmRevenueService mmRevenueService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	//combo box select 값
	private String combo;
	private String selectyear;/////
	
	/**
	 * 월별매출관리 관리 초기화면
	 */
	@RequestMapping("mmRevenue.do")
	public String mmRevenue(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		//날짜 형식 설정
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
		
		//한국 시간 설정
		Calendar ca1 = Calendar.getInstance(Locale.KOREA);
		
		selectyear = sdf.format(ca1.getTime());
		ca1.setTime(ca1.getTime());
		System.out.println("확인 : "+ selectyear);
		model.addAttribute("selectyear",selectyear);
		
		return "sales/mmRevenue/mmRevenue";
	}
	
	/**
	 * 월별매출관리 관리 초기화면
	 */
	@RequestMapping("vueMmRevenue.do")
	public String vueMmrevenue(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		//날짜 형식 설정
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
		
		//한국 시간 설정
		Calendar ca1 = Calendar.getInstance(Locale.KOREA);
		
		selectyear = sdf.format(ca1.getTime());
		ca1.setTime(ca1.getTime());
		System.out.println("확인 : "+ selectyear);
		model.addAttribute("selectyear",selectyear);
		
		return "sales/mmRevenue/vueMmRevenue";
	}
	
	/**
	 * 월별 손익통계 테이블
	 */
	@RequestMapping("mmRevenuelist.do")
	public String mmRevenuelist(Model model, @RequestParam Map<String, Object> paramMap) throws Exception {
		
		logger.info("+ Start " + className + ".mmRevenuelist");
		logger.info("   - paramMap : " + paramMap);
		
		//콤보박스 값
		combo = (String) paramMap.get("selectyear");
		System.out.println("combo : "+combo);

			
		List<MmRevenueModel> mmRevenuelist1 = mmRevenueService.mmRevenuelist1(paramMap);		
		model.addAttribute("mmRevenuelist1", mmRevenuelist1);
		
		List<MmRevenueModel> mmRevenuelist2 = mmRevenueService.mmRevenuelist2(paramMap);		
		model.addAttribute("mmRevenuelist2", mmRevenuelist2);
			
		logger.info("+ End " + className + ".mmRevenuelist");

		
		return "sales/mmRevenue/mmRevenuelist";		
	}
	
	/**
	 * 월별 손익통계 차트
	 */
	@RequestMapping("viewmmChart.do")
	public String viewmmChart(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".viewmmChart");
		logger.info("   - paramMap : " + paramMap);
		
		//콤보박스 값
		combo = (String) paramMap.get("selectyear");
		System.out.println("combo : "+combo);

			
		List<MmRevenueModel> mmRevenuelist = mmRevenueService.mmRevenuelist(paramMap);		
		model.addAttribute("mmRevenuelist", mmRevenuelist);
			
		logger.info("+ End " + className + ".viewmmChart");


		return "/sales/mmRevenue/mmRevenuechart";
	}

	/**
	 * 월별 손익통계 테이블
	 */
	@RequestMapping("mmRevenuelistvue.do")
	@ResponseBody
	public Map<String, Object> mmRevenuelistvue(Model model, @RequestParam Map<String, Object> paramMap) throws Exception {

		logger.info("+ Start " + className + ".mmRevenuelist");
		logger.info("   - paramMap : " + paramMap);

		//콤보박스 값
		combo = (String) paramMap.get("selectyear");
		System.out.println("combo : "+combo);


		List<MmRevenueModel> mmRevenuelist1 = mmRevenueService.mmRevenuelist1(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		//model.addAttribute("mmRevenuelist1", mmRevenuelist1);

		resultMap.put("mmRevenuelist1", mmRevenuelist1);


		List<MmRevenueModel> mmRevenuelist2 = mmRevenueService.mmRevenuelist2(paramMap);
		//model.addAttribute("mmRevenuelist2", mmRevenuelist2);

		resultMap.put("mmRevenuelist2", mmRevenuelist2);


		logger.info("+ End " + className + ".mmRevenuelist");


		return resultMap;
	}

	/**
	 * 월별 손익통계 차트
	 */
	@RequestMapping("viewmmChartvue.do")
	@ResponseBody
	public Map<String, Object> viewmmChartvue(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
							  HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".viewmmChart");
		logger.info("   - paramMap : " + paramMap);

		//콤보박스 값
		combo = (String) paramMap.get("selectyear");
		System.out.println("combo : "+combo);


		List<MmRevenueModel> mmRevenuelist = mmRevenueService.mmRevenuelist(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		//model.addAttribute("mmRevenuelist", mmRevenuelist);

		resultMap.put("mmRevenuelist", mmRevenuelist);

		logger.info("+ End " + className + ".viewmmChart");


		return resultMap;
	}
		
}
