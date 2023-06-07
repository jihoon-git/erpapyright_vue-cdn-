<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" /> 
<title>영업 실적 조회</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<script type="text/javascript">
	// 그룹코드 페이징 설정
	var pageSize = 5; //한페이지에 몇개 볼것인가
	var pageBlockSize = 5;

	/** OnLoad event */
	$(function() {

		allBmSalePlanList();

		fRegisterButtonClickEvent();
		$("#testchoice").show();
		$("#mcategory").hide();
		$("#prodchoice").show();
		$("#productname").hide();

		comcombo("lcategory_cd", "lcategory", "sel", "selvalue");
		midProductList("", "mcategory", "sel", "selvalue");
		productList("", "", "productname", "sel", "selvalue")
		

	});

	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault(); //이후의 예약 이벤트를 모두 소멸시킴

			var btnId = $(this).attr('id'); //해당 버튼의 아이디를 꺼내라
			switch (btnId) {
			case 'listsearch':
				var numbercheck = /[0-9]/g;
				var numberboolean = numbercheck.test($("#empname").val())
				
				if(numberboolean){
					alert("이름 검색엔 숫자가 들어가지 않습니다.");
					break;
				}
				
				if($("#searchdate").val() > getToday()){
					alert("조회날짜가 오늘 날짜 이후가 될 순 없습니다.")
					break;
				}
				$("#scempname").val($("#empname").val())
				$("#scsearchdate").val($("#searchdate").val())
				$("#sclcategory").val($("#lcategory").val())
				$("#scmcategory").val($("#mcategory").val())
				$("#scproductname").val($("#productname").val())
				allBmSalePlanList()
				break;
			case 'btnSave':
				fn_save();
				break;
			case 'btnClose':
			case 'btnClosefile':
				gfCloseModal();
				break;
			}
		});
	}
	
	/** 오늘 날짜 */
	function getToday() {
		var date = new Date();
		var year = date.getFullYear();
		var month = ("0" + (1 + date.getMonth())).slice(-2);
		var day = ("0" + date.getDate()).slice(-2);

		return year + "-" + month + "-" + day;
	}

	/** 영업실적 리스트 조회 */
	function allBmSalePlanList(cpage) { //cpage라는 파라미터 값을 받을 것
		console.log("userType : " + $("#userType").val())
		var userType = $("#userType").val();
		cpage = cpage || 1; //undefined 면 1로 셋팅
		//먼저 파라미터, callback 지정해줘야함
		if (userType == 'B' || userType == 'A') {
			var param = {
				empname : $("#scempname").val(),
				searchdate : $("#scsearchdate").val(),
				lcategory : $("#sclcategory").val(),
				mcategory : $("#scmcategory").val(),
				productname : $("#scproductname").val(),
				userType : userType,
				pageSize : pageSize,
				cpage : cpage, //페이지번호를 넘김
			}
		} else if (userType == 'D') {
			var param = {
				empname : $("#scempname").val(),
				searchdate : $("#scsearchdate").val(),
				lcategory : $("#sclcategory").val(),
				mcategory : $("sc#mcategory").val(),
				productname : $("#scproductname").val(),
				loginId : $("#loginId").val(),
				userType : userType,
				pageSize : pageSize,
				cpage : cpage, //페이지번호를 넘김
			}
		}//{}json 형태

		$("#searchcheck").val("")

		console.log(JSON.stringify(param))

		var listcallback = function(returndata) {
			console.log(returndata);
			$("#bmsaleplanlist").empty().append(returndata);

			console.log("totcnt: " + $("#countbmsaleplan").val());
			var countbmsaleplan = $("#countbmsaleplan").val();

			var paginationHtml = getPaginationHtml(cpage, countbmsaleplan,
					pageSize, pageBlockSize, 'allBmSalePlanList');
			console.log("paginationHtml" + paginationHtml);

			$("#bmSalePlanPagination").empty().append(paginationHtml);

			$("#currentpage").val(cpage);
		}
		/**
		 * ajax 공통 호출 함수
		 *
		 * @param
		 *   url : 서비스 호출URL
		 *   method : post, get
		 *   async : true, false		비동기식, sync는 응답을 기다림, async 사용시 false
		 *   param : data parameter
		 *   callback : callback function name
		 */

		callAjax("/business/bmsaleplanlist.do", "post", "text", "false", param,
				listcallback);

	}

	// 검색 조건의 대분류명이 바뀌면 제품이랑 중분류명 바뀌게
	function lcategorychange() {
		console.log($("#lcategory").val())
		console.log($("#mcategory").val());
		if ($("#lcategory").val() >= 1) {
			midProductList($("#lcategory").val(), "mcategory", "sel",
					"selvalue");
			productList($("#lcategory").val(), $("#mcategory").val(),
					"productname", "sel", "selvalue");
			$("#midchoice").hide();
			$("#mcategory").show();
			$("#prodchoice").show();
			$("#productname").hide();
			
		} else{
			$("#midchoice").show();
			$("#mcategory").hide();
			$("#prodchoice").show();
			$("#productname").hide();
		}
	}
	// 검색 조건의 중분류명이 바뀌면 제품명 바뀌게
	function mcategorychange() {
		console.log($("#mcategory").val());
		if ($("#mcategory").val() >= 1) {
		productList($("#lcategory").val(), $("#mcategory").val(),
				"productname", "sel", "selvalue");
		$("#prodchoice").hide();
		$("#productname").show();
		} else {
			$("#prodchoice").show();
			$("#productname").hide();
		}
	}
</script>

</head>
<body>
	<form id="myForm" action="" method="">
		<input type="hidden" name="action" id="action" value=""> <input
			type="hidden" name="loginId" id="loginId" value="${loginId}">
		<input type="hidden" name="userNm" id="userNm" value="${userNm}">
		<input type="hidden" name="userType" id="userType" value="${userType}">
		<input type="hidden" name="currentpage" id="currentpage" value="">
		<input type="hidden" name="scempname" id="scempname" value="">
		<input type="hidden" name="scsearchdate" id="scsearchdate" value="">
		<input type="hidden" name="sclcategory" id="sclcategory" value="">
		<input type="hidden" name="scmcategory" id="scmcategory" value="">
		<input type="hidden" name="scproductname" id="scproductname" value="">

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
								<span class="btn_nav bold">영업</span> <span class="btn_nav bold">영업
									실적 조회</span> <a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
							</p>

							<p class="conTitle">
								<span>영업 실적 조회</span> <span class="fr"> <c:if
										test="${userType eq 'B' || userType eq 'A'}">
								 	사원명 <input type="text" name="empname" id="empname"
											style="width: 80px" />
									</c:if>
									 조회날짜 <input type="date" name="searchdate" id="searchdate" />
									제품 대분류 품목별 <select name='lcategory' id='lcategory' style="width: 70px" onchange="lcategorychange()"></select>
									제품 중분류 품목별 <select id="midchoice"  style="width: 70px">
												<option>선택</option>
											  </select>
								 			  <select name='mcategory' id='mcategory' style="width: 70px" onchange="mcategorychange()"></select>
								          제품이름 <select id="prodchoice"  style="width: 70px">
											<option>선택</option>
									     </select>
									     <select name='productname' id='productname' style="width: 70px"></select>
									<a class="btnType blue" href="" id="listsearch" name="btn"><span>조회</span></a>
								</span>

							</p>


							<div class="divComGrpCodList">
								<table class="col">
									<caption>caption</caption>
									<c:if test="${userType eq 'B' || userType eq 'A'}">
										<colgroup>
											<col width="8%">
											<col width="9%">
											<col width="9%">
											<col width="9%">
											<col width="13%">
											<col width="18%">
											<col width="9%">
											<col width="9%">
											<col width="9%">
											<col width="7%">
										</colgroup>
										<thead>
											<tr>
												<th scope="col">사번</th>
												<th scope="col">이름</th>
												<th scope="col">거래처</th>
												<th scope="col">날짜</th>
												<th scope="col">제품코드</th>
												<th scope="col">제품이름</th>
												<th scope="col">목표수랑</th>
												<th scope="col">실적수량</th>
												<th scope="col">달성율</th>
												<th scope="col">비고</th>
											</tr>
										</thead>
									</c:if>
									<c:if test="${userType eq 'D' }">
										<colgroup>
											<col width="12%">
											<col width="12%">
											<col width="12%">
											<col width="16%">
											<col width="12%">
											<col width="12%">
											<col width="12%">
											<col width="12%">
										</colgroup>
										<thead>
											<tr>
												<th scope="col">날짜</th>
												<th scope="col">거래처</th>
												<th scope="col">제품코드</th>
												<th scope="col">제품이름</th>
												<th scope="col">목표수랑</th>
												<th scope="col">실적수량</th>
												<th scope="col">달성율</th>
												<th scope="col">비고</th>
											</tr>
										</thead>
									</c:if>
									<tbody id="bmsaleplanlist"></tbody>
								</table>
							</div>

							<div class="paging_area" id="bmSalePlanPagination"></div>

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