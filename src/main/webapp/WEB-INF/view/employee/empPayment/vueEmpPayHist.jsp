<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> --%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>급여관리</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<script type="text/javascript">

	// 그룹코드 페이징 설정_급여내역
	var pageSize = 5;			//한페이지에 몇개 볼것인가
	var pageBlockSize = 5;
	
	// 그룹코드 페이징 설정_개인급여내역
	var opageSize = 5;			//한페이지에 몇개 볼것인가
	var opageBlockSize = 5;
	
	/** OnLoad event */ 
	$(function() {
		
		init();
		//$("#hisdetail").hide();
		
		myemp();

		fRegisterButtonClickEvent();
		
	});
	//vue init function
	function init(){
		container = new Vue({
			el : "#container",
			data : {
				/* combo box */
				myEno : '',
				myNm : '',
				myDept : '',
				myRank : '',
				
				/* page */
				cntempHislist : '',
				HisPagination : '',
				
				/* 아래 list */
				grouplist : [],
			} ,
			methods : {
				setPageGrid : function(myDate){
					myemp(myDate);
				}
			},
			filters:{
			  comma : function(val){
			  	return String(val).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			  }
			},
		});
		hisdetail = new Vue({
			el : "#hisdetail",
			data : {
			
				detail_hnm : '',
				detail_hdept : '',
				detail_hrank : '',

				detail_ypay : '',
				detail_mpay : '',
				detail_nins : '',
				detail_hins : '',
				detail_iins : '',
				detail_eins : '',
				detail_tax : '',
				detail_extra : '',
				detail_rpay : '',
			} ,
			methods : {
				setPageGrid : function(mydate){
					hisdetail2(mydate);
				}
			},
			filters:{
			  comma : function(val){
			  	return String(val).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			  }
			},
		});
		
		
	}
	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();		//이후의 예약 이벤트를 모두 소멸시킴

			var btnId = $(this).attr('id');	//해당 버튼의 아이디를 꺼내라

			switch (btnId) {

			case 'btnClose' :
				gfCloseModal();
				break;
			}
		});
	}
	
	/* 로그인한 사람 개인 조회 */
	function myemp(cpage) { // 현재 page 받기

		cpage = cpage || 1;		// 현재 page가 undefined 면 1로 셋팅	
		// param과 callback 지정
		var param = { // 컨트롤러로 넘겨줄 이름 : 보내줄값
				pageSize : opageSize,
				cpage : cpage,
				//loginId : $("#loginId").val(),
				
		} // {} json 형태
		
		var mycallback = function(mreturndata){
			console.log("mycallback : " + JSON.stringify(mreturndata));
			//console.log("mycallback : " +mreturndata.empHislist.myEno);
 			// $("#HisEmp").empty().append(mreturndata);
			container.grouplist = mreturndata.empHislist;
			// var cntempHislist = $("#cntempHislist").val();
			container.cntempHislist = mreturndata.cntempHislist;
			
/*    			$("#meno").val($("#hiseno").val());
   			$("#mnm").val($("#hisnm").val());
   			$("#mdept").val($("#hisdept").val());
   			$("#mrank").val($("#hisrank").val()); */
   			container.myEno=mreturndata.empHislist[0].myEno;
			container.myNm=mreturndata.empHislist[0].myNm;
			container.myDept=mreturndata.empHislist[0].myDept;
			container.myRank=mreturndata.empHislist[0].myRank;
			
			//console.log("mycallback container.myNm : " + JSON.stringify(container.myNm));
			
			var paginationHtml = getPaginationHtml(cpage, mreturndata.cntempHislist, opageSize, opageBlockSize, 'myemp');
			//console.log("paginationHtml : " + paginationHtml);
			container.HisPagination = paginationHtml
		//	$("#HisPagination").empty().append( paginationHtml );
			
		}
		
		
		callAjax("/employee/vueEmpPayHistlist.do", "post", "json", "false", param, mycallback);
	} //myemp	
	
	
	/*날짜 클릭하면 디테일*/
	function hisdetail2(myDate) {
		//var loginId = $("#loginId").val();
	
		//console.log("hisdetail2 myDate : "+myDate + " );
		// param과 callback 지정
		var param = { // 컨트롤러로 넘겨줄 이름 : 보내줄값
				myDate : myDate,
				//loginId : loginId,
		} // {} json 형태
		
		var detailcallback = function(dreturndata){
			console.log("hisdetail2 detailcallback : "+ JSON.stringify(dreturndata));
			
			readpopup(dreturndata);
			//gfModalPop("#hisdetail");
		}
		
		callAjax("/employee/empPayHistdetail.do", "post", "json", "false", param, detailcallback);
	} //hisdetail
	
	/* 상세조회 팝업-읽기전용 */
	function readpopup(object) {

		//var testMoney =  <fmt:formatNumber value=object.myYpay type="number"/>
		
		console.log("readpopup object : "+JSON.stringify(object));
		
 	 //$("#detail_hnm").empty().append(object.myNm);
 	 	hisdetail.detail_hnm = object.empHisdetail.myNm;
	//	$("#detail_hdept").empty().append(object.myDept);
		hisdetail.detail_hdept = object.empHisdetail.myDept;
	//	$("#detail_hrank").empty().append(object.myRank);
		hisdetail.detail_hrank = object.empHisdetail.myRank;
		
	//	$("#detail_ypay").empty().append(object.myYpay.toLocaleString());
		hisdetail.detail_ypay = object.empHisdetail.myYpay;
	// $("#detail_mpay").empty().append(object.myMpay.toLocaleString());
		hisdetail.detail_mpay = object.empHisdetail.myMpay;
	//$("#detail_nins").empty().append(object.myNins.toLocaleString());
		hisdetail.detail_nins = object.empHisdetail.myNins;
	//	$("#detail_hins").empty().append(object.myHins.toLocaleString());
		hisdetail.detail_hins = object.empHisdetail.myHins;
	//	$("#detail_iins").empty().append(object.myIins.toLocaleString());
		hisdetail.detail_iins = object.empHisdetail.myIins;
	//	$("#detail_eins").empty().append(object.myEins.toLocaleString());
		hisdetail.detail_eins = object.empHisdetail.myEins;
	//	$("#detail_tax").empty().append(object.myTax.toLocaleString());
		hisdetail.detail_tax = object.empHisdetail.myTax;
	//	$("#detail_extra").empty().append(object.myExtra.toLocaleString());
		hisdetail.detail_extra = object.empHisdetail.myExtra;
	//	$("#detail_rpay").empty().append(object.myRpay.toLocaleString()); 
		hisdetail.detail_rpay = object.empHisdetail.myRpay;
		
		gfModalPop("#hisdetail"); //모달함수: 태그의 아이디값의 창, 띄운다
	}
	
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
	<input type="hidden" name="myDate" id="myDate" value="">
	
	<!-- 모달 배경 -->
	<div id="mask"></div>

	<div id="wrap_area">

		<h2 class="hidden">header 영역</h2>
		<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

		<h2 class="hidden">컨텐츠 영역</h2>
		<div id="container">
			<%-- <input type="hidden" name="loginId" id="loginId"  value="${loginId}"> --%>
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
								class="btn_nav bold">인사 · 급여 </span> <span class="btn_nav bold">급여조회
								</span> <a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
						</p>
						
						<div class="HisEmpList" id="HisEmpList">
						<p class="conTitle">
							<span>개인 급여 지급 내역 조회</span> <span class="fr" style="float: left; margin-bottom: 5px;">
							사번
							<input type="text" width="100px;" id="meno" name="meno" v-model="myEno"	style="text-align: center; font-weight: bold;" readonly/>
							&nbsp;사원명
							<input type="text" width="100px;" id="mnm" name="mnm" v-model="myNm" style="text-align: center; font-weight: bold;"	readonly/>
							&nbsp;부서명
							<input type="text" width="100px;" id="mdept" name="mdept" v-model="myDept" style="text-align: center; font-weight: bold;"	readonly/>
							&nbsp;현재직급
							<input type="text" width="100px;" id="mrank" name="mrank" v-model="myRank" style="text-align: center; font-weight: bold;"	readonly/>
							</span>
						</p>
							
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="10%">
									<col width="10%">
									<col width="10%">
									<col width="10%">
									<col width="10%">
									
									<col width="10%">
									<col width="10%">
									<col width="10%">
									<col width="10%">
									<col width="10%">
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">지급일</th>
										<th scope="col">연봉</th>
										<th scope="col">기본급</th>
										<th scope="col">국민연금</th>
										<th scope="col">건강보험</th>
										
										<th scope="col">산재보험</th>
										<th scope="col">고용보험</th>
										<th scope="col">소득세</th>
										<th scope="col">비고금액</th>
										<th scope="col">실급여</th>
									</tr>
								</thead>
								<tbody id="HisEmp">
	  								
								<tr v-for="(list, index) in grouplist" v-if="container.cntempHislist">
										<td>
										<a href="" @click.prevent = "hisdetail.setPageGrid(list.myDate)">{{list.myDate}}</a>
										</td>
										<td>{{list.myYpay|comma}} </td>
										<td>{{list.myMpay|comma}} </td>
										<td>{{list.myNins|comma}} </td>
										<td>{{list.myHins|comma}}</td>
										<td>{{list.myIins|comma}} </td>
										<td>{{list.myEins|comma}} </td>
										<td>{{list.myTax|comma}} </td>
										<td>{{list.myExtra|comma}} </td>
										<td>{{list.myRpay|comma}} 원</td>
									</tr>
									<tr v-if="! container.cntempHislist">
										<td colspan="10">데이터가 존재하지 않습니다.</td>
									</tr>
								</tbody>
							</table>
	
						<div class="paging_area"  id="HisPagination" v-html = "HisPagination"> </div>
						</div>	
						
						</div> <!--// content -->
	
						<h3 class="hidden">풋터 영역</h3>
							<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
					</li>
				</ul>
			</div>
		</div>						
						
						
		<div id="hisdetail" class="layerPop layerType2" style="width: 600px;">
			     <dl>
					<dt>
						<strong>급여 상세조회</strong>
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
									<th colspan="2" scope="col">사원명</th>
									<th colspan="2" scope="col">부서</th>
									<th colspan="2" scope="col">직급</th>
								</tr>
								<tr style="text-align: center">
									<td colspan="2" name="detail_hnm" id="detail_hnm" v-html="detail_hnm"></td>
									<td colspan="2" name="detail_hdept" id="detail_hdept" v-html="detail_hdept"></td>
									<td colspan="2" name="detail_hrank" id="detail_hrank" v-html="detail_hrank"></td>
								</tr>
		
								<tr>
									<th colspan="3" scope="row">항목</th>
									<th colspan="3" scope="row">금액(원)</th>
								</tr>
									
								<tr>
									<th colspan="3" scope="row">연봉</th>
									<td colspan="3" style="text-align: center" name="detail_ypay" id="detail_ypay" v-html="$options.filters.comma(detail_ypay)">
									</td>
								</tr>
														
								<tr>
									<th colspan="3" scope="row">기본급</th>
									<td colspan="3" style="text-align: center" name="detail_mpay" id="detail_mpay" v-html="$options.filters.comma(detail_mpay)">
									</td>
								</tr>
														
								<tr>
									<th colspan="3" scope="row">국민연금</th>
									<td colspan="3" style="text-align: center" name="detail_nins" id="detail_nins" v-html="$options.filters.comma(detail_nins)">
									</td>
								</tr>
								
								<tr>
									<th colspan="3" scope="row">건강보험료</th>
									<td colspan="3" style="text-align: center" name="detail_hins" id="detail_hins" v-html="$options.filters.comma(detail_hins)">
									</td>
								</tr>
								
								<tr>
									<th colspan="3" scope="row">고용보험료</th>
									<td colspan="3" style="text-align: center" name="detail_iins" id="detail_iins" v-html="$options.filters.comma(detail_iins)">
									</td>
								</tr>
								
								<tr>
									<th colspan="3" scope="row">산재보험료</th>
									<td colspan="3" style="text-align: center" name="detail_eins" id="detail_eins" v-html="$options.filters.comma(detail_eins)">
									</td>
								</tr>
								
								<tr>
									<th colspan="3" scope="row">소득세</th>
									<td colspan="3" style="text-align: center" name="detail_tax" id="detail_tax" v-html="$options.filters.comma(detail_tax)">
									</td>
								</tr>
								
								<tr>
									<th colspan="3" scope="row">비고금액</th>
									<td colspan="3" style="text-align: center" name="detail_extra" id="detail_extra" v-html="$options.filters.comma(detail_extra)">
									</td>
								</tr>
								
								<tr>
									<th colspan="3" scope="row">실수령액</th>
									<td colspan="3" style="text-align: center;" name="detail_rpay" id="detail_rpay" v-html="$options.filters.comma(detail_rpay)">
									</td>
								</tr>
							</tbody>
						</table>											

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