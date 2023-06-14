<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>근태신청</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<script type="text/javascript">

	// 그룹코드 페이징 설정
	var pageSize = 5;			//한페이지에 몇개 볼것인가
	var pageBlockSize = 5;
	
	var container1;
	var rest_reg;
	
	
	
	/** OnLoad event */ 
	$(function() {
		
		init();
		
		searchTaApply();
		
		searchlest();
		
		fRegisterButtonClickEvent();	
		
		comcombo("rest_cd", "rest_cd_search", "all", "");
		
		
	});
	
	
	function init(){
		container1 = new Vue({
			el : "#wrap_area",
			data : {
				grouplist : [],
				grouplist2 : [], 
				srcsdate: "",
				srcedate: "",
				search_rest_name: "",
				search_atd_yn: "",
				loginId: "",
				pageSize : 5,
				pageBlockSize : 5,
				cpage : "",
				pagenavi : "",
				taApplyPagination : '',
				rest_cd : "",
				st_date : "",
				ed_date : "",
				rest_cd_search : "",
				counttaApplylist : "",
							              
				
			},
			methods : {
				fn_searchTaApply: function(test){
					searchTaApply(test);
				},
				fn_RegisterVal: function(value){
					RegisterVal(value);
				},
				
			}
		});
		
		rest_reg = new Vue({
			el : "#rest_reg",
			data : {
				dept_name : "",
				name : "",
				emp_no : "",
				rest_rsn : "",
				rest_hp : "",
				st_date : "",
				ed_date : "",
				atd_name : "",
				reject_rsn : "",
				rest_cd : "",
				atd_no : "",
				loginId : "",
				action : "",
				
				              
			},
			methods : {
				
			}
			
		});
		
		/* content = new Vue({
			el : "#content",
			data : { 
				srcsdate : "",
				srcedate : "",
				search_rest_name : "",
				search_atd_yn : "",
			},
			methods : {

				
			}
		
		}); */
	}
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
					case 'btnClosefile' :
						gfCloseModal();
						break;
			}
		});
	}
	
	function searchTaApply(cpage){		//cpage라는 파라미터 값을 받을 것
		
		console.log(container1.search_model);
		
		cpage = cpage || 1;		//undefined 면 1로 셋팅
		
/*  		if($("#srcsdate").val()= "" && $("#srcedate").val() == ""){
			alert("종료일을 선택하세요."); 
		} else if($("#srcsdate").val() == "" && $("#srcedate").val() !="") {
			alert("시작일을 선택하세요.");
		} else if( $("#srcsdate").val() !="" && $("#srcedate").val() !="" && $("#srcsdate").val() > $("#srcedate").val()){
			alert("날짜를 확인해 주세요.");
		} else {} */
		console.log("!!!!!" + container1.rest_cd_search);
		//먼저 파라미터, callback 지정해줘야함
		var param = {				
					//srcsdate : $("#srcsdate").val(),
					srcsdate : container1.srcsdate,
					
					//srcedate : $("#srcedate").val(),
					srcedate : container1.srcedate,
					
					//search_rest_name : $("#search_rest_name").val(),
					search_rest_name : container1.rest_cd_search == 2 ? '연차' : container1.rest_cd_search == 1 ? "월차" : '',
					
					//search_atd_yn : $("#search_atd_yn").val(),
					search_atd_yn : container1.search_atd_yn,
					
					pageSize : pageSize,
					cpage : cpage, 	//페이지번호를 넘김
					
					//loginId : $("#loginId").val(),
					loginId : container1.loginId,
					
					
			} //{}json 형태
			
			//console.log(param);
			
			var listcallback = function(returndata){
				console.log(JSON.stringify(returndata));
						
				//$("#taApplylist").empty().append(returndata);
				container1.grouplist = returndata.taApplylist;


				//var counttaApplylist = $("#counttaApplylist").val();
				container1.counttaApplylist = returndata.counttaApplylist;
				
				container1.grouplist2 = returndata.total_rest;
				                                     // 현재페이지, 총 개수, 한페이지에 몇개?, 페이지 개수, 실행할 함수
				var paginationHtml = getPaginationHtml(cpage, container1.counttaApplylist, container1.pageSize, container1.pageBlockSize, 'searchTaApply');
				console.log("paginationHtml : " + paginationHtml);
				//swal(paginationHtml);
				//$("#taApplyPagination").empty().append( paginationHtml );
				container1.taApplyPagination = paginationHtml;
				
				// 현재 페이지 설정
				//$("#currentPageComnGrpCod").val(cpage);
			}
								
//			}	//함수형 변수
			
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
			 
			 callAjax("/employee/empTaApplylistvue.do", "post", "json", true, param, listcallback);
		}		 
	
	/* 휴가등록 validation */
	function RegisterVal(){
		  
		//var rest_cd = $("#rest_cd").val();
		var rest_cd = rest_reg.rest_cd;
		
		//var st_date = $("#st_date").val();
		var st_date = rest_reg.st_date;
		
		//var ed_date = $("#ed_date").val();
		var ed_date = rest_reg.ed_date;
		
		//var rest_rsn = $("#rest_rsn").val();
		var rest_rsn = rest_reg.rest_rsn;
		
		if(rest_cd == ""){
			swal("근태종류를 선택하세요").then(function() {
				//$("#rest_cd").focus();
			  });
			return false;
		}
		
		if(st_date == ""){
			swal("시작날짜를 선택하세요").then(function() {
				//$("#st_date").focus();
			  });
			return false;
		}
		
		if(ed_date == ""){
			swal("마지막 날짜를 선택하세요").then(function() {
				//$("#ed_date").focus();
			  });
			return false;
		} 
		
		if(rest_rsn == ""){
			swal("휴가사유를 적어주세요").then(function() {
				//$("#rest_rsn").focus();
			  });
			return false;
		}

		return true;
		
	}
	
function searchlest(){		//cpage라는 파라미터 값을 받을 것
		
		//undefined 면 1로 셋팅
		
		//먼저 파라미터, callback 지정해줘야함
		var param = {			// loginId : $("#loginId").val(),
				loginId : container1.loginId,
				
		} //{}json 형태
		console.log(param);
		var listcallback = function(returndata){
					
			//$("#total_rest").empty().append(returndata);
			container1.grouplist2 = returndata.total_rest;
									
		}		
		
		 callAjax("/employee/empTaApplylist2vue.do", "post", "json", true, param, listcallback);
		 
	}
	
	/* 신규 등록 || 수정  */
	function initpopup(object) {		
			//$("#dept_name").val(object.dept_name);
			rest_reg.dept_name = object.dept_name;

			//$("#rest_cd").val("");
			rest_reg.rest_cd = "";
			
			//$("#name").val(object.name);
			rest_reg.name = object.name;
			
			//$("#emp_no").val(object.emp_no);
			rest_reg.emp_no = object.emp_no;
			
			//$("#st_date").val("");
			rest_reg.st_date = "";
			
			//$("#ed_date").val("");
			rest_reg.ed_date = "";
			
			//$("#rest_rsn").val("");
			rest_reg.rest_rsn = "";
			
			//$("#rest_hp").val(object.hp);
			rest_reg.rest_hp = object.hp;
		
	}
	

	function fn_openpopup(){
	
	
			var param = {			
					//loginId : $("#loginId").val(),
					loginId : container1.loginId,
					
			} //{}json 형태
			console.log(param);
			var listcallback = function(returndata){
				console.log("returndata:", returndata);
			
			initpopup(returndata.rest_info);		
			 
		}		
			callAjax("/employee/restinfo.do", "post", "json", true, param, listcallback);
		gfModalPop("#rest_reg");
	}
	
	function fn_save() {
			
			var param = {					
					
					//atd_no : $("#atd_no").val(),
					atd_no : rest_reg.atd_no,
		
					//rest_cd : $("#rest_cd").val(),
					rest_cd : rest_reg.rest_cd,
					
					//loginId : $("#loginId").val(),
					loginId : rest_reg.loginId,
					
					//st_date : $("#st_date").val(),
					st_date : rest_reg.st_date,
					
					//ed_date : $("#ed_date").val(),	
					ed_date : rest_reg.ed_date,
					
					//rest_rsn : $("#rest_rsn").val(),
					rest_rsn : rest_reg.rest_rsn,
					
					//action : $("#action").val(),
					action : rest_reg.action,
			}
			
			var savecallback = function(returndata) {
							
				console.log(  JSON.stringify(returndata) );
				
				if(returndata.result == "SUCCESS") {
					alert("신청 되었습니다.");
					gfCloseModal();
					searchTaApply();
				}
			}
			if(!RegisterVal()){
				
				return;
			}
			callAjax("/employee/taApplysave.do", "post", "json", "false", param, savecallback) ;
			
		}
		
	/* 반려사유 조회  */
	function rejectpopup(object) {		
			//$("#atd_name").val(object.atd_name);
			rest_reg.atd_name = object.atd_name;
			
			//$("#reject_rsn").val(object.reject_rsn);
			rest_reg.reject_rsn = object.reject_rsn;
	}
	function fn_rest_reject(atd_no){
		console.log(atd_no)
		
		var param = {
				atd_no : atd_no				
		}
		
		var detailonecallback = function (returndata){
			console.log( "returndata:" + JSON.stringify(returndata) );
			console.log(returndata.rest_reject.atd_no);
			
			rejectpopup(returndata.rest_reject);
			
		}
		
		callAjax("/employee/rest_reject.do", "post", "json", "false", param, detailonecallback);
		gfModalPop("#rest_reject");
	}	
	
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
	<form id="myForm" action="" method="">
	<div id="container1">
		<input type="hidden" name="action" id="action" value="">
		<%-- <input type="hidden" name="loginId" id="loginId" value="${loginId}"> --%>
		<input type="hidden" name="loginId" id="loginId" :value="loginId">
		
		<%-- <input type="hidden" name="userNm" id="userNm" value="${userNm}"> --%>
		<input type="hidden" name="userNm" id="userNm" :value="userNm">
		
		<input type="hidden" name="atd_no" id="atd_no" value="">
		<input type="hidden" name="currentpage" id="currentpage" value="">
		

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
								<span class="btn_nav bold">인사관리</span>
								<span class="btn_nav bold">근태신청/조회</span>
								<a href="../employee/empTaApply.do" class="btn_set refresh">새로고침</a>
							</p>

							<p class="conTitle">
								<span>근태신청/조회</span>
								<span class="fr">
								일자<input type="date" id="srcsdate" name="srcsdate" v-model="srcsdate"/> ~
								<input type="date" id="srcedate" name="srcedate" v-model="srcedate"/>								
								<select id="rest_cd_search" name="search_rest_name" v-model="rest_cd_search">
								</select>								
								<select id="search_atd_yn" name="search_atd_yn" v-model="search_atd_yn">
									<option value="">결재상태</option>
									<option value="y">승인</option>
									<option value="w">승인대기</option>
									<option value="n">반려</option>
								</select>
								<a class="btnType blue" href="javascript:searchTaApply()" name="modal">
									<span>조회</span></a>									
								</span>
							</p>
							
							<div>
								<table class="col">
									<caption>caption</caption>
									<colgroup>
										<col width="30%">
										<col width="30%">
										<col width="30%">										
									</colgroup>
									<thead>
										<tr>
											<th scope="col">총 연차</th>
											<th scope="col">사용 연차</th>
											<th scope="col">남은 연차</th>
										</tr>
									</thead>
									
									<tbody id="total_rest" v-for="(list, item) in grouplist2">
										<tr>
											<td>{{list.total_rest}}</td>
											<td>{{list.use_rest}}</td>
											<td>{{list.remain_rest}}</td>
										</tr>
									</tbody>
									<!-- <tbody id="total_rest"></tbody> -->
									<%-- <c:forEach items="${total_rest}" var="list">
									<tr>
										<td>${list.total_rest}</td>
										<td>${list.use_rest}</td>										
										<td>${list.remain_rest}</td>
									</tr>
									</c:forEach> --%>
							
									
									
								</table>
							</div>
							<a class="btnType blue"	href="javascript:fn_openpopup();" name="modal" style="float: right">
									<span>개인근태신청</span></a>
							<div class="divComGrpCodList">
								<table class="col">
									<caption>caption</caption>
									<colgroup>
										<col width="10%">
										<col width="10%">										
										<col width="25%">
										<col width="25%">
										<col width="15%">
										<col width="15%">
										
									</colgroup>
									<thead>
										<tr>
											<th scope="col">번호</th>
											<th scope="col">휴가종류</th>											
											<th scope="col">시작일</th>
											<th scope="col">종료일</th>
											<th scope="col">결재자</th>
											<th scope="col">결재상태</th>											
										</tr>
									</thead>
									<template v-if="counttaApplylist == 0">
									<tbody>
                                        <tr>
                                            <td colspan="8">데이터가 존재하지 않습니다.</td>
                                        </tr>
									</tbody>
                                    </template>
                                    <template v-else>
									<tbody id="taApplylist" v-for="(list, item) in grouplist">
										<tr>
											<td>{{list.atd_no}}</td>
											<td>{{list.rest_name}}</td>
											<td>{{list.st_date}}</td>
											<td>{{list.ed_date}}</td>
											<td>{{list.atd_name}}</td>
											<td>
												<template v-if="list.atd_yn == '반려'">
													<%-- <a href="javascript:fn_rest_reject('${list.atd_no}')" >${list.atd_yn}</a> --%>
													<a href="" @click.prevent="fn_rest_reject(list.atd_no)">{{list.atd_yn}}</a>
												</template v-if>
												<template v-else>
													{{list.atd_yn}}
												</template v-else>
											</td>
										</tr>
									</tbody>
									</template>

									<!-- <tbody id="taApplylist"> -->
<%--
							<c:if test="${counttaApplylist eq 0 }">
								<tr>
									<td colspan="8">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>

							<c:if test="${counttaApplylist > 0 }">
                                <c:forEach items="${taApplylist}" var="list">
									<tr>
										<td>${list.atd_no}</td>
										<td>${list.rest_name}</td>										
										<td>${list.st_date}</td>
										<td>${list.ed_date}</td>
										<td>${list.atd_name}</td>
										<td>
											<c:if test="${list.atd_yn == '반려'}">
												<a href="javascript:fn_rest_reject('${list.atd_no}')" >${list.atd_yn}</a>
											</c:if>
											<c:if test="${list.atd_yn != '반려'}">
												${list.atd_yn}
											</c:if>
										</td>
									</tr>
								</c:forEach>
                                </c:if>

                                <input type="hidden" id="counttaApplylist" name="counttaApplylist" value ="${counttaApplylist}"/> --%>

								<input type="hidden" id="counttaApplylist" name="counttaApplylist" :value ="counttaApplylist"/>
									
								</table>
							</div>
							<div class="paging_area" id="taApplyPagination" v-html="taApplyPagination"></div>
						</div>

							


						</div> <!--// content -->

						<h3 class="hidden">풋터 영역</h3> <jsp:include
							page="/WEB-INF/view/common/footer.jsp"></jsp:include>
					</li>
				</ul>
			</div>
			</div>
		</div>

		<div id="rest_reg" class="layerPop layerType2" style="width: 600px;">
			<dl>
				<dt>
					<strong>근태 신청</strong>
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

						<tbody>
							<tr>
								<th scope="row">근무부서 <span class="font_red"></span></th>
								<td><input type="text" class="inputTxt p100" name="dept_name"
									id="dept_name" v-model="dept_name" readonly /></td>
								<th scope="row">근태종류 <span class="font_red"></span></th>
								<td>
								<select id="rest_cd" name="rest_cd" size="1" class="check" v-model="rest_cd">									
									<option value="">근태종류</option>									
									<option value="1">월차</option>
									<option value="2">연차</option>
								</select>
								</td>
							</tr>
							<tr>
								<th scope="row">성명<span class="font_red"></span></th>
								<td><input type="text" class="inputTxt p100" name="name"
									id="name" v-model="name" readonly /></td>
								<th scope="row">사원번호<span class="font_red"></span></th>
								<td><input type="text" class="inputTxt p100"
									name="emp_no" id="emp_no" v-model="emp_no" readonly /></td>
							</tr>
							<tr>
								<th scope="row">기간 <span class="font_red">*</span></th>
								<td colspan="3">
								일자<input type="date" id="st_date" name="st_date" v-model="st_date"/> ~
								<input type="date" id="ed_date" name="ed_date" v-model="ed_date"/>	</td>
							</tr>

							<tr>
								<th scope="row">휴가사유<span class="font_red">*</span></th>
								<td colspan="3"><textarea class="inputTxt p100"
										name="rest_rsn" id="rest_rsn" v-model="rest_rsn"> </textarea></td>
							</tr>
							<tr>
								<th scope="row">연락처<span class="font_red"></span></th>
								<td colspan="3">
								<input type="text" class="inputTxt p100"
									id="rest_hp" name="rest_hp" v-model="rest_hp" readonly /></td>
							</tr>

						</tbody>
					</table>

					<!-- e : 여기에 내용입력 -->

					<div class="btn_areaC mt30">
						<a href="" class="btnType blue" id="btnSave" name="btn"><span>신청</span></a>						
						<a href="" class="btnType gray" id="btnClose" name="btn"><span>닫기</span></a>
					</div>
				</dd>
			</dl>
			<a href="" class="closePop"><span class="hidden">닫기</span></a>
		</div>
		
		<div id="rest_reject" class="layerPop layerType2" style="width: 600px;">
			<dl>
				<dt>
					<strong>반려사유</strong>
				</dt>
				<dd class="content">
					<!-- s : 여기에 내용입력 -->
					<table class="row">
						<caption>caption</caption>
						<colgroup>
							<col width="120px">
							<col width="*">
						</colgroup>

						<tbody>
							<tr>
								<th scope="row">결재자 <span class="font_red"></span></th>
								<td>
								<input type="text" class="inputTxt p100" name="atd_name" id="atd_name" readonly />
								</td>
							</tr>
							<tr  height="100">
								<th scope="row">반려사유<span class="font_red"></span></th>
								<td >
								<textarea class="inputTxt p100" name="reject_rsn" id="reject_rsn" readonly></textarea>
								<!-- <input type="text" class="inputTxt p100" name="reject_rsn" id="reject_rsn" readonly/> -->
								</td>								
							</tr>
						</tbody>
					</table>

					<!-- e : 여기에 내용입력 -->
					<div class="btn_areaC mt30">												
						<a href="" class="btnType gray" id="btnClose" name="btn"><span>닫기</span></a>
					</div>
				</dd>
			</dl>
			<a href="" class="closePop"><span class="hidden">닫기</span></a>
		</div>


	</form>
</body>
</html>