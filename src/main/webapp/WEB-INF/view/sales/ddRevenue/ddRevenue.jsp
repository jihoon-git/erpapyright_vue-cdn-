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
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">

	// 일별매출 페이징 설정
	var pageSize = 5;
	var pageBlock = 5;

	$(function(){
		//거래처 콤보박스
		clientSelectBox("client_no", "searchClientNo", "all", "");
		// 버튼 이벤트 등록 (조회)
		fButtonClickEvent();

		// page onload시 오늘 날짜의 검색 결과 보여주기
		document.getElementById('searchDate').valueAsDate = new Date();
		searchDdRev();
		fnDdRevChart();
		fnDdRevProdChart();
		
	});
	

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
				fnDdRevProdChart();  //일자별 품목별 매출 파이 차트
				break;
			}
		});
	}
	
	// 일별매출리스트 검색
	function searchDdRev(currentPage) {

		var searchDate = $('#searchDate').val();		//검색날짜
		var searchClientNo = $("#searchClientNo").val();  //거래처 콤보박스 값

		currentPage = currentPage || 1;

		console.log("currentPage : " + currentPage);

		var param = {
				searchDate : searchDate,
				currentPage : currentPage,
				pageSize : pageSize,
				searchClientNo : $("#searchClientNo").val()
		}

		var resultCallback = function(data) {
			console.log(data);
			ddRevenueListResult(data,currentPage);
		}
		

		callAjax("/sales/ddRevenueList.do", "post", "text", true, param, resultCallback);

	}

	// 차트함수 (일별매출/한달간 누적매출)
	function fnDdRevChart() {
		var searchDate = $('#searchDate').val();
		var strArr = searchDate.split('-');
		var oneMonthAgo_ = new Date(strArr[0], strArr[1]-1, strArr[2]);
		oneMonthAgo_ = new Date(oneMonthAgo_.setMonth(oneMonthAgo_.getMonth() - 1));	// 한달 전
		var oneMonthAgo = getFormatDate(oneMonthAgo_);
		var searchClientNo = $('#searchClientNo').val();  //거래처 콤보박스 값

		var param = {
				searchDate : searchDate,  //검색 날짜
				oneMonthAgo:oneMonthAgo,  //한달전 날짜
				searchClientNo : $('#searchClientNo').val()
		}
		
		var resultCallback = function(data) {
			$('#chartDiv').empty().append(data);
		}

		callAjax("/sales/ddRevChart.do", "post", "text", true, param, resultCallback);

	}

	// 파이 차트함수 (일자별 품목별 매출)
	function fnDdRevProdChart() {
		var searchDate = $('#searchDate').val();
		var searchClientNo = $('#searchClientNo').val();  //거래처 콤보박스 값

		var param = {
				searchDate : searchDate,  //검색 날짜
				searchClientNo : $('#searchClientNo').val()
		}
		
		var resultCallback = function(data) {
			$('#PieChartDiv').empty().append(data);
		}

		callAjax("/sales/ddRevProductChart.do", "post", "text", true, param, resultCallback);

	}
	
	function ddRevenueListResult(data, currentPage) {
		console.log(data);

		// 기존 목록 삭제후 생성
		$('#ddRevenueList').empty().append(data);

		// 총 개수 추출
		var totalCntddRevenue = $("#totalCntddRevenue").val();

		console.log("totalCntddRevenue : " + totalCntddRevenue);
		
		document.getElementById("totalCntdRevList").innerHTML=totalCntddRevenue;
		
		// 페이지네이션 생성
		var paginationHtml = getPaginationHtml(currentPage, totalCntddRevenue, pageSize, pageBlock, 'searchDdRev');
		console.log("paginationHtml : " + paginationHtml);
		$("#ddRevenuePagination").empty().append(paginationHtml);

		// 현재 페이지 설정
		$("#currentPageddRevenue").val(currentPage);
	}
	
</script>
</head>
<body>
<form id="myForm" action=""  method="">
	<input type="hidden" id="currentPageddRevenue" value="1">
	<input type="hidden" name="action" id="action" value="">
	<input type="hidden" name="currentDate" id="currentDate" value="">
	
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
						 <td><select id="searchClientNo" name="searchClientNo">	</select></td>          
			             <td width="30" height="25" style="font-size: 100%"></td>
						
					    <!-- 날짜(일 단위) 선택 -->
						<span class="fr" style="padding-right : 20px;">
							<p class="Location">
								<input type="date" id="searchDate" name = "searchDate" style="width : 250px;">
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
							<span>총 <span id="totalCntdRevList" style="color:red;font-weight:bold"></span>건</span>
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
								<tbody id="ddRevenueList"></tbody>
							</table>
						</div>
	
						<!-- 페이지네이션 -->
						<div class="paging_area"  id="ddRevenuePagination"> </div>
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