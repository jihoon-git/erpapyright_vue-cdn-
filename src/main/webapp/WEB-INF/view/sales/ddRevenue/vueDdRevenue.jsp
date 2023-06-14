<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>일별매출현황</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->
<style>
</style>

<%--  <script>
	/*그래프 데이터 변수 선언*/
	var dateArr = new Array();  //일별날짜
	var salesArr = new Array();  //매출
	var cumsalesArr = new Array(); //매출총이익
</script>

<c:forEach items="${ddRevChartModel}" var="list">
	<script>

      // 배열에 리스트에 담아온 데이터를 push
		dateArr.push("${list.contract_date}");
		salesArr.push("${list.sum_sales}");
		cumsalesArr.push("${list.cumsum_sales}");
	</script>
</c:forEach>  --%>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">

/* 구글차트 onload,callback */
google.charts.load('current', {packages: ['corechart']});
google.charts.setOnLoadCallback(drawChart);
google.charts.setOnLoadCallback(searchDdRev);

	// 일별매출 페이징 설정
	//var pageSize = 5;
	//var pageBlock = 5;
	var vuearea;
	var hiddenarea;
	
	/*그래프 데이터 변수 선언*/
	var dateArr = new Array();  //일별날짜
	var salesArr = new Array();  //매출
	var cumsalesArr = new Array(); //매출총이익
	
	</script>
	
	<c:forEach items="${ddRevChartModel}" var="list">
	<script>
      // 배열에 리스트에 담아온 데이터를 push
		dateArr.push("${list.contract_date}");
		salesArr.push("${list.sum_sales}");
		cumsalesArr.push("${list.cumsum_sales}");
	</script>
	</c:forEach> 
	<script>
	
	/** OnLoad event */
	$(function(){
		
		init();
		
		//거래처 콤보박스
		clientSelectBox("client_no", "searchClientNo", "all", "");
		// 버튼 이벤트 등록 (조회)
		fButtonClickEvent();


		//console.log("날짜 : " + searchDate);
		vuearea.fn_searchDdRev();
		fnDdRevChart();
		//fnDdRevProdChart();
		
	});
	
	function init(){
		vuearea = new Vue({
			el : "#wrap_area",
			data : {
				pageSize : 5,
				pageBlockSize : 5,
				
				grouplist : [],
				grouplistcnt : '',
				ddPagination : '',
				
				searchDate : '',
				searchClientNo : '',
				totalCntdRevList : '',
				
				chartDiv : '',
			},
			methods : {
				fn_searchDdRev : function(){
					vuearea.searchDate = getToday();
					//console.log("=========");
					//console.log(vuearea.searchDate);
					searchDdRev();
				}
			},
		}),
		
		hiddenarea = new Vue({
			el : "#hiddenarea",
			data : {
				currentPageddRevenue : '',
				action : '',
				currentDate : '',
	
			},
		}),
		console.log(dateArr);
		
	}//init-end
	

	/* 날짜포맷 yyyy-MM-dd 변환  */
    function getFormatDate(date){
        var year = date.getFullYear();
        var month = (1 + date.getMonth());
        month = month >= 10 ? month : '0' + month;
        var day = date.getDate();
        day = day >= 10 ? day : '0' + day;
        return year + '-' + month + '-' + day;
    }


	/* 버튼 이벤트 등록 - 조회  */
	function fButtonClickEvent(){
		$('a[name=btn]').click(function(e){
			e.preventDefault();
					
			var btnId = $(this).attr('id');
			
			switch(btnId){
			case 'btnSearch' :
				searchDdRev();  // 일별매출목록
				fnDdRevChart();  //일별매출/누적매출 차트
				//fnDdRevProdChart();  //일자별 품목별 매출 파이 차트
				break;
			}
		});
	}
	
	// 일별매출리스트 검색
	function searchDdRev(currentPage) {

		//var searchDate = vuearea.searchDate; //검색날짜
		//var searchDate = $('#searchDate').val(); //검색날짜
		//var searchClientNo = vuearea.searchClientNo;  //거래처 콤보박스 값
		//var searchClientNo = $("#searchClientNo").val();  //거래처 콤보박스 값

		currentPage = currentPage || 1;

		console.log("currentPage : " + currentPage);

		var param = {
				searchDate : vuearea.searchDate,
				searchClientNo : vuearea.searchClientNo,
				currentPage : currentPage,
				pageSize : vuearea.pageSize,
		}
		console.log("param : " + JSON.stringify(param));
		var resultCallback = function(data) {
			console.log("data : " + JSON.stringify(data));
			ddRevenueListResult(data,currentPage);
		}

		callAjax("/sales/vueDdRevenueList.do", "post", "json", true, param, resultCallback);
	}
	
	// 차트함수 (일별매출/한달간 누적매출)
	function fnDdRevChart() {
		
		var searchDate = vuearea.searchDate;
		console.log("차트함수 searchDate: " + searchDate);
		var strArr = searchDate.split('-');
		var oneMonthAgo_ = new Date(strArr[0], strArr[1]-1, strArr[2]);
		oneMonthAgo_ = new Date(oneMonthAgo_.setMonth(oneMonthAgo_.getMonth() - 1));	// 한달 전
		var oneMonthAgo = getFormatDate(oneMonthAgo_);
		//var searchClientNo = $('#searchClientNo').val();  //거래처 콤보박스 값
		var searchClientNo = vuearea.searchClientNo;
		console.log("ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ :" + searchClientNo);
		var param = {
				searchDate : vuearea.searchDate,  //검색 날짜
				oneMonthAgo:oneMonthAgo,  //한달전 날짜
				searchClientNo : vuearea.searchClientNo,
		}
		console.log("ddddd" + JSON.stringify(param));
		var resultCallback = function(data) {
			//$('#chartDiv').empty().append(data);
			console.log(" 차트함수 data: " + data);
			console.log(" 차트함수 data : " + JSON.stringify(data.ddRevChartModel));
			drawChart(data.ddRevChartModel);
			vuearea.chartDiv = data.ddRevChartModel;
			console.log(" 차트함수 vuearea.chartDiv: " + JSON.stringify(vuearea.chartDiv));
			
		}

		callAjax("/sales/vueDdRevChart.do", "post", "json", true, param, resultCallback);

	}

	
	//일별매출 리스트 불러오기
	function ddRevenueListResult(data, currentPage) {
		console.log("여기서부터 콘솔");
		console.log("data : " + JSON.stringify(data));
		
		//console.log(data.ddRevenueList);
		vuearea.grouplist = data.ddRevenueList;
		vuearea.grouplistcnt = data.totalCntddRevenue;

		/* console.log(data.totalCntddRevenue);
		console.log(vuearea.grouplist);
		console.log(vuearea.grouplistcnt); */
		// 기존 목록 삭제후 생성
		//$('#ddRevenueList').empty().append(data);

		// 총 개수 추출
		//var totalCntddRevenue = $("#totalCntddRevenue").val();

		console.log("totalCntddRevenue : " + data.totalCntddRevenue);
		
		vuearea.totalCntdRevList = data.totalCntddRevenue;
		console.log("vuearea.totalCntdRevList : " + vuearea.totalCntdRevList);
		document.getElementById("totalCntdRevList").innerHTML = data.totalCntddRevenue;
		
		// 페이지네이션 생성
		var paginationHtml = getPaginationHtml(currentPage, data.totalCntddRevenue, 
							vuearea.pageSize, vuearea.pageBlockSize, 'searchDdRev');
		
		vuearea.ddRevenuePagination = paginationHtml;
		//$("#ddRevenuePagination").empty().append(paginationHtml);

		// 현재 페이지 설정
		hiddenarea.currentPageddRevenue = currentPage;
	}
	

	
	function drawChart(chardata) {
			console.log("drawchart 시작!!!")
		   // 차트에 들어갈 데이터
		   console.log("drawchart object : " + chardata);
		   console.log("drawchart object : " + JSON.stringify(chardata));
		   //console.log(object.ddRevChartModel[0].contract_date);
			//console.log("여기여기여기 data 총 몇개? : "+Object.keys(chardata).length);
			console.log("=================================")
		   for (var j = 0; j < Object.keys(chardata).length; j++){
			var data = new google.visualization.DataTable(chardata);
/* 			data.addColumn('string','Date',chardata.ddRevChartModel[j].contract_date);
			//data.addColumn('string','Date',object.ddRevChartModel[j].contract_date);
			data.addColumn('number','매출',chardata.ddRevChartModel[j].sum_sales);
			data.addColumn('number','누적매출',chardata.ddRevChartModel[j].cumsum_sales); */
			data.addColumn('string','Date','chardata[j].contract_date');
			data.addColumn('number','매출','chardata[j].sum_sales');
			data.addColumn('number','누적매출','chardata[j].cumsum_sales');
		   }
		      // 데이터를 배열로 넣어준다
		      // data.addRows([ 
		      //    ['피자',5],
		      //    ['치킨',2],
		      //    ['햄버거',3]]);
		      
		      // substring(2) : 날짜 표시 2023-05-16 -> 23-05-16 
		      // parseInt해야함
			for(var i=0;i<dateArr.length;i++){
		      data.addRow([dateArr[i].substring(2),parseInt(salesArr[i]),parseInt(cumsalesArr[i])]);
			}

		   // 차트 타이틀과 크기, 옵션을 지정
			var options = {
					legend: {'position':'top','alignment':'center'},
		            height:400,
		            label:'top',
		            hAxis: {showTextEvery: 1,
		            	fontSize:'5',
		            	slantedText: true,
		            	slantedTextAngle:45}, 
		            vAxes: {0: {
		            	title:'단위:원'
		            }, 
		            1: {
		            	title:'단위:원'
		            }},
		            chartArea : {
						height: '70%',
						width : '60%'
					},
					animation : { //차트가 뿌려질때 실행될 애니메이션 효과
						startup : true,
						duration : 1000,
						easing : 'linear'
					},
					seriesType : 'bars',
					color:'blue',
					series : {1: {type:'line',
								  targetAxisIndex: 1,
								  color:'red'}}
		          };

		    var chart = new google.visualization.ComboChart(document.getElementById('chartDiv'));

		    chart.draw(data, options);
			}
	
	// 오늘 날짜
    function getToday(){
        var date = new Date();
        var year = date.getFullYear();
        var month = ("0" + (1 + date.getMonth())).slice(-2);
        var day = ("0" + date.getDate()).slice(-2);

        return year + "-" + month + "-" + day;
    }
		
	

</script>
</head>
<body>
<form id="myForm" action=""  method="">

<div id="hiddenarea">
	<input type="hidden" id="currentPageddRevenue" v-model="currentPageddRevenue">
	<input type="hidden" name="action" id="action" v-model="action">
	<input type="hidden" name="currentDate" id="currentDate" v-model="currentDate">
</div>
	
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
							<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a>
							<span class="btn_nav bold">매출</span> <span class="btn_nav bold">일별매출현황</span> 
							<a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
						</p>

						<!-- 일별매출현황 제목 -->
						<p class="conTitle">
							<span>일별매출현황</span> <span class="fr"></span>
						</p>
						
						<!-- 검색창 --> 
							
						 <td width="40" height="25" style="font-size: 100%">거래처명&nbsp;</td>
						 <td><select id="searchClientNo" name="searchClientNo" v-model="searchClientNo">	</select></td>          
			             <td width="30" height="25" style="font-size: 100%"></td>
						
					    <!-- 날짜(일 단위) 선택 -->
						<span class="fr" style="padding-right : 20px;">
							<p class="Location">
								<input type="date" id="searchDate_today" name = "searchDate" style="width : 250px;" v-model="searchDate">
								<a href="" class="btn_icon search" id="btnSearch" name="btn">
								<span>검  색</span></a>
							</p>
						</span>
						<!-- 검색창 끝 -->
						
						<!--차트 영역 -->
						<div class="divddRevenueSumList"> 
						  <table class="col" width="900" height="300">
						     <tr>
						  	 	<!--일별매출/한달간 누적매출 차트 영역 -->
						     	<td width="70%">
						     		<div id="chartDiv"></div>
						     	</td>
								<!--일자별 품목별 매출 파이 차트 영역 -->
						     	<td width="25%">
						     		<div id="PieChartDiv"></div>
						     	</td>
						     </tr>
<%-- 							 <tr>
								<td>합계 : </td>
								<td></td>
							 </tr> --%>
						   </table>
						</div>
						
						<!-- 일별매출조회 테이블 -->
						<div class="divddRevenueList">
							<span>총 <span id="totalCntdRevList" style="color:red;font-weight:bold" v-model="totalCntdRevList"></span>건</span>
							<table class="col">
								<caption>단위:원</caption>
								<colgroup>
									<col width="12.5%">
									<col width="12.5%">
									<col width="12.5%">
									<col width="12.5%">
									<col width="12.5%">
									<col width="12.5%">
									<col width="12.5%">
									<col width="12.5%">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">수주일자</th>
										<th scope="col">기업명</th>
										<th scope="col">상품명</th>
										<th scope="col">수량</th>
										<th scope="col">단가</th>
										<th scope="col">공급가액</th>
										<th scope="col">부가세</th>
										<th scope="col">합계</th>
									</tr>
								</thead>
								
								<template v-if="grouplistcnt == 0">
									<tbody>
				                    	<tr>
											<td colspan="8">데이터가 존재하지 않습니다.</td>
										</tr>
									</tbody>
								</template>
								
								<template v-else>
									<tbody id="ddRevenueList" v-for = "(list,index) in grouplist">
										<tr>
						                  <td>{{list.contract_date}}</td>
						                  <td>{{list.client_name}}</td>
						                  <td>{{list.product_name}}</td>
						                  <td>{{list.product_amt}}EA</td>
						                  <td>{{list.price}}원</td>
						                  <td>{{list.amt_price}}원</td>
						                  <td>{{list.tax}}원</td>
						                  <td>{{list.total_price}}원</td>
						                </tr>
									</tbody>
								</template>
							</table>
						</div>
	
						<!-- 페이지네이션 -->
						<div class="paging_area"  id="ddRevenuePagination" v-html="ddRevenuePagination"> </div>
							<table style="margin-top: 10px" width="100%" cellpadding="5"
								cellspacing="0" border="1" align="left"
								style="collapse; border: 1px #50bcdf;">
								<tr style="border: 0px; border-color: blue">
									<td width="80" height="25" style="font-size: 120%;">&nbsp;&nbsp;</td>
									<td width="50" height="25"
										style="font-size: 100%; text-align: left; padding-right: 25px;">
									</td>
								</tr>
							</table>
					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>
</form>
</body>
</html>