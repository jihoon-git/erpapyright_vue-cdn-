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

	var dateArr;
	var salesArr;
	var sproArr;
	var sproRateArr;
	
	var mm_rev_area;


	$(function() {

	    init();
	    
		// 버튼 이벤트 등록 (조회)
		fButtonClickEvent();
		
		setDateBox();
		var dt = new Date();
		var year = dt.getFullYear();
		//$('#selectyear').val(year);
		
		mm_rev_area.selectyear = year;
		board_search();
		viewmmChart();
	});


	function init(){
        mm_rev_area = new Vue({
            el : "#wrap_area",
            data : {
            	selectyear : "",
            	mmRevenuelist1 : [],
            	mmRevenuelist2 : [],
            	mmRevenuelist : [],
            	dateArr : [],
            	salesArr : [],
            	sproArr : [],
            	sproRateArr : [],
            	grouplist : [],
            	grouplist1 : [],
            },
            methods : {

            },
        });
        
        

    }




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
		//$("#selectyear").val(selectyear);
		mm_rev_area.selectyear = selectyear;
		//console.log("넣은거 확인 : " + mm_rev_area.selectyear);
		
	}
	
	
	// 검색 기능 구현 (테이블)
	
	function board_search() {
		console.log("boardsearch");
		var param = {
			//selectyear : $("#selectyear").val(),
				selectyear : mm_rev_area.selectyear,
		}

		var callback = function(data) {
			console.log("callback : " + JSON.stringify(data));
			showTable(data);
			
			
		}
			
			
		callAjax("/sales/mmRevenuelistvue.do", "post", "json", true, param, callback);
		
	}
	
	// 검색 기능 구현 (차트)
	function viewmmChart(){
		console.log("viewmmchart");
		var param = {
				//selectyear : $("#selectyear").val(),
				selectyear : mm_rev_area.selectyear,
			}
		
		var callback = function(data) {
			
			console.log("callback1 : " + JSON.stringify(data));
			
			
			showChart(data);
		}
		
		callAjax("/sales/viewmmChartvue.do", "post", "json", true, param, callback);
	}

	
	//테이블
	function showTable(data) {
		console.log("showtable");
		console.log(JSON.stringify(data));

		//기존목록 삭제 후 생성
		//$('#mmRevtable_main').empty().append(data);
		//mm_rev_area.grouplist = data;
		mm_rev_area.mmRevenuelist1 = data.mmRevenuelist1;
		
		

	}

	//차트
	function showChart(data){
		console.log("showchart");
		console.log("callbackshowchart : " + JSON.stringify(data));

		//기존목록 삭제 후 생성
		//$('#chart_div_main').empty().append(data);
		mm_rev_area.mmRevenuelist = data.mmRevenuelist;
		
	}
	
 	google.charts.load('current', {packages:['corechart']});
	google.charts.setOnLoadCallback(drawChart);
	
	  
  	//구글차트
 	function drawChart() {
	  	var dateArr = new Array();  //날짜
		var salesArr = new Array();  //매출
		var sproArr = new Array();  //영업이익
		var sproRateArr = new Array();  //영업이익률
	
		for(list in mm_rev_area.mmRevenuelist){
			dateArr.push("${list.ym_date}");  //날짜
			salesArr.push("${list.outgo}");  //매출
			sproArr.push("${list.sales_profit}");  //영업이익
			sproRateArr.push("${list.profit_rate}");  //영업이익률
		}
  
	  console.log("dateArr: "+ dateArr);
	  console.log("salesArr: "+salesArr);
	  console.log("sproArr: "+sproArr);
	  console.log("sproRateArr: "+sproRateArr);
	  console.log("drawchart");
	  
	  var data = new google.visualization.DataTable();
	  data.addColumn('string','Month');
	  data.addColumn('number','매출');
	  data.addColumn('number','영업이익');
	  data.addColumn('number','영업이익률');
	  console.log("data: "+ JSON.stringify(data));
		for(var i=0; i<dateArr.length; i++){
			data.addRow([dateArr[i],parseInt(salesArr[i]),parseInt(sproArr[i]),parseFloat(sproRateArr[i])]);
		}
	
		var options = {
			animation : { //차트가 뿌려질때 실행될 애니메이션 효과
				startup : true,
				duration : 1000,
				easing : 'linear'
			},
			seriesType : 'bars',
			series : {2: {type:'line',
						  targetAxisIndex: 1},			
		   },
		   vAxes: {0: {
	          	title:'단위:원'
	          }, 	
	          }
		}
	
		 var chart = new google.visualization.ComboChart(document.getElementById('chart_div'));
		 
		 chart.draw(data, options);
  	}

	
</script>

</head>
<body>
	<form id="myForm" action="" method="">
		<input type="hidden" name="action" id="action" :value="" >
		<input type="hidden" name="loginId" id="loginId" :value="loginId">
		<input type="hidden" name="userNm" id="userNm" :value="userNm">
		<input type="hidden" name="currentpage" id="currentpage" :value="">
 		<input type="hidden" name="selectyear" id="selectyear" :value="">
		
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
							<select id="year" name="year" style="width: 150px;" v-model="year">
							</select>

							<!-- 날짜선택 -->
							<input type="text" style="width: 150px; height: 25px;" value="1월" readonly/> 
							~ 
							<input type="text" style="width: 150px; height: 25px;" value="12월" readonly/> 
							<a href="" class="btnType blue" id="btnSearch" name="btn"> 
							<span>검색</span></a>
							<!-- 검색창 끝 -->

							<!-- 월별 매출통게 차트영역 -->
							<div id="chart_div_main">

							<!-- 월별 손익통계 차트 -->
							<template v-if="mmRevenuelist != ''">
								<!-- <template v-for="(list, item) in mmRevenuelist"> -->
								<script>
									/* var dateArr = new Array();  //날짜
									var salesArr = new Array();  //매출
									var sproArr = new Array();  //영업이익
									var sproRateArr = new Array();  //영업이익률
									
									for(list in mmRevenuelist){
										console.log("listlist");
										dateArr.push("${list.ym_date}");  //날짜
										salesArr.push("${list.outgo}");  //매출
										sproArr.push("${list.sales_profit}");  //영업이익
										sproRateArr.push("${list.profit_rate}");  //영업이익률
									} */
								</script>	
								<!-- </template> -->
								
								<script type="text/javascript">
								  
								  
								  
								</script>

                            	<div id="chart_div"></div>

                            </template>


					<%-- 	<c:if test="${not empty mmRevenuelist}">

                            <!-- 월별 손익통계 차트 -->
                            <script type="text/javascript">
                            	var dateArr = new Array();  //날짜
                            	var salesArr = new Array();  //매출
                            	var sproArr = new Array();  //영업이익
                            	var sproRateArr = new Array();  //영업이익률
                            </script>

                            <c:forEach items="${mmRevenuelist}" var="list">
                            	<script>
                            	dateArr.push("${list.ym_date}");  //날짜
                            	salesArr.push("${list.outgo}");  //매출
                            	sproArr.push("${list.sales_profit}");  //영업이익
                            	sproRateArr.push("${list.profit_rate}");  //영업이익률
                            	</script>
                            </c:forEach>

                            <script type="text/javascript">
                              google.charts.load('current', {packages:['corechart']});
                              google.charts.setOnLoadCallback(drawChart);

                              //구글차트
                              function drawChart() {
                            	  var data = new google.visualization.DataTable();
                            	  data.addColumn('string','Month');
                            	  data.addColumn('number','매출');
                            	  data.addColumn('number','영업이익');
                            	  data.addColumn('number','영업이익률');

                            		for(var i=0;i<dateArr.length;i++){
                            			data.addRow([dateArr[i],parseInt(salesArr[i]),parseInt(sproArr[i]),parseFloat(sproRateArr[i])]);
                            		}

                            		var options = {
                            			animation : { //차트가 뿌려질때 실행될 애니메이션 효과
                            				startup : true,
                            				duration : 1000,
                            				easing : 'linear'
                            			},
                            			seriesType : 'bars',
                            			series : {2: {type:'line',
                            						  targetAxisIndex: 1},
                            		   },
                            		   vAxes: {0: {
                                       	title:'단위:원'
                                       },
                                       }
                            		}

                            		 var chart = new google.visualization.ComboChart(document.getElementById('chart_div'));

                            		 chart.draw(data, options);
                              }


                            </script>

                            <div id="chart_div"></div>

                            </c:if>  --%>


							</div>
							
							<!-- 월별매출조회 테이블 -->
							<br><br>
							<div class="divmmRevList">			
								<table id="mmRevtable_main" class="col">						
									<template v-if="mmRevenuelist1==''&& mmRevenuelist2==''">
									<colgroup>
										<col width="10%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
									</colgroup>
									
									<thead>
										<tr>
											<th colspan="7" scope="col"></th>
										</tr>
									</thead>
									<tbody>
                                			<tr>
                                				<td colspan="7">데이터가 존재하지 않습니다.</td>
                                			</tr>
                                	</tbody>	
									</template> 
									
								<template v-if="mmRevenuelist1 != ''">
									
									<colgroup>
										<col width="10%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
									</colgroup>
                                    <thead>
                                        <tr>
                                            <th scope="col"></th>
                                            <th scope="col" v-for="(list, item) in mmRevenuelist1">{{list.ym_date}}</th>
                                        </tr>
                                    </thead>

									<tbody >
										<tr>
											<td scope="row">주문건수</td>
											<td v-for="(list, item) in mmRevenuelist1">{{list.order_amt}}(건)</td>
										</tr>
										<tr>
											<td scope="row">매출</td>
											<td v-for="(list, item) in mmRevenuelist1">{{list.outgo}}</td>
										</tr>
										<tr>
											<td scope="row">영업비</td>
											<td v-for="(list, item) in mmRevenuelist1">{{list.sales_exp}}</td>
										</tr>
										<tr>
											<td scope="row">영업이익</td>
											<td v-for="(list, item) in mmRevenuelist1">{{list.sales_profit}}</td>
										</tr>
										<tr>
											<td scope="row">영업이익률</td>
											<td v-for="(list, item) in mmRevenuelist1">{{ list.profit_rate}}</td>
										</tr>

                                	</tbody>		
									</template>

                                <!-- 월별 손익 통계 테이블 하반기 -->

                                <%-- 	<c:if test="${empty mmRevenuelist2}">
                                		<colgroup>
                                			<col width="10%">
                                			<col width="12%">
                                			<col width="12%">
                                			<col width="12%">
                                			<col width="12%">
                                			<col width="12%">
                                			<col width="12%">
                                		</colgroup>

                                		<thead>
                                			<tr>
                                				<th colspan="7" scope="col"></th>
                                			</tr>
                                		</thead>
                                		<tbody>

                                			<tr>
                                				<td colspan="7">데이터가 존재하지 않습니다.</td>
                                			</tr>
                                		</tbody>
                                	</c:if> --%>

                               

									<template v-if="mmRevenuelist2 != ''">
									
									<colgroup>
										<col width="10%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
									</colgroup>

                               		 <thead>
                                        <tr>
                                            <th scope="col"></th>
                                            <th scope="col" v-for="(list, item) in mmRevenuelist2">{{list.ym_date}}</th>
                                        </tr>
                                    </thead>

									<tbody >
										<tr>
											<td scope="row">주문건수</td>
											<td v-for="(list, item) in mmRevenuelist2">{{list.order_amt}}(건)</td>
										</tr>
										<tr>
											<td scope="row">매출</td>
											<td v-for="(list, item) in mmRevenuelist2">{{list.outgo}}</td>
										</tr>
										<tr>
											<td scope="row">영업비</td>
											<td v-for="(list, item) in mmRevenuelist2">{{list.sales_exp}}</td>
										</tr>
										<tr>
											<td scope="row">영업이익</td>
											<td v-for="(list, item) in mmRevenuelist2">{{list.sales_profit}}</td>
										</tr>
										<tr>
											<td scope="row">영업이익률</td>
											<td v-for="(list, item) in mmRevenuelist2">{{ list.profit_rate}}</td>
										</tr>

                                	</tbody>		
									</template>
		
						<%-- 	<c:if test="${empty mmRevenuelist1 and empty mmRevenuelist2}">
                                		<colgroup>
                                			<col width="10%">
                                			<col width="12%">
                                			<col width="12%">
                                			<col width="12%">
                                			<col width="12%">
                                			<col width="12%">
                                			<col width="12%">
                                		</colgroup>

                                		<thead>
                                			<tr>
                                				<th colspan="7" scope="col"></th>
                                			</tr>
                                		</thead>
                                		<tbody>

                                			<tr>
                                				<td colspan="7">데이터가 존재하지 않습니다.</td>
                                			</tr>
                                		</tbody>
                                	</c:if>

                                	<c:if test="${not empty mmRevenuelist1}">

                                		<colgroup>
                                			<col width="10%">
                                			<col width="12%">
                                			<col width="12%">
                                			<col width="12%">
                                			<col width="12%">
                                			<col width="12%">
                                			<col width="12%">
                                		</colgroup>


                                		<thead>
                                			<tr>
                                				<th scope="col"></th>
                                				<c:forEach items="${mmRevenuelist1}" var="list">
                                					<th scope="col">${list.ym_date}</th>
                                				</c:forEach>
                                			</tr>
                                		</thead>
                                		<tbody>
                                			<tr>
                                			<th scope="row">주문건수</th>
                                				<c:forEach items="${mmRevenuelist1}" var="list">
                                					<td scope="col">${list.order_amt} (건)</td>
                                				</c:forEach>
                                			</tr>

                                			<tr>
                                			<th scope="row">매출</th>
                                				<c:forEach items="${mmRevenuelist1}" var="list">
                                					<td scope="col"><fmt:formatNumber value="${list.outgo}" pattern="#,###"/></td>
                                				</c:forEach>
                                			</tr>

                                			<tr>
                                			<th scope="row">영업비</th>
                                				<c:forEach items="${mmRevenuelist1}" var="list">
                                					<td scope="col"><fmt:formatNumber value="${list.sales_exp}" pattern="#,###"/></td>
                                				</c:forEach>
                                			</tr>

                                			<tr>
                                			<th scope="row">영업이익</th>
                                				<c:forEach items="${mmRevenuelist1}" var="list">
                                					<td scope="col"><fmt:formatNumber value="${list.sales_profit}" pattern="#,###"/></td>
                                				</c:forEach>
                                			</tr>

                                			<tr>
                                			<th scope="row">영업이익률</th>
                                				<c:forEach items="${mmRevenuelist1}" var="list">
                                					<td scope="col">${list.profit_rate}</td>
                                				</c:forEach>
                                			</tr>

                                		</tbody>
                                	</c:if> --%>

                                <!-- 월별 손익 통계 테이블 하반기 -->

                                <%-- 	<c:if test="${empty mmRevenuelist2}">
                                		<colgroup>
                                			<col width="10%">
                                			<col width="12%">
                                			<col width="12%">
                                			<col width="12%">
                                			<col width="12%">
                                			<col width="12%">
                                			<col width="12%">
                                		</colgroup>

                                		<thead>
                                			<tr>
                                				<th colspan="7" scope="col"></th>
                                			</tr>
                                		</thead>
                                		<tbody>

                                			<tr>
                                				<td colspan="7">데이터가 존재하지 않습니다.</td>
                                			</tr>
                                		</tbody>
                                	</c:if> --%>

                                <%--	<c:if test="${not empty mmRevenuelist2}">

                                		<colgroup>
                                			<col width="10%">
                                			<col width="12%">
                                			<col width="12%">
                                			<col width="12%">
                                			<col width="12%">
                                			<col width="12%">
                                			<col width="12%">
                                		</colgroup>


                                		<thead>
                                			<tr>
                                				<th scope="col"></th>
                                				<c:forEach items="${mmRevenuelist2}" var="list">
                                					<th scope="col">${list.ym_date}</th>
                                				</c:forEach>
                                			</tr>
                                		</thead>
                                		<tbody>
                                			<tr>
                                			<th scope="row">주문건수</th>
                                				<c:forEach items="${mmRevenuelist2}" var="list">
                                					<td scope="col">${list.order_amt}</td>
                                				</c:forEach>
                                			</tr>

                                			<tr>
                                			<th scope="row">매출</th>
                                				<c:forEach items="${mmRevenuelist2}" var="list">
                                					<td scope="col">${list.outgo}</td>
                                				</c:forEach>
                                			</tr>

                                			<tr>
                                			<th scope="row">영업비</th>
                                				<c:forEach items="${mmRevenuelist2}" var="list">
                                					<td scope="col">${list.sales_exp}</td>
                                				</c:forEach>
                                			</tr>

                                			<tr>
                                			<th scope="row">영업이익</th>
                                				<c:forEach items="${mmRevenuelist2}" var="list">
                                					<td scope="col">${list.sales_profit}</td>
                                				</c:forEach>
                                			</tr>

                                			<tr>
                                			<th scope="row">영업이익률</th>
                                				<c:forEach items="${mmRevenuelist2}" var="list">
                                					<td scope="col">${list.profit_rate}</td>
                                				</c:forEach>
                                			</tr>

                                		</tbody>
                                	</c:if> --%>


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