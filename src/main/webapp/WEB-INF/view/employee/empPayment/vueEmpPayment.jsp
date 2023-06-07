<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

	var vuearea;
	var hiddenarea;
	
	/** OnLoad event */ 
	$(function() {
		
		//vue init 등록
		init();
		
		// 부서, 직급 콤콤보
		comcombo("dept_cd", "srcdept", "all", "selvalue");
		comcombo("rank_cd", "srcrank", "all", "selvalue");
		
		// 급여관리
		searchemp();
		
		fRegisterButtonClickEvent();
	
	});
	
	function init(){
		
		vuearea = new Vue({
			el : "#wrap_area",
			data : {
				empPaylist : [],
				cntempPaylist : '',
		        pageSize : 3,
		        pageBlockSize : 5,
		        empPagination : '',		        
				srcrank : '',
				srcdept : '',
				srcName : '',
				srcyn : '',
				srcdate : '',
				btnAllSave_show : false,
				oneEmpListArea : false,
				oneEmpList : [],
				cntempOnelist : '',
				opageSize : 5,
				opageBlockSize : 5,
				onePagination : '',
				seno : '',
				snm : '',
				sdept : '',
				srank : '',
				clickEmp : '',
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
				sloginID : '',
				cloginID : '',
				salaryno : '',
				expno : '',
			},
		})
	}
	
	
	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();		//이후의 예약 이벤트를 모두 소멸시킴

			var btnId = $(this).attr('id');	//해당 버튼의 아이디를 꺼내라

			switch (btnId) {
			case 'btnEmpClick' :
				vuearea.clickEmp=''; //검색후 검색한것 초기화 용도
				vuearea.clickEmp='Z';
				searchemp();
				break;
			case 'btnSave' :
					fn_save();
					break;
			case 'btnAllSave' :
					allSaveBtn();
					break;
			case 'btnClose' :
				gfCloseModal();
				break;
			}
		});
	}
	
	function nameCheckForm(obj) {
		
		var regexp = /[a-z0-9]|[ \[\]{}()<>?|`~!@#$%^&*-_+=,.;:\"'\\]/g;
		var checkNm = $(obj).val();
		
		if(regexp.test(checkNm)){
			alert("한글만 입력 가능 합니다.");
			$(obj).val(checkNm.replace(regexp, ''));
			
		}
		
	}
	
	
	/*급여 지급 내역 리스트*/
	function searchemp(cpage) { // 현재 page 받기
		
		// $("#oneEmpList").hide();
		vuearea.oneEmpListArea = false;

		if (vuearea.srcdate <= getToday()){
			
			cpage = cpage || 1;		// 현재 page가 undefined 면 1로 셋팅	
		
			if(vuearea.clickEmp =='Z'){
				// param과 callback 지정
				var param = { // 컨트롤러로 넘겨줄 이름 : 보내줄값
		
						srcrank : vuearea.srcrank,
						srcdept : vuearea.srcdept,
						srcName : vuearea.srcName,
						srcyn : vuearea.srcyn,
						srcdate : vuearea.srcdate,
						pageSize : vuearea.pageSize,
						cpage : cpage,
						
				}
			} else{
				var param = { // 컨트롤러로 넘겨줄 이름 : 보내줄값
						
						pageSize : vuearea.pageSize,
						cpage : cpage,
						
				}
			}
			
			var listcallback = function(returndata){
				// console.log(returndata);
/* 				console.log(returndata.checkyn);
				console.log(returndata.cntempPaylist); */
				
 				/* 일괄 지급 버튼 show hide */
				if(returndata.checkyn != returndata.cntempPaylist || returndata.checkyn == null){
					vuearea.btnAllSave_show = true;
				}else{
					vuearea.btnAllSave_show = false;
				}
				
				vuearea.empPaylist = returndata.empPaylist;
				vuearea.cntempPaylist = returndata.cntempPaylist;
						
				var paginationHtml = getPaginationHtml(cpage, vuearea.cntempPaylist, vuearea.pageSize, vuearea.pageBlockSize, 'searchemp');
				
				vuearea.empPagination = paginationHtml;
				

			}
			callAjax("/employee/vueEmpPaylist.do", "post", "json", "false", param, listcallback);
			
		}else {
			alert('오늘 이후의 날짜는 검색 할 수 없습니다.')
		}

	} //searchemp
	
	/* 오늘날짜 */
	function getToday(){
        var date = new Date();
        var year = date.getFullYear();
        var month = ("0" + (1 + date.getMonth())).slice(-2);
        var day = ("0" + date.getDate()).slice(-2);

        return year + "-" + month + "-" + day;
    }
	
	/* 사원명 눌러서 개인 급여 조회 */
	function fn_oneemp(sloginID){
		hiddenarea.sloginID = sloginID;
		vuearea.oneEmpListArea = true;
		oneemp();
		
	} //fn_oneemp
	
	/*개인 급여 지급 내역 조회*/
	function oneemp(cpage) { // 현재 page 받기
		cpage = cpage || 1;		// 현재 page가 undefined 면 1로 셋팅	
		
		/* 선택한 아이디값... */
		
		// param과 callback 지정
		var param = { // 컨트롤러로 넘겨줄 이름 : 보내줄값

				sloginID : hiddenarea.sloginID,
				pageSize : vuearea.opageSize,
				cpage : cpage,
				
		} // {} json 형태
		
		var onecallback = function(oreturndata){

			vuearea.oneEmpList = oreturndata.empOnelist;
 			
			vuearea.seno = oreturndata.empOnelist[0].oneeno;
			vuearea.snm = oreturndata.empOnelist[0].onenm;
			vuearea.sdept = oreturndata.empOnelist[0].onedept;
			vuearea.srank = oreturndata.empOnelist[0].onerank;
 			
			vuearea.cntempOnelist = oreturndata.cntempOnelist;
			
			var paginationHtml = getPaginationHtml(cpage, oreturndata.cntempOnelist, vuearea.opageSize, vuearea.opageBlockSize, 'oneemp');
			vuearea.onePagination = paginationHtml;
		}
		
		callAjax("/employee/vueEmpOneList.do", "post", "json", "false", param, onecallback);
	} //oneemp
	
	/* 버튼 클릭시 값 저장 */
    function fn_loginsave(sloginID,salaryno,expno){
		
		var saveOneQue = confirm("급여를 개별지급 하시겠습니까?");
		
		if(saveOneQue){
			hiddenarea.cloginID = sloginID;
			hiddenarea.salaryno = salaryno;
			hiddenarea.expno = expno;
	    	vuearea.oneEmpListArea = false;
	    	
	    	fn_onesave();
		}
		
	} //fn_loginsave
	
	
	/* 지급대기 버튼 클릭시 저장 */
	function fn_onesave(sloginID) {
		
		// console.log($("#cloginID").val());
	
		var param = {
				loginID : hiddenarea.cloginID,
				salaryno : hiddenarea.salaryno,
				expno : hiddenarea.expno,
				srcdate :vuearea.srcdate,
		}
		
		var onesavecallback = function(returndata) {
						
			// console.log(  JSON.stringify(returndata) );
			
			if(returndata.result == "SUCCESS") {
				alert("지급 되었습니다.");
				searchemp();
			}
		}
		
		callAjax("/employee/empsave.do", "post", "json", "false", param, onesavecallback) ;
		
	}//fn_onesave
	
	/* 일괄저장  */
	function allSaveBtn() {
		
		var saveAllQue = confirm("급여를 일괄지급 하시겠습니까?");
		
		if(saveAllQue){
			
			var param = {
					srcrank : vuearea.srcrank,
					srcdept : vuearea.srcdept,
					srcName : vuearea.srcName,
					srcyn : vuearea.srcyn,
					srcdate : vuearea.srcdate,
			}
			
			var allsavecallback = function(returndata) {
							
				// console.log(  JSON.stringify(returndata) );
				
				if(returndata.result == "SUCCESS") {
					alert("일괄지급 되었습니다.");
					searchemp();
				}
			}
			
			callAjax("/employee/empsaveall.do", "post", "json", "false", param, allsavecallback);	
		}
		
	}//allSaveBtn
		
	
</script>

</head>
<body>
<form id="myForm" action=""  method="">
	<div id="hiddenarea">
		<input type="hidden" name="sloginID" id="sloginID" v-model="sloginID">
		<input type="hidden" name="cloginID" id="cloginID" v-model="cloginID">
		<input type="hidden" name="salaryno" id="salaryno" v-model="salaryno">
		<input type="hidden" name="expno" id="expno" v-model="expno">
	</div>
	
	
	<!-- 모달 배경 -->
	<div id="mask"></div>

	<div id="wrap_area">

		<input type="hidden" name="clickEmp" id="clickEmp" v-model="clickEmp">
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
								class="btn_nav bold">인사 · 급여 </span> <span class="btn_nav bold">급여관리
								</span> <a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>급여 지급 내역 조회</span> <span class="fr" style="float: left; margin-bottom: 5px"> 
							   부서
							   <select name="srcdept" id="srcdept" style="width: 80px;" v-model="srcdept"></select>
							 &nbsp;직급
							   <select name="srcrank" id="srcrank" style="width: 50px;" v-model="srcrank"></select>
							 &nbsp;사원명
							   <input type="text" width="100px;" id="srcName" name="srcName" onkeyup="nameCheckForm(this)"	v-model="srcName"/>
                             &nbsp;지급상태  
                               <select name="srcyn" id="srcyn" style="width: 50px;"  v-model="srcyn">
                               		<option value>전체</option>
                               		<option value="y">완료</option>
                               		<option value="w">대기</option>
                               </select>
                             &nbsp;급여년월  
                               <input type="date" id="srcdate" name="srcdate" style="margin-right: 90px"  v-model="srcdate"/>
                               <a	class="btnType blue" href="" id=btnEmpClick name="btn" ><span>검색</span></a>						   
                               <a	class="btnType blue" href="" id=btnAllSave name="btn" v-show="btnAllSave_show"><span>일괄지급</span></a>						   
						</span>
						</p>
						
						<div class="empSearchList">
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="8%">
									<col width="6%">
									<col width="6%">
									<col width="6%">
									<col width="6%">
									
									<col width="8%">
									<col width="8%">
									<col width="7%">
									<col width="7%">
									<col width="7%">
									
									<col width="7%">
									<col width="6%">
									<col width="7%">
									<col width="6%">
									<col width="6%">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">지급년월</th>
										<th scope="col">부서</th>
										<th scope="col">직급</th>
										<th scope="col">사번</th>
										<th scope="col">사원명</th>
										
										<th scope="col">연봉</th>
										<th scope="col">기본급</th>
										<th scope="col">국민연금</th>
										<th scope="col">건강보험</th>
										<th scope="col">산재보험</th>
										
										<th scope="col">고용보험</th>
										<th scope="col">소득세</th>
										<th scope="col">비고금액</th>
										<th scope="col">실급여</th>
										<th scope="col">지급</th>
									</tr>
								</thead>
								<template v-if="cntempPaylist == 0">
									<tbody>	
										<tr>
											<td colspan="15">데이터가 존재하지 않습니다.</td>
										</tr>
									</tbody>
								</template>
								<template v-else>						
									<tbody id="listEmp" v-for="(list, item) in empPaylist">
									<tr>
										<td>{{ list.pay_date }}</td>
										<td>{{ list.dept }}</td>
										<td>{{ list.rank }}</td>
										<td>{{ list.emp_no }}</td>
										<td>
											<a href="" @click.prevent="fn_oneemp(list.sloginID)">{{ list.name }}</a>
										</td>
										<td>{{ list.year_pay | comma }}</td>
										<td>{{ list.month_pay | comma }}</td>
										<td>{{ list.ins_n | comma }}</td>
										<td>{{ list.ins_h | comma }}</td>
										<td>{{ list.ins_i | comma }}</td>
										<td>{{ list.ins_e | comma }}</td>
										<td>{{ list.tax | comma }}</td>
										<td>{{ list.extra | comma }}</td>
										<td>{{ list.total | comma }} 원</td>
											<template v-if="list.pay_yn == 'y'">
												<td>지급완료</td>
											</template>
											<template v-else>
												<td>
													<a style="color: red; font-weight: bold;" href="" @click.prevent="fn_loginsave(list.sloginID, list.salary_no, list.exp_no)"><span>지급대기</span></a>
												</td>
											</template>
										</tr>
									</tbody>
								 </template>															
							</table>
						</div>
	
						<div class="paging_area"  id="empPagination" v-html="empPagination"> </div>
						
						<br/>
						<br/>
						
						<div class="oneEmpList" id="oneEmpListArea" v-show="oneEmpListArea">
						
						<p class="conTitle">
							<span>개인 급여 지급 내역 조회</span> <span class="fr" style="float: left; margin-bottom: 5px;">
							사번
							<input type="text" width="100px;" id="seno" name="seno"	v-model="seno" style="text-align: center; font-weight: bold;"  readonly/>
							&nbsp;사원명
							<input type="text" width="100px;" id="snm" name="snm" v-model="snm" style="text-align: center; font-weight: bold;"	readonly/>
							&nbsp;부서명
							<input type="text" width="100px;" id="sdept" name="sdept" v-model="sdept" style="text-align: center; font-weight: bold;"	readonly/>
							&nbsp;현재직급
							<input type="text" width="100px;" id="srank" name="srank" v-model="srank" style="text-align: center; font-weight: bold;"	readonly/>
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
								<template v-if="cntempOnelist == 0">
									<tbody v-for="(list, item) in oneEmpList">
										<tr>
											<td colspan="10">데이터가 존재하지 않습니다.</td>
										</tr>
									</tbody>
								</template>
								<template v-else>
									<tbody id="oneEmp" v-for="(list, item) in oneEmpList">
										<tr>
											<td>{{ list.onedate }}</td>
											<td>{{ list.oneypay | comma }}</td>
											<td>{{ list.onempay | comma }}</td>
											<td>{{ list.onenins | comma }}</td>
											<td>{{ list.onehins | comma }}</td>
											<td>{{ list.oneeins | comma }}</td>
											<td>{{ list.oneiins | comma }}</td>
											<td>{{ list.onetax | comma }}</td>
											<td>{{ list.oneextra | comma }}</td>
											<td>{{ list.onerpay | comma }} 원</td>
										</tr>
									</tbody>
								 </template>
							</table>
	
						<div class="paging_area"  id="onePagination" v-html="onePagination"> </div>
						</div>
						
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>
	
</form>
</body>
</html>