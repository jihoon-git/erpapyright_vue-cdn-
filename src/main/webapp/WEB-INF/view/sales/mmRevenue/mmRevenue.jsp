<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>월별매출현황</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script src="https://www.gstatic.com/charts/loader.js"></script>
<!-- sweet swal import -->

<script type="text/javascript">
	$(function() {
		// 버튼 이벤트 등록 (조회)
		fButtonClickEvent();
		
		setDateBox();
		var dt = new Date();
		var year = dt.getFullYear();
		$('#selectyear').val(year);
		board_search();
		viewmmChart();
	});

	/* 버튼 이벤트 등록 - 조회  */
	function fButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();

			var btnId = $(this).attr('id');

			switch (btnId) {
			case 'btnSearch':
				setDateBox(); //년도 선택 후 검색했을때 결과가 뜸
				board_search();
				viewmmChart();
				break;
			}
		});
	}
	
	function setDateBox(){
		var dt = new Date();
		var year = dt.getFullYear();
		
		//$("#year").append("<option value=''>년도</option>");
		
		for(var y = (year); y >= (year-10); y--){
			$("#year").append("<option value='"+ y +"'>"+ y + " 년" +"</option>");
		}
		
		var selectyear = $("#year option:selected").val();
		//var selectyear = '${selectyear}';
		
		console.log("선택년도: "+ selectyear);
		//선택한 값 넣어주기.
		$("#selectyear").val(selectyear);
		console.log("넣은거 확인 : " + $('#selectyear').val());
		
	}
	
	
	// 검색 기능 구현 (테이블)
	
	function board_search() {

		var param = {
			selectyear : $("#selectyear").val(),
		}

		var callback = function(data) {
			console.log("callback : " + data);
			
			showTable(data);
		}
			
			
		callAjax("/sales/mmRevenuelist.do", "post", "text", true, param, callback);
		
	}
	
	// 검색 기능 구현 (차트)
	function viewmmChart(){
		
		var param = {
				selectyear : $("#selectyear").val(),
			}
		
		var callback = function(data) {
			console.log("callback : " + data);
			
			showChart(data);
		}
		
		callAjax("/sales/viewmmChart.do", "post", "text", true, param, callback);
	}

	
	//테이블
	function showTable(data) {
		
		console.log(data);

		//기존목록 삭제 후 생성
		$('#mmRevtable_main').empty().append(data);

	}

	//차트
	function showChart(data){
		
		console.log(data);

		//기존목록 삭제 후 생성
		$('#chart_div_main').empty().append(data);
	}
</script>

</head>
<body>
	<form id="myForm" action="" method="">
		<input type="hidden" name="action" id="action" value="">
		<input type="hidden" name="loginId" id="loginId" value="${loginId}">
		<input type="hidden" name="userNm" id="userNm" value="${userNm}">
		<input type="hidden" name="currentpage" id="currentpage" value="">
 		<input type="hidden" name="selectyear" id="selectyear" value="">
		
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
								<span class="btn_nav bold">매출</span> <span class="btn_nav bold">월별매출현황</span> 
								<a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
							</p>

							<p class="conTitle">
								<span>월별매출현황</span>
							</p>

							<!-- 검색창 시작 -->
							<span>기 간 </span>
							<select id="year" name="year" style="width: 150px;">
							</select>

							<!-- 날짜선택 -->
							<input type="text" style="width: 150px; height: 25px;" value="1월" readonly/> 
							~ 
							<input type="text" style="width: 150px; height: 25px;" value="12월" readonly/> 
							<a href="" class="btnType blue" id="btnSearch" name="btn"> 
							<span>검색</span></a>
							<!-- 검색창 끝 -->

							<!-- 월별 매출통게 차트영역 -->
							<div id="chart_div_main"></div>
							
							<!-- 월별매출조회 테이블 -->
							<br><br>
							<div class="divmmRevList">			
								<table id="mmRevtable_main" class="col">
								</table>
							</div>

						</div> <!--// content -->

						<h3 class="hidden">풋터 영역</h3> <jsp:include
							page="/WEB-INF/view/common/footer.jsp"></jsp:include>
					</li>
				</ul>
			</div>
		</div>



	</form>
</body>
</html>