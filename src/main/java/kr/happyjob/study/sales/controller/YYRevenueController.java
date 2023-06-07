package kr.happyjob.study.sales.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import net.sf.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.happyjob.study.sales.model.YYRevenueModel;
import kr.happyjob.study.sales.service.YYRevenueService;

@Controller
@RequestMapping("/sales/")
public class YYRevenueController {
	
	@Autowired
	YYRevenueService yYRevenueService;
	
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	/**
	 * 년매출 초기화면
	 */
	@RequestMapping("yyRevenue.do")
	public String yyRevenue(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".yyRevenue");
		logger.info("   - paramMap : " + paramMap);
		
		
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));
		
		logger.info("+ End " + className + ".yyRevenue");

		return "sales/yyRevenue/yyRevenue";
	}
	
	/**
	 * 년매출 구글차트
	 */
	@RequestMapping("yearRevenue.do")
	@ResponseBody
	public Map<String, Object> yearRevenue(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".yearRevenue");
		logger.info("   - paramMap : " + paramMap);
		
		
		List<Object> resultList = new ArrayList<>(); //object 타입으로 리스트 만듬
		JSONArray result1 = JSONArray.fromObject(resultList); // 리스트를 json형태로 배치
		
		List<Object> resultList1 = new ArrayList<>(); //object 타입으로 리스트 만듬
		YYRevenueModel yearList = new YYRevenueModel(); // json 1행 초기값 생성용_model에서 값 저장해서 불러옴
		resultList1.add(yearList.getAaa1()); 
		resultList1.add(yearList.getAaa2());
		resultList1.add(yearList.getAaa3());
		resultList1.add(yearList.getAaa4());
		resultList1.add(yearList.getAaa5());
		resultList1.add(yearList.getAaa6());
		result1.add(resultList1); // 1행에 model에서 저장한 값 추가해서 json형태로 result1 초기값 1행으로 추가
				
		List<YYRevenueModel> YYRevenueList = new ArrayList<YYRevenueModel>(); //구글차트 아래 목록 뿌려주기용도로 만든 리스트
		
		for(int i=0; i<3; i++){
			
			paramMap.put("index", i); // 반복문 돌리기 및 param값으로 i,index
			
			YYRevenueModel yearList1 = yYRevenueService.yearList(paramMap);
			
			YYRevenueList.add(yYRevenueService.yearList(paramMap)); // 반복문 돌려서 값 저장
			
			List<Object> resultList2 = new ArrayList<>(); //반복문 돌려서 넣을 초기값
			
			resultList2.add(yearList1.getSrcday());
			resultList2.add(yearList1.getIncome());
			resultList2.add(yearList1.getTake_pay());
			resultList2.add(yearList1.getOrder_pay());
			resultList2.add(yearList1.getSalary_pay());
			resultList2.add(yearList1.getExpense_pay());
			
			result1.add(resultList2); //resultList2에 반복문 돌려서 나온 list를 json형식으로 추가 2행,3행,4행
			
		}
		
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
		returnmap.put("YYRevenueList", YYRevenueList);
		returnmap.put("result1", result1);
		//returnmap.put("yearList", yearList);
		
		logger.info("+ End " + className + ".yearRevenue");

		return returnmap;
	}
	

}
