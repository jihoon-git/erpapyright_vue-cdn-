<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>근태신청</title>
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
		
		searchTaApply();
		
		searchlest();
		
		fRegisterButtonClickEvent();	
	
	});
	
	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();		//이후의 예약 이벤트를 모두 소멸시킴

			var btnId = $(this).attr('id');	//해당 버튼의 아이디를 꺼내라

			switch (btnId) {
			case 'btnSave' :
					fn_save();
					break;
					case 'btnClose' :
					case 'btnClosefile' :
						gfCloseModal();
						break;
			}
		});
	}
	
	function searchTaApply(cpage){		//cpage라는 파라미터 값을 받을 것
		
		cpage = cpage || 1;		//undefined 면 1로 셋팅
		
		if($("#srcsdate").val() != "" && $("#srcedate").val() ==""){
			alert("종료일을 선택하세요."); 
		} else if($("#srcsdate").val() == "" && $("#srcedate").val() !="") {
			alert("시작일을 선택하세요.");
		} else if( $("#srcsdate").val() !="" && $("#srcedate").val() !="" && $("#srcsdate").val() > $("#srcedate").val()){
			alert("날짜를 확인해 주세요.");
		} else {
		
			//먼저 파라미터, callback 지정해줘야함
			var param = {				
					srcsdate : $("#srcsdate").val(),
					srcedate : $("#srcedate").val(),
					search_rest_name : $("#search_rest_name").val(),
					search_atd_yn : $("#search_atd_yn").val(),				
					pageSize : pageSize,
					cpage : cpage, 	//페이지번호를 넘김
					loginId : $("#loginId").val(),
					
			} //{}json 형태
			console.log(param);
			var listcallback = function(returndata){
				console.log(returndata);
						
				$("#taApplylist").empty().append(returndata);
				
				console.log("totcnt: " + $("#counttaApplylist").val());
				var counttaApplylist = $("#counttaApplylist").val();
				
				var paginationHtml = getPaginationHtml(cpage, counttaApplylist, pageSize, pageBlockSize, 'searchTaApply');
				console.log("paginationHtml : " + paginationHtml);
				//swal(paginationHtml);
				$("#taApplyPagination").empty().append( paginationHtml );
				
				// 현재 페이지 설정
				//$("#currentPageComnGrpCod").val(cpage);
				
								
			}	//함수형 변수
			
			/**
			 * ajax 공통 호출 함수
			 *
			 * @param
			 *   url : 서비스 호출URL
			 *   method : post, get
			 *   async : true, false		비동기식, sync는 응답을 기다림, async 사용시 false
			 *   param : data parameter
			 *   callback : callback function name
			 */
			 
			 callAjax("/employee/empTaApplylist.do", "post", "text", "false", param, listcallback);
		}
		 
	}
	
	/* 휴가등록 validation */
	function RegisterVal(){
		  
		var rest_cd = $("#rest_cd").val();
		var st_date = $("#st_date").val();
		var ed_date = $("#ed_date").val();
		var rest_rsn = $("#rest_rsn").val();
		
		if(rest_cd == ""){
			swal("근태종류를 선택하세요").then(function() {
				$("#rest_cd").focus();
			  });
			return false;
		}
		
		if(st_date == ""){
			swal("시작날짜를 선택하세요").then(function() {
				$("#st_date").focus();
			  });
			return false;
		}
		
		if(ed_date == ""){
			swal("마지막 날짜를 선택하세요").then(function() {
				$("#ed_date").focus();
			  });
			return false;
		}
		
		if(rest_rsn == ""){
			swal("휴가사유를 적어주세요").then(function() {
				$("#rest_rsn").focus();
			  });
			return false;
		}

		return true;
		
	}
	
function searchlest(){		//cpage라는 파라미터 값을 받을 것
		
		//undefined 면 1로 셋팅
		
		//먼저 파라미터, callback 지정해줘야함
		var param = {			
				loginId : $("#loginId").val(),
				
		} //{}json 형태
		console.log(param);
		var listcallback = function(returndata){
			console.log(returndata);
							
			$("#total_rest").empty().append(returndata);
									
		}		
		
		 callAjax("/employee/empTaApplylist2.do", "post", "text", "false", param, listcallback);
		 
	}
	
	/* 신규 등록 || 수정  */
	function initpopup(object) {		
			$("#dept_name").val(object.dept_name);
			$("#rest_cd").val("");
			
			$("#name").val(object.name);
			$("#emp_no").val(object.emp_no);		
			
			$("#st_date").val("");
			$("#ed_date").val("");
			
			$("#rest_rsn").val("");
			$("#rest_hp").val(object.hp);		
		
	}
	
	function fn_openpopup(){
	
	
			var param = {			
					loginId : $("#loginId").val(),
					
			} //{}json 형태
			console.log(param);
			var listcallback = function(returndata){
				console.log("returndata:", returndata);
			
			initpopup(returndata.rest_info);		
			 
		}		
			callAjax("/employee/restinfo.do", "post", "json", "false", param, listcallback);
		gfModalPop("#rest_reg");
	}
	
	function fn_save() {
			
			var param = {					
					
					atd_no : $("#atd_no").val(),
					rest_cd : $("#rest_cd").val(),
					loginId : $("#loginId").val(),
					st_date : $("#st_date").val(),
					ed_date : $("#ed_date").val(),									   
					rest_rsn : $("#rest_rsn").val(),
					action : $("#action").val(),
			}
			
			var savecallback = function(returndata) {
							
				console.log(  JSON.stringify(returndata) );
				
				if(returndata.result == "SUCCESS") {
					alert("신청 되었습니다.");
					gfCloseModal();
					searchTaApply();
				}
			}
			if(!RegisterVal()){
				
				return;
			}
			callAjax("/employee/taApplysave.do", "post", "json", "false", param, savecallback) ;
			
		}
		
	/* 반려사유 조회  */
	function rejectpopup(object) {		
			$("#atd_name").val(object.atd_name);
			$("#reject_rsn").val(object.reject_rsn);
			
	}
	function fn_rest_reject(atd_no){
		console.log(atd_no)
		
		var param = {
				atd_no : atd_no				
		}
		
		var detailonecallback = function (returndata){
			console.log( "returndata:" + JSON.stringify(returndata) );
			console.log(returndata.rest_reject.atd_no);
			
			rejectpopup(returndata.rest_reject);
			
		}
		
		callAjax("/employee/rest_reject.do", "post", "json", "false", param, detailonecallback);
		gfModalPop("#rest_reject");
	}	
	
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
	<form id="myForm" action="" method="">
		<input type="hidden" name="action" id="action" value="">
		<input type="hidden" name="loginId" id="loginId" value="${loginId}">
		<input type="hidden" name="userNm" id="userNm" value="${userNm}">
		<input type="hidden" name="atd_no" id="atd_no" value="">
		<input type="hidden" name="currentpage" id="currentpage" value="">
		

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
								<span class="btn_nav bold">인사관리</span>
								<span class="btn_nav bold">근태신청/조회</span>
								<a href="../employee/empTaApply.do" class="btn_set refresh">새로고침</a>
							</p>

							<p class="conTitle">
								<span>근태신청/조회</span>
								<span class="fr">
								일자<input type="date" id="srcsdate" name="srcsdate" /> ~
								<input type="date" id="srcedate" name="srcedate" />								
								<select id="search_rest_name" name="search_rest_name" size="1">
									<option value="">근태종류</option>
									<option value="월차">월차</option>
									<option value="연차">연차</option>
								</select>								
								<select id="search_atd_yn" name="search_atd_yn" size="1">
									<option value="">결재상태</option>
									<option value="y">승인</option>
									<option value="w">승인대기</option>
									<option value="n">반려</option>
								</select>
								<a class="btnType blue" href="javascript:searchTaApply();" name="modal">
									<span>조회</span></a>									
								</span>
							</p>
							
							<div>
								<table class="col">
									<caption>caption</caption>
									<colgroup>
										<col width="30%">
										<col width="30%">
										<col width="30%">										
									</colgroup>
									<thead>
										<tr>
											<th scope="col">총 연차</th>
											<th scope="col">사용 연차</th>
											<th scope="col">남은 연차</th>
										</tr>
									</thead>
									<tbody id="total_rest"></tbody>
								</table>
							</div>
							<a class="btnType blue"	href="javascript:fn_openpopup();" name="modal" style="float: right">
									<span>개인근태신청</span></a>
							<div class="divComGrpCodList">
								<table class="col">
									<caption>caption</caption>
									<colgroup>
										<col width="10%">
										<col width="10%">										
										<col width="25%">
										<col width="25%">
										<col width="15%">
										<col width="15%">
										
									</colgroup>
									<thead>
										<tr>
											<th scope="col">번호</th>
											<th scope="col">휴가종류</th>											
											<th scope="col">시작일</th>
											<th scope="col">종료일</th>
											<th scope="col">결재자</th>
											<th scope="col">결재상태</th>											
										</tr>
									</thead>
									<tbody id="taApplylist"></tbody>
								</table>
							</div>
							<div class="paging_area" id="taApplyPagination"></div>
						</div>

							


						</div> <!--// content -->

						<h3 class="hidden">풋터 영역</h3> <jsp:include
							page="/WEB-INF/view/common/footer.jsp"></jsp:include>
					</li>
				</ul>
			</div>
		</div>

		<div id="rest_reg" class="layerPop layerType2" style="width: 600px;">
			<dl>
				<dt>
					<strong>근태 신청</strong>
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
								<th scope="row">근무부서 <span class="font_red"></span></th>
								<td><input type="text" class="inputTxt p100" name="dept_name"
									id="dept_name" readonly /></td>
								<th scope="row">근태종류 <span class="font_red"></span></th>
								<td>
								<select id="rest_cd" name="rest_cd" size="1" class="check">
									<option value="">근태종류</option>									
									<option value="1">월차</option>
									<option value="2">연차</option>
								</select>
								</td>
							</tr>
							<tr>
								<th scope="row">성명<span class="font_red"></span></th>
								<td><input type="text" class="inputTxt p100" name="name"
									id="name" readonly /></td>
								<th scope="row">사원번호<span class="font_red"></span></th>
								<td><input type="text" class="inputTxt p100"
									name="emp_no" id="emp_no" readonly /></td>
							</tr>
							<tr>
								<th scope="row">기간 <span class="font_red">*</span></th>
								<td colspan="3">
								일자<input type="date" id="st_date" name="st_date" /> ~
								<input type="date" id="ed_date" name="ed_date" />	</td>
							</tr>

							<tr>
								<th scope="row">휴가사유<span class="font_red">*</span></th>
								<td colspan="3"><textarea class="inputTxt p100"
										name="rest_rsn" id="rest_rsn"> </textarea></td>
							</tr>
							<tr>
								<th scope="row">연락처<span class="font_red"></span></th>
								<td colspan="3">
								<input type="text" class="inputTxt p100"
									id="rest_hp" name="rest_hp" readonly /></td>
							</tr>

						</tbody>
					</table>

					<!-- e : 여기에 내용입력 -->

					<div class="btn_areaC mt30">
						<a href="" class="btnType blue" id="btnSave" name="btn"><span>신청</span></a>						
						<a href="" class="btnType gray" id="btnClose" name="btn"><span>닫기</span></a>
					</div>
				</dd>
			</dl>
			<a href="" class="closePop"><span class="hidden">닫기</span></a>
		</div>
		
		<div id="rest_reject" class="layerPop layerType2" style="width: 600px;">
			<dl>
				<dt>
					<strong>반려사유</strong>
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
								<th scope="row">결재자 <span class="font_red"></span></th>
								<td>
								<input type="text" class="inputTxt p100" name="atd_name" id="atd_name" readonly />
								</td>
							</tr>
							<tr  height="100">
								<th scope="row">반려사유<span class="font_red"></span></th>
								<td >
								<textarea class="inputTxt p100" name="reject_rsn" id="reject_rsn" readonly></textarea>
								<!-- <input type="text" class="inputTxt p100" name="reject_rsn" id="reject_rsn" readonly/> -->
								</td>								
							</tr>
						</tbody>
					</table>

					<!-- e : 여기에 내용입력 -->
					<div class="btn_areaC mt30">												
						<a href="" class="btnType gray" id="btnClose" name="btn"><span>닫기</span></a>
					</div>
				</dd>
			</dl>
			<a href="" class="closePop"><span class="hidden">닫기</span></a>
		</div>


	</form>
</body>
</html>