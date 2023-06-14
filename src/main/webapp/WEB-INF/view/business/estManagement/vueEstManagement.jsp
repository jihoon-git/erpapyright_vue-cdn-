<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>견적서 작성 및 조회</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<script type="text/javascript">
	var vuearea;
	var hiddenarea;
	var modalEstdetail;
	var estreg;

	/** OnLoad event */ 
	$(function() {
		
		//vue init 등록
		init();
		
		// 견적서 목록 조회
		vuearea.fn_searchest();
		
		// 버튼 이벤트 등록
		fRegisterButtonClickEvent();
		
	});
	
	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();		//이후의 예약 이벤트를 모두 소멸시킴

			var btnId = $(this).attr('id');	//해당 버튼의 아이디를 꺼내라

			switch (btnId) {
			case 'btnClick' :
				vuearea.clickBtn=''; //검색후 검색한것 초기화 용도
				vuearea.clickBtn='Z';
					searchest();
				break;
			case 'btnClose' :
				gfCloseModal();
				break;
		    case 'btnDelete' :
				fn_delete();
				break;	
			}
		});
	}
	
	//vue init 등록
	function init(){
		
		// 견적서 목록
		vuearea = new Vue({
			el : "#wrap_area",
			data :{
				pageSize : 5,
				pageBlockSize : 5,
				clientNameSearch : '',
				consdate : '',
				conedate : '',
				estlist : [],
				estlistcnt : '',
				estPagination : '',
				clickBtn : '',
			},
			methods : {
				fn_searchest : function(){
					searchest();
				},
				fn_estdetail : function(no){
					estdetail(no);
				},
			},
			filters:{
			  comma : function(val){
			  	return String(val).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			  }
			}
		}),
		
		// hidden값 모음
		hiddenarea = new Vue({
			el : "#hiddenarea",
			data : {
				contractno : '',
				product_price : '',
				product_stock : '',
			},
		}),
		
		// 상세조회 모달
		modalEstdetail = new Vue({
			el : "#modalEstdetail",
			data : {
				detail_clnm : '',
				detail_cnm : '',
				detail_clno : '',
				detail_cno : '',
				detail_clmnm : '',
				detail_cmnm : '',
				detail_claddr : '',
				detail_caddr : '',
				detail_cldaddr : '',
				detail_cdaddr : '',
				detail_clmhp : '',
				detail_cmhp : '',
				detail_date : '',
				detail_nm : '',
				detail_price : '',
				detail_amt : '',
				detail_amt_price : '',
				detail_tax : '',
				detail_total : '',
			},
			methods : {
				close : function(){
					gfCloseModal();
				},
			},
			
		}),
		
		// 견적서 등록
		estreg = new Vue({
			el : "#estreg",
			data : {
				clname : '',
				categoryl : '',
				categorym_model : '',
				productno_model : '',
				product_amt_model : '',
				selectl : true,
				categorym : false,
				selectm : true,
				productno : false,
				hidden_amt : true,
				product_amt : false,
			},
			methods : {
				fn_estsave : function(){
					fn_Estsave();
				},
			}
		})
	}
	
	// 견적서 목록 조회
	function searchest(cpage) { // 현재 page 받기
		cpage = cpage || 1;		// 현재 page가 undefined 면 1로 셋팅	
				
		// param과 callback 지정
		if(vuearea.clickBtn=='Z'){
			
			if(vuearea.consdate!= '' && vuearea.conedate!= ''){
				if(vuearea.consdate > vuearea.conedate){
					alert("종료일이 시작일 보다 빠를 수 없습니다.");
					return false;
				}
			}

			var param = { // 컨트롤러로 넘겨줄 이름 : 보내줄값
					clientNameSearch : vuearea.clientNameSearch,
					consdate : vuearea.consdate,
					conedate : vuearea.conedate,
					pageSize : vuearea.pageSize,
					cpage : cpage,
			}
		}else{
			var param = { // 컨트롤러로 넘겨줄 이름 : 보내줄값

					pageSize : vuearea.pageSize,
					cpage : cpage,
			}
			
		}
		
		var listcallback = function(returndata){
			console.log(JSON.stringify(returndata));
			vuearea.estlist = returndata.estmanagementlist;
			vuearea.estlistcnt = returndata.cntestmanagementlist;

			console.log(vuearea.estlist);
			
			var paginationHtml = getPaginationHtml(cpage, returndata.cntestmanagementlist, vuearea.pageSize, vuearea.pageBlockSize, 'searchest');
			console.log("paginationHtml : " + paginationHtml);
			
			vuearea.estPagination = paginationHtml;
			
		}
		
		callAjax("/business/vueEstmanagementlist.do", "post", "json", "false", param, listcallback);
	} //searchest
	

	/* 견적서 상세조회 */
	function estdetail(contract_no) {
		
		var param = {
				contract_no : contract_no,
		}
		
		var detailcallback = function (returndata){
			console.log(  JSON.stringify(returndata) );
			
			readpopup(returndata.estdetail);
			
			gfModalPop("#modalEstdetail");
		}
		
		callAjax("/business/estdetail.do", "post", "json", false, param, detailcallback) ;
		
	} //est_detail
	
	/* 상세조회 팝업-읽기전용 */
	function readpopup(object) {

		
		modalEstdetail.detail_clnm = object.clnm;
		modalEstdetail.detail_cnm = object.cnm;
		modalEstdetail.detail_clno = object.clno;
		modalEstdetail.detail_cno = object.cno;
		modalEstdetail.detail_clmnm = object.clmnm;
		modalEstdetail.detail_cmnm = object.cmnm;
		modalEstdetail.detail_claddr = object.claddr;
		modalEstdetail.detail_caddr = object.caddr;
		modalEstdetail.detail_cldaddr = object.cldaddr;
		modalEstdetail.detail_cdaddr = object.cdaddr;
		modalEstdetail.detail_clmhp = object.clmhp;
		modalEstdetail.detail_cmhp = object.cmhp;
		modalEstdetail.detail_date = object.contract_date;
		modalEstdetail.detail_nm = object.product_name;
		modalEstdetail.detail_price = object.price.toLocaleString();
		modalEstdetail.detail_amt = object.product_amt+' EA';
		modalEstdetail.detail_amt_price = object.amt_price.toLocaleString();
		modalEstdetail.detail_tax = object.tax.toLocaleString();
		modalEstdetail.detail_total = object.total_price.toLocaleString();
		

	} // readpopup
	
	/* 신규등록 팝업  */
	function fn_openpopup() {
		clientSelectBox("client_no", "clname", "all", "selvalue");
		comcombo("lcategory_cd", "categoryl", "sel", "selvalue");
		
		estreg.selectl  =true;
		estreg.categorym =false;
		estreg.selectm  =true;
		estreg.productno  =false;
		estreg.hidden_amt =true;
		estreg.product_amt = false;
	
		gfModalPop("#estreg");
		
	} //fn_openpopup
	
	/* 대분류 change하면 중분류 호출하는 함수 */
	function lselectChange(){
		
		console.log(estreg.categoryl);
		
		/*대-중-제품-수량 입력창에서 대분류를 다른 값으로 선택시 중,제품,수량 값 선택창으로 show*/
 		if (estreg.categoryl=="") {
 			
 			estreg.selectl  =true;
 			estreg.categorym =false;
 			estreg.selectm  =true;
 			estreg.productno  =false;
 			estreg.hidden_amt =true;
 			estreg.product_amt = false;
 			
 			
		} else{
			
 			estreg.selectl  =false;
 			estreg.categorym =true;
 			estreg.selectm  =false;
 			estreg.productno  =true;
 			estreg.hidden_amt =false;
 			estreg.product_amt = true;
 			
		}
 			midProductList(estreg.categoryl, "categorym", "sel", "selvalue");
	} //lselectChange
	
	/* 중분류 change하면 제품 호출하는 함수 */
	function mselectChange(){
		console.log(estreg.categorym);
 		if (estreg.categorym_model=="") {
 			
 			estreg.selectm  =true;
 			estreg.productno  =false;
 			estreg.hidden_amt =true;
 			estreg.product_amt = false;
 			
		} else{
 			estreg.selectm  =false;
 			estreg.productno  =true;
 			estreg.hidden_amt =false;
 			estreg.product_amt = true;	

		}
 		
 		productList(estreg.categoryl, estreg.categorym_model, "productno", "sel", "selvalue");
			
	} //mselectChange

	
	/* 제품 선택시 onchange해서 값저장하는 함수  */
	function saveChange(){

		
 		if (estreg.productno_model == "") {
 			estreg.hidden_amt =true;
 			estreg.product_amt = false;
		} else{
 			estreg.hidden_amt =false;
 			estreg.product_amt = true;	
		}
 		
		var param = { // 컨트롤러로 넘겨줄 이름 : 보내줄값
				product_no : estreg.productno_model
			} // {} json 형태
		
		var changecallback = function(returndata){
			console.log(  JSON.stringify(returndata) );
			hiddenarea.product_stock = returndata.savechange.stock; // 남은수량 확인용으로 저장
			
			/* 제품선택시 남은수량이 0인경우 alert 후 초기화 */
			if(hiddenarea.product_stock == 0){
				alert('선택하신 제품이 품절되었습니다. \n다른 제품을 선택해주세요.')
				
				fn_openpopup();
				
			}else{
				hiddenarea.product_price = returndata.savechange.price;
				hiddenarea.product_stock = returndata.savechange.stock;
			}
		}
		callAjax("/business/savechange.do", "post", "json", "false", param, changecallback);
	} //saveChange
	
	/* 남은수량 체크 */
	function remainStock(){
		var minusstock = estreg.product_amt_model;
		var currentstock = hiddenarea.product_stock;
		var amtstock = (currentstock-minusstock);
		
		if(amtstock < 0){
			alert('선택하신 물품이 작성한 남은 수량보다 적습니다. \n현재 남은 수량 :' + currentstock)
			
			estreg.product_amt_model='';
			
			fn_openpopup();
		}
	}//remainStock
	
	/* 저장버튼 클릭시 저장할 값  */
    function fn_Estsave(){
		if(estreg.clname == 0){
			alert('거래처이름을 선택해주세요.');
			fn_openpopup();
		}else if(estreg.categoryl == 0){
			alert('대분류를 선택해주세요.');
			fn_openpopup();
		}else if(estreg.categorym_model == 0){
			alert('중분류를 선택해주세요.');
			fn_openpopup();
		}else if(estreg.productno_model == 0){
			alert('제품을 선택해주세요.');
			fn_openpopup();
		}else if(estreg.product_amt_model == 0){
			alert('수량을 작성해주세요.');
			fn_openpopup();
		}else{
    	
	    	Estsave();
		}
	} //fn_Estsave
	
	/* 견적서 저장 */
	function Estsave() {
		
		var param = {
				
				client_no : estreg.clname,
				product_no : estreg.productno_model,
				lcategory_cd : estreg.categoryl,
				mcategory_cd : estreg.categorym_model,
				product_amt : estreg.product_amt_model,
				price : hiddenarea.product_price
		}
		
		var savecallback = function(returndata) {
						
			console.log(  JSON.stringify(returndata) );
			
			if(returndata.result == "SUCCESS") {
				alert("저장 되었습니다.");
				gfCloseModal();
				searchest();
			}
		}
		
		callAjax("/business/estsave.do", "post", "json", "false", param, savecallback) ;
	} //Estsave
	
</script>

</head>
<body>
<form id="myForm" action=""  method="">
	<div id="hiddenarea">
		<input type="hidden" name="contractno" id="contractno" v-model="contractno">
		<input type="hidden" name="product_price" id="product_price" v-model="product_price">
		<input type="hidden" name="product_stock" id="product_stock" v-model="product_stock">
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
							<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a> <span
								class="btn_nav bold">영업</span> <span class="btn_nav bold">견적서 작성 및 조회
								</span> <a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>견적서 작성 및 조회</span> <span class="fr"> 
							   거래처
							   <input type="text" id="clientNameSearch" name="clientNameSearch"	v-model="clientNameSearch"/>
                               <input type="date" id="consdate" name="consdate" v-model="consdate"/>
                               <input type="date" id="conedate" name="conedate" v-model="conedate"/>
                               <a	class="btnType blue" href="" id=btnClick name="btn" ><span>조회</span></a>						   
							   <a	class="btnType blue" @click="javascript:fn_openpopup();" name="modal"><span>신규작성</span></a>
							</span>
						</p>
						
						<div class="divComGrpCodList">
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="10%">
									<col width="20%">
									<col width="20%">
									<col width="10%">
									<col width="10%">
									<col width="10%">
									<col width="10%">
									<col width="10%">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">작성일</th>
										<th scope="col">거래처</th>
										<th scope="col">제품이름</th>
										<th scope="col">단가</th>
										<th scope="col">수량</th>
										<th scope="col">공급가액</th>
										<th scope="col">부가세</th>
										<th scope="col">합계</th>
									</tr>
								</thead>
								
								<template v-if="estlistcnt == 0">
									<tbody>	
										<tr>
											<td colspan="8">데이터가 존재하지 않습니다.</td>
										</tr>
									</tbody>
								</template>
								<template v-else>
									<tbody id="listEst" v-for="(list, item) in estlist">
										<tr @click="fn_estdetail(list.contract_no)">
											<td>{{ list.contract_date }}</td>
											<td>{{ list.client_name }}</td>
											<td>{{ list.product_name }}</td>
											<td>{{ list.price | comma }} 원</td>
											<td>{{ list.product_amt }} EA</td>
											<td>{{ list.amt_price | comma }} 원</td>
											<td>{{ list.tax | comma }} 원</td>
											<td>{{ list.total_price | comma }} 원</td>
										</tr>
									</tbody>
								 </template>
								
									<%-- <c:forEach items="${estmanagementlist}" var="list">
									<tr>
										<td><a href="javascript:est_detail('${list.contract_no}')">${list.contract_date}</a></td>
										<td>${list.client_name}</td>
										<td>${list.product_name}</td>
										<td><fmt:formatNumber value="${list.price}" type="number"/></td>
										<td>${list.product_amt} EA</td>
										<td><fmt:formatNumber value="${list.amt_price}" type="number"/></td>
										<td><fmt:formatNumber value="${list.tax}" type="number"/></td>
										<td><fmt:formatNumber value="${list.total_price}" type="number"/> 원</td>
									</tr>
								</c:forEach> --%>
							</table>
						</div>
	
						<div class="paging_area"  id="estPagination" v-html="estPagination"> </div>
						
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>
	
	<div id="estreg" class="layerPop layerType2" style="width: 600px;">
	     <dl>
			<dt>
				<strong>견적서 등록</strong>
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
							<th scope="row">거래처 이름 <span class="font_red">*</span></th>
							<td>
								<select name="clname" id="clname" v-model="clname"></select>
							</td>
						</tr>
						<tr>
							<th scope="row">대분류 <span class="font_red">*</span></th>
							<td>
								<select name="categoryl" id="categoryl" @change="lselectChange()" v-model="categoryl"></select>
							</td>
							<th scope="row">중분류 <span class="font_red">*</span></th>
							<td>
							<select name="selectl" id="selectl" v-show="selectl" >
								<option value="">대분류를 선택해주세요</option>
							</select>
								<select name="categorym" id="categorym" @change="mselectChange()" v-show="categorym" v-model="categorym_model"></select>
							</td>
						</tr>
						<tr>
							<th scope="row">제품 <span class="font_red">*</span></th>
							<td>
								<select name="selectm" id="selectm" v-show="selectm">
									<option value="" >중분류를 선택해주세요</option>
								</select>
								<select name="productno" id="productno" @change="saveChange()" v-show="productno" v-model="productno_model"></select>
							</td>
							<th scope="row">수량 <span class="font_red">*</span></th>
							<td>
								<input type="text" class="inputTxt p100" name="product_amt" id="product_amt" @change="remainStock()" v-show="product_amt" v-model="product_amt_model"/>
								<input type="text" class="inputTxt p100" name="hidden_amt" id="hidden_amt" v-show="hidden_amt" value="제품을 선택해주세요." readonly/>
							</td>
						</tr>
							
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSave" name="btn" @click.prevent="fn_estsave"><span>등록</span></a> 
					<a href=""	class="btnType gray"  id="btnClose" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	
	
	</div>
	
	<div id="modalEstdetail" class="layerPop layerType2" style="width: 600px;">
	     <dl>
			<dt>
				<strong>견적서 상세조회</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="120px">
						<col width="120px">
						<col width="120px">
						<col width="120px">
						<col width="120px">
						<col width="120px">
					</colgroup>

					<tbody>
						<tr>
							<th colspan="3" scope="row" name="detail_clnm" id="detail_clnm" v-model = "detail_clnm"> {{ detail_clnm }} </th>
							<th colspan="3" scope="row" name="detail_cnm" id="detail_cnm" v-model = "detail_cnm"> {{ detail_cnm }} </th>
						</tr>
						<tr>
							<th scope="row">사업자등록번호</th>
							<td colspan="2" name="detail_clno" id="detail_clno" v-model = "detail_clno">
							 {{ detail_clno }} 
							</td>
							<th scope="row">사업자등록번호</th>
							<td colspan="2" name="detail_cno" id="detail_cno" v-model = "detail_cno">
							{{ detail_cno }} 
							</td>
						</tr>

						<tr>
							<th scope="row">담당자</th>
							<td colspan="2" name="detail_clmnm" id="detail_clmnm" v-model = "detail_clmnm">
								{{ detail_clmnm }} 
							</td>
							<th scope="row">담당자</th>
							<td colspan="2" name="detail_cmnm" id="detail_cmnm" v-model = "detail_cmnm">
								{{ detail_cmnm }} 
							</td>
						</tr>
							
						<tr>
							<th scope="row">주소</th>
							<td colspan="2" name="detail_claddr" id="detail_claddr" v-model = "detail_claddr">
								{{ detail_claddr }}
							</td>
							<th scope="row">주소</th>
							<td colspan="2" name="detail_caddr" id="detail_caddr" v-model = "detail_caddr">
								{{ detail_caddr }}
							</td>
						</tr>
												
						<tr>
							<th scope="row">나머지주소</th>
							<td colspan="2" name="detail_cldaddr" id="detail_cldaddr" v-model = "detail_cldaddr">
								{{ detail_cldaddr }}
							</td>
							<th scope="row">나머지주소</th>
							<td colspan="2" name="detail_cdaddr" id="detail_cdaddr" v-model = "detail_cdaddr">
								{{ detail_cdaddr }}
							</td>
						</tr>
												
						<tr>
							<th scope="row">TEL</th>
							<td colspan="2" name="detail_clmhp" id="detail_clmhp" v-model = "detail_clmhp">
								{{ detail_clmhp }}
							</td>
							<th scope="row">TEL</th>
							<td colspan="2" name="detail_cmhp" id="detail_cmhp" v-model = "detail_cmhp">
								{{ detail_cmhp }}
							</td>
						</tr>
						
						<tr>
							<th scope="row">견적작성일</th>
							<td colspan="5" name="detail_date" id="detail_date" v-model = "detail_date">
								{{ detail_date }}
							</td>
						</tr>
						
						<tr>
							<th scope="col">제품명</th>
							<th scope="col">단가</th>	
							<th scope="col">수량</th>	
							<th scope="col">공급가액</th>
							<th scope="col">부가세</th>
							<th scope="col">합계</th>	
						</tr>
						
						<tr>
							<td name="detail_nm" id="detail_nm" v-model = "detail_nm">
								{{ detail_nm }}
							</td>
							<td name="detail_price" id="detail_price" v-model = "detail_price">
								{{ detail_price }}
							</td>
							<td name="detail_amt" id="detail_amt" v-model = "detail_amt">
								{{ detail_amt }}
							</td>
							<td name="detail_amt_price" id="detail_amt_price" v-model = "detail_amt_price">
								{{ detail_amt_price }}
							</td>
							<td name="detail_tax" id="detail_tax" v-model = "detail_tax">
								{{ detail_tax }}
							</td>
							<td name="detail_total" id="detail_total" v-model = "detail_total">
								{{ detail_total }}
							</td>
						</tr>
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href=""	class="btnType gray"  id="btnClose" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	
	
	</div>	
	
</form>
</body>
</html>