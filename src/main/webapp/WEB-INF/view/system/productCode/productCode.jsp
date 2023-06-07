<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>제품 대분류 관리</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<script type="text/javascript">

	// 페이징 설정
	var pageSize = 5;
	var pageBlockSize = 5;
	var check = /^[0-9]+$/;
	
	/** OnLoad event */ 
	$(function() {
	
		fRegisterButtonClickEvent();
	
		searchproduct();
		$("#searchname").val("");
		
	});
	
	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();

			var btnId = $(this).attr('id');
			
			switch (btnId) {
			    case 'btnSave' :
					fn_save();
					break;
			    case 'btnDelete' :
			    	$("#action").val("D");
					fn_save();
					break;			    
				case 'btnClose' :				
					gfCloseModal();
					break;
				case 'btnSearch' :
					$("#ssearchname").val($("#searchname").val());
					$("#scpage").val($("#cpage").val());
					$("#spageSize").val($("#pageSize").val());
					searchproduct($("#scpage").val(), $("#ssearchname").val());
					break;
			}
		});		
		
	}
		
	function searchproduct(cpage, searchname) {
		
		console.log(cpage, searchname);
		cpage = cpage || 1;
		$("#currentpage").val(cpage);
		$("#searchname").val(searchname);
		
		
		// 파라메터,  callback
		var param = {
				searchname : $("#searchname").val(),				
				pageSize : pageSize,
				cpage : cpage,
		}
		
		var listcallback = function(returndata) {
						
			console.log(returndata);
			
			$("#productlist").empty().append(returndata);
			
			var countproductlist = $("#countproductlist").val();
			
			var paginationHtml = getPaginationHtml(cpage, countproductlist, pageSize, pageBlockSize, 'searchproduct');
			
			$("#productPagination").empty().append(paginationHtml);
			
			$("#currentpage").val(cpage);
			
		}
		
		callAjax("/system/productCodeList.do", "post", "text", "false", param, listcallback) ;
	}
	
	/* 휴가등록 validation */
	function RegisterVal(){
		  
		var detail_name = $("#detail_name").val();
		var detail_code = $("#detail_code").val();		
		
		if(detail_name == ""){
			swal("대분류명을 입력하세요").then(function() {
				$("#detail_name").focus();
			  });
			return false;
		}
		
		if(detail_code == ""){
			swal("대분류 코드를 입력하세요").then(function() {
				$("#detail_code").focus();
			  });
			return false;
		}		

		return true;
		
	}
	
	
    ////파일 미첨부 시작	
	function fn_openpopup() {
		
		initpopup();
		
		gfModalPop("#productreg");
		
	}
	
	function fn_save() {
		if($("#detail_name").val() == ""){
			alert("제품 대분류 명을 기입해 주세요.");
			$("#detail_name").focus();
		} else if($("#detail_code").val() == ""){
			alert("제품 대분류 코드를 기입해 주세요.");
			$("#detail_code").focus();
		} else if(!check.test($("#detail_code").val())){
			alert("숫자만 기입해 주세요.");
			$("#detail_code").val("");
			$("#detail_code").focus();
		} else {
			
			var param = {
					detail_name : $("#detail_name").val(),
					detail_code  : $("#detail_code").val(),  
				    action : $("#action").val()
			}
			
			var savecallback = function(returndata) {
							
				console.log(  JSON.stringify(returndata) );
				
				if(returndata.result == "FAILNAME") {
					swal("제품 대분류 명이 중복 되었습니다. \n 확인 후 다시 입력해주세요. ");
				} else if (returndata.result == "FAILCODE" ){
					swal("제품 대분류 코드가 중복 되었습니다. \n 확인 후 다시 입력해주세요.");
				}
				
				if(returndata.result == "SUCCESS") {
					alert("저장 되었습니다.");
					gfCloseModal();
					
					if($("#action").val() == "U") {
						searchproduct($("#currentpage").val());
					} else {
						searchproduct();
					}
					
				}
			}
			
			if(!RegisterVal()){
				
				return;
			}
			
			callAjax("/system/productcodeinsert.do", "post", "json", "false", param, savecallback) ;
			
		}
		
	}
	
	function initpopup(object) {	
		
		if( object == "" || object == null || object == undefined) {
						
			$("#detail_name").val("");
			$("#detail_code").val("");
			$("#detail_code").removeAttr("readonly");			
			
			$("#btnDelete").hide();
			
			$("#action").val("I");
			
		} else {			
			// {"notice_no":17,"loginID":"admin","writer":"변경","notice_title":"test","notice_date":"2023-05-08","notice_det":"test","file_name":null,"file_size":0,"file_nadd":null,"file_madd":null}
		
		    $("#detail_name").val(object.detail_name);
			$("#detail_code").val(object.detail_code);			
			$("#detail_code").attr("readonly","readonly");			
			
			$("#btnDelete").show();
			
			$("#action").val("U");
		}
		
	}
	
	
    function fn_detailone(detail_code,popuptype) {
    	
    	var param = {
    			detail_code : detail_code
    	}
    	
    	var detailonecallback = function(returndata) {
    		console.log(  JSON.stringify(returndata)  );
    		
    		console.log( returndata.detailproductcode.detail_code);
    		    		
    			initpopup(returndata.detailproductcode);
        		
        		gfModalPop("#productreg");
    		    		
    	}
    	
    	callAjax("/system/detailproductcode.do", "post", "json", "false", param, detailonecallback) ;
    }    
    //// 파일 미첨부 끝   
    
</script>

</head>
<body>
<form id="myForm" action=""  method="">
	<input type="hidden" name="action" id="action" value="">
	<input type="hidden" name="loginId" id="loginId" value="${loginId}">
	<input type="hidden" name="userNm" id="userNm" value="${userNm}">
	<input type="hidden" name="noticeno" id="noticeno" value="">
	<input type="hidden" name="currentpage" id="currentpage" value="">
	<input type="hidden" name="ssearchname" id="ssearchname" value="">
	<input type="hidden" name="scpage" id="scpage" value="">
	<input type="hidden" name="spageSize" id="spageSize" value="">
	
	
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
							<span class="btn_nav bold">시스템 관리</span>
							<span class="btn_nav bold">제품 대분류 관리</span>
							<a href="../system/productCode.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>제품 대분류 관리</span>
							<span class="fr"> 
							  대분류명 <input type="text" id="searchname" name="searchname" />                               					   
							   <a class="btnType blue" href="" id="btnSearch" name="btn" ><span>검색</span></a>
							</span>
						</p>
						<div align="right">						
						<a class="btnType blue" href="javascript:fn_openpopup();" name="modal"><span>등록</span></a>						
						</div>
						<div class="divComGrpCodList">
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="50%">
									<col width="50%">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">대분류명</th>
										<th scope="col">대분류 코드</th>										
									</tr>
								</thead>
								<tbody id="productlist"></tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="productPagination"> </div>
						
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>
	
	<div id="productreg" class="layerPop layerType2" style="width: 600px;">
	     <dl>
			<dt>
				<strong>제품 대분류 등록/수정</strong>
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
							<th scope="row">제품 대분류명 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" name="detail_name" id="detail_name"/></td>
							<th scope="row">제품 대분류코드<span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" name="detail_code" id="detail_code"/></td>
						</tr>						
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">				
					<a href="" class="btnType blue" id="btnSave" name="btn"><span>등록</span></a> 
					<a href="" class="btnType blue" id="btnDelete" name="btn"><span>삭제</span></a>				
					<a href=""	class="btnType gray"  id="btnClose" name="btn"><span>닫기</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
</form>
</body>
</html>