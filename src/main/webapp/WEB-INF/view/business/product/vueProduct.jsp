<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt"%>
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
        var check = /^[0-9]+$/;
        
        var vuearea;
    	var hiddenarea;
    	var insertProduct;
    	
		/* onload 이벤트  */ 
		$(function() {
			
			init();
			comcombo("lcategory_cd", "lcategory_cd", "sel", "selvalue");
			console.log(" vuearea.lcategory_cd =" + vuearea.lcategory_cd);
			
			if(vuearea.lcategory_cd == null || vuearea.lcategory_cd == ""){
			//if(true){
				console.log("zzz");
				vuearea.mcategory_cd_html = "<option value=''>제품대분류를 선택해 주세요.</option>";
				//vuearea.mcategory = "<option value=''>제품대분류를 선택해 주세요.</option>";
				//$("#mcategory_cd").empty().append("<option>제품대분류를 선택해 주세요.</option>");
			}else{
				console.log("zzz2");
				//vuearea.mcategory_cd_html = ''
			}
			
			vuearea.fn_productSearch();
			
	    });
		
		function init(){
			vuearea = new Vue({
				el : "#wrap_area",
				data : {
					pageSize : 5,
					pageBlockSize : 5,
					
					grouplist :[],
					totalCnt : '',
					productPagination : '',
					
					lcategory_cd : '',
					mcategory_cd : '',
					
					searchKey : '',
					
					mcategory_cd_html : '',
					addStock : [],
										
				},
				methods : {					
					fn_productSearch : function(){
						hiddenarea.lcategory_cd = vuearea.lcategory_cd;
						hiddenarea.mcategory_cd = vuearea.mcategory_cd;
					
						productSearch();						
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
					
					lcategory_cd : '',
					mcategory_cd : '',
					searchKey : '',
					
				},
				methods : {
					
				}
			}),
			
			newplan = new Vue({
				el : "#insertProduct",
				data : {
					newclient : '',
					newlcategory : '',
					newmcategory : '',
					newproduct : '',
					newnumber : '',
					
					popLcategory_cd : '',
					popMcategory_cd : '',
					addMcategory_cd : '',
					popProduct_cd : '',
					addProduct_cd : '',
					insertPrice : '',
					insertStockPop : '',

					newMcategory_cd : '',
					newProduct_cd : '',
					newAddMcategory_cd : '',
					newAddProduct_cd : '',

					newMcategory_cdflag : '',
					newProduct_cdflag : '',
					newAddMcategory_cdflag : '',
					newAddProduct_cdflag : '',
					action : '',					
					
					popMcategory_cd_html : '',
					popProduct_cd_html : '',
				},
				methods : {
					
				}
			})
		}	
		
		/* 제품리스트 검색 및 조회 */
		//function productSearch(cpage, lcategory_cd, mcategory_cd){
		function productSearch(cpage){
			
			//$("#searchKey").val("search");
			//vuearea.searchKey = "search";
			//hiddenarea.searchKey = vuearea.searchKey;
			
			cpage = cpage || 1;
			//$("#cpage").val(cpage);
			
			//lcategory_cd = lcategory_cd || $("#lcategory_cd").val();
			//mcategory_cd = mcategory_cd || $("#mcategory_cd").val();
			
			//hiddenarea.lcategory_cd = vuearea.lcategory_cd;
			//hiddenarea.mcategory_cd = vuearea.mcategory_cd;
			
			// var navi = [hiddenarea.lcategory_cd, hiddenarea.mcategory_cd];
			
			var param = {
					pageSize : pageSize,
					cpage : cpage,
					
					lcategory_cd : hiddenarea.lcategory_cd,
					mcategory_cd : hiddenarea.mcategory_cd
			}
			var productListCallback = function(data){
				
				vuearea.grouplist = data.productList;
				vuearea.totalCnt = data.totalCnt;
				

				//$("#productList").empty().append(data);
				
				//var totalCnt = $("#totalCnt").val();
				
				var productPagination = getPaginationHtml(cpage, data.totalCnt, pageSize, pageBlockSize, 'productSearch');
				
				console.log(productPagination);
				vuearea.productPagination = productPagination;

				//$("#productPagination").empty().append(paginationHtml);
			}
			
			callAjax("/business/vueProductList.do", "post", "json", "false", param, productListCallback);
		};
		
		/* 팝업창 닫기 */
		function closePop() {
			gfCloseModal();
			
			newplan.popLcategory_cd = '';
			newplan.popMcategory_cd = '';
			newplan.addMcategory_cd = '';
			newplan.popProduct_cd = '';
			newplan.addProduct_cd = '';
			newplan.newMcategory_cd = '';
			newplan.newProduct_cd = '';
			newplan.newAddMcategory_cd = '';
			newplan.newAddProduct_cd = '';
			newplan.insertPrice = '';
			newplan.insertStockPop = '';
		}
		
		/* 중분류 SelectBox */
		function midProductSel() {
			console.log(newplan.popLcategory_cd);
			
			if(vuearea.lcategory_cd != null && vuearea.lcategory_cd != ""){
				midProductList(vuearea.lcategory_cd, "mcategory_cd", "sel", "selvalue");
			} else {
				vuearea.mcategory_cd_html = "<option value=''>제품대분류를 선택해 주세요.</option>";
				//$("#mcategory_cd").empty().append("<option>제품대분류를 선택해 주세요.</option>");
			}
			if(newplan.popLcategory_cd != null && newplan.popLcategory_cd != "") {
				midProductList(newplan.popLcategory_cd, "popMcategory_cd", "sel", "selvalue");
				
				newplan.newMcategory_cdflag = true;
				newplan.newProduct_cdflag = false;
				newplan.newAddMcategory_cdflag = true;
				newplan.newAddProduct_cdflag = false;
				//$("#newMcategory_cd").show();
				//$("#newProduct_cd").hide();
				//$("#newAddMcategory_cd").show();
				//$("#newAddProduct_cd").hide();
			} else {
				
				newplan.popMcategory_cd_html = "<option>제품대분류를 선택해 주세요.</option>";
				newplan.newMcategory_cdflag = false;
				newplan.newProduct_cdflag = false;
				newplan.newAddMcategory_cdflag = false;
				newplan.newAddProduct_cdflag = false;
			
				//$("#popMcategory_cd").empty().append("<option>제품대분류를 선택해 주세요.</option>");
				//$("#newMcategory_cd").hide();
				//$("#newProduct_cd").hide();
				//$("#newAddMcategory_cd").hide();
				//$("#newAddProduct_cd").hide();
			}
		}
		
		/* 제품 SelectBox */
		function productSel() {
			//console.log($("#popMcategory_cd").val());
			console.log(newplan.popMcategory_cd);
			
			if(newplan.popMcategory_cd != null || newplan.popMcategory_cd != "") {
				productList(newplan.popLcategory_cd, newplan.popMcategory_cd, "popProduct_cd", "sel", "selvalue");
				newplan.newMcategory_cdflag = false;
				newplan.newProduct_cdflag = true;
				newplan.newAddMcategory_cdflag = false;
				newplan.newAddProduct_cdflag = true;
				
				//$("#newMcategory_cd").hide();
				//$("#newProduct_cd").show();
				//$("#newAddMcategory_cd").hide();
				//$("#newAddProduct_cd").show();
			} else {
				vuearea.popProduct_cd_html = "<option>제품중분류를 선택해 주세요.</option>";
				newplan.newMcategory_cdflag = false;
				newplan.newProduct_cdflag = false;
				newplan.newAddMcategory_cdflag = false;
				newplan.newAddProduct_cdflag = false;
				
				//$("#popProduct_cd").empty().append("<option>제품중분류를 선택해 주세요.</option>");
				//$("#newMcategory_cd").hide();
				//$("#newProduct_cd").hide(); 
				//$("#newAddMcategory_cd").hide();
				//$("#newAddProduct_cd").hide();
			}
		}
		
		/* 제품 재고수량 추가 */
		function insertStock(product_no, addStock) {
			
			console.log("product_no : " + product_no + " addStock : " + addStock);
			//if(!check.test($("#"+addStock).val())){
			if(!check.test(addStock)){
				alert("숫자만 기입해 주세요.");
				$("#"+addStock).val("");
			} else {
				console.log("받은 데이터 product_no : "+product_no);
				console.log("입력받은 제품 수량 : "+addStock);
				var param = {
						product_no : product_no,
						stock : addStock,
				}
				
				var insertStockCallback = function(data) {
					console.log(data);
					if(data.result == "SUCCESS"){
						alert("추가되었습니다.");
						//productSearch($("#cpage").val());
						productSearch();
						vuearea.addStock = [];
					}
				}
				
				callAjax("/business/vueProductInsertStock.do", "post", "json", "false", param, insertStockCallback);
				}
		}
		
		/* 금액 한글표기 */
		function convertToKoreanNumber(num) {
			  var result = '';
			  var digits = ['영','일','이','삼','사','오','육','칠','팔','구'];
			  var units = ['', '십', '백', '천', '만', '십만', '백만', '천만', '억', '십억', '백억', '천억', '조', '십조', '백조', '천조'];
			  
			  var numStr = num.toString(); // 문자열로 변환
			  var numLen = numStr.length; // 문자열의 길이
			  
			  for(var i=0; i<numLen; i++) {
			    var digit = parseInt(numStr.charAt(i)); // i번째 자릿수 숫자
			    var unit = units[numLen-i-1]; // i번째 자릿수 단위
			    
			    // 일의 자리인 경우에는 숫자를 그대로 한글로 변환
			    if(i === numLen-1 && digit === 1 && numLen !== 1) {
			      result += '일';
			    } else if(digit !== 0) { // 일의 자리가 아니거나 숫자가 0이 아닐 경우
			      result += digits[digit] + unit;
			    } else if(i === numLen-5) { // 십만 단위에서는 '만'을 붙이지 않습니다.
			      result += '만';
			    }
			  }
			  
			  return result;
			}
		newplan.popLcategory_cd
		/* 제품 대,중,소등록 */
		function newProductTypesInsert(action){
			var param = {
					
					lcategory_cd : newplan.popLcategory_cd,
					mProduct_name : newplan.addMcategory_cd,
					mProduct_cd : newplan.popMcategory_cd,
					product_no : newplan.popProduct_cd,
					product_name : newplan.addProduct_cd,
					action : action
					
					//lcategory_cd : $("#popLcategory_cd").val(),
					//mProduct_name : $("#addMcategory_cd").val(),
					//mProduct_cd : $("#popMcategory_cd").val(),
					//product_no : $("#popProduct_cd").val(),
					//product_name : $("#addProduct_cd").val(),
					//action : action
			}
			var newProductTypesInsertCallback = function(data) {
				console.log(data);
				if(data.result == 'SUCCESS'){
					newplan.addMcategory_cd = '';
					newplan.addProduct_cd = '';
					//$("#addMcategory_cd").val("");
					//$("#addProduct_cd").val("");
					alert('등록에 성공했습니다.');
					midProductSel();
					productSel();
				} else if(data.result == 'FAILETYPE'){
					alert('중복되는 중분류가 존재합니다.');
					newplan.addMcategory_cd = '';
					//$("#addMcategory_cd").val("");
				} else if(data.result == 'FAILEPRODUCT') {
					alert('중복되는 제품이 존재합니다.');
					newplan.addProduct_cd = '';
					//$("#addProduct_cd").val("");
				} else {
					alert('등록에 실패했습니다.');
				}
			}
			callAjax("/business/vuenewProductTypesInsert.do", "post", "json", "false", param, newProductTypesInsertCallback);
		}		
		
		/* 제품등록 */
		function insertProduct(){
			
			comcombo("lcategory_cd", "popLcategory_cd", "sel", "selvalue");
			newplan.newMcategory_cdflag = false
			newplan.newProduct_cdflag = false
			newplan.newAddMcategory_cdflag = false
			newplan.newAddProduct_cdflag = false
			
			//$("#newMcategory_cd").hide();
			//$("#newProduct_cd").hide();
			//$("#newAddMcategory_cd").hide();
			//$("#newAddProduct_cd").hide();
			
			//if($("#popLcategory_cd").val() == null){
			if(newplan.popLcategory_cd == null){
				newplan.popMcategory_cd_html = "<option>제품대분류를 선택해 주세요.</option>";
				//$("#popMcategory_cd").empty().append("<option>제품대분류를 선택해 주세요.</option>");
			}
			
			//if($("#popMcategory_cd").val() == "제품대분류를 선택해 주세요."){
			if(newplan.popMcategory_cd == "제품대분류를 선택해 주세요."){
				newplan.popProduct_cd_html = "<option>제품중분류를 선택해 주세요.</option>";
				//$("#popProduct_cd").empty().append("<option>제품중분류를 선택해 주세요.</option>");
			}
			
			gfModalPop("#insertProduct");
		}
		
		/* 제품등록POP 등록 버튼 */
		function productSave() {
			console.log(newplan.insertStockPop);
			//console.log($("#insertStockPop").val());
			
			var detaileParam = {
					lcategory_cd : newplan.popLcategory_cd,
					mcategory_cd : newplan.popMcategory_cd,
					product_no : newplan.popProduct_cd,
			}
			
			var productDetaileCallback = function(data) {
				console.log(data);
				
				if(data.productDetaile != null && data.productDetaile.price != 0 ) {
					alert("이미 등록된 제품입니다.");
				} else {
					if( newplan.popLcategory_cd == "" ){
						alert("제품대분류를 선택해 주세요.");
					} else if(newplan.popMcategory_cd == "제품대분류를 선택해 주세요." || newplan.popMcategory_cd == "") {
						alert("제품중분류를 선택해 주세요.");
					} else if(newplan.popProduct_cd == ""){
						alert("제품을 선택해 주세요.");
					} else if(newplan.insertPrice == ""){
						alert("단가를 입력해 주세요.");
						document.getElementById('insertPrice').focus();
					}else if(newplan.insertStockPop == ""){
						alert("수량을 입력해 주세요.");
						document.getElementById('insertStockPop').focus();
					} else if(!check.test(newplan.insertPrice)){
						 alert("숫자만 기입해 주세요.");
						 //$("#insertPrice").val("");
					} else if(!check.test($("#insertStockPop").val())){
						alert("숫자만 기입해 주세요.");
						 //$("#insertStockPop").val(""); 
					} else {
						
						var param = {
								lcategory_cd : newplan.popLcategory_cd,
								mcategory_cd : newplan.popMcategory_cd,
								product_no : newplan.popProduct_cd,
								price : newplan.insertPrice,
								insertStock : newplan.insertStockPop,
								
								//lcategory_cd : $("#popLcategory_cd").val(),
								//mcategory_cd : $("#popMcategory_cd").val(),
								//product_no : $("#popProduct_cd").val(),
								//price : $("#insertPrice").val(),
								//insertStock : $("#insertStockPop").val(),
						}
							
						var productSaveCallback = function(result) {
							if(result.result == 'SUCCESS'){
								alert(data.vueProductDetaile.product_name+"을 등록했습니다.");	
								//gfCloseModal();
								closePop();
								productSearch();
							}
						}
						callAjax("/business/vueProductInsertStock.do", "post", "json", "false", param, productSaveCallback);
					}
				}
			}
			
			callAjax("/business/vueProductDetaile.do", "post", "json", "false", detaileParam, productDetaileCallback);
						
			
		}
		
		
</script>

</head>
<body>
<form id="myForm" action=""  method="">
<div v-model="hidden">
<input type="hidden" id="cpage" name="cpage" value =""/>
<input type="hidden" id="searchKey" name="searchKey" value="" v-model="searchKey"/>	
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
							<span class="btn_nav bold">영업</span> <span class="btn_nav bold">제품관리</span>
							<a href="../business/vueProduct.do" class="btn_set refresh">새로고침</a>
						</p> 

						<p class="conTitle">
							<span>제품관리</span> <span class="fr"> 
							제품대분류
							<select id="lcategory_cd" name="lcategory_cd" v-model="lcategory_cd" @change="midProductSel()"></select>
							제품중분류
							<select id="mcategory_cd" name="mcategory_cd" v-model="mcategory_cd" v-html="mcategory_cd_html"></select>
							<a	class="btnType blue" href="" @click.prevent="fn_productSearch()" name="modal"><span>조회</span></a>
							</span>
						</p>
							<a	class="btnType blue" href="" @click.prevent="insertProduct()"name="modal" style="margin-left: 905px;"><span>제품등록</span></a>
						<div class="divComGrpCodList">
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="10%">
									<col width="15%">
									<col width="15%">
									<col width="30%">
									<col width="10%">
									<col width="10%">
									<col width="10%">
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">제품번호</th>
										<th scope="col">제품대분류</th>
										<th scope="col">제품중분류</th>
										<th scope="col">제품이름</th>
										<th scope="col">단가</th>
										<th scope="col">수량</th>
										<th scope="col">추가수량</th>
									</tr>
								</thead>
								
								<template v-if="totalCnt == 0">	
									<tbody>							
										<tr>
											<td colspan="7">데이터가 존재하지 않습니다.</td>
										</tr>
									</tbody>								
								</template>
								
								<template v-else>
									<tbody id="productList" v-for = "(list,index) in grouplist">
												<tr>
													<td>{{list.product_no}}</td>
													<td>{{list.lcategory_name}}</td>
													<td>{{list.mcategory_name}}</td>
													<td>{{list.product_name}}</td>
													<td>{{list.price}}원</td>
													<td>{{list.stock}}EA</td>
													<td style="display: flex;">
													<input type="text" id="addStock${status.index}" name="addStock" v-model="addStock[index]" style="width: 80px; text-align-last: center;"/>
													<button type="button" @click="insertStock(list.product_no,addStock[index])" style="width: 50px;">추가</button>
												</td>
												</tr>
									</tbody>	
								 
									<%-- <c:forEach items="${productList}" var="list" varStatus="status">
										<tr>
												<td style="font-weight: bold;">${list.product_no}</td>
												<td style="font-weight: bold;">${list.lcategory_name}</td>
												<td style="font-weight: bold;">${list.mcategory_name}</td>
												<td style="font-weight: bold;">${list.product_name}</td>
												<td style="font-weight: bold;"><fmt:formatNumber value="${list.price}" pattern="#,###" />원</td>
												<td style="font-weight: bold;">${list.stock}EA</td>
												<td style="display: flex;">
													<input type="text" id="addStock${status.index}" name="addStock" style="width: 80px; text-align-last: center;"/>
													<button type="button" onclick="insertStock('${list.product_no}','addStock${status.index}')" style="width: 50px;">추가</button>
												</td>
										</tr>
									</c:forEach> --%>							 	
							 	</template> 					 	
								
							</table>
						</div>
	
						<div class="paging_area"  id="productPagination" v-html="productPagination"> </div>
						
					</div> <!--// content -->
					
					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>
	 <!-- 모달팝업 ==  신규 등록  -->
		   <div id="insertProduct" class="layerPop layerType2"  style="width: 800px;">
		      <dl>
		         <dt>
		            <div id="divtitle" style="color:white">제품등록</div>
		         </dt>
		         <dd class="content">
		            <!-- s : 여기에 내용입력 -->
		             <table class="col" style="background-color: aliceblue">
		               <caption>caption</caption>
		               <colgroup>
		                  <col width="25%">
                           <col width="25%">
                           <col width="25%">
                           <col width="25%">
		               </colgroup>
					   <thead>
					   		<tr>
								<th scope="col">제품대분류</th>
									<td><select id="popLcategory_cd" v-model="popLcategory_cd" @change="midProductSel()"></select></td>
						   		</tr>
					   		<tr>
								<th scope="col">제품중분류</th>
									<td><select id="popMcategory_cd" v-model="popMcategory_cd" @change="productSel()" v-html="popMcategory_cd_html"></select></td>
								<th scope="col" id="newMcategory_cd" v-model="newMcategory_cd" v-show="newMcategory_cdflag" >신규중분류등록</th>
									<td style="display: flex;" id="newAddMcategory_cd" v-model="newAddMcategory_cd" v-show="newAddMcategory_cdflag">
										<input type="text" id="addMcategory_cd" name="addMcategory_cd" v-model="addMcategory_cd" style="width: 125px; height: 30px; text-align-last: center; margin-top: 3px;"/>
										<button type="button" @click="newProductTypesInsert('M')" style="width: 50px;">추가</button>
								</td>
					   		</tr>
					   		<tr>
								<th scope="col">제품</th>
									<td><select id="popProduct_cd" v-model="popProduct_cd" v-html="popProduct_cd_html"></select></td>
								 <th scope="col" id="newProduct_cd" v-model="newProduct_cd" v-show="newProduct_cdflag">신규제품등록</th>
									<td style="display: flex;" id="newAddProduct_cd" v-model="newAddProduct_cd" v-show="newAddProduct_cdflag">
										<input type="text" id="addProduct_cd" name="addProduct_cd" v-model="addProduct_cd" style="width: 125px; height: 30px; text-align-last: center; margin-top: 3px;"/>
										<button type="button" @click="newProductTypesInsert('S')" style="width: 50px;">추가</button>
								 </td>
					   		</tr>
					   		<tr>
								<th scope="col">단가</th>
									<td >
										<input type="text" id="insertPrice" name="insertPrice" v-model="insertPrice" style="width: 150px; height: 30px; text-align-last: center; font-weight: bold; font-size: initial;"/>
										<span style="font-weight: bold; font-size: initial">원</span>
								</td>
								<th scope="col">수량</th>
									<td >
										<input type="text" id="insertStockPop" name="insertStockPop" v-model="insertStockPop" style="width: 150px; height: 30px; text-align-last: center; font-weight: bold; font-size: initial;"/>
										<span style="font-weight: bold; font-size: initial">EA</span>
								</td>
					   		</tr>
						</thead>
						</tbody>
						</table> 
			            <div class="btn_areaC mt30">
			               <a href="javascript:productSave();" class="btnType blue" id="btnUpdateOem" name="btn"><span>등록</span></a> 	
			               <a href="javascript:closePop();"   class="btnType gray"  id="btnCloseOem" name="btn"><span>취소</span></a>
			            </div>
			         </dd>
			      </dl>
			      <a href="javascript:closePop();" class="closePop"><span class="hidden">닫기</span></a>
			   </div>
			   <!-- 모달 끝 -->
</form>
</body>
</html>