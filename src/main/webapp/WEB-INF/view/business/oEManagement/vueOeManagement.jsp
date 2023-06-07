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

		var vuearea;
		var detailearea;
		var insertContractArea;

		/* onload 이벤트  */
		$(function() {
			
			//vue init 등록
			init();
			
			// 거래처 검색 select box
			clientList();
			
			// 수주서 목록 조회
			vuearea.fn_oEManagemenSearch();
			
			estimateDetaile2();
			
	    });
		
		//vue init 등록
		function init(){
			
			vuearea = new Vue({
				el : "#wrap_area",
				data : {
			        oEManagementList : [],
			        totalCnt : '',
			        pageSize : 5,
			        pageBlockSize : 5,
			        oEManagementPagination : '',
			        srcsdate  : '',
			        srcedate  : '',
			        client_no : '',
			        searchKey : '',
				},
				methods : {
					fn_oEManagemenSearch : function(){
						oEManagemenSearch();
					},
					fn_contractDetaile : function(order_cd, product_no){
						contractDetaile(order_cd, product_no);
					},
					fn_insertContract : function(){
						insertContract();
					},
				},
				filters:{
				  comma : function(val){
				  	return String(val).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
				  }
				}
			}),
			
			detailearea = new Vue({
			el : "#contractDetailePop",
			data : {
				clientName : '',
				homeName : '',
				clintPermitNo : '',
				homePermitNo : '',
				clintManagerName : '',
				homeManagerName : '',
				clintAddr : '',
				homeAddr : '',
				clintDetAddr : '',
				homeDetAddr : '',
				clintManagerHp : '',
				homeManagerHp : '',
				txt_money : '',
				estimate_no : '',
				slip_no : '',
				OemDetailList_html : '',
			},
			method : {
				fn_closePop : function(){
					closePop();
				}
			}
		}),
		
		insertContractArea = new Vue({
			el : "#insertContractPop",
			data : {
				contractType : '',
				estDetaile : '',
				estimate_cd_html : '',
				estimateDetaileList_html : '',
				selectBox : '',
				estimateNumList : [],
				
			},
			method : {
				fn_closePop : function(){
					closePop();
				},
			},
/* 			watch : {
				estDetaile : function(){
					console.log("estDetaile : " + estDetaile);
					estimateDetaile2();
				}
			} */
		})
			
	}
		
		/* 수주리스트 검색 및 조회 */
		function oEManagemenSearch(cpage, srcsdate, srcedate, client_no){
			
			cpage = cpage || 1;
			srcsdate = srcsdate || vuearea.srcsdate;
			srcedate = srcedate || vuearea.srcedate;
			client_no = client_no || vuearea.client_no;
			
			if( vuearea.srcsdate !="" && vuearea.srcedate !="" && vuearea.srcsdate > vuearea.srcedate){
				alert("검색 날짜를 확인해 주세요.");
			} else                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      {
				var param = {
						pageSize : vuearea.pageSize,
						cpage : cpage,
						srcsdate : vuearea.srcsdate,
						srcedate : vuearea.srcedate,
						client_no : vuearea.client_no
				}
				
				var oEManagementListCallback = function(data){
					// console.log(JSON.stringify(data));
					
					vuearea.oEManagementList = data.oEManagementList;
					vuearea.totalCnt = data.totalCnt;
					
					var paginationHtml = getPaginationHtml(cpage, data.totalCnt, vuearea.pageSize, vuearea.pageBlockSize, 'oEManagemenSearch');
	
					vuearea.oEManagementPagination = paginationHtml;
				}
				
				callAjax("/business/vueOeManagementList.do", "post", "json", "false", param, oEManagementListCallback);
			}
		};
		
		/* 팝업창 닫기 */
		function closePop() {
			insertContractArea.estDetaile = "";
			insertContractArea.estimateDetaileList_html = "<tr><td colspan=6>견적서 번호를 선택해 주세요.</td></tr>";
			gfCloseModal();
		}
		
		/* 거래처 리스트 SelectBox */
		function clientList() {
			clientSelectBox("", "client_no", "sel", "selvalue");
		} 
		
		/* 수주단건 조회 */
		function contractDetaile(order_cd, product_no) {
			 // console.log("받은 데이터 order_cd : "+order_cd);
			 // console.log("받은 데이터 product_no : "+product_no);
			var param = {
					order_cd : order_cd,
					product_no : product_no,
			}
			
			var contractDetaileCallback = function(data) {
				// console.log(data);
				var contractDetaile = data.contractDetaile[0];
				console.log(contractDetaile.client_name);
				detailearea.clientName = contractDetaile.client_name;
				detailearea.homeName = contractDetaile.home_name;
				detailearea.clintPermitNo = contractDetaile.clint_permit_no;
				detailearea.homePermitNo = contractDetaile.home_permit_no;
				detailearea.clintManagerName = contractDetaile.clint_manager_name;
				detailearea.homeManagerName = contractDetaile.home_manager_name;
				detailearea.clintAddr = contractDetaile.clint_addr;
				detailearea.homeAddr = contractDetaile.home_addr;
				detailearea.clintDetAddr = contractDetaile.clint_det_addr;
				detailearea.homeDetAddr = contractDetaile.home_det_addr;
				detailearea.clintManagerHp = contractDetaile.clint_manager_hp;
				detailearea.homeManagerHp = contractDetaile.home_manager_hp;
				detailearea.txt_money = convertToKoreanNumber(contractDetaile.total_price)+"원";
				
				detailearea.OemDetailList_html = "<tr>"
							 +"<td style='font-weight: bold;'>"+contractDetaile.product_name+"</td>"
							 +"<td style='font-weight: bold;'>"+contractDetaile.product_amt+"EA</td>"
							 +"<td style='font-weight: bold;'>"+contractDetaile.tax.toLocaleString('ko-KR')+"원</td>"
							 +"<td style='font-weight: bold;'>"+contractDetaile.price.toLocaleString('ko-KR')+"원</td>"
							 +"<td style='font-weight: bold;'>"+contractDetaile.amt_price.toLocaleString('ko-KR')+"원</td>"
							 +"<td style='font-weight: bold;'>"+contractDetaile.total_price.toLocaleString('ko-KR')+"원</td>"
							 +"<tr>";
							 
            	// $("#OemDetailList").empty().append(product);
            	
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
			
			// insertContractArea.selectBox ="";
			
			var param = {
					contractType : '1',
			}
			
			var estimateListCallback = function(data) {
				// console.log(data);
				
				// 견적서 번호 불러오는 리스트
				insertContractArea.estimateNumList = data.oEManagementList;
				
				// $("#estimateDetaileList").empty().append("<tr><td colspan=6>견적서 번호를 선택해 주세요.</td></tr>");
/* 				insertContractArea.estimateDetaileList_html = "<tr><td colspan=6>견적서 번호를 선택해 주세요.</td></tr>";
				
				for ( var i in data.oEManagementList){
					insertContractArea.selectBox += "<option value="+data.oEManagementList[i].estimate_cd+">"+data.oEManagementList[i].estimate_cd+"</option>";
					console.log("for문 안 : "+insertContractArea.selectBox);
				}
				if(insertContractArea.selectBox == ""){
					insertContractArea.estimate_cd_html = "<select id='estDetaile' v-on:change='fn_estimateDetaile2()' v-model='estDetaile'><option value='견적서가 없습니다'>견적서가 없습니다</option>"+ insertContractArea.selectBox +"</select>";
				} else {
					insertContractArea.estimate_cd_html = "<select id='estDetaile' v-on:change='fn_estimateDetaile2()'  v-model='estDetaile'><option value='선택'>선택</option>"+ insertContractArea.selectBox +"</select>";
				}
				console.log(insertContractArea.estimate_cd_html); */
			}
			
			callAjax("/business/oEManagementListJson.do", "post", "json", "false", param, estimateListCallback);
			gfModalPop("#insertContractPop");
		}
		
		/* 견적서리스트 */
		function estimateDetaile2() {
			
			insertContractArea.estimateDetaileList_html = "";
			// console.log("하하하" + insertContractArea.estDetaile);
			var param = {
					estimate_cd : insertContractArea.estDetaile,
			}
			
			// console.log(param.estimate_cd);
			
			var estimateDetaileCallback = function(data) {
				// console.log(data);
				
				var contractDetaile = data.contractDetaile;
				
				if(insertContractArea.estDetaile==""){
					
					insertContractArea.estimateDetaileList_html = "<tr><td colspan=6>견적서 번호를 선택해 주세요.</td></tr>";
					
				} else{
					for(var i in contractDetaile){
						// console.log(contractDetaile[i].client_name);
						insertContractArea.estimateDetaileList_html += "<tr>"
					                      +"<td>"+contractDetaile[i].client_name+"</td>"
					                      +"<td>"+contractDetaile[i].lproduct_name+"</td>"
					                      +"<td>"+contractDetaile[i].mproduct_name+"</td>"
					                      +"<td>"+contractDetaile[i].product_name+"</td>"
					                      +"<td>"+contractDetaile[i].product_amt+"EA</td>"
					                      +"<td>"+contractDetaile[i].stock+"EA</td>"
					                      +"</tr>"
					}
				}
				//$("#estimateDetaileList").empty().append(estimateDetaile);
				
				//console.log(estimateDetaile);			
			}
			callAjax("/business/contractDetaile.do", "post", "json", "false", param, estimateDetaileCallback);
		}
		
		/* 수주서등록 */
		function orderSave(object){
			// console.log(object);
			
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
			
			// console.log($('#estDetaile').val()); 
			
			if(insertContractArea.estimateNumList.length == 0){
				alert("견적서가 존재하지 않습니다.");
			} else if(insertContractArea.estDetaile==""){
				alert("견적서를 선택해주세요");
			} else if(insertContractArea.estDetaile!="" && insertContractArea.estimateNumList.length != 0){
				var param = {
						estimate_cd : insertContractArea.estDetaile,
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
	<!-- 모달 배경 -->
	<div id="mask"></div>

	<div id="wrap_area">
	<input type="hidden" id="searchKey" name="searchKey" v-model="searchKey"/>	

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
							<input type="date" id="srcsdate" name="srcsdate" style="width: 145px;" v-model="srcsdate">~ 
							<input type="date" id="srcedate" name="srcedate" style="width: 145px;" v-model="srcedate">
							</br>
							거래처명
							<select id="client_no" name="client_no" v-model="client_no"></select>
							<a	class="btnType blue" href="javascript:oEManagemenSearch();" name="modal"><span>조회</span></a>
							</span>
						</p>
							<a	class="btnType blue" href="" @click.prevent="fn_insertContract()" name="modal" style="margin-left: 905px;"><span>수주서 신규등록</span></a>
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
								<template v-if="totalCnt == 0">
									<tbody>	
										<tr>
											<td colspan="9">데이터가 존재하지 않습니다.</td>
										</tr>
									</tbody>
								</template>
								<template v-else>
									<tbody v-for="(list, item) in oEManagementList">
										<tr>
											<td style="font-weight: bold;">{{ list.estimate_cd }}</td>
											<td style="font-weight: bold;"><a href="" @click.prevent="fn_contractDetaile(list.order_cd, list.product_no)">{{ list.order_cd }}</a></td>
											<td style="font-weight: bold;">{{ list.client_name }}</td>
											<td style="font-weight: bold;">{{ list.product_name }}</td>
											<td style="font-weight: bold;">{{ list.product_amt }} EA</td>
											<td style="font-weight: bold;">{{ list.tax | comma }} 원</td>
											<td style="font-weight: bold;">{{ list.price | comma }} 원</td>
											<td style="font-weight: bold;">{{ list.amt_price | comma }} 원</td>
											<td style="color: blue; font-weight: bold;">{{ list.total_price | comma }}원</td>
										</tr>
									</tbody>
								</template>
							</table>
						</div>
	
						<div class="paging_area"  id="oEManagementPagination" v-html="oEManagementPagination"> </div>
						
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
		                     <th scope="row" colspan="2" id="clientName" name="clientName" v-model="clientName"> {{ clientName }} </th>
		                      <th scope="row" colspan="2" id="homeName" name="homeName" v-model="homeName"> {{ homeName }} </th>
		                  </tr>
		  
		                
		                  <tr>
		                  <!-- 목록조회 외에 UPDATE, INSERT , DELETE 등을 위해 필요함  hidden 값  // INT가 아닌것도 있음  -->
		                   <td hidden=""><input type="text" class="inputTxt p100" name="estimate_no" id="estimate_no" v-model="estimate_no"/></td> 
		                      <!-- 목록조회 외에 UPDATE, INSERT , DELETE 등을 위해 필요함  hidden 값  // INT가 아닌것도 있음  -->
		                   <td hidden=""><input type="text" class="inputTxt p100" name="slip_no" id="slip_no" v-model="slip_no"/></td> 
                       	   
                       	   <th scope="row">사업자등록번호</th>
		                     <td  class="inputTxt p100" name="clintPermitNo" id="clintPermitNo" style="font-weight: bold;" v-model="clintPermitNo"> {{ clintPermitNo }} </td> 	
		     
		     			 <th scope="row">사업자등록번호</th>
	                     	<td  class="inputTxt p100" name="homePermitNo" id="homePermitNo" style="font-weight: bold;" v-model="homePermitNo"> {{ homePermitNo }} </td> 
	                  </tr>
	                  <tr>
	                     <th scope="row">담당자</th>
	                     <td name="clintManagerName" id= "clintManagerName" style="font-weight: bold;" v-model="clintManagerName">
	                      {{ clintManagerName }} 
	                     </td>
	                      <th scope="row">담당자</th>
	                     <td name="homeManagerName" id= "homeManagerName" style="font-weight: bold;" v-model="homeManagerName">
	                      {{ homeManagerName }} 
	                     </td>
	                  </tr>
	          
	                  <tr>
                         <th scope="row">주소</th>
	                     	<td name="clintAddr" id="clintAddr" style="font-weight: bold;" v-model="clintAddr">
	                     	 {{ clintAddr }} 
	                     	</td>
                     	<th scope="row">주소</th>
	                     	<td name="homeAddr" id="homeAddr" style="font-weight: bold;" v-model="homeAddr">
	                     	 {{ homeAddr }} 
	                     	</td>
	                  </tr>
	                  <tr>
                         <th scope="row">나머지 주소</th>
	                     	<td name="clintDetAddr" id="clintDetAddr" style="font-weight: bold;" v-model="clintDetAddr">
	                     	 {{ clintDetAddr }} 
	                     	</td>
                     	 <th scope="row">나머지주소</th>
	                     	<td name="homeDetAddr" id="homeDetAddr" style="font-weight: bold;" v-model="homeDetAddr">
	                     	 {{ homeDetAddr }} 
	                     	</td>
	                  </tr>
	                   <tr> 	   
	                   	<th scope="row">TEL</th>
		                     <td  name="clintManagerHp" id="clintManagerHp" style="font-weight: bold;" v-model="clintManagerHp"> 
		                     	{{ clintManagerHp }} 
		                     </td> 	
		     			 <th scope="row">TEL</th>
	                     	<td  name="homeManagerHp" id="homeManagerHp" style="font-weight: bold;" v-model="homeManagerHp">
	                     		{{ homeManagerHp }} 
	                     	</td>
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
			  				<td id="txt_money" style="font-weight: bold;" v-model="txt_money"><!-- <input type="text" id="txt_money" maxlength="12"  readOnly  /> -->
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
	                    <tbody id="OemDetailList" v-html="OemDetailList_html"></tbody>    <!--  detail 끼워넣기  -->
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
									<template v-if="estimateNumList.length == 0">
										<th>
											<select id='estDetaile' v-on:change='estimateDetaile2()' v-model='estDetaile'>
												<option value="" selected="true"> 견적서가 없습니다 </option>
											</select>
										</th>
									</template>
									<template v-else>
										<th>
											<select id='estDetaile' v-on:change='estimateDetaile2()' v-model='estDetaile'>
												<option value="">선택</option>
												<template v-for="(item, index) in estimateNumList">
													<option :value="item.estimate_cd"> {{ item.estimate_cd }} </option>
												</template>
											</select>
										</th>
									 </template>
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
		               <tbody id="estimateDetaileList" v-html="estimateDetaileList_html">
						</tbody>
						</table>
			            <div class="btn_areaC mt30">
			               <a href="javascript:orderSaveBtn();" class="btnType blue" id="btnUpdateOem" name="btn"><span>등록</span></a> 	
			               <a href="javascript:closePop();" class="btnType gray"  id="btnCloseOem" name="btn"><span>취소</span></a>
			            </div>
			         </dd>
			      </dl>
			      <a href="javascript:closePop();" class="closePop"><span class="hidden">닫기</span></a>
			   </div>
			   <!-- 모달 끝 -->
</form>
</body>
</html>