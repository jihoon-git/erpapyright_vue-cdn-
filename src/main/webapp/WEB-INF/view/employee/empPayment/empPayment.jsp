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

	// 그룹코드 페이징 설정_급여내역
	var pageSize = 3;			//한페이지에 몇개 볼것인가
	var pageBlockSize = 5;
	
	// 그룹코드 페이징 설정_개인급여내역
	var opageSize = 5;			//한페이지에 몇개 볼것인가
	var opageBlockSize = 5;
	
	/** OnLoad event */ 
	$(function() {
		
		comcombo("dept_cd", "srcdept", "all", "selvalue");
		comcombo("rank_cd", "srcrank", "all", "selvalue");
		
		
		
		searchemp();
		
		fRegisterButtonClickEvent();
	
	});
	
	
	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();		//이후의 예약 이벤트를 모두 소멸시킴

			var btnId = $(this).attr('id');	//해당 버튼의 아이디를 꺼내라

			switch (btnId) {
			case 'btnEmpClick' :
				$("#clickEmp").val(''); //검색후 검색한것 초기화 용도
				$("#clickEmp").val('Z');
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
		
		$("#oneEmpList").hide();
		var srcdate = $("#srcdate").val();
		
		if (srcdate <= getToday()){
			
			cpage = cpage || 1;		// 현재 page가 undefined 면 1로 셋팅	
		
			if($("#clickEmp").val()=='Z'){
				// param과 callback 지정
				var param = { // 컨트롤러로 넘겨줄 이름 : 보내줄값
		
						srcrank : $("#srcrank").val(),
						srcdept : $("#srcdept").val(),
						srcName : $("#srcName").val(),
						srcyn : $("#srcyn").val(),
						srcdate : $("#srcdate").val(),
						pageSize : pageSize,
						cpage : cpage,
						
				}
			} else{
				var param = { // 컨트롤러로 넘겨줄 이름 : 보내줄값
						
						pageSize : pageSize,
						cpage : cpage,
						
				}
			}
			
			var listcallback = function(returndata){
				console.log(returndata);
				
	 			$("#listEmp").empty().append(returndata);
				var cntempPaylist = $("#cntempPaylist").val();
				var checkyn = $("#yncheck").val();
				
				if(checkyn != cntempPaylist || checkyn == null){
					$("#btnAllSave").show();
				}else{
					$("#btnAllSave").hide();
				}
					
				
				var paginationHtml = getPaginationHtml(cpage, cntempPaylist, pageSize, pageBlockSize, 'searchemp');
				console.log("paginationHtml : " + paginationHtml);
				
				$("#empPagination").empty().append( paginationHtml );
				

			}
			callAjax("/employee/empPaylist.do", "post", "text", "false", param, listcallback);
			
		}else {
			alert('오늘 이후의 날짜는 검색 할 수 없습니다.')
		}

	} //searchemp
	
	
	/* 버튼 클릭시 값 저장 */
    function fn_loginsave(sloginID,salaryno,expno){
		
    	$("#cloginID").val(sloginID);
    	$("#salaryno").val(salaryno);
    	$("#expno").val(expno);
    	$("#oneEmpList").hide();
    	
    	fn_onesave();
	} //fn_loginsave
	
	
	/* 지급대기 버튼 클릭시 저장 */
	function fn_onesave(sloginID) {
		
		console.log($("#cloginID").val());
	
		var param = {
				loginID : $("#cloginID").val(),
				salaryno : $("#salaryno").val(),
				expno : $("#expno").val(),
				srcdate : $("#srcdate").val(),
		}
		
		var onesavecallback = function(returndata) {
						
			console.log(  JSON.stringify(returndata) );
			
			if(returndata.result == "SUCCESS") {
				alert("지급 되었습니다.");
				searchemp();
			}
		}
		
		callAjax("/employee/empsave.do", "post", "json", "false", param, onesavecallback) ;
		
	}//fn_onesave
	
	
	
	/* 일괄저장  */
	function allSaveBtn() {
			
		var param = {
				srcrank : $("#srcrank").val(),
				srcdept : $("#srcdept").val(),
				srcName : $("#srcName").val(),
				srcyn : $("#srcyn").val(),
				srcdate : $("#srcdate").val(),
		}
		
		var allsavecallback = function(returndata) {
						
			console.log(  JSON.stringify(returndata) );
			
			if(returndata.result == "SUCCESS") {
				alert("일괄지급 되었습니다.");
				searchemp();
			}
		}
		
		callAjax("/employee/empsaveall.do", "post", "json", "false", param, allsavecallback) ;
		
	}//allSaveBtn
	
	
	/* 사원명 눌러서 개인 급여 조회 */
	function fn_oneemp(sloginID){
		
		$("#sloginID").val(sloginID);
		$("#oneEmpList").show();
		oneemp();
		
	} //fn_oneemp
	
	
	/*개인 급여 지급 내역 조회*/
	
	function oneemp(cpage) { // 현재 page 받기
		cpage = cpage || 1;		// 현재 page가 undefined 면 1로 셋팅	
		
		/* 선택한 아이디값... */
		
		// param과 callback 지정
		var param = { // 컨트롤러로 넘겨줄 이름 : 보내줄값

				sloginID : $("#sloginID").val(),
				pageSize : opageSize,
				cpage : cpage,
				
		} // {} json 형태
		
		var onecallback = function(oreturndata){
			console.log(oreturndata);
			
 			$("#oneEmp").empty().append(oreturndata);
 			
   			$("#seno").val($("#oneeno").val());
   			$("#snm").val($("#onenm").val());
   			$("#sdept").val($("#onedept").val());
   			$("#srank").val($("#onerank").val());
 			
			var cntempOnelist = $("#cntempOnelist").val();
			
			
			var paginationHtml = getPaginationHtml(cpage, cntempOnelist, opageSize, opageBlockSize, 'oneemp');
			console.log("paginationHtml : " + paginationHtml);
			$("#onePagination").empty().append( paginationHtml );
		}
		
		callAjax("/employee/emponelist.do", "post", "text", "false", param, onecallback);
	} //oneemp
	
	
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
	<input type="hidden" name="sloginID" id="sloginID" value="">
	<input type="hidden" name="cloginID" id="cloginID" value="">
	<input type="hidden" name="salaryno" id="salaryno" value="">
	<input type="hidden" name="expno" id="expno" value="">
	<input type="hidden" name="clickEmp" id="clickEmp" value="">
	
	
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
								class="btn_nav bold">인사 · 급여 </span> <span class="btn_nav bold">급여관리
								</span> <a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>급여 지급 내역 조회</span> <span class="fr" style="float: left; margin-bottom: 5px"> 
							   부서
							   <select name="srcdept" id="srcdept" style="width: 80px;"></select>
							 &nbsp;직급
							   <select name="srcrank" id="srcrank" style="width: 50px;"></select>
							 &nbsp;사원명
							   <input type="text" width="100px;" id="srcName" name="srcName" onkeyup="nameCheckForm(this)"	/>
                             &nbsp;지급상태  
                               <select name="srcyn" id="srcyn" style="width: 50px;">
                               		<option value>전체</option>
                               		<option value="y">완료</option>
                               		<option value="w">대기</option>
                               </select>
                             &nbsp;급여년월  
                               <input type="date" id="srcdate" name="srcdate" style="margin-right: 90px"/>
                               <a	class="btnType blue" href="" id=btnEmpClick name="btn" ><span>검색</span></a>						   
                               <a	class="btnType blue" href="" id=btnAllSave name="btn" ><span>일괄지급</span></a>						   
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
								<tbody id="listEmp"></tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="empPagination"> </div>
						
						<br/>
						<br/>
						
						<div class="oneEmpList" id="oneEmpList">
						
						<p class="conTitle">
							<span>개인 급여 지급 내역 조회</span> <span class="fr" style="float: left; margin-bottom: 5px;">
							사번
							<input type="text" width="100px;" id="seno" name="seno"	style="text-align: center; font-weight: bold;"  readonly/>
							&nbsp;사원명
							<input type="text" width="100px;" id="snm" name="snm" style="text-align: center; font-weight: bold;"	readonly/>
							&nbsp;부서명
							<input type="text" width="100px;" id="sdept" name="sdept" style="text-align: center; font-weight: bold;"	readonly/>
							&nbsp;현재직급
							<input type="text" width="100px;" id="srank" name="srank" style="text-align: center; font-weight: bold;"	readonly/>
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
								<tbody id="oneEmp"></tbody>
							</table>
	
						<div class="paging_area"  id="onePagination"> </div>
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