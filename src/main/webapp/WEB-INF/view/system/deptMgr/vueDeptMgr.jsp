<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>부서관리</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<script type="text/javascript">
	
	// 페이징 설정
	//var pageSize = 5;
	//var pageBlockSize = 5;
	//var container;
	
	/** OnLoad event */ 
	$(function() {

		init();
		searchdept();
		fRegisterButtonClickEvent(); //버튼이벤트
		
		
		//$("#ssrcdept").val("");
	});
	
	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();

			var btnId = $(this).attr('id');
			
			switch (btnId) {
				
			    case 'btnSave' :   //저장버튼
			    	deptcheck();
					break;
			    case 'btnDelete' :
			    	//$("#action").val("D");  //삭제버튼
			    	container.action="D";
					fn_countindept();
					break;
				case 'btnClose' :    //닫기 버튼
					gfCloseModal();
					break;
 				case 'searchbtn' :
 					container.clickBtn = '';
 					container.clickBtn = 'Z';
 					//$("#ssrcdept").val($("#srcdept").val());
					//$("#sscpage").val($("#cpage").val());
					//$("#sspageSize").val($("#pageSize").val()); 
					searchdept();
					break;
			}
		});
	}
	
	
	function init(){
		container =	new Vue({
			el : "#container",
			data : {
				
				deptlist : [],
				action : '',
				
				srcdept : '', 
				
				/* page */
				pageSize : 5,
				pageBlockSize : 5,
				countdeptlist : '',
				deptPagination : '',
				currentpage : '',
				
				countindept : '',
				clickBtn : '',
			},
			methods : {
				vuefn_detaildept : function(test){
					fn_detaildept(test);
				},
				fn_searchdept : function(test){
					searchdept(test);
				}
			},
		});
		deptreg = new Vue({
			el : "#deptreg",
			data : {
				detail_name : '',
				detail_code : '',
				
				//show hide
				tdshow_show : false,
				thshow_show : false,
				btnDelete_show : false,
			}
		})
		
	}
	
	/* 부서 정보 검색 */
	function searchdept(cpage, ssrcdept) {
		cpage = cpage || 1;
		//$("#srcdept").val(ssrcdept);
		
		console.log(cpage, ssrcdept);
		// 파라메터,  callback
		if(container.clickBtn == 'Z'){
			//검색 버튼 눌렀을때
			var param = {
					srcdept :container.srcdept,
					pageSize : container.pageSize,
					cpage : cpage
			}
			console.log(param);
		}else{
			//검색 버튼 누르기 전 초기상태
			var param = {
				pageSize : container.pageSize,
				cpage : cpage,
			}
			console.log(param);
		}
		
		
		var listcallback = function(returndata) {
						
			console.log("searchdept listcallback : "+ JSON.stringify(returndata));
			
			//$("#listDept").empty().append(returndata);
			container.deptlist = returndata.deptlist;
			
			//var countdeptlist = $("#countdeptlist").val();
			container.countdeptlist = returndata.countdeptlist;
			var paginationHtml = getPaginationHtml(cpage, returndata.countdeptlist, container.pageSize, container.pageBlockSize, 'searchdept');
			
			//$("#deptPagination").empty().append(paginationHtml);
			container.deptPagination = paginationHtml ;
			
			//$("#currentpage").val(cpage);
			container.currentpage = cpage;
		}
		
		callAjax("/system/vueDeptlist.do", "post", "json", "false", param, listcallback) ;
	}
	
    /* 부서 등록 팝업 */	
	function fn_openpopup() {
		
    	// $('#thshow').hide();
    	deptreg.thshow_show = false;
    	
    	//$('#tdshow').hide();
    	deptreg.tdshow_show = false;
    	
		initpopup();
		
		gfModalPop("#deptreg");
		
	}
    
    /* 부서 중복 확인 */
    function deptcheck(){
    	
    	var data1 = {"detail_name" :deptreg.detail_name};
    	var senddata;
    	var listcallback = function(returndata) {
    		if(returndata == 0){
    			fn_save();
    		} else {
    			alert("부서명이 중복입니다.")
    		}
    		
    		
    	}
    	    	
    	callAjax("/system/check_dept.do", "post", "json", "false", data1, listcallback) ;
    }
    
    /* 부서정보 저장 */
	function fn_save(data) {
    	
		if(!fValidate()) {
			return;
		}
		
		if(!data == 0){ //data는 존재인원이 넘어옴
			console.log("들어왔다")
			alert("해당 부서에 인원이 존재합니다.")
			return;
		}
		
		var param = {
				detail_name  : deptreg.detail_name,  
				detail_code : deptreg.detail_code,
				action : container.action,
		}
		console.log(param);
		var savecallback = function(returndata) {
						
			console.log(  JSON.stringify(returndata) );
			
			if(returndata.result == "SUCCESS") {
				
				if(container.action == "U") {
					alert("수정 되었습니다.");
					searchdept(container.currentpage);
				} else if (container.action == "D") {
					alert("삭제 되었습니다.");
					searchdept();
				} else{
					alert("저장 되었습니다.");
				}
				searchdept(container.currentpage);
				gfCloseModal();
			}
		}
		
		callAjax("/system/deptsave.do", "post", "json", "false", param, savecallback) ;
		
	}
    
    /* Validation (값 입력 안했을 때)  */
    function fValidate() {
    	
		var chk = checkNotEmpty(
				[
						[ "detail_name", "부서명을 입력해 주세요." ]
				]
		);

		if (!chk) {
			return;
		}

		return true;
	}
    
    /* 모달 창 띄우기 */
	function initpopup(object) {	
		//등록시  저장,취소 버튼만 뜸
		if( object == "" || object == null || object == undefined) {
			
			//$("#detail_name").val("");
			deptreg.detail_name = "";
			//$("#detail_code").val("");
			deptreg.detail_code = "";
			//$("#btnDelete").hide();
			deptreg.btnDelete_show=false;
			
			//$("#action").val("I");
			container.action = "I";
		//수정시 저장,삭제,취소버튼 뜸 
		} else {			
			
			//$("#detail_name").val(object.detail_name);
			deptreg.detail_name = object.detail_name;
			//$("#detail_code").val(object.detail_code);
			deptreg.detail_code = object.detail_code;
			
			//$("#btnDelete").show();
			deptreg.btnDelete_show = true;
			//$("#action").val("U");
			container.action = "U";
		}
		
	}
	
	
	// 부서 상세정보 조회
    function fn_detaildept(detail_code,popuptype) {
    	
    	//$("#thshow").show();
    	deptreg.thshow = true;
    	//$("#tdshow").show();
    	deptreg.tdshow_show = true;
		
		//$("#countindept").val(detail_code);
		container.countindept = detail_code;
		
    	var param = {
    			detail_code : detail_code
    	}
    	
    	var detaildeptcallback = function(returndata) {
    		console.log(  JSON.stringify(returndata)  );
    		
    		console.log( returndata.detaildept.detail_code);
    		
    		
    		initpopup(returndata.detaildept);
        		
        	gfModalPop("#deptreg");
    		
    		
    	}
    	
    	callAjax("/system/detaildept.do", "post", "json", "false", param, detaildeptcallback) ;
    } 
	
	
	function fn_countindept(){ // 삭제 시 부서에 인원이 존재하는지 확인하는 함수
		
		var param = {
				dept_cd : container.countindept,
		}
		
		var callback = function(data){
			console.log(data);
			fn_save(data.countindept);
		}
		callAjax("/system/countindept.do", "post", "json", false, param, callback);
	}

</script>

</head>
<body>

<form id="myForm" action=""  method="">
	<input type="hidden" name="loginId" id="loginId" value="${loginId}">
	<input type="hidden" name="userNm" id="userNm" value="${userNm}">
	<input type="hidden" name="ssrcdept" id="ssrcdept" value="">
	<input type="hidden" name="sscpage" id="sscpage" value="">
	<input type="hidden" name="sspageSize" id="sspageSize" value="">
	<!-- 모달 배경 -->
	<div id="mask"></div>

	<div id="wrap_area">

		<h2 class="hidden">header 영역</h2>
		<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

		<h2 class="hidden">컨텐츠 영역</h2>
		<div id="container">
			<input type="hidden" name="action" id="action" value="" v-model="action">
			<input type="hidden" name="currentpage" id="currentpage" value="" v-model="currentpage">
			<input type="hidden" name="countindept" id="countindept" value="" v-model="countindept">
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
								class="btn_nav bold">시스템</span> <span class="btn_nav bold">부서관리
								</span> <a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>부서관리</span> 
						</p>
						
						
						<span>	
						부서명
						
						<input type="text" id="srcdept" name="srcdept" style="width: 150px; height: 25px;" v-model="srcdept"/>
								
						<a	class="btnType blue" v-on:click="container.fn_searchdept();" id="searchbtn" name="btn" v-model="clickBtn"><span>검색</span></a>
							<c:if test ="${sessionScope.userType eq 'A'}">
								<a	class="btnType blue" href="javascript:fn_openpopup();" name="modal"><span>등록</span></a>
							</c:if>	
						<!-- userType이 관리자 일때만 등록 버튼이 뜸 -->
						</span>										
							
						
						
						<div class="divComGrpCodList">
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="50%">
									<col width="50%">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">부서명</th>
										<th scope="col">부서코드</th>
									</tr>
								</thead>
								<tbody id="listDept" >
								 	
									<template v-if="countdeptlist">
									<tr v-for="(list, index) in container.deptlist">
										<td>
										<a href="" @click.prevent ="container.vuefn_detaildept(list.detail_code ,1, list.detail_name)">{{list.detail_name}}</a></td>
										<td>{{list.detail_code}}</td>
									</tr>
									</template>
									<template v-if="! countdeptlist">
									<tr>
										<td colspan="2">데이터가 존재하지 않습니다.</td>
									</tr>
									</template>
								</tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="deptPagination" v-html="deptPagination"> </div>
						
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>
	
	
	
	<!-- 부서 등록, 수정 모달창 -->
<c:choose>
			
	<c:when test = "${sessionScope.userType eq 'A'}">
	
		<div id="deptreg" class="layerPop layerType2" style="width: 600px;">
			<dl>
				<dt>
					<strong>부서 등록/수정</strong>
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
				<th scope="row">부서명 <span class="font_red">*</span></th>
				<td><input type="text" class="inputTxt p100" name="detail_name" id="detail_name" v-model="detail_name"/></td>
				<th scope="row" id="thshow" v-show="thshow_show">부서코드 <span class="font_red">*</span></th>
				<td id="tdshow" v-show="tdshow_show"><input type="text"  class="inputTxt p100" name="detail_code" id="detail_code" v-model="detail_code" readonly /></td>									
		</tr>	
			</tbody>
		</table>
		
		<div class="btn_areaC mt30">
		
			<a href="" class="btnType blue" id="btnSave" name="btn"><span>저장</span></a> 
			<a href="" class="btnType blue" id="btnDelete" name="btn" v-show="btnDelete_show"><span>삭제</span></a>
			<a href=""	class="btnType gray"  id="btnClose" name="btn"><span>취소</span></a> 			            
							
		</div>
		 
		</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
			
			
		</div>
	  
	</c:when>
						 		
	<c:otherwise>
		<div id="deptreg" class="layerPop layerType2" style="width: 600px;">
			<dl>
			<dt>
				<strong>부서 조회</strong>
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
					<th scope="row">부서명 <span class="font_red">*</span></th>
					<td><input type="text" class="inputTxt p100" name="detail_name" id="detail_name" readonly v-model="detail_name"/></td>
												
					<th scope="row">부서코드 <span class="font_red">*</span></th>
					<td><input type="text" class="inputTxt p100" name="detail_code" id="detail_code" readonly v-model="detail_code"/></td>
				</tr>	
			</tbody>
		</table>
		
			<div class="btn_areaC mt30">
				<a href=""	class="btnType gray"  id="btnClose" name="btn"><span>확인</span></a>		            					
			</div>
		
			</dd>
			</dl>
			
			<a href="" class="closePop"><span class="hidden">닫기</span></a>
			
			
		</div>
	   
	</c:otherwise>

</c:choose>
	

	
	

</form>

</body>
</html>