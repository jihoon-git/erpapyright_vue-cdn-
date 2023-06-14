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
	var vuearea;
	var hiddenarea;

	/** OnLoad event */
	$(function() {

		init();
		vuearea.fn_allBmSalePlanList();
		//allBmSalePlanList();

		fRegisterButtonClickEvent();
		//$("#testchoice").show();
		//$("#mcategory").hide();
		//$("#prodchoice").show();
		//$("#productname").hide();

		comcombo("lcategory_cd", "lcategory", "sel", "selvalue");
		midProductList("", "mcategory", "sel", "selvalue");
		productList("", "", "productname", "sel", "selvalue")
		

	});
	//init 등록
	function init(){
		//영업실적조회 등록
		vuearea = new Vue({
			el : "#wrap_area",
			data : {
				pageSize : 5,
				pageBlockSize : 5,
				empname : '',				
				searchdate : '',
				lcategory : '',
				mcategory : '',
				productname :'',							
				grouplist :[],
				countbmsaleplan : 0,
				bmSalePlanPagination : '',
				userType : '',
				lcategoryflag : true,
				midchoiceflag : true,
				mcategoryflag : false,
				prodchoiceflag : true,
				productnameflag : false,
			},
			methods : {
				fn_allBmSalePlanList : function(){
					allBmSalePlanList();
				}
			}
		}),
		//hidden 등록
		hiddenarea = new Vue({
			el : "#hiddenarea",
			data : {
				scempname : '',				
				scsearchdate : '',
				sclcategory : '',
				scmcategory : '',
				scproductname : '',
				userType : '',
				userNm : '',
				loginId : '',
				
			}
		})
		
	}

	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault(); //이후의 예약 이벤트를 모두 소멸시킴

			var btnId = $(this).attr('id'); //해당 버튼의 아이디를 꺼내라
			switch (btnId) {
			case 'listsearch':				
				var numbercheck = /[0-9]/g;
				var numberboolean = numbercheck.test(vuearea.empname)
				
				if(numberboolean){
					alert("이름 검색엔 숫자가 들어가지 않습니다.");
					break;
				}
				
				if(vuearea.searchdate > getToday()){
					alert("조회날짜가 오늘 날짜 이후가 될 순 없습니다.")
					break;
				}
				hiddenarea.scempname = vuearea.empname;
				hiddenarea.scsearchdate = vuearea.searchdate;
				hiddenarea.sclcategory = vuearea.lcategory;
				hiddenarea.scmcategory = vuearea.mcategory;
				hiddenarea.scproductname = vuearea.productname;				
				allBmSalePlanList();
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
		console.log("userType : " + hiddenarea.userType)
		var userType = hiddenarea.userType;
		cpage = cpage || 1; //undefined 면 1로 셋팅
		//먼저 파라미터, callback 지정해줘야함
		
		var param = {
				empname : hiddenarea.scempname,
				searchdate : hiddenarea.scsearchdate,
				lcategory : hiddenarea.sclcategory,
				mcategory : hiddenarea.scmcategory,
				productname : hiddenarea.scproductname,
				pageSize : pageSize,
				cpage : cpage, //페이지번호를 넘김
			}

		//$("#searchcheck").val("")

		console.log("ajax가기전" + JSON.stringify(param))

		var listcallback = function(returndata) {	
			console.log(JSON.stringify(returndata));
			vuearea.grouplist = returndata.bmsaleplanlist;
			vuearea.countbmsaleplan = returndata.countbmsaleplan;
			
			
			hiddenarea.userType = returndata.userType;
			hiddenarea.userNm = returndata.userNm;
			hiddenarea.loginId = returndata.loginId;
			vuearea.userType = hiddenarea.userType;
			
			/* console.log(returndata);
			$("#bmsaleplanlist").empty().append(returndata);

			console.log("totcnt: " + $("#countbmsaleplan").val());
			var countbmsaleplan = $("#countbmsaleplan").val();

			console.log("paginationHtml" + paginationHtml);

			$("#bmSalePlanPagination").empty().append(paginationHtml);

			$("#currentpage").val(cpage); */
		var paginationHtml = getPaginationHtml(cpage, returndata.countbmsaleplan,
				vuearea.pageSize, vuearea.pageBlockSize, 'allBmSalePlanList');
			vuearea.bmSalePlanPagination = paginationHtml;
			
		}		

		callAjax("/business/vueBmsaleplanlist.do", "post", "json", "false", param, listcallback);
	}
	
	// 검색 조건의 대분류명이 바뀌면 제품이랑 중분류명 바뀌게
	function lcategorychange() {
		console.log(vuearea.lcategory);
		//console.log($("#mcategory").val());
		
		if (vuearea.lcategory >= 1) {
			midProductList(vuearea.lcategory, "mcategory", "sel",
					"selvalue");
			productList(vuearea.lcategory, vuearea.mcategory,
					"productname", "sel", "selvalue");
			
			vuearea.midchoiceflag = false;
			vuearea.mcategoryflag = true;
			vuearea.prodchoiceflag = false;
			vuearea.productnameflag = true;
			//$("#midchoice").hide();
			//$("#mcategory").show();
			//$("#prodchoice").show();
			//$("#productname").hide();
			
		} else{
			vuearea.midchoiceflag = true;
			vuearea.mcategoryflag = false;
			vuearea.prodchoiceflag = true;
			vuearea.productnameflag = false;
			//$("#midchoice").show();
			//$("#mcategory").hide();
			//$("#prodchoice").show();
			//$("#productname").hide();
		}
	}
	
	// 검색 조건의 중분류명이 바뀌면 제품명 바뀌게
	function mcategorychange() {
		console.log(vuearea.mcategory);
		if (vuearea.mcategory >= 1) {
		productList(vuearea.lcategory, vuearea.mcategory,
				"productname", "sel", "selvalue");
		//$("#prodchoice").hide();
		//$("#productname").show();
		vuearea.prodchoiceflag = false;
		vuearea.productnameflag = true;
		} else {
			//$("#prodchoice").show();
			//$("#productname").hide();
			vuearea.prodchoiceflag = true;
			vuearea.productnameflag = false;
		}
	}
 
</script>

</head>
<body>
	<form id="myForm" action="" method="">
		<div id="hiddenarea">
			<input type="hidden" name="action" id="action" value="">
			<input type="hidden" name="loginId" id="loginId" v-model="loginId" >
			<input type="hidden" name="userNm" id="userNm" v-model="userNm">
			<input type="hidden" name="userType" id="userType" v-model="userType">
			<input type="hidden" name="currentpage" id="currentpage" value="">
			<input type="hidden" name="scempname" id="scempname" v-model="scempname" >
			<input type="hidden" name="scsearchdate" id="scsearchdate" v-model="scsearchdate">
			<input type="hidden" name="sclcategory" id="sclcategory" v-model="sclcategory">
			<input type="hidden" name="scmcategory" id="scmcategory" v-model="scmcategory">
			<input type="hidden" name="scproductname" id="scproductname"  v-model="scproductname">
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
								<span class="btn_nav bold">영업</span> <span class="btn_nav bold">영업
									실적 조회</span> <a href="../business/vueBmSalePlan.do" class="btn_set refresh">새로고침</a>
							</p>

							<p class="conTitle">
								<span>영업 실적 조회</span> <span class="fr">
								<template v-if="userType == 'B' || userType == 'A'"> 
								 	사원명 <input type="text" name="empname" id="empname" v-model="empname" style="width: 80px" />
								</template> 
									 조회날짜 <input type="date" name="searchdate" id="searchdate" v-model="searchdate" />
									제품 대분류 품목별 <select name='lcategory' id='lcategory' v-model='lcategory' v-show='lcategoryflag' style="width: 70px" @change="lcategorychange()"></select>
									 제품 중분류 품목별 <select id="midchoice"  style="width: 70px" v-show='midchoiceflag'>
												<option>선택</option>
											  </select>
								 			  <select name='mcategory' id='mcategory' v-model='mcategory' v-show='mcategoryflag' style="width: 70px" @change="mcategorychange()"></select>
								          제품이름 <select id="prodchoice"  style="width: 70px" v-show='prodchoiceflag'>
											<option>선택</option>
									     </select>
									     <select name='productname' id='productname' v-model='productname' v-show='productnameflag' style="width: 70px"></select>
									<a class="btnType blue" href="" id="listsearch" name="btn"><span>조회</span></a>
								</span>
							</p>  


							 <div class="divComGrpCodList">
								<table class="col">
									<caption>caption</caption>
									<template v-if="userType == 'B' || userType == 'A'">
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
									</template>
									<template v-if="userType == 'D'">
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
									</template>
 
 									<template v-if="userType == 'B' || userType == 'A'"> 
										<template v-if="countbmsaleplan == 0">										
											<tbody>
											<tr>
												<td colspan="10">데이터가 존재하지 않습니다.</td>
											</tr>
											</tbody>										
										</template>
																			
										<template v-else>										
											<tbody id="bmsaleplanlist" v-for = "(list,index) in grouplist">
												<tr>
													<td>{{list.emp_no}}</td>
													<td>{{list.name}}</td>
													<td>{{list.client_name}}</td>
													<td>{{list.plan_date}}</td>
													<td>{{list.product_no}}</td>
													<td>{{list.product_name}}</td>
													<td>{{list.goal_amt}}</td>
													<td>{{list.now_amt}}</td>
													<td>{{list.acvm_rate}}</td>
													<td></td>
												</tr>
											</tbody>										
										</template>
									</template> 
										
									<template v-if="userType == 'D'">
										<template v-if="countbmsaleplan == 0">
											<tbody>
												<tr>
													<td colspan=8>데이터가 존재하지 않습니다.</td>
												</tr>
											</tbody>
										</template>
										<template v-else>
											<tbody id="bmsaleplanlist" v-for = "(list,index) in grouplist">
												<tr>
													<td>{{list.plan_date}}</td>
													<td>{{list.client_name}}</td>
													<td>{{list.product_no}}</td>
													<td>{{list.product_name}}</td>
													<td>{{list.goal_amt}}</td>
													<td>{{list.now_amt}}</td>
													<td>{{list.acvm_rate}}</td>												
													<td></td>
												</tr>
											</tbody>
										</template>										
									</template>									
								</table>
							</div> 

							<div class="paging_area" id="bmSalePlanPagination" v-html="bmSalePlanPagination"></div>

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