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

		/* onload 이벤트  */
		$(function() {
			
			clientList();
			
			oEManagemenSearch();
			
	    });
		
		/* 수주리스트 검색 및 조회 */
		function oEManagemenSearch(cpage, srcsdate, srcedate, client_no){
			
			$("#searchKey").val("search");
			
			cpage = cpage || 1;
			srcsdate = srcsdate || $("#srcsdate").val();
			srcedate = srcedate || $("#srcedate").val();
			client_no = client_no || $("#client_no").val();
			var navi = [srcsdate, srcedate, client_no];
			
			if($("#srcsdate").val() != "" && $("#srcedate").val() ==""){
				alert("종료일을 선택하세요."); 
			} else if($("#srcsdate").val() == "" && $("#srcedate").val() !="") {
				alert("시작일을 선택하세요.");
			} else if( $("#srcsdate").val() !="" && $("#srcedate").val() !="" && $("#srcsdate").val() > $("#srcedate").val()){
				alert("날짜를 확인해 주세요.");
			} else                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      {
				var param = {
						pageSize : pageSize,
						cpage : cpage,
						srcsdate : srcsdate,
						srcedate : srcedate,
						client_no : client_no
				}
				
				var oEManagementListCallback = function(data){
					console.log(data);
	
					$("#oEManagementList").empty().append(data);
					
					var totalCnt = $("#totalCnt").val();
					
					var paginationHtml = getPaginationHtml(cpage, totalCnt, pageSize, pageBlockSize, 'fn_oEManagementList', navi);
	
					$("#oEManagementPagination").empty().append(paginationHtml);
				}
				
				callAjax("/business/oEManagementList.do", "post", "text", "false", param, oEManagementListCallback);
			}
		};
		
		/* 수주리스트 네비게이션 */
		function fn_oEManagementList(cpage, srcsdate, srcedate, client_no){
			
			if($("#searchKey").val() == "search"){ 
				$("#client_no").val(client_no).prop("selected",true);
				$("#srcsdate").val(srcsdate);
				$("#srcedate").val(srcedate);
			}
			
			cpage = cpage || 1;
			
			var navi = [srcsdate, srcedate, client_no];
			
			var param = {
					pageSize : pageSize,
					cpage : cpage,
					srcsdate : srcsdate,
					srcedate : srcedate,
					client_no : client_no
			}
			
			var oEManagementListCallback = function(data){
				console.log(data);

				$("#oEManagementList").empty().append(data);
				
				var totalCnt = $("#totalCnt").val();
				
				var paginationHtml = getPaginationHtml(cpage, totalCnt, pageSize, pageBlockSize, 'fn_oEManagementList', navi);

				$("#oEManagementPagination").empty().append(paginationHtml);
			}
			
			callAjax("/business/oEManagementList.do", "post", "text", "false", param, oEManagementListCallback);
		};
		
		/* 팝업창 닫기 */
		function closePop() {
			gfCloseModal();
		}
		
		/* 거래처 리스트 SelectBox */
		function clientList() {
			clientSelectBox("", "client_no", "sel", "selvalue");
		}
		
		/* 수주단건 조회 */
		function contractDetaile(order_cd, product_no) {
			 console.log("받은 데이터 order_cd : "+order_cd);
			 console.log("받은 데이터 product_no : "+product_no);
			var param = {
					order_cd : order_cd,
					product_no : product_no,
			}
			
			var contractDetaileCallback = function(data) {
				console.log(data);
				var contractDetaile = data.contractDetaile[0];
				$("#clientName").empty().append(contractDetaile.client_name);
				$("#homeName").empty().append(contractDetaile.home_name);
				$("#clintPermitNo").empty().append(contractDetaile.clint_permit_no);
				$("#homePermitNo").empty().append(contractDetaile.home_permit_no);
				$("#clintManagerName").empty().append(contractDetaile.clint_manager_name);
				$("#homeManagerName").empty().append(contractDetaile.home_manager_name);
				$("#clintAddr").empty().append(contractDetaile.clint_addr);
				$("#homeAddr").empty().append(contractDetaile.home_addr);
				$("#clintDetAddr").empty().append(contractDetaile.clint_det_addr);
				$("#homeDetAddr").empty().append(contractDetaile.home_det_addr);
				$("#clintManagerHp").empty().append(contractDetaile.clint_manager_hp);
				$("#homeManagerHp").empty().append(contractDetaile.home_manager_hp);
				$("#txt_money").empty().append(convertToKoreanNumber(contractDetaile.total_price)+"원");
				
				var product = "<tr>"
							 +"<td style='font-weight: bold;'>"+contractDetaile.product_name+"</td>"
							 +"<td style='font-weight: bold;'>"+contractDetaile.product_amt+"EA</td>"
							 +"<td style='font-weight: bold;'>"+contractDetaile.tax.toLocaleString('ko-KR')+"원</td>"
							 +"<td style='font-weight: bold;'>"+contractDetaile.price.toLocaleString('ko-KR')+"원</td>"
							 +"<td style='font-weight: bold;'>"+contractDetaile.amt_price.toLocaleString('ko-KR')+"원</td>"
							 +"<td style='font-weight: bold;'>"+contractDetaile.total_price.toLocaleString('ko-KR')+"원</td>"
							 +"<tr>";
							 
            	$("#OemDetailList").empty().append(product);
            	
				gfModalPop("#contractDetailePop");
			}
			
			callAjax("/business/contractDetaile.do", "post", "json", "false", param, contractDetaileCallback);
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
		
		/* 견적서 SelectBox */
		function insertContract() {
			
			var param = {
					contractType : '1',
			}
			
			var estimateListCallback = function(data) {
				console.log(data);
				
				$("#estimateDetaileList").empty().append("<tr><td colspan=6>견적서 번호를 선택해 주세요.</td></tr>");
				
				var selectBox = "";
				for ( var i in data.oEManagementList){
					selectBox += "<option value="+data.oEManagementList[i].estimate_cd+">"+data.oEManagementList[i].estimate_cd+"</option>";
					console.log("for문 안 : "+selectBox);
				}
				if(selectBox == ""){
					$("#estimate_cd").empty().append("<select id='estDetaile' onchange='estimateDetaile()'><option value='견적서가 없습니다'>견적서가 없습니다</option>"+selectBox+"</select>");
				} else {
					$("#estimate_cd").empty().append("<select id='estDetaile' onchange='estimateDetaile()'><option value='선택'>선택</option>"+selectBox+"</select>");
				}
			}
			
			callAjax("/business/oEManagementListJson.do", "post", "json", "false", param, estimateListCallback);
			gfModalPop("#insertContractPop");
		}
		
		/* 견적서리스트 */
		function estimateDetaile() {
			
			var param = {
					estimate_cd : $("#estDetaile").val(),
			}
			
			var estimateDetaileCallback = function(data) {
				console.log(data);
				
				var contractDetaile = data.contractDetaile;
				var estimateDetaile = "";
				
				for(var i in contractDetaile){
					console.log(contractDetaile[i].client_name);
					estimateDetaile += "<tr>"
				                      +"<td>"+contractDetaile[i].client_name+"</td>"
				                      +"<td>"+contractDetaile[i].lproduct_name+"</td>"
				                      +"<td>"+contractDetaile[i].mproduct_name+"</td>"
				                      +"<td>"+contractDetaile[i].product_name+"</td>"
				                      +"<td>"+contractDetaile[i].product_amt+"EA</td>"
				                      +"<td>"+contractDetaile[i].stock+"EA</td>"
				                      +"</tr>"
				}
				$("#estimateDetaileList").empty().append(estimateDetaile);
				
				console.log(estimateDetaile);			
			}
			callAjax("/business/contractDetaile.do", "post", "json", "false", param, estimateDetaileCallback);
		} 
		
		/* 수주서등록 */
		function orderSave(object){
			console.log(object);
			
			for (var i in object){
				
				var src = "";
				var index = 0;
				
				var param = {
						estimate_cd : object[i].estimate_cd,
						contract_no : object[i].contract_no,
						popClient_no : object[i].client_no,
						lProduct_no : object[i].lproduct_cd,
						midProduct_no : object[i].mproduct_cd,
						product_no : object[i].product_no,
						productAmtVal : object[i].product_amt,
						index : i,
						price : object[i].price,
				}
				console.log(param);
				var saveCallback = function(data) {
					console.log(data);
					
					index += parseInt(i)+1;
					src = data.contractDetaile;
				 	console.log(index);
				 	
					console.log("object.length : "+object.length);
					if(index === object.length) {
						if(data.contractDetaile != "OK"){
							alert("등록에 실패했습니다.")
						} else {
							alert("등록에 성공했습니다.");
							oEManagemenSearch();
							closePop();
						}
					} 
				}
				callAjax("/business/contractSave.do", "post", "json", "false", param, saveCallback);
			}
		}
		
		/* 수주서 등록 버튼 */
		function orderSaveBtn() {
			
			console.log($('#estDetaile').val()); 
			
			if($('#estDetaile').val() == "선택"){
				alert("견적서를 선택해주세요");
			} else if($('#estDetaile').val() == "견적서가 없습니다"){
				alert("견적서가 존재하지 않습니다.");
			} else {
				var param = {
						estimate_cd : $("#estDetaile").val(),
				}
					
				var estimateDetaileCallback = function(data) {
					console.log(data.contractDetaile);
	
					var arm = "";
					
					for(var i in data.contractDetaile){
						if(data.contractDetaile[i].product_amt > data.contractDetaile[i].stock) {
							arm += ","+data.contractDetaile[i].product_name+"의 재고가 모자릅니다.";
						}
					}
					
					if(arm != ""){
						alert(arm.substring(1));
						return false;
					}
					
					orderSave(data.contractDetaile);
				}
				callAjax("/business/contractDetaile.do", "post", "json", "false", param, estimateDetaileCallback);
			}
			
		}
		
		
</script>

</head>
<body>
<form id="myForm" action=""  method="">
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
							<span class="btn_nav bold">영업</span> <span class="btn_nav bold">수주서 작성 및 조회</span>
							<a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
						</p> 

						<p class="conTitle">
							<span>수주서 작성 및 조회</span> <span class="fr" style="margin-top: 5px;"> 
							<input type="date" id="srcsdate" name="srcsdate" style="width: 145px;">~ 
							<input type="date" id="srcedate" name="srcedate" style="width: 145px;">
							</br>
							거래처명
							<select id="client_no" name="client_no"></select>
							<a	class="btnType blue" href="javascript:oEManagemenSearch();" name="modal"><span>조회</span></a>
							</span>
						</p>
							<a	class="btnType blue" href="javascript:insertContract();" name="modal" style="margin-left: 905px;"><span>수주서 신규등록</span></a>
							</span>
						<div class="divComGrpCodList">
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="8%">
									<col width="7%">
									<col width="20%">
									<col width="20%">
									<col width="5%">
									<col width="10%">
									<col width="10%">
									<col width="10%">
									<col width="10%">
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">견적서번호</th>
										<th scope="col">수주번호</th>
										<th scope="col">거래처</th>
										<th scope="col">제품이름</th>
										<th scope="col">수량</th>
										<th scope="col">부가세</th>
										<th scope="col">단가</th>
										<th scope="col">공급가액</th>
										<th scope="col">총액</th>
									</tr>
								</thead>
								<tbody id="oEManagementList"></tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="oEManagementPagination"> </div>
						
					</div> <!--// content -->
					
					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>

	<!-- 모달팝업1  -->
	   <div id="contractDetailePop" class="layerPop layerType2"  style="width: 800px;">
	      <dl>
	         	<dt id= "titledt">
	         		
	         	</dt>
	       
	         <dd class="content">
	            <!-- s : 여기에 내용입력 -->
	            <table class="row">
	               <caption>caption</caption>
	               <colgroup>
	                  <col width="15%">
	                  <col width="35%">
	                  <col width="15%">
	                  <col width="35%">
	               </colgroup>
	
	               <tbody>
	                <tr>
					   
					    
	                       <tr id="clcom">
		                     <th scope="row" colspan="2" id="clientName" name="clientName"></th>
		                      <th scope="row" colspan="2" id="homeName" name="homeName"></th>
		                  </tr>
		  
		                
		                  <tr>
		                  <!-- 목록조회 외에 UPDATE, INSERT , DELETE 등을 위해 필요함  hidden 값  // INT가 아닌것도 있음  -->
		                   <td hidden=""><input type="text" class="inputTxt p100" name="estimate_no" id="estimate_no" /></td> 
		                      <!-- 목록조회 외에 UPDATE, INSERT , DELETE 등을 위해 필요함  hidden 값  // INT가 아닌것도 있음  -->
		                   <td hidden=""><input type="text" class="inputTxt p100" name="slip_no" id="slip_no" /></td> 
                       	   
                       	   <th scope="row">사업자등록번호</th>
		                     <td  class="inputTxt p100" name="clintPermitNo" id="clintPermitNo" style="font-weight: bold;">  	
		     
		     			 <th scope="row">사업자등록번호</th>
	                     	<td  class="inputTxt p100" name="homePermitNo" id="homePermitNo" style="font-weight: bold;">
	                  </tr>
	                  <tr>
	                     <th scope="row">담당자</th>
	                     <td name="clintManagerName" id= "clintManagerName" style="font-weight: bold;">
	                     </td>
	                      <th scope="row">담당자</th>
	                     <td name="homeManagerName" id= "homeManagerName" style="font-weight: bold;">
	                     </td>
	                  </tr>
	          
	                  <tr>
                         <th scope="row">주소</th>
	                     	<td name="clintAddr" id="clintAddr" style="font-weight: bold;">
	                     	</td>
	                     	<th scope="row">주소</th>
		                     	<td name="homeAddr" id="homeAddr" style="font-weight: bold;">
		                     	</td>
	                  </tr>
	                  <tr>
                         <th scope="row">나머지 주소</th>
	                     	<td name="clintDetAddr" id="clintDetAddr" style="font-weight: bold;">
	                     	</td>
	                     	<th scope="row">나머지주소</th>
		                     	<td name="homeDetAddr" id="homeDetAddr" style="font-weight: bold;">
		                     	</td>
	                  </tr>
	                   <tr> 	   
	                   	<th scope="row">TEL</th>
		                     <td  name="clintManagerHp" id="clintManagerHp" style="font-weight: bold;">  	
		     			 <th scope="row">TEL</th>
	                     	<td  name="homeManagerHp" id="homeManagerHp" style="font-weight: bold;">
	                  </tr>
	                  
	                  	                  
	           <!-- 거래처 + erp 회사 정보 끝 -->
	           
	           
	                  <!--  한 칸 띄우기  -->
	            	  <tr>
                     	<td  colspan="4" class="inputTxt p100">
		              </tr>
		             						
				     	<tr>
                     		<td scope="row" colspan="4" >
	                     		<br>
	                     		    1. 귀사의 일익 번창하심을 기원합니다. <br>
	                     		    2.하기와 같이 견적드리오니 검토하기 바랍니다.<br>
		              	</tr>
           			<tr>

	                  
	                  <tr>
			   			 <th scope="row" class="han_money" id="han_money" >  합 계 </th>
			  				<td id="txt_money" style="font-weight: bold;"><!-- <input type="text" id="txt_money" maxlength="12"  readOnly  /> -->
			  				</td>
			  			</tr>
	            
		              
                     <table class="col">
                        <caption>caption</caption>
                        <colgroup>
                           <col width="15%">
                           <col width="10%">
                           <col width="15%">
                           <col width="15%">
                           <col width="15%">
                           <col width="10%">
                        </colgroup>
                       <thead>
  
  		
                           <tr>
                           	   <th scope="col">제품이름</th>
                               <th scope="col" id= "oeCnts">수량</th>
							   <th scope="col">부가세</th>
							   <th scope="col">단가</th>
							   <th scope="col">공급가액</th>
							   <th scope="col">총액</th>
                           </tr>
                        </thead>
	                    <tbody id="OemDetailList"></tbody>    <!--  detail 끼워넣기  -->
	            </table>
	            <div class="btn_areaC mt30">
	   				<!--  <a href="" class="btnType blue" id="btnUpdateOem2" name="btn"><span>저장</span></a> -->
	               <a href="javascript:closePop();"   class="btnType gray"  id="btnCloseOem" name="btn"><span>취소</span></a>
	            </div>
	         </dd>
	      </dl>
	     
	      <a href="javascript:closePop();" class="closePop"><span class="hidden">닫기</span></a>
	   </div>
	<!--// 모달팝업 -->
	
	 <!-- 모달팝업 ==  신규 등록  -->
		   <div id="insertContractPop" class="layerPop layerType2"  style="width: 800px;">
		      <dl>
		         <dt>
		            <div id="divtitle" style="color:white">수주서 신규등록</div>
		         </dt>
		         <dd class="content">
		            <!-- s : 여기에 내용입력 -->
		            <table class="col">
		               <caption>caption</caption>
		               <colgroup>
		                  <col width="15%">
                           <col width="15%">
                           <col width="15%">
                           <col width="15%">
                           <col width="15%">
                           <col width="15%">
		               </colgroup>
					   <thead>
					   		<tr>
								<th scope="col">계약서 번호</th>
								<th id="estimate_cd"></th>
								<th colspan=4 style="background-color: aliceblue; border: none;"></th>
					   		</tr>
							<tr>
								<th scope="row" >거래처 이름</th>
								<th scope="row">대분류</th>
								<th scope="row">중분류</th>
								<th scope="row" >제품</th>
								<th scope="row">수량</th>
								<th scope="row">재고</th>
							</tr>
						</thead>
		               <tbody id="estimateDetaileList">
						</tbody>
						</table>
			            <div class="btn_areaC mt30">
			               <a href="javascript:orderSaveBtn();" class="btnType blue" id="btnUpdateOem" name="btn"><span>등록</span></a> 	
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