<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>영업 계획</title>
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

		allEmpSaleList();

		fRegisterButtonClickEvent();		

		comcombo("lcategory_cd", "lcategory", "sel", "selvalue");
		midProductList("", "mcategory", "sel", "selvalue");
		productList("", "", "productname", "sel", "selvalue");
		clientSelectBox("", "clientname", "sel", "selvalue")

		comcombo("lcategory_cd", "newlcategory", "sel", "selvalue");
		midProductList("", "newmcategory", "sel", "selvalue");
		productList("", "", "newproduct", "sel", "selvalue");
		clientSelectBox("", "newclient", "sel", "selvalue")

	});

	
	
	function init(){
		vuearea = new Vue({
			el : "#wrap_area",
			data : {
				pageSize : 5,
				pageBlockSize : 5,
				
				grouplist :[],
				countempsaleplan : 0,
				empSalePlanPagination : '',
				
				clientname : '',
				stdate : '',
				eddate : '',
				lcategory : '',
				mcategory : '',
				prodchoice : '',
				productname : '',
				midchoice : '',
				
				midchoiceflag : true,
				mcategoryflag :false,
				productnameflag : false,
				prodchoiceflag : true,
			},
			methods : {
				fn_allEmpSaleList : function(){
					allEmpSaleList();
				}
			}
		}),
		
		hiddenarea = new Vue({
			el : "#hiddenarea",
			data : {
				scclientname : '',
				scstdate : '',
				sceddate : '',
				sclcategory : '',
				scmcategory : '',
				scproductname : '',
				
				loginId : '',
				userNm : '',
				userType : '',
				
			},
			methods : {
				
			}
		}),
		
		newplan = new Vue({
			el : "#newplan",
			data : {
				newclient : '',
				newlcategory : '',
				newmcategory : '',
				newproduct : '',
				newnumber : '',
				
			},
			methods : {
				
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
				if(vuearea.stdate != '' && vuearea.eddate != ''){
				if(vuearea.stdate > vuearea.eddate){
					alert("날짜 검색조건을 확인하세요");
					break;
				}
				}
			hiddenarea.scclientname = vuearea.clientname;
			hiddenarea.scstdate = vuearea.stdate;
			hiddenarea.sceddate = vuearea.eddate;
			hiddenarea.sclcategory = vuearea.lcategory;
			hiddenarea.scmcategory = vuearea.mcategory;
			hiddenarea.scproductname = vuearea.productname;
						
				allEmpSaleList()
				break;
			case 'btnSave':
				fn_save();
				break;
			case 'btnClose':
				gfCloseModal();
				break;
			}
		});
	}
	

	/** 영업실적 리스트 조회 */
	function allEmpSaleList(cpage) { //cpage라는 파라미터 값을 받을 것
		
		cpage = cpage || 1; //undefined 면 1로 셋팅
		
			var param = {
				clientname : hiddenarea.scclientname,
				stdate : hiddenarea.scstdate,
				eddate : hiddenarea.sceddate,
				lcategory : hiddenarea.sclcategory,
				mcategory : hiddenarea.scmcategory,
				productname : hiddenarea.scproductname,
				
				pageSize : pageSize,
				cpage : cpage, //페이지번호를 넘김
			}
		

		console.log("param: " + JSON.stringify(param))

		var listcallback = function(returndata) {
			console.log(returndata);
			//$("#empsaleplanlist").empty().append(returndata);
			vuearea.grouplist = returndata.vueEmpSalePlanlist;
			vuearea.countempsaleplan = returndata.countempsaleplan;
			
			hiddenarea.userType = returndata.userType;
			hiddenarea.userNm = returndata.userNm;
			hiddenarea.loginId = returndata.loginId;
			

			var paginationHtml = getPaginationHtml(cpage, returndata.countempsaleplan,
					vuearea.pageSize, vuearea.pageBlockSize, 'allEmpSaleList');
			
			vuearea.empSalePlanPagination = paginationHtml;

			
		}
		
		callAjax("/business/vueEmpSalePlanlist.do", "post", "json", "false", param, listcallback);

	}

	//검색 조건의 대분류명이 바뀌면 중분류명이랑 제품명 바뀌게
	function lcategorychange() {
		console.log(" vuearea.lcategory " + vuearea.lcategory)
		
		if(vuearea.lcategory >= 1 ){
			midProductList(vuearea.lcategory, "mcategory", "sel", "selvalue");
			productList(vuearea.lcategory, vuearea.mcategory, "productname", "sel", "selvalue");
			
			vuearea.midchoiceflag = false;
			vuearea.mcategoryflag = true;
			vuearea.prodchoiceflag = true;
			vuearea.productnameflag	= false;		
		} else {
			vuearea.midchoiceflag = true;
			vuearea.mcategoryflag = false;
			vuearea.prodchoiceflag = false;
			vuearea.productnameflag	= true;			
		}
		
	
	}
	
	//검색 조건의 중분류명이 바뀌면 제품명 바뀌게
	function mcategorychange() {
		console.log(vuearea.mcategory);
		if(vuearea.mcategory >= 1 ){
		productList(vuearea.lcategory, vuearea.mcategory, "productname", "sel", "selvalue");
		
		vuearea.prodchoiceflag = false;
		vuearea.productnameflag	= true;
		
		} else{
			vuearea.prodchoiceflag = true;
			vuearea.productnameflag	= false;			
		}
	}

	//검색 조건 초기화
	function resetsearch() {
				
		vuearea.clientname = '';
		vuearea.stdate = '';
		vuearea.eddate = '';
		vuearea.lcategory = '';
		vuearea.mcategory = '';		
		vuearea.productname = '';		
		
		//$("#clientname").val("")
		//$("#stdate").val("")
		//$("#eddate").val("")
		//$("#lcategory").val("")
		//$("#mcategory").val("")
		//$("#productname").val("")
	}

	//저장할 때
	function fn_newplan() {
		initpopup();
		gfModalPop("#newplan")

	}

	//초기값 세팅
	function initpopup() {
		newplan.newclient = '';
		newplan.newlcategory = '';
		newplan.newmcategory = '';
		newplan.newproduct = '';
		newplan.newnumber = '';
		//$("#newclient").val("")
		//$("#newlcategory").val("")
		//$("#newmcategory").val("")
		//$("#newproduct").val("")
		//$("#newnumber").val("")
	}

	//저장할 때 대분류명 바뀌면 중분류명이랑 제품명 바뀌게
	function newlcategorychange() {
		midProductList(newplan.newlcategory, "newmcategory", "sel", "selvalue");
		productList(newplan.newlcategory, newplan.newmcategory, "newproduct", "sel", "selvalue");
	}

	//저장할 때 중분류명 바뀌면 제품명 바뀌게
	function newmcategorychange() {
		productList(newplan.newlcategory, newplan.newmcategory, "newproduct", "sel", "selvalue");
	}

	//저장
	function fn_save() {
		if (!fValidate()) {
			return;
		}
		var params = {
			client : newplan.newclient,
			lcategory : newplan.newlcategory,
			mcategory : newplan.newmcategory,
			product : newplan.newproduct,
			amount : newplan.newnumber,
			loginID : hiddenarea.loginId,
			plandate : getToday(),
			goaldate : nextmonthToday(),
		}
		console.log(params)

		var savecallback = function(returndata) {
			console.log("returndata: " + JSON.stringify(returndata))

			if (returndata.RESULT === "SUCCESS") {
				gfCloseModal();
				allEmpSaleList();
			} else if(returndata.RESULT === "FAILE")
				alert("같은 기간, 같은 회사, 같은 제품은 하나만 등록됩니다.")

		}

		callAjax("/business/newempsaleplan.do", "post", "json", "false", params, savecallback);
	}

	/** 오늘 날짜 */
	function getToday() {
		var date = new Date();
		var year = date.getFullYear();
		var month = ("0" + (1 + date.getMonth())).slice(-2);
		var day = ("0" + date.getDate()).slice(-2);

		return year + "-" + month + "-" + day;
	}

	/** 오늘 날짜에서 한달만 더한 값 */
	function nextmonthToday() {
		var date = new Date();
		var year = date.getFullYear();
		var month = ("0" + (2 + date.getMonth())).slice(-2);
		if (month >= "13") {
			year = 1 + date.getFullYear();
			month = "01"
		}
		var day = ("0" + date.getDate()).slice(-2);

		return year + "-" + month + "-" + day;
	}

	/* 저장할 때 발리데이션 체크 */
	function fValidate() {

		var chk = checkNotEmpty([ [ "newclient", "거래처를 입력해주세요" ],
				[ "newlcategory", "대분류를 입력해주세요" ],
				[ "newmcategory", "중분류를 입력해주세요" ],
				[ "newproduct", "제품을 입력해주세요" ], [ "newnumber", "수량을 입력해주세요" ]

		]);

		if (!chk) {
			return;
		}

		return true;
	}
	
</script>

</head>
<body>
	<form id="myForm" action="" method="">
	<div id="hiddenarea">
		<input type="hidden" name="action" id="action" value="">
		<input type="hidden" name="loginId" id="loginId" v-model="loginId">
		<input type="hidden" name="userNm" id="userNm" v-model="userNm">
		<input type="hidden" name="userType" id="userType" v-model="userType">
		<input type="hidden" name="currentpage" id="currentpage" >
		<input type="hidden" name="scclientname" id="scclientname" v-model="scclientname">
		<input type="hidden" name="scstdate" id="scstdate" v-model="scstdate">
		<input type="hidden" name="sceddate" id="sceddate" v-model="sceddate">
		<input type="hidden" name="sclcategory" id="sclcategory" v-model="sclcategory">
		<input type="hidden" name="scmcategory" id="scmcategory" v-model="scmcategory">
		<input type="hidden" name="scproductname" id="scproductname" v-model="scproductname">
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
								<span class="btn_nav bold">영업</span> <span class="btn_nav bold">영업계획</span>
								<a href="../business/vueEmpSalePlan.do" class="btn_set refresh">새로고침</a>
							</p>

							<p class="conTitle">
								<span>영업계획</span>
								<span class="fr">
								<a class="btnType blue" href="javascript:fn_newplan()" name="modal">
								<span>계획등록</span></a>
								</span>
							</p>
							<div style="border: 2px solid skyblue">
								<p style="text-align: center">
									거래처<select name="clientname" id="clientname" v-model="clientname"></select>
									 날짜<input type="date" name="stdate" id="stdate" v-model="stdate"/>
									  ~ <input type="date" name="eddate" id="eddate" v-model="eddate"/>
								</p>
								<p style="text-align: center">
									대분류 <select name="lcategory" id="lcategory" v-model="lcategory" @change="lcategorychange()"></select>
									 중분류 <select id="midchoice" v-model="midchoice" v-show="midchoiceflag">
											<option value="">선택</option>
										</select>
									    <select name="mcategory" id="mcategory"  v-model="mcategory" v-show="mcategoryflag" @change="mcategorychange()"></select>
									  제품  <select id="prodchoice" v-model="prodchoice" v-show="prodchoiceflag">
											<option value="">선택</option>
										</select>
									  <select name="productname" id="productname" v-model="productname" v-show="productnameflag"></select>
									<a class="btnType blue" href="" id="listsearch" name="btn"><span>조회</span></a>
									<a class="btnType blue" href="javascript:resetsearch()" name="modal"><span>검색초기화</span></a>
								</p>
							</div>

							<br />

							<div class="divComGrpCodList">
								<table class="col">
									<caption>caption</caption>
									<colgroup>
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="16%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
									</colgroup>
									<thead>
										<tr>
											<th scope="col">등록일</th>
											<th scope="col">거래처이름</th>
											<th scope="col">대분류</th>
											<th scope="col">중분류</th>
											<th scope="col">제품이름</th>
											<th scope="col">목표수량</th>
											<th scope="col">실적수량</th>
											<th scope="col">비고</th>
										</tr>
									</thead>
									<template v-if="countempsaleplan == 0">
										<tbody>									
											<tr>
												<td colspan=8>데이터가 존재하지 않습니다.</td>
											</tr>
										</tbody>	
									</template>
									<template v-else>
										<tbody id="vueEmpSalePlanlist" v-for = "(list,index) in grouplist">
											<tr>
												<td>{{list.plan_date}}</td>
												<td>{{list.client_name}}</td>
												<td>{{list.mcname}}</td>
												<td>{{list.pdname}}</td>
												<td>{{list.product_name}}</td>
												<td>{{list.goal_amt}}</td>
												<td>{{list.now_amt}}</td>														
												<td></td>
											</tr>
										</tbody>										
									</template>
								</table>
							</div>

							<div class="paging_area" id="empSalePlanPagination" v-html="empSalePlanPagination"></div>

						</div> <!--// content -->

						<h3 class="hidden">풋터 영역</h3> <jsp:include
							page="/WEB-INF/view/common/footer.jsp"></jsp:include>
					</li>
				</ul>
			</div>
		</div>


		<div id="newplan" class="layerPop layerType2"
			style="width: 600px; margin-top: 120px;">
			<dl>
				<dt>
					<strong>신규계획등록</strong>
				</dt>
				<dd class="content">
					<!-- s : 여기에 내용입력 -->
					<table class="row">
						<caption>caption</caption>
						<colgroup>
							<col width="120px">
							<col width="*">
							<col width="120px">
							<col width="*">
						</colgroup>

						<!-- 디테일 팝업 -->
						<tbody id="">
							<tr>
								<th scope="row">거래처 이름<span class="font_red">*</span></th>
								<td colspan=3><select name="newclient" id="newclient" v-model="newclient"></select></td>
							</tr>
							<tr>
								<th scope="row">대분류<span class="font_red">*</span></th>
								<td><select name="newlcategory" id="newlcategory" v-model="newlcategory"
									@change="newlcategorychange()"></select></td>
								<th scope="row">중분류<span class="font_red">*</span></th>
								<td><select name="newmcategory" id="newmcategory" v-model="newmcategory"
									@change="newmcategorychange()"></select></td>
							</tr>
							<tr>
								<th scope="row">제품<span class="font_red">*</span></th>
								<td><select name="newproduct" id="newproduct" v-model="newproduct"></select></td>
								<th scope="row">수량<span class="font_red">*</span></th>
								<td><input type="number" class="inputTxt p100" v-model="newnumber"
									name="newnumber" id="newnumber" /></td>
							</tr>
						</tbody>

					</table>

					<!-- e : 여기에 내용입력 -->

					<div class="btn_areaC mt30">
						<a href="" class="btnType blue" id="btnSave" name="btn"><span>등록</span></a>
						<a href="" class="btnType gray" id="btnClose" name="btn"><span>취소</span></a>
					</div>
				</dd>
			</dl>
			<a href="" class="closePop"><span class="hidden">닫기</span></a>
		</div>

	</form>
</body>
</html>