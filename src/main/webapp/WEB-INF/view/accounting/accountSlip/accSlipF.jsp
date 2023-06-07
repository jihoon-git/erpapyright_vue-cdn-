<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Job Korea</title>

<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<script src="https://unpkg.com/axios@0.12.0/dist/axios.min.js"></script>
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<!-- D3 -->
<style>
//
click-able rows
	.clickable-rows {tbody tr td { cursor:pointer;
	
}

.el-table__expanded-cell {
	cursor: default;
}
}
</style>
<script type="text/javascript">
        var pageSize = 5;
        var pageBlockSize = 5;

		/* onload 이벤트  */
		$(function() {
			
			$("#contractDetaile").hide();
			
			$("#expDetaile").hide();
			
			accSlipFListSearch(); 
			
			clientList();
			
	    });
		
		/* 회계전표 리스트 */
		
		function fn_accSlipFListList(cpage, client_no, account_cd, srcsdate, srcedate) {
			
			$("#contractDetaile").hide();
			
			$("#expDetaile").hide();
			
			//alert("리스트");
			
			var navi = [client_no,account_cd,srcsdate,srcedate];
			
			if($("#searchKey").val() == "search"){
				$("#client_no").val(client_no).prop("selected", true);
				$("#account_name").val(account_cd).prop("selected", true);
				$("#srcsdate").val(srcsdate);
				$("#srcedate").val(srcedate);
			}
			
			if($("#srcsdate").val() != "" && $("#srcedate").val() ==""){
				alert("종료일을 선택하세요."); 
			} else if($("#srcsdate").val() == "" && $("#srcedate").val() !="") {
				alert("시작일을 선택하세요.");
			} else if( $("#srcsdate").val() !="" && $("#srcedate").val() !="" && $("#srcsdate").val() > $("#srcedate").val()){
				alert("날짜를 확인해 주세요.");
			} else{
			
				cpage = cpage || 1;
					
				var param = {
						pageSize : pageSize,
						cpage : cpage,
						client_no : client_no,
						account_cd : account_cd,
						srcsdate : srcsdate,
						srcedate : srcedate
				}
				
				var listcallback = function(data){
					//console.log(data);
					
					$("#accSlipFList").empty().append(data);
					
					var totalCnt = $("#totalCnt").val();
					console.log("리스트 : "+navi);
					var paginationHtml = getPaginationHtml(cpage, totalCnt, pageSize, pageBlockSize, 'fn_accSlipFListList', navi);
					
					console.log(paginationHtml);
					
					$("#accSlipPagination").empty().append(paginationHtml);
				
				}
	
				callAjax("/accounting/accSlipFList.do", "post", "text", "false", param, listcallback);
			}
		}

		/* 회계전표 리스트 및 검색 */
		function accSlipFListSearch(cpage, client_no, account_cd, srcsdate, srcedate) {
			//alert("서치");
			
			$("#contractDetaile").hide();
			
			$("#expDetaile").hide();
			
			$("#searchKey").val("search");
			
			searchKey = searchKey || "";
			client_no = client_no || $("#client_no").val();
			account_cd = account_cd || $("#account_name").val();
			srcsdate = srcsdate || $("#srcsdate").val();
			srcedate = srcedate || $("#srcedate").val();
			var navi = [client_no,account_cd,srcsdate,srcedate];
			
			console.log("서치 안 searchKey:"+searchKey);
			 
			if($("#srcsdate").val() != "" && $("#srcedate").val() ==""){
				alert("종료일을 선택하세요."); 
			} else if($("#srcsdate").val() == "" && $("#srcedate").val() !="") {
				alert("시작일을 선택하세요.");
			} else if( $("#srcsdate").val() !="" && $("#srcedate").val() !="" && $("#srcsdate").val() > $("#srcedate").val()){
				alert("날짜를 확인해 주세요.");
			} else{
			
				cpage = cpage || 1;
					
				var param = {
						pageSize : pageSize,
						cpage : cpage,
						client_no : client_no,
						account_cd : account_cd,
						srcsdate : srcsdate,
						srcedate : srcedate 
				}
				
				var searchcallback = function(data){
					//console.log(data);
					
					$("#accSlipFList").empty().append(data);
					
					var totalCnt = $("#totalCnt").val();
					
					var paginationHtml = getPaginationHtml(cpage, totalCnt, pageSize, pageBlockSize, 'fn_accSlipFListList', navi);
						
					console.log(paginationHtml);
						
					$("#accSlipPagination").empty().append(paginationHtml);
					}
				
				callAjax("/accounting/accSlipFList.do", "post", "text", "false", param, searchcallback);
			} 
		}


		/* 회계전표 상세 조회 */
		function contractDetaile(order_cd) {
			
			  var param = {
					  req_no : order_cd,
			}
			
			var accSlipDetailecallback = function(data){
				
				console.log(data);
				  
				var leg = data.accSlipDetaile;
				
				var detaile = "";

				for (var i in leg){
					detaile += "<tr>"+
								"<td>"+leg[i].account_no+"</td>"+
								"<td>"+leg[i].contract_date+"</td>"+
								"<td>"+leg[i].order_cd+"</td>"+
								"<td>"+leg[i].conUserName+"</td>"+
								"<td>"+leg[i].client_name+"</td>"+
								"<td>"+leg[i].lcategory_name+"</td>"+
								"<td>"+leg[i].mproduct_name+"</td>"+
								"<td>"+leg[i].sproduct_name+"</td>"+
								"<td>"+leg[i].price+"</td>"+
								"<td>"+leg[i].total_amt+"EA</td>"+
								"<td>"+leg[i].total_price+"원</td>"+
								"</tr>";
				}
				
				$("#conDetaile").empty().append(detaile);
				
				$("#contractDetaile").show();
				$("#expDetaile").hide();
				
			}
			
			callAjax("/accounting/accSlipDetaile.do", "post", "JSON", "false", param, accSlipDetailecallback);
		}

		/* 지출번호 상세 조회 */
		function expDetaile(exp_no) {
			
			  var param = {
					  req_no : exp_no,
			}
			
			var accSlipDetailecallback = function(data){
				console.log(data);
				
			var leg = data.accSlipDetaile;
				
				var detaile = "";

				for (var i in leg){
					detaile += "<tr>"+
								"<td>"+leg[i].account_no+"</td>"+
								"<td>"+leg[i].expYn_date+"</td>"+
								"<td>"+leg[i].exp_no+"</td>"+
								"<td>"+leg[i].expUserName+"</td>"+
								"<td>"+leg[i].laccount_name+"</td>"+
								"<td>"+leg[i].account_name+"</td>"+
								"<td>"+leg[i].exp_det+"</td>"+
								"<td>"+leg[i].exp_spent+"원</td>"+
								"</tr>";
				}
				
				$("#exDetaile").empty().append(detaile);
				
				$("#contractDetaile").hide();
				$("#expDetaile").show();
			}
			
			callAjax("/accounting/accSlipDetaile.do", "post", "JSON", "false", param, accSlipDetailecallback);
		}
		
		/* SelectBox */
		function clientList() {
			
			clientSelectBox("", "client_no", "sel", "selvalue");
			
			detileAccount("","account_name", "sel", "selvalue");
			
		}
		
		/* function chang(){
			var client_no = JSON.stringify($("#client_no").val());
			console.log("client_no : "+$("#client_no").val());
			console.log("account_name : "+$("#account_name").val());
		} */
</script>

</head>
<body>
<form id="myForm" action=""  method="">
	<input type="hidden" id="searchKey" name="searchKey" value=""/>
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
								class="btn_nav bold">회계</span> <span class="btn_nav bold">회계전표
								조회</span> <a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
						</p> 

						<p class="conTitle">
							<span>회계전표 조회</span> <span class="fr" style="margin-top: 5px;"> 
							<input type="date" id="srcsdate" name="srcsdate" style="width: 145px;">~ 
							<input type="date" id="srcedate" name="srcedate" style="width: 145px;">
							</br>
							거래처명
							<select id="client_no" name="client_no" style="width: 100px; margin-right: 8px;" onchange="chang()">
							</select>
							계정과목
							<select id="account_name" name="account_name" style="width: 100px;" onchange="chang()">
							</select>
							<a	class="btnType blue" href="javascript:accSlipFListSearch();" name="modal"><span>조회</span></a>
							</span>
						</p>
						<div class="divComGrpCodList">
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="5%">
									<col width="8%">
									<col width="12%">
									<col width="10%">
									<col width="7%">
									<col width="10%">
									<col width="8%">
									<col width="30%">
									<col width="10%">
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">번호</th>
										<th scope="col">전표번호</th>
										<th scope="col">수주/지출일자</th>
										<th scope="col">수주/지출번호</th>
										<th scope="col">계정코드</th>
										<th scope="col">계정과목</th>
										<th scope="col">담당자</th>
										<th scope="col">거래처명</th>
										<th scope="col">수입/지출</th>
									</tr>
								</thead>
								<tbody id="accSlipFList"></tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="accSlipPagination"> </div>
						
						</br>
						</br>
                     
						<div id="contractDetaile">
						
							<p class="conTitle">
									<span>수주 상세 조회</span> <span class="fr" style="margin-top: 5px;"> 
									</span>
							</p>
						
							<div class="divComGrpCodList">
								<table class="col">
									<caption>caption</caption>
									<colgroup>
										<col width="5%">
										<col width="10%">
										<col width="5%">
										<col width="10%">
										<col width="10%">
										<col width="10%">
										<col width="10%">
										<col width="10%">
										<col width="10%">
										<col width="10%">
										<col width="10%">
									</colgroup>
		
									<thead>
										<tr>
											<th scope="col">전표번호</th>
											<th scope="col">수주일자</th>
											<th scope="col">수주번호</th>
											<th scope="col">담당자</th>
											<th scope="col">거래처명</th>
											<th scope="col">제품 대분류</th>
											<th scope="col">제품 중분류</th>
											<th scope="col">제품명</th>
											<th scope="col">단가</th>
											<th scope="col">수량</th>
											<th scope="col">총액</th>
										</tr>
									</thead>
									<tbody id="conDetaile"></tbody>
								</table>
							</div>
							
						</div>
					
						<div id="expDetaile">
						
							<p class="conTitle">
									<span>지출 상세 조회</span> <span class="fr" style="margin-top: 5px;"> 
									</span>
							</p>
						
							<div class="divComGrpCodList">
								<table class="col">
									<caption>caption</caption>
									<colgroup>
										<col width="6%">
										<col width="10%">
										<col width="6%">
										<col width="10%">
										<col width="10%">
										<col width="10%">
										<col width="28%">
										<col width="10%">
									</colgroup>
		
									<thead>
										<tr>
											<th scope="col">전표번호</th>
											<th scope="col">지출승인일자</th>
											<th scope="col">지출번호</th>
											<th scope="col">담당자</th>
											<th scope="col">계정 대분류</th>
											<th scope="col">계정과목</th>
											<th scope="col">지출내용</th>
											<th scope="col">지출비용</th>
										</tr>
									</thead>
									<tbody id="exDetaile"></tbody>
								</table>
							</div>
							
						</div>
					</div> <!--// content -->
					
					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>

	<!-- 모달팝업 -->
	<!--// 모달팝업 -->
	
	<!-- 모달팝업 -->
	<!--// 모달팝업 -->
</form>
</body>
</html>