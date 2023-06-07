<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>년별매출현황</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>


<script type="text/javascript">

	// 그룹코드 페이징 설정_급여내역
	var pageSize = 5;			//한페이지에 몇개 볼것인가
	var pageBlockSize = 5;
	
	/** OnLoad event */ 
	$(function() {
		
		/* 
		구글차트 그려주는거에서 .load(온로드) .Callback(콜백) 해줘서 onload event에 yearRevenue(); 안넣음	
		아래가 구글차트 onload,Callback
	  	google.charts.load('current', {'packages':['corechart']});
	    google.charts.setOnLoadCallback(yearRevenue);
		*/	
		
		fRegisterButtonClickEvent();
	
	});
	
	
	
	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();		//이후의 예약 이벤트를 모두 소멸시킴

			var btnId = $(this).attr('id');	//해당 버튼의 아이디를 꺼내라

			switch (btnId) {
			case 'btnSave' :
					fn_save();
					break;
			case 'btnClose' :
				gfCloseModal();
				break;
			}
		});
	}
	
	
	/*년매출 리스트*/
	function yearRevenue() {
		
		// param과 callback 지정
		var param = {
				srcdate : $('#srcdate').val()
			} // {} json 형태
		
		var yearcallback = function(returndata){ 
			
			var html_head = "<th scope=\"col\"></th>";
			var html_body1 = "<td>당기순이익</td>";	
			var html_body2 = "<td>영업이익</td>";	
			var html_body3 = "<td>매출</td>";	
			var html_body4 = "<td>인건비</td>";	
			var html_body5 = "<td>기타지출</td>";	
			var html_body6 = "<td>전년대비매출성장률</td>";	
			var html_body7 = "<td>전년대비순이익성장률</td>";
			
	
			
			
			for (var i in returndata.YYRevenueList){
				html_head += "\n"+"<th scope=" + "\"col\"" + ">" + returndata.YYRevenueList[i].srcday + "</th>";
				
 				html_body1 += "\n"+"<td>"+returndata.YYRevenueList[i].income.toLocaleString()+"</td>";
 				html_body2 += "\n"+"<td>"+returndata.YYRevenueList[i].take_pay.toLocaleString()+"</td>";
 				html_body3 += "\n"+"<td>"+returndata.YYRevenueList[i].order_pay.toLocaleString()+"</td>";
 				html_body4 += "\n"+"<td>"+returndata.YYRevenueList[i].salary_pay.toLocaleString()+"</td>";
 				html_body5 += "\n"+"<td>"+returndata.YYRevenueList[i].expense_pay.toLocaleString()+"</td>";
 				
 				
 				if(returndata.YYRevenueList[i].take_pay_growth < 0){
 					html_body6 += "\n"+"<td style=\"color: blue\">"+returndata.YYRevenueList[i].take_pay_growth+"%"+"</td>";
 				}else if (returndata.YYRevenueList[i].take_pay_growth > 0){
 					html_body6 += "\n"+"<td style=\"color: red\">"+returndata.YYRevenueList[i].take_pay_growth+"%"+"</td>";
 				}else{
 					html_body6 += "\n"+"<td>"+returndata.YYRevenueList[i].take_pay_growth+"%"+"</td>";
 				}
 				
 				if(returndata.YYRevenueList[i].income__growth < 0){
 					html_body7 += "\n"+"<td style=\"color: blue\">"+returndata.YYRevenueList[i].income__growth+"%"+"</td>";
 				}else if (returndata.YYRevenueList[i].income__growth > 0){
 					html_body7 += "\n"+"<td style=\"color: red\">"+returndata.YYRevenueList[i].income__growth+"%"+"</td>";
 				}else{
 					html_body7 += "\n"+"<td>"+returndata.YYRevenueList[i].income__growth+"%"+"</td>";
 				}
 				
			$("#yearHead").empty().append(html_head);
			$("#html_body1").empty().append(html_body1);
			$("#html_body2").empty().append(html_body2);
			$("#html_body3").empty().append(html_body3);
			$("#html_body4").empty().append(html_body4);
			$("#html_body5").empty().append(html_body5);
			$("#html_body6").empty().append(html_body6);
			$("#html_body7").empty().append(html_body7);
			
			/* controller에서 json 형식으로 만들어서 넣어줌 */
			drawVisualization(returndata.result1);
			}
			}

		callAjax("/sales/yearRevenue.do", "post", "json", "false", param, yearcallback);
		
	} //yearRevenue*/
	
	
	/* 구글차트 onload,callback */
  	google.charts.load('current', {'packages':['corechart']});
    google.charts.setOnLoadCallback(yearRevenue);

	/* 구글차트 */
      function drawVisualization(object) { //json만들어준거 object형식으로 받아서 넘겨줌

      // Some raw data (not necessarily accurate)
      var data = google.visualization.arrayToDataTable(object);            
         
      var options = {
        title : '년 매출',
        vAxis: {title: '원'},
        hAxis: {title: 'Year'},
        seriesType: 'bars',
      };

      var chart = new google.visualization.ComboChart(document.getElementById('chart_div'));
      chart.draw(data, options);
      
      
    }

	
</script>

</head>
<body>
<form id="myForm" action=""  method="">

	<!-- 모달 배경 -->
	<div id="mask"></div>

	<div id="wrap_area">

		<h2 class="hidden">header 영역</h2>
		<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

		<h2 class="hidden">컨텐츠 영역</h2>
		<div id="container">
			<ul>
				<li class="lnb">
					<!-- lnb 영역 --> <jsp:include
						page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> <!--// lnb 영역 -->
				</li>
				<li class="contents">
					<!-- contents -->
					<h3 class="hidden">contents 영역</h3> <!-- content -->
					<div class="content">

						<p class="Location">
							<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a> <span
								class="btn_nav bold">매출 </span> <span class="btn_nav bold">년도매출현황
								</span> <a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>년도매출현황</span> <span class="fr"> 
							</span>
						</p>
						<p style="text-align: right;">
						기간&nbsp;
							<input type="date" id="srcdate" name="srcdate" />
                     	    <a	class="btnType blue" href="javascript:yearRevenue();" ><span>조회</span></a>		
						</p>
						<!-- 구글차트 -->
						<div id="chart_div" style="width: 900px; height: 500px;"></div> 
						
						<div class="yearSearchList" id="yearSearchList">
						<table class="col">
						<caption>caption</caption>
							<colgroup>
								<col width="19%">
								<col width="27%">
								<col width="27%">
								<col width="27%">
							</colgroup>
							<thead>
								<tr id="yearHead">
								</tr>
							</thead>
							<tbody>
								<tr id="html_body1">
								</tr>
								<tr id="html_body2"></tr>
								<tr id="html_body3"></tr>
								<tr id="html_body4"></tr>
								<tr id="html_body5"></tr>
								<tr id="html_body6"></tr>
								<tr id="html_body7"></tr>
							</tbody>
							</table>
						</div>
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>
	
</form>
</body>
</html>