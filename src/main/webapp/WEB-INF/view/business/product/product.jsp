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
        var check = /^[0-9]+$/;
		/* onload 이벤트  */ 
		$(function() {
			
			 /* $("#insertPrice").change(function() {
				 if(!check.test($(this).val())){
			        alert("숫자만 기입해 주세요.");
					 $("#insertPrice").val("");
				 }
			 });
			
			 $("#insertStockPop").change(function() {
				 alert("dd");
				 if(!check.test($(this).val())){
			        alert("숫자만 기입해 주세요.");
					 $("#insertStockPop").val("");
				 }
			 }); */
			
			comcombo("lcategory_cd", "lcategory_cd", "sel", "selvalue");
			console.log($("#lcategory_cd").val());
			
			if($("#lcategory_cd").val() == null && $("#lcategory_cd").val() != ""){
				$("#mcategory_cd").empty().append("<option>제품대분류를 선택해 주세요.</option>");
			}
			
			productSearch();
			
	    });
		
		/* 제품리스트  */
		function fn_productList(cpage, lcategory_cd, mcategory_cd){
			
			cpage = cpage || 1;
			$("#cpage").val(cpage);
			var navi = [lcategory_cd,mcategory_cd];
			if($("#searchKey").val() == "search"){ 
				$("#lcategory_cd").val(lcategory_cd).prop("selected",true);
				$("#mcategory_cd").val(mcategory_cd).prop("selected",true);
			}
			var param = { 
					pageSize : pageSize,
					cpage : cpage,
					lcategory_cd : lcategory_cd,
					mcategory_cd : mcategory_cd
			}
			
			var productListCallback = function(data){

				$("#productList").empty().append(data);
				
				var totalCnt = $("#totalCnt").val();
				
				var paginationHtml = getPaginationHtml(cpage, totalCnt, pageSize, pageBlockSize, 'fn_productList', navi);

				$("#productPagination").empty().append(paginationHtml);
			}
			
			callAjax("/business/productList.do", "post", "text", "false", param, productListCallback);
			
		}
		
		/* 제품리스트 검색 및 조회 */
		function productSearch(cpage, lcategory_cd, mcategory_cd){
			
			$("#searchKey").val("search");
			cpage = cpage || 1;
			$("#cpage").val(cpage);
			
			lcategory_cd = lcategory_cd || $("#lcategory_cd").val();
			mcategory_cd = mcategory_cd || $("#mcategory_cd").val();
			
			var navi = [lcategory_cd,mcategory_cd];
			
			var param = {
					pageSize : pageSize,
					cpage : cpage,
					lcategory_cd : lcategory_cd,
					mcategory_cd : mcategory_cd
			}
			var productListCallback = function(data){

				$("#productList").empty().append(data);
				
				var totalCnt = $("#totalCnt").val();
				
				var paginationHtml = getPaginationHtml(cpage, totalCnt, pageSize, pageBlockSize, 'fn_productList', navi);
				
				console.log(paginationHtml);

				$("#productPagination").empty().append(paginationHtml);
			}
			
			callAjax("/business/productList.do", "post", "text", "false", param, productListCallback);
		};
		
		/* 팝업창 닫기 */
		function closePop() {
			gfCloseModal();
		}
		
		/* 중분류 SelectBox */
		function midProductSel() {
			console.log($("#popLcategory_cd").val());
			
			if($("#lcategory_cd").val() != null && $("#lcategory_cd").val() != ""){
				midProductList($("#lcategory_cd").val(), "mcategory_cd", "sel", "selvalue");
			} else {
				$("#mcategory_cd").empty().append("<option>제품대분류를 선택해 주세요.</option>");
			}
			if($("#popLcategory_cd").val() != null && $("#popLcategory_cd").val() != "") {
				midProductList($("#popLcategory_cd").val(), "popMcategory_cd", "sel", "selvalue");
				$("#newMcategory_cd").show();
				$("#newProduct_cd").hide();
				$("#newAddMcategory_cd").show();
				$("#newAddProduct_cd").hide();
			} else {
				$("#popMcategory_cd").empty().append("<option>제품대분류를 선택해 주세요.</option>");
				$("#newMcategory_cd").hide();
				$("#newProduct_cd").hide();
				$("#newAddMcategory_cd").hide();
				$("#newAddProduct_cd").hide();
			}
		}
		
		/* 제품 SelectBox */
		function productSel() {
			console.log($("#popMcategory_cd").val());
			
			if($("#popMcategory_cd").val() != null && $("#popMcategory_cd").val() != "") {
				productList($("#popLcategory_cd").val(), $("#popMcategory_cd").val(), "popProduct_cd", "sel", "selvalue");
				$("#newMcategory_cd").hide();
				$("#newProduct_cd").show();
				$("#newAddMcategory_cd").hide();
				$("#newAddProduct_cd").show();
			} else {
				$("#popProduct_cd").empty().append("<option>제품중분류를 선택해 주세요.</option>");
				$("#newMcategory_cd").hide();
				$("#newProduct_cd").hide(); 
				$("#newAddMcategory_cd").hide();
				$("#newAddProduct_cd").hide();
			}
		}
		
		/* 제품 재고수량 추가 */
		function insertStock(product_no, addStock) {
			
			if(!check.test($("#"+addStock).val())){
				alert("숫자만 기입해 주세요.");
				$("#"+addStock).val("");
			} else {
				console.log("받은 데이터 product_no : "+product_no);
				console.log("입력받은 제품 수량 : "+$("#"+addStock).val());
				var param = {
						product_no : product_no,
						stock : $("#"+addStock).val()
				}
				
				var insertStockCallback = function(data) {
					console.log(data);
					if(data.result == "SUCCESS"){
						alert("추가되었습니다.");
						productSearch($("#cpage").val());
					}
				}
				
				callAjax("/business/insertStock.do", "post", "json", "false", param, insertStockCallback);
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
		
		/* 제품 대,중,소등록 */
		function newProductTypesInsert(action){
			var param = {
					lcategory_cd : $("#popLcategory_cd").val(),
					mProduct_name : $("#addMcategory_cd").val(),
					mProduct_cd : $("#popMcategory_cd").val(),
					product_no : $("#popProduct_cd").val(),
					product_name : $("#addProduct_cd").val(),
					action : action
			}
			var newProductTypesInsertCallback = function(data) {
				console.log(data);
				if(data.result == 'SUCCESS'){
					$("#addMcategory_cd").val("");
					$("#addProduct_cd").val("");
					alert('등록에 성공했습니다.');
					midProductSel();
					productSel();
				} else if(data.result == 'FAILETYPE'){
					alert('중복되는 중분류가 존재합니다.');
					$("#addMcategory_cd").val("");
				} else if(data.result == 'FAILEPRODUCT') {
					alert('중복되는 제품이 존재합니다.');
					$("#addProduct_cd").val("");
				} else {
					alert('등록에 실패했습니다.');
				}
			}
			callAjax("/business/newProductTypesInsert.do", "post", "json", "false", param, newProductTypesInsertCallback);
		}		
		
		/* 제품등록 */
		function insertProduct(){
			
			comcombo("lcategory_cd", "popLcategory_cd", "sel", "selvalue");
			$("#newMcategory_cd").hide();
			$("#newProduct_cd").hide();
			$("#newAddMcategory_cd").hide();
			$("#newAddProduct_cd").hide();
			
			if($("#popLcategory_cd").val() == null){
				$("#popMcategory_cd").empty().append("<option>제품대분류를 선택해 주세요.</option>");
			}
			
			if($("#popMcategory_cd").val() == "제품대분류를 선택해 주세요."){
				$("#popProduct_cd").empty().append("<option>제품중분류를 선택해 주세요.</option>");
			}
			
			gfModalPop("#insertProduct");
		}
		
		/* 제품등록POP 등록 버튼 */
		function productSave() {
			console.log($("#insertStockPop").val());
			
			var detaileParam = {
					lcategory_cd : $("#popLcategory_cd").val(),
					mcategory_cd : $("#popMcategory_cd").val(),
					product_no : $("#popProduct_cd").val(),
			}
			
			var productDetaileCallback = function(data) {
				console.log(data);
				
				if(data.productDetaile != null && data.productDetaile.price != 0 ) {
					alert("이미 등록된 제품입니다.");
				} else {
					if( $("#popLcategory_cd").val() == "" ){
						alert("제품대분류를 선택해 주세요.");
					} else if($("#popMcategory_cd").val() == "제품대분류를 선택해 주세요." || $("#popMcategory_cd").val() == "") {
						alert("제품중분류를 선택해 주세요.");
					} else if($("#popProduct_cd").val() == ""){
						alert("제품을 선택해 주세요.");
					} else if($("#insertPrice").val() == ""){
						alert("단가를 입력해 주세요.");
						document.getElementById('insertPrice').focus();
					}else if($("#insertStockPop").val() == ""){
						alert("수량을 입력해 주세요.");
						document.getElementById('insertStockPop').focus();
					} else if(!check.test($("#insertPrice").val())){
						 alert("숫자만 기입해 주세요.");
						 $("#insertPrice").val("");
					} else if(!check.test($("#insertStockPop").val())){
						alert("숫자만 기입해 주세요.");
						 $("#insertStockPop").val(""); 
					} else {
						
						var param = {
								lcategory_cd : $("#popLcategory_cd").val(),
								mcategory_cd : $("#popMcategory_cd").val(),
								product_no : $("#popProduct_cd").val(),
								price : $("#insertPrice").val(),
								insertStock : $("#insertStockPop").val(),
						}
							
						var productSaveCallback = function(result) {
							if(result.result == 'SUCCESS'){
								alert(data.productDetaile.product_name+"을 등록했습니다.");	
								gfCloseModal();
								productSearch();
							}
						}
						callAjax("/business/insertStock.do", "post", "json", "false", param, productSaveCallback);
					}
				}
			}
			
			callAjax("/business/productDetaile.do", "post", "json", "false", detaileParam, productDetaileCallback);
			
			
		}
		
		
</script>

</head>
<body>
<form id="myForm" action=""  method="">
<input type="hidden" id="cpage" name="cpage" value =""/>
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
							<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a> 
							<span class="btn_nav bold">영업</span> <span class="btn_nav bold">제품관리</span>
							<a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
						</p> 

						<p class="conTitle">
							<span>제품관리</span> <span class="fr"> 
							제품대분류
							<select id="lcategory_cd" name="lcategory_cd" onchange="midProductSel()"></select>
							제품중분류
							<select id="mcategory_cd" name="mcategory_cd"></select>
							<a	class="btnType blue" href="javascript:productSearch();" name="modal"><span>조회</span></a>
							</span>
						</p>
							<a	class="btnType blue" href="javascript:insertProduct();" name="modal" style="margin-left: 905px;"><span>제품등록</span></a>
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
								<tbody id="productList"></tbody>
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
									<td><select id="popLcategory_cd" onchange="midProductSel()"></select></td>
						   		</tr>
					   		<tr>
								<th scope="col">제품중분류</th>
									<td><select id="popMcategory_cd" onchange="productSel()"></select></td>
								<th scope="col" id="newMcategory_cd">신규중분류등록</th>
									<td style="display: flex;" id="newAddMcategory_cd">
										<input type="text" id="addMcategory_cd" name="addMcategory_cd" style="width: 125px; height: 30px; text-align-last: center; margin-top: 3px;"/>
										<button type="button" onclick="newProductTypesInsert('M')" style="width: 50px;">추가</button>
								</td>
					   		</tr>
					   		<tr>
								<th scope="col">제품</th>
									<td><select id="popProduct_cd"></select></td>
								<th scope="col" id="newProduct_cd">신규제품등록</th>
									<td style="display: flex;" id="newAddProduct_cd">
										<input type="text" id="addProduct_cd" name="addProduct_cd" style="width: 125px; height: 30px; text-align-last: center; margin-top: 3px;"/>
										<button type="button" onclick="newProductTypesInsert('S')" style="width: 50px;">추가</button>
								</td>
					   		</tr>
					   		<tr>
								<th scope="col">단가</th>
									<td >
										<input type="text" id="insertPrice" name="insertPrice" style="width: 150px; height: 30px; text-align-last: center; font-weight: bold; font-size: initial;"/>
										<span style="font-weight: bold; font-size: initial">원</span>
								</td>
								<th scope="col">수량</th>
									<td >
										<input type="text" id="insertStockPop" name="insertStockPop" style="width: 150px; height: 30px; text-align-last: center; font-weight: bold; font-size: initial;"/>
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