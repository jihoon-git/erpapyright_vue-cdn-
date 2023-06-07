<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

	// 그룹코드 페이징 설정
	var pageSize = 5;			//한페이지에 몇개 볼것인가
	var pageBlockSize = 5;
	
	/** OnLoad event */ 
	$(function() {
		
		searchest();
		
		fRegisterButtonClickEvent();
		
	});
	
	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();		//이후의 예약 이벤트를 모두 소멸시킴

			var btnId = $(this).attr('id');	//해당 버튼의 아이디를 꺼내라

			switch (btnId) {
			case 'btnClick' :
				$("#clickBtn").val(''); //검색후 검색한것 초기화 용도
				$("#clickBtn").val('Z');
				if($("#consdate").val() <= $("#conedate").val()){
					searchest();
				}else{
					alert('검색 시작 일을 확인해주세요');
					return false;
				}
				break;
			case 'btnSave' :
					fn_Estsave();
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
	
	/* 대분류 change하면 중분류 호출하는 함수 */
	function lselectChange(obj){
		
		var selectlcategory = $(obj).val();
		
		/*대-중-제품-수량 입력창에서 대분류를 다른 값으로 선택시 중,제품,수량 값 선택창으로 show*/
 		if (selectlcategory == "") {
 			$("#selectl").show();   //중분류 빈창
 			$("#categorym").hide(); //중분류 선택창
 			
 			$("#selectm").show();   //제품 빈창
 			$("#productno").hide(); //제품선택창
 			
 			$("#hidden_amt").show(); //수량 빈창
 			$("#product_amt").hide();//수량입력창
		} else{
			$("#selectl").hide();  //중분류 빈창
 			$("#categorym").show();//중분류 선택창
 			
			$("#selectm").show();   //제품 빈창
 			$("#productno").hide(); //제품선택창
 			
			$("#hidden_amt").show(); //수량 빈창
 			$("#product_amt").hide();//수량입력창
 			
 			
		}
			midProductList(selectlcategory, "categorym", "sel", "selvalue");
	} //lselectChange
	
	/* 중분류 change하면 제품 호출하는 함수 */
	function mselectChange(obj){
		var selectlcategory = $('#categoryl').val();
		var selectmcategory = $(obj).val();
		
 		if (selectmcategory == "") {
 			$("#selectm").show();
 			$("#productno").hide();
 			
 			$("#hidden_amt").show();
 			$("#product_amt").hide();
		} else{
 			$("#productno").show();
			$("#selectm").hide();
 			
			$("#hidden_amt").show();
 			$("#product_amt").hide();
		}
			
 		productList(selectlcategory,selectmcategory, "productno", "sel", "selvalue");
	} //mselectChange
	
	/* 제품 선택시 onchange해서 값저장하는 함수  */
	function saveChange(obj){
		var selectlcategory = $('#categoryl').val();
		var selectmcategory = $('#categorym').val();
		var selectproduct = $(obj).val();
		
 		if (selectproduct == "") {
 			$("#hidden_amt").show();
 			$("#product_amt").hide();
		} else{
			$("#hidden_amt").hide();
 			$("#product_amt").show();
		}
 		
		var param = { // 컨트롤러로 넘겨줄 이름 : 보내줄값
				product_no : selectproduct	
			} // {} json 형태
		
		var changecallback = function(returndata){
			console.log(  JSON.stringify(returndata) );
			$("#product_stock").val(returndata.savechange.stock); // 남은수량 확인용으로 저장
			
			/* 제품선택시 남은수량이 0인경우 alert 후 초기화 */
			if($("#product_stock").val() == 0){
				alert('선택하신 제품이 품절되었습니다. \n다른 제품을 선택해주세요.')
				
				fn_openpopup();
				
			}else{
				$("#product_price").val(returndata.savechange.price);
				$("#product_stock").val(returndata.savechange.stock);
			}
		}
		callAjax("/business/savechange.do", "post", "json", "false", param, changecallback);
	} //saveChange
	
	/* 남은수량 체크 */
	function remainStock(obj){
		var minusstock = $(obj).val();
		var currentstock = $("#product_stock").val();
		var amtstock = (currentstock-minusstock);
		
		if(amtstock < 0){
			alert('선택하신 물품이 작성한 남은 수량보다 적습니다. \n현재 남은 수량 :' + currentstock)
			
			$('#product_amt').val("");
			
			fn_openpopup();
		}
	}//remainStock
	
	/* 견적서 리스트 */
	function searchest(cpage) { // 현재 page 받기
		cpage = cpage || 1;		// 현재 page가 undefined 면 1로 셋팅	
				
		// param과 callback 지정
		if($("#clickBtn").val()=='Z'){
			
			var param = { // 컨트롤러로 넘겨줄 이름 : 보내줄값
					clientNameSearch : $("#clientNameSearch").val(),
					consdate : $("#consdate").val(),
					conedate : $("#conedate").val(),
					pageSize : pageSize,
					cpage : cpage,
			}
		}else{
			var param = { // 컨트롤러로 넘겨줄 이름 : 보내줄값

					pageSize : pageSize,
					cpage : cpage,
			}
			
		}
		
		var listcallback = function(returndata){
			console.log(returndata);
			
			$("#listEst").empty().append(returndata);
			var cntestmanagementlist = $("#cntestmanagementlist").val();
			
			var paginationHtml = getPaginationHtml(cpage, cntestmanagementlist, pageSize, pageBlockSize, 'searchest');
			console.log("paginationHtml : " + paginationHtml);
			
			$("#estPagination").empty().append( paginationHtml );
		}
		
		callAjax("/business/estmanagementlist.do", "post", "text", "false", param, listcallback);
	} //searchest
	
	/* 팝업  */
	function fn_openpopup() {
		clientSelectBox("client_no", "clname", "all", "selvalue");
		comcombo("lcategory_cd", "categoryl", "sel", "selvalue");
		
		/*대분류 select*/
		$("#selectl").show();
 		$("#categorym").hide();
 		/*중분류 select*/
		$("#selectm").show();
 		$("#productno").hide();
 		/*제품 select*/
 		$("#hidden_amt").show();
 		$("#product_amt").hide();
 		
		initpopup();
		gfModalPop("#estreg");
		
	} //fn_openpopup
	
	/* 초기...화?   */
	function initpopup(){
		$('#categoryl').val("");
		$('#categorym').val("");
		$('#productno').val("");
		
		$("#product_stock").val("");
		$("#product_amt").val("");
		
	}
	
	
	/* 저장버튼 클릭시 저장할 값  */
    function fn_Estsave(){
		if($("#clname").val() == 0){
			alert('거래처이름을 선택해주세요.');
			fn_openpopup();
		}else if($("#categoryl").val() == 0){
			alert('대분류를 선택해주세요.');
			fn_openpopup();
		}else if($("#categorym").val() == 0){
			alert('중분류를 선택해주세요.');
			fn_openpopup();
		}else if($("#productno").val() == 0){
			alert('제품을 선택해주세요.');
			fn_openpopup();
		}else if($("#product_amt").val() == 0){
			alert('수량을 작성해주세요.');
			fn_openpopup();
		}else{
    	
	    	Estsave();
		}
	} //fn_Estsave
	
	/* 견적서 저장 */
	function Estsave() {
		
		var param = {
				contract_no : $("#contractno").val(),
				client_no : $("#clname").val(),
				product_no : $("#productno").val(),
				lcategory_cd : $("#categoryl").val(),
				mcategory_cd : $("#categorym").val(),
				product_amt : $("#product_amt").val(),
				price : $("#product_price").val(),
				loginID : $("#loginID").val(),
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

	
	/* 견적서 상세조회 */
	function est_detail(contract_no) {
		/* contractno 저장용 */
		$('#contractno').val(contract_no);
		
		var param = {
				contract_no : $('#contractno').val(),
		}
		
		var detailcallback = function (returndata){
			console.log(  JSON.stringify(returndata) );
			
			readpopup(returndata.estdetail);
			
			gfModalPop("#estdetail");
		}
		
		callAjax("/business/estdetail.do", "post", "json", "false", param, detailcallback) ;
		
	} //est_detail
	
	/* 상세조회 팝업-읽기전용 */
	function readpopup(object) {


		$("#detail_clnm").empty().append(object.clnm);
		$("#detail_cnm").empty().append(object.cnm);
		
		$("#detail_clno").empty().append(object.clno);
		$("#detail_cno").empty().append(object.cno);
		
		$("#detail_clmnm").empty().append(object.clmnm);
		$("#detail_cmnm").empty().append(object.cmnm);
		
		$("#detail_claddr").empty().append(object.claddr);
		$("#detail_caddr").empty().append(object.caddr);
		
		$("#detail_cldaddr").empty().append(object.cldaddr);
		$("#detail_cdaddr").empty().append(object.cdaddr);
		
		$("#detail_clmhp").empty().append(object.clmhp);
		$("#detail_cmhp").empty().append(object.cmhp);
		
		$("#detail_date").empty().append(object.contract_date);
		
		$("#detail_nm").empty().append(object.product_name);
		$("#detail_price").empty().append(object.price.toLocaleString());
		$("#detail_amt").empty().append(object.product_amt+' EA');
		$("#detail_amt_price").empty().append(object.amt_price.toLocaleString());
		$("#detail_tax").empty().append(object.tax.toLocaleString());
		$("#detail_total").empty().append(object.total_price.toLocaleString());

	} // readpopup
	
	
	/* 견적서 삭제*/
	function fn_delete() {
		
		var param = {
				contract_no : $("#contractno").val(),
		}
		
		var deletecallback = function(returndata) {
						
			console.log(  JSON.stringify(returndata) );
			
			if(returndata.result == "SUCCESS") {
				alert("삭제 되었습니다.");
				gfCloseModal();
				searchest();
			}
		}
		
		callAjax("/business/estdelete.do", "post", "json", "false", param, deletecallback) ;
	}//fn_delete
	
	
	/* 오늘날짜 */
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
<form id="myForm" action=""  method="">
	<input type="hidden" name="contractno" id="contractno" value="">
	<input type="hidden" name="loginId" id="loginId" value="${loginId}">
	<input type="hidden" name="product_price" id="product_price" value="">
	<input type="hidden" name="product_stock" id="product_stock" value="">
	<input type="hidden" name="clickBtn" id="clickBtn" value="">
	
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
							<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a> <span
								class="btn_nav bold">영업</span> <span class="btn_nav bold">견적서 작성 및 조회
								</span> <a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>견적서 작성 및 조회</span> <span class="fr"> 
							   거래처
							   <input type="text" id="clientNameSearch" name="clientNameSearch"	/>
                               <input type="date" id="consdate" name="consdate" />
                               <input type="date" id="conedate" name="conedate" />
                               <a	class="btnType blue" href="" id=btnClick name="btn" ><span>조회</span></a>						   
							   <a	class="btnType blue" href="javascript:fn_openpopup();" name="modal"><span>신규작성</span></a>
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
								<tbody id="listEst"></tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="estPagination"> </div>
						
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
								<select name="clname" id="clname"></select>
							</td>
						</tr>
						<tr>
							<th scope="row">대분류 <span class="font_red">*</span></th>
							<td>
								<select name="categoryl" id="categoryl" onchange="lselectChange(this)" ></select>
							</td>
							<th scope="row">중분류 <span class="font_red">*</span></th>
							<td>
							<select name="selectl" id="selectl">
								<option value="">대분류를 선택해주세요</option>
							</select>
								<select name="categorym" id="categorym" onchange="mselectChange(this)"></select>
							</td>
						</tr>
						<tr>
							<th scope="row">제품 <span class="font_red">*</span></th>
							<td>
								<select name="selectm" id="selectm">
									<option value="">중분류를 선택해주세요</option>
								</select>
								<select name="productno" id="productno" onchange="saveChange(this)"></select>
							</td>
							<th scope="row">수량 <span class="font_red">*</span></th>
							<td>
								<input type="text" class="inputTxt p100" name="product_amt" id="product_amt" onchange="remainStock(this)" />
								<input type="text" class="inputTxt p100" name="hidden_amt" id="hidden_amt" value="제품을 선택해주세요." readonly />
							</td>
						</tr>
							
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSave" name="btn"><span>등록</span></a> 
					<a href=""	class="btnType gray"  id="btnClose" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	
	
	</div>
	
	<div id="estdetail" class="layerPop layerType2" style="width: 600px;">
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
							<th colspan="3" scope="row" name="detail_clnm" id="detail_clnm" ></th>
							<th colspan="3" scope="row" name="detail_cnm" id="detail_cnm" ></th>
						</tr>
						<tr>
							<th scope="row">사업자등록번호</th>
							<td colspan="2" name="detail_clno" id="detail_clno" >
							</td>
							<th scope="row">사업자등록번호</th>
							<td colspan="2" name="detail_cno" id="detail_cno" >
							</td>
						</tr>

						<tr>
							<th scope="row">담당자</th>
							<td colspan="2" name="detail_clmnm" id="detail_clmnm" >
							</td>
							<th scope="row">담당자</th>
							<td colspan="2" name="detail_cmnm" id="detail_cmnm" >
							</td>
						</tr>
							
						<tr>
							<th scope="row">주소</th>
							<td colspan="2" name="detail_claddr" id="detail_claddr" >
							</td>
							<th scope="row">주소</th>
							<td colspan="2" name="detail_caddr" id="detail_caddr">
							</td>
						</tr>
												
						<tr>
							<th scope="row">나머지주소</th>
							<td colspan="2" name="detail_cldaddr" id="detail_cldaddr" >
							</td>
							<th scope="row">나머지주소</th>
							<td colspan="2" name="detail_cdaddr" id="detail_cdaddr" >
							</td>
						</tr>
												
						<tr>
							<th scope="row">TEL</th>
							<td colspan="2" name="detail_clmhp" id="detail_clmhp" >
							</td>
							<th scope="row">TEL</th>
							<td colspan="2" name="detail_cmhp" id="detail_cmhp" >
							</td>
						</tr>
						
						<tr>
							<th scope="row">견적작성일</th>
							<td colspan="5" name="detail_date" id="detail_date" >
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
							<td name="detail_nm" id="detail_nm" >
							</td>
							<td name="detail_price" id="detail_price" >
							</td>
							<td name="detail_amt" id="detail_amt" >
							</td>
							<td name="detail_amt_price" id="detail_amt_price" >
							</td>
							<td name="detail_tax" id="detail_tax" >
							</td>
							<td name="detail_total" id="detail_total" >
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