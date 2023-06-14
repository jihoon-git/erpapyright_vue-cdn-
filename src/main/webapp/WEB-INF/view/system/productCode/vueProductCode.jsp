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

	var vuearea;
	var check = /^[0-9]+$/;//////
	
	/** OnLoad event */ 
	$(function() {
		
		
		init();
	
		fRegisterButtonClickEvent();
	
		searchproduct();
		vuearea.searchname = "";
		//$("#searchname").val("");
		
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
			    	productreg.action = 'D';
					fn_save();
					break;			    
				case 'btnClose' :				
					gfCloseModal();
					break;
				case 'btnSearch' :
					console.log("검색버튼 이벤트 시작!!!");
					vuearea.clickBtn=''; //검색후 검색한것 초기화 용도
					vuearea.clickBtn='Z';
				
					//hiddenarea.ssearchname = vuearea.searchname;
					//hiddenarea.scpage = cpage
					//hiddenarea.spageSize = pageSize;
					searchproduct(hiddenarea.currentpage ,vuearea.searchname);
					
					
					break;
			}
		});		
		
	}//fRegisterButtonClickEvent-end
		
	function init(){
		vuearea = new Vue ({
			el : "#wrap_area",  
			
			data : {
				pageSize : 5,
				pageBlockSize : 5,
				prodlist : [],
				prodlistcnt : '',
				prodPagination : '',
				searchname : '',
				clickBtn : '',
				
			},
			methods : {
				fn_searchproduct : function(){
					searchproduct();
				},
				grpdetail : function(code){
					fn_detailone(code);
				}
			}
		});
		
		productreg = new Vue({
			el : "#productreg",
			data : {
				detail_name : '',
				detail_code : '',
				action: '',
				delbtnshow : '',
			}
		});
		
		hiddenarea = new Vue({
			el : "#hiddenarea",
			data : {
				currentpage : 0,
				ssearchname : '',
				scpage : '',
				spageSize : '',
				
			}
		});
		
		
	
	
		
		
	}//init-end
	
	function searchproduct(cpage, searchname) {	//현재 page 받기
												//현재 page가 undefied면 1로 셋팅

		console.log("cpage 확인 : " + cpage);
		console.log("searchname 확인 : " + searchname);
		
		cpage = cpage || 1;
		hiddenarea.currentpage = cpage;
		
		if(vuearea.clickBtn=='Z'){
			// 파라메터,  callback
			var param = { // 컨트롤러로 넘겨줄 이름 : 보내줄값
					searchname : vuearea.searchname,				
					pageSize : vuearea.pageSize,
					cpage : cpage,
			}
		}else{
			var param = { // 컨트롤러로 넘겨줄 이름 : 보내줄값

					pageSize : vuearea.pageSize,
					cpage : cpage,
			}
		}
		

		
		var listcallback = function(returndata) {
						
			console.log(JSON.stringify(returndata));
			
			vuearea.prodlist = returndata.productCodelist;
			vuearea.prodlistcnt = returndata.countproductlist;
			
			var paginationHtml = getPaginationHtml(cpage, returndata.countproductlist, vuearea.pageSize, vuearea.pageBlockSize, 'searchproduct');
			
			vuearea.prodPagination = paginationHtml;
			
			//$("#currentpage").val(cpage); 
			
		}
		
		callAjax("/system/vueProductCodeList.do", "post", "json", "false", param, listcallback) ;
	}//searchproduct-end
	
    ////파일 미첨부 시작	
	function fn_openpopup() {
		
		initpopup();
		
		gfModalPop("#productreg");
		
	}
	
	//저장
	function fn_save() {
		
		if(productreg.detail_name == ""){
			alert("제품 대분류 명을 기입해 주세요.");
			//$("#detail_name").focus();
		} else if(productreg.detail_code == ""){
			alert("제품 대분류 코드를 기입해 주세요.");
			//$("#detail_code").focus();
		} else if(!check.test(productreg.detail_code)){
			alert("제품 대분류 코드는 숫자만 기입해 주세요.");
			productreg.detail_code = "";
			//$("#detail_code").focus();
		} else { 
			
			
			var param = {
					
					detail_name : productreg.detail_name,
					detail_code : productreg.detail_code,  
				    action : productreg.action
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
					
					if(param.action == "U") {
						searchproduct(hiddenarea.currentpage);
					} else {
						searchproduct();
					}
					
				}
			}		
			callAjax("/system/productcodeinsert.do", "post", "json", "false", param, savecallback) ;
			
		}
		
	}
	
		
	//정보조회 팝업
	function initpopup(object) {	
		
		if( object == "" || object == null || object == undefined) {
			
			productreg.detail_name ="" ;
			productreg.detail_code ="" ;
			productreg.action ="I" ;
			productreg.delbtnshow = false ;
			

			//$("#detail_code").removeAttr("readonly");			
			
			//$("#btnDelete").hide();			
			
		} else {			
			// {"notice_no":17,"loginID":"admin","writer":"변경","notice_title":"test","notice_date":"2023-05-08","notice_det":"test","file_name":null,"file_size":0,"file_nadd":null,"file_madd":null}
			productreg.detail_name = object.detail_name ;
			productreg.detail_code = object.detail_code;
			productreg.action ="U" ;
			productreg.delbtnshow = true ;
			
			//$("#detail_code").attr("readonly","readonly");			
			
			//$("#btnDelete").show();

		}
		
	}
	
	//상세조회 ,popuptype
    function fn_detailone(detail_code) {
    	
    	var param = {
    			detail_code : detail_code
    	}
    	console.log(param);
    	
    	var detailonecallback = function(returndata) {
    		console.log(  JSON.stringify(returndata)  );
    		
    		console.log( returndata.detailproductcode.detail_code);
    		    		
    			initpopup(returndata.detailproductcode);
        		
        		gfModalPop("#productreg");
    		    		
    	}
    	
    	callAjax("/system/detailproductcode.do", "post", "json", "false", param, detailonecallback) ;
    }
	//파일 미첨부 끝
    
</script>

</head>
<body>
<form id="myForm" action=""  method="">

	<div id="hiddenarea">
		<input type="hidden" name="action" id="action" value="">
		<input type="hidden" name="loginId" id="loginId" value="${loginId}">
		<input type="hidden" name="userNm" id="userNm" value="${userNm}">
		<input type="hidden" name="noticeno" id="noticeno" value="">
		<input type="hidden" name="currentpage" id="currentpage" value="" v-model="currentpage">
		<input type="hidden" name="ssearchname" id="ssearchname" value="" v-model="ssearchname">
		<input type="hidden" name="scpage" id="scpage" value="" v-model="scpage">
		<input type="hidden" name="spageSize" id="spageSize" value="" v-model="spageSize">
	</div>
	
	
	<!-- 모달 배경 -->
	<div id="mask"></div>

	<div id="wrap_area">

		<input type="hidden" name="clickBtn" id="clickBtn" v-model="clickBtn">
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
							  대분류명 <input type="text" id="searchname" name="searchname" v-model="searchname"/>                               					   
							   <a class="btnType blue" href="" id="btnSearch" name="btn" ><span>검색</span></a>
							</span>
						</p>
						<div align="right">						
						<a class="btnType blue" @click="javascript:fn_openpopup();" name="modal"><span>등록</span></a>						
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
								<template v-if="prodlistcnt == 0">
	                            	<tbody>
					               		<tr>
											<td colspan="5">데이터가 존재하지 않습니다.</td>
										</tr>
									</tbody>	
                                </template>
                                <template v-else>
									<tbody id="productlist" v-for="(list,item) in prodlist ">
										<tr @click="grpdetail(list.detail_code)">
											<%-- <td><a href="javascript:fn_detailone('${list.detail_code}')">${list.detail_name}</a></td> --%>										
											<td>{{list.detail_name}}</td>										
											<td>{{list.detail_code}}</td>
										</tr>
									</tbody>
								</template>
							</table>
						</div>
	
						<div class="paging_area"  id="prodPagination" v-html="prodPagination"> </div>
						
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
							<td><input type="text" class="inputTxt p100" name="detail_name" id="detail_name" v-model="detail_name"/></td>
							<th scope="row">제품 대분류코드<span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" name="detail_code" id="detail_code" v-model="detail_code"/></td>
						</tr>						
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">				
					<a href="" class="btnType blue" id="btnSave" name="btn"><span>등록</span></a> 
					<a href="" class="btnType blue" id="btnDelete" name="btn" v-show="delbtnshow"><span>삭제</span></a>				
					<a href=""	class="btnType gray"  id="btnClose" name="btn"><span>닫기</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
</form>
</body>
</html>