<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>인사 관리</title>
<!-- 우편번호 조회 -->
<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" charset="utf-8"
	src="${CTX_PATH}/js/popFindZipCode.js"></script>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<script type="text/javascript">

	// 페이징 설정
	var pageSize = 5;
	var pageBlockSize = 5;
	
	/** OnLoad event */ 
	$(function() {
	
		fRegisterButtonClickEvent();
	
		// 공통코드
		comcombo("dept_cd", "searchDeptCd", "all", ""); //부서
		comcombo("rank_cd", "searchRankCd", "all", ""); //직무

		// 사원목록
		searchEmpMgt();
		
	});
	
	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();

			var btnId = $(this).attr('id');

			switch (btnId) {
				case 'btnClose' :
				case 'btnClosefile' :
					gfCloseModal();
					break;
			}
		});

		$('a[name=search]').click(function(e) {
			e.preventDefault();

			var btnId = $(this).attr('id');
			if(btnId = "btnSearch"){

				if($("#srcsdate").val()!= '' && $("#srcedate").val() != ''){
					if($("#srcsdate").val()>$("#srcedate").val()){
						swal("종료일이 시작일 보다 빠를 수 없습니다.");
						return;
						}
					}
				var numbercheck = /^[0-9]*$/;
				var namecheck = /^[a-zA-Z가-힣]*$/;
				if($("#searchWord").val()!= ''){
					if($("#searchKey").val()=="empNo"){
						if(!numbercheck.test($("#searchWord").val())){
						swal("사번에는 숫자만 입력 가능합니다.");
							return;
						}
					} 
					if($("#searchKey").val()=="name"){
						if(!namecheck.test($("#searchWord").val())){
						swal("사원명에는 문자만 입력 가능합니다.");
							return;
						}
					}
				}

				$("#hdSearchDeptCd").val($("#searchDeptCd").val())
				$("#hdSearchRankCd").val($("#searchRankCd").val())
				$("#hdSearchKey").val($("#searchKey").val())
				$("#hdSearchWord").val($("#searchWord").val())
				$("#hdSrcsdate").val($("#srcsdate").val())
				$("#hdSrcedate").val($("#srcedate").val())
				searchEmpMgt();
			}
			
		});
		
		var upfile = document.getElementById('profileUpload');
		console.log(upfile);
		upfile.addEventListener('change',
				function(event) {
					$("#profilePreview").empty();
					var image = event.target;
					var imgpath = "";
					if (image.files[0]) {								
						imgpath = window.URL.createObjectURL(image.files[0]);
						
						console.log(imgpath);
						
						var filearr = $("#profileUpload").val().split(".");

						var previewhtml = "";

						if (filearr[1] == "jpg" || filearr[1] == "png") {
							previewhtml = "<img src='" + imgpath + "' style='width: 200px; height: 130px;' />";
						} else {
							previewhtml = "";
						}

						$("#profilePreview").empty().append(previewhtml);
					}
				});
		}
	
	
	/* 사원 목록 조회 */
	function searchEmpMgt(cpage, statusCd) {

		cpage = cpage || 1;
		statusCd = statusCd || 'A';

		/* 재직자 휴직자 퇴직자 버튼 컬러 변경 */
		if (statusCd == 'A'){ //재직
			$('#showInEmp').removeClass('color1');
			$('#showInEmp').addClass('color2');
			$('#showRestEmp').removeClass('color2');
			$('#showRestEmp').addClass('color1');
			$('#showOutEmp').removeClass('color2');
			$('#showOutEmp').addClass('color1');
			$('#edDate').hide();
			$('#lvDay').hide();
			$('#comeback').hide();
			$('#updateStatus').show();
		}
		if (statusCd == 'B') { //휴직
			$('#showRestEmp').removeClass('color1');
			$('#showRestEmp').addClass('color2');
			$('#showInEmp').removeClass('color2');
			$('#showInEmp').addClass('color1');
			$('#showOutEmp').removeClass('color2');
			$('#showOutEmp').addClass('color1');
			$('#edDate').hide();
			$('#updateStatus').hide();
			$('#lvDay').show();
			$('#comeback').show();
		}
		if(statusCd == 'C'){ //퇴직
			$('#showOutEmp').removeClass('color1');
			$('#showOutEmp').addClass('color2');
			$('#showRestEmp').removeClass('color2');
			$('#showRestEmp').addClass('color1');
			$('#showInEmp').removeClass('color2');
			$('#showInEmp').addClass('color1');
			$('#updateStatus').hide();
			$('#lvDay').hide();
			$('#comeback').hide();
			$('#edDate').show();
		}

		// 검색시 재직상태 고정되는지 체크해봐야 함
		$('#currentEmpStatus').val(statusCd);

			// 파라미터,  callback
			var param = {
					searchDeptCd : $('#hdSearchDeptCd').val(),
					searchRankCd : $('#hdSearchRankCd').val(),
					searchKey : $('#hdSearchKey').val(),
					searchWord : $('#hdSearchWord').val(),
					srcsdate : $("#hdSrcsdate").val(),
					srcedate : $("#hdSrcedate").val(),
					pageSize : pageSize,
					cpage : cpage,
					statusCd : statusCd
			}
		console.log(param);
		
		var listcallback = function(returndata) {
	
			console.log(returndata);
			
			$("#listEmpMgt").empty().append(returndata);
			
			var countEmpMgtList = $("#countEmpMgtList").val();
			
			var paginationHtml = getPaginationHtml(cpage, countEmpMgtList, pageSize, pageBlockSize, 'searchEmpMgt',[statusCd]);
			
			$("#empMgtPagination").empty().append(paginationHtml);
			
			$("#currentpage").val(cpage);

			$("#currentEmpStatus").val(statusCd);
			
		}
		
		callAjax("/employee/empMgtList.do", "post", "text", "false", param, listcallback) ;
	}
	
// 오늘 날짜
    function getToday(){
        var date = new Date();
        var year = date.getFullYear();
        var month = ("0" + (1 + date.getMonth())).slice(-2);
        var day = ("0" + date.getDate()).slice(-2);

        return year + "-" + month + "-" + day;
    }
	
// 휴직 모달
function fModalLeaveEmp(leaveLoginID, leaveEmpNo, leaveName, leaveJoinDate){

	$('#leaveLoginID').val(leaveLoginID);
	$('#leaveEmpNo').val(leaveEmpNo);
	$('#leaveName').val(leaveName);
	$('#leaveJoinDate').val(leaveJoinDate);
	$('#leaveStartDate').val("");
	$('#leaveEndDate').val("");
	
	$("#leaveStartDate").change(function() {
		if ($("#leaveStartDate").val() < $("#leaveJoinDate").val()) {
			swal("입사일 보다 휴직 시작일이 작을 수 없습니다.")
			$("#leaveStartDate").val('');
		}
	});

	gfModalPop("#leaveEmp");
}

// 휴직 처리
function fnLeaveEmp(){

	var leaveStartDate = $('#leaveStartDate').val();
	var leaveEndDate = $('#leaveEndDate').val();

	if(leaveStartDate == ""){
		swal("휴직 시작일을 입력해주세요.")
		return;
	}
	if(leaveEndDate == ""){
		swal("휴직 종료일을 입력해주세요.")
		return;
	}
	if(leaveStartDate!= '' && leaveEndDate != ''){
		if(leaveStartDate>leaveEndDate){
		swal("휴직 종료일이 시작일 보다 빠를 수 없습니다.");
		$("#leaveStartDate").val('');
		$("#leaveEndDate").val('');
		return;
		}
	}

	var param = {
		loginID : $("#leaveLoginID").val(),
		lvst_date : $("#leaveStartDate").val(),
		lved_date : $("#leaveEndDate").val()
	}

	swal("휴직 처리 하시겠습니까?", {
		buttons : {
			yes : "예",
			no : "취소"
		}
	}).then((value) => {
		switch(value){
		case "yes" :
			var leaveCallback = function(returndata){
				if(returndata.result == "SUCCESS") {
					swal(returndata.resultMsg);
					gfCloseModal();
					searchEmpMgt($("#currentpage").val());
				}else {
					swal("휴직처리에 실패하였습니다.");
				}
			};
			
			callAjax("/employee/leaveEmp.do", "post", "json", "false", param, leaveCallback);
			
			break;
		case "no" :
			break;
		}
	});


}

// 복직 모달
function fModalComebackEmp(comebackLoginID, comebackEmpNo, comebackName, comebackStartDate, comebackEndDate){

	$('#comebackLoginID').val(comebackLoginID);
	$('#comebackEmpNo').val(comebackEmpNo);
	$('#comebackName').val(comebackName);
	$('#comebackStartDate').val(comebackStartDate);
	$('#comebackEndDate').val(comebackEndDate);

	gfModalPop("#comebackEmp");
}

// 복직 처리
function fnComebackEmp(){

	var param = {
		loginID : $("#comebackLoginID").val()
	}

	swal("복직 처리 하시겠습니까?", {
		buttons : {
			yes : "예",
			no : "취소"
		}
	}).then((value) => {
		switch(value){
		case "yes" :
			var comebackCallback = function(returndata){
				if(returndata.result == "SUCCESS") {
					swal(returndata.resultMsg);
					gfCloseModal();
					searchEmpMgt($("#currentpage").val());
				}else {
					swal("복직처리에 실패하였습니다.");
				}
			};
			
			callAjax("/employee/comebackEmp.do", "post", "json", "false", param, comebackCallback);
			
			break;
		case "no" :
			break;
		}
	});


}


// 퇴직 모달
function fModalRetireEmp(retireLoginID, retireEmpNo, retireName, retireStDate){
	
	$('#retireLoginID').val(retireLoginID);
	$('#retireEmpNo').val(retireEmpNo);
	$('#retireName').val(retireName);
	$('#retireStDate').val(retireStDate);

	$("#retireEdDate").change(function() {
		if ($("#retireEdDate").val() < $("#retireStDate").val()) {
			swal("입사일 보다 퇴사일이 작을 수 없습니다.")
			$("#retireEdDate").val('');
		}
	});
	
	gfModalPop("#retireEmp");
}

// 퇴직 처리
function fnRetireEmp(){

	var retireEdDate = $('#retireEdDate').val();

	if(retireEdDate == ""){
		swal("퇴사일을 입력해주세요.")
		return;
	}

	var param = {
	loginID : $("#retireLoginID").val(),
	ed_date : $("#retireEdDate").val()
	}

	swal("퇴사 처리 하시겠습니까?", {
			buttons : {
				yes : "예",
				no : "취소"
			}
		}).then((value) => {
			switch(value){
			case "yes" :
				var retireCallback = function(returndata){

					if(returndata.result == "SUCCESS") {
						swal(returndata.resultMsg);
						gfCloseModal();
						searchEmpMgt($("#currentpage").val());

					} else {
						swal("퇴직처리에 실패하였습니다.");
					}
				};
				
				callAjax("/employee/retireEmp.do", "post", "json", "false", param, retireCallback);
				
				break;
			case "no" :
				break;
			}
		});


	}



// 사원 상세 조회 모달
function fnEmpMgtDet(loginID){

	var param = {
		loginID : loginID
	}

	var resultCallback = function(returndata){
		console.log(  JSON.stringify(returndata)  );

		if(returndata.result == "SUCCESS"){
			empMgtDetInit(returndata)
			gfModalPop('#layer1');
		}
	};

	callAjax("/employee/empMgtDet.do", "post", "json", true, param, resultCallback);
}

// 사원 상세 조회 init
function empMgtDetInit(object){
	
		// 사원 정보 수정만 가능하기 때문에 object가 null 일때의 if문은 작성x
		empEmpDisabled(object.empMgtDet.status_cd); // 퇴직자의 경우 수정 불가하게 하는 함수

		// var splitMail = (object.empMgtDet.email ||'').split('@');;
		var splitHp = (object.empMgtDet.hp||'').split('-');;
		
		$("#emp_no").val(object.empMgtDet.emp_no); // 사번
		$("#loginID").val(object.empMgtDet.loginID); // 로그인ID
		$("#detLoginId").val(object.empMgtDet.loginID); // 로그인ID
		$("#name").val(object.empMgtDet.name); // 사원명
		$("#birthday").val(object.empMgtDet.birthday); // 생년월일
		$("#sex").val(object.empMgtDet.sex).prop("selected", true); // 성별
		comcombo("school_cd", "detSchoolCd", "sel", object.empMgtDet.school_cd); // 최종학력

		// $('#mail1').val(splitMail[0]); $('#mail2').val(splitMail[1]); // 이메일
		$("#mail").val(object.empMgtDet.email); // 이메일
		$.each($("#hp1 > option"), function(index, item){
				if($(item).text() == splitHp[0]){
					$(item).prop("selected", true);
				}
			});//전화번호 앞자리
		$('#hp2').val(splitHp[1]); $('#hp3').val(splitHp[2]); // 전화번호
		$('#detZip').val(object.empMgtDet.zip_code); $('#addr').val(object.empMgtDet.addr); $('#det_addr').val(object.empMgtDet.det_addr);

		comcombo("bank_cd", "detBankCd", "sel", object.empMgtDet.bank_cd); // 은행명
		$("#account").val(object.empMgtDet.account); // 계좌번호
		comcombo("user_type", "detUserType", "sel", object.empMgtDet.user_type); // 권한
		comcombo("dept_cd", "detDeptCd", "sel", object.empMgtDet.dept_cd); // 부서
		comcombo("rank_cd", "detRankCd", "sel", object.empMgtDet.rank_cd); // 직급
		comcombo("status_cd", "detStatusCd", "sel", object.empMgtDet.status_cd); // 재직상태

		$("#st_date").val(object.empMgtDet.st_date); // 입사일

		if(object.empMgtDet.pay_nego == 0){ // 연봉협상버튼
			$("#negoBtn").val("입력");
			$("#year_pay").val('');
			$("#year_pay").attr("placeholder", "미협상");
		} else {
			$("#negoBtn").val("수정");
			$("#year_pay").val(object.empMgtDet.year_pay); // 연봉
		}
		$("#pay_nego").val(object.empMgtDet.pay_nego); // 연봉협상유무 0이면 insert
		$("#lvst_date").val(object.empMgtDet.lvst_date); // 휴직시작일
		$("#lved_date").val(object.empMgtDet.lved_date); // 휴직종료일
		$("#ed_date").val(object.empMgtDet.ed_date); // 퇴사일


		//재직/휴직/퇴직 경우 다르게 해야함
		if(object.empMgtDet.status_cd =='C'){ // 퇴직
			$('#updateBtnArea').hide(); // 수정버튼숨기기
			$('#negoBtn').hide(); // 연봉협상버튼숨기기
			$('#vacationPeriod').hide(); // 휴직기간 숨기기
			$('#retirementDate').show(); // 퇴사일 보이게

		}  else if (object.empMgtDet.status_cd =='B') { // 휴직
			$('#updateBtnArea').show(); // 수정버튼 보이게
			$('#negoBtn').show(); // 연봉협상버튼 보이게
			$('#vacationPeriod').show(); // 휴직기간 보이게
			$('#retirementDate').hide(); // 퇴사일 숨기기

		} else{ // 재직
		$('#updateBtnArea').show(); // 수정버튼 보이게
		$('#negoBtn').show(); // 연봉협상버튼 보이게
			$('#vacationPeriod').hide(); // 휴직기간 숨기기
			$('#retirementDate').hide(); // 퇴사일 숨기기
		}
		
	$("#profilePreview").val("");
	
	var file_name = object.empMgtDet.file_name;
	var filearr = [];
	var previewhtml = "";

	
	if( file_name == "" || file_name == null || file_name == undefined) {
		previewhtml = "";
	} else {
		filearr = file_name.split(".");
		
		
		if (filearr[1] == "jpg" || filearr[1] == "png") {
			previewhtml = "<a>   <img src='" + object.empMgtDet.file_nadd + "' style='width: 200px; height: 130px;' />  </a>";
		} else {
			previewhtml = "<a>" + object.empMgtDet.file_name  + "</a>";
		}
	}
	

	$("#profilePreview").empty().append(previewhtml);
	
	// $("#btnDeletefile").show();
}


// 사원 정보 수정
function fnUpdateEmp(){

	var param = $("#detail").serialize();

 	/*이메일 정규식*/
	var emailRules = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
	var email = $("#mail").val();
	
	/*전화번호 정규식*/
	var hp1Rules = /^\d{2,3}$/;
	var hp2Rules = /^\d{3,4}$/;
	var hp3Rules = /^\d{4}$/;
	var hp1 = $("#hp1").val();
	var hp2 = $("#hp2").val();
	var hp3 = $("#hp3").val();

	/* 계좌번호 정규식 */
	var accountRules = /^\d{0,20}$/;
	var account = $("#account").val();

	var empViewForm = document.getElementById("detail");

	if(!validateEmp()){
		return;
	}
	if(!emailRules.test($("#mail").val())){
		swal("이메일 형식을 확인해주세요.").then(function() {
			$("#mail").focus();
		  });
	} else if(!hp1Rules.test($("#hp1").val())){
		swal("전화번호를 확인해주세요.").then(function() {
			$("#hp1").focus();
		  });
	} else if(!hp2Rules.test($("#hp2").val())){
		swal("전화번호를 확인해주세요.").then(function() {
			$("#hp2").focus();
		  });
	} else if(!hp3Rules.test($("#hp3").val())){
		swal("전화번호를 확인해주세요.").then(function() {
			$("#hp3").focus();
		  });
	} else if(!accountRules.test($("#account").val())){
		swal("계좌번호는 숫자만 입력 가능합니다.").then(function() {
			$("#account").focus();
		  });
	} else{
			swal("사원 정보를 수정 하시겠습니까?", {
			buttons : {
				yes : "예",
				no : "취소"
			}
			}).then((value) => {
				switch(value){
				case "yes" :
					empViewForm.enctype = 'multipart/form-data';

					var fileData = new FormData(empViewForm);

					
					var resultCallback = function(data) {
						updateEmpResult(data);
					};

				callAjaxFileUploadSetFormData("/employee/updateEmp.do", "post", "json",  true, fileData, resultCallback);
						
					break;

					case "no" :
					break;
				}
			});
	}

}

//사원 정보 수정 callback함수
function updateEmpResult(data){
	if (data.result == "SUCCESS") {
		swal(data.resultMsg);
		gfCloseModal();
		searchEmpMgt($("#currentpage").val());
	}else {
		swal("수정 실패하였습니다.");
	}
}

// 사원 정보 주소 입력 다음주소 api (login.jsp)
function execDaumPostcode(q) {
	new daum.Postcode({
		oncomplete : function(data) {
			// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

			// 각 주소의 노출 규칙에 따라 주소를 조합한다.
			// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
			var addr = ''; // 주소 변수
			var extraAddr = ''; // 참고항목 변수

			//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
			if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
				addr = data.roadAddress;
			} else { // 사용자가 지번 주소를 선택했을 경우(J)
				addr = data.jibunAddress;
			}

			// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
			if (data.userSelectedType === 'R') {
				// 법정동명이 있을 경우 추가한다. (법정리는 제외)
				// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
				if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
					extraAddr += data.bname;
				}
				// 건물명이 있고, 공동주택일 경우 추가한다.
				if (data.buildingName !== '' && data.apartment === 'Y') {
					extraAddr += (extraAddr !== '' ? ', '
							+ data.buildingName : data.buildingName);
				}
			}

			// 우편번호와 주소 정보를 해당 필드에 넣는다.
			document.getElementById('detZip').value = data.zonecode;
			document.getElementById("addr").value = addr;
			// 커서를 상세주소 필드로 이동한다.
			document.getElementById("det_addr").focus();
		}
	}).open({
		q : q
	});
}

// 연봉 협상
function fnNego(){

var year_pay = $('#year_pay').val();

	if(year_pay == ""){
		swal("연봉을 입력해주세요.").then(function() {
			$("#year_pay").focus();
			});
	return false;
	}
	if(year_pay == 0){
		swal("연봉을 0 이상 입력해주세요.").then(function() {
			$("#year_pay").focus();
			});
	return false;
	}
	
	var param = {
			loginID :  $("#loginID").val(),
			year_pay : $("#year_pay").val()
		}

	if(pay_nego.value == 0){ // 연봉협상 테이블에 협상내역이 없을 때 insert

	swal("연봉을 입력 하시겠습니까?", {
			buttons : {
				yes : "예",
				no : "취소"
			}
		}).then((value) => {
			switch(value){
			case "yes" :
				var negoCallback = function(returndata){
					if(returndata.result == "SUCCESS") {
						swal(returndata.resultMsg);
					}
				}
				
				callAjax("/employee/insertNego.do", "post", "json", "false", param, negoCallback);
				$("#pay_nego").val(-1); // pay_nego 값을 -1로 변경하여 연속으로 버튼을 눌렀을 때 반복적으로 insert 하지 않도록 함
				$("#negoBtn").val("수정");
				
					break;
				case "no" :
					break;
				}
		});

	} else{ // 연봉협상 테이블에 협상내역이 있을 때 update

		swal("연봉을 수정 하시겠습니까?", {
			buttons : {
				yes : "예",
				no : "취소"
			}
		}).then((value) => {
			switch(value){
			case "yes" :
				var negoCallback = function(returndata){
				console.log(  JSON.stringify(returndata) );
						if(returndata.result == "SUCCESS") {
							swal(returndata.resultMsg);
					}
				}

				callAjax("/employee/updateNego.do", "post", "json", "false", param, negoCallback);
				
				break;
				case "no" :
				break;
			}
		});

	}
}

// 사원 상세조회 - 퇴직자 정보 disabled
function empEmpDisabled(currentEmpStatus){

	if(currentEmpStatus == 'C'){ //퇴직자 일 때
		$('#userProfile').attr('onclick', '').unbind('click');
		$('#userProfile').attr("style", "cursor : default");
		$("#detSchoolCd").prop("disabled", true);
		$("#detBankCd").prop("disabled", true);
		$("#detDeptCd").prop("disabled", true);
		$("#detUserType").prop("disabled", true);
		$("#detRankCd").prop("disabled", true);
		
		$("#hp1").prop("disabled", true);
		$('#loginID').prop("disabled", true); $('#name').prop("disabled", true); 
		$('#emp_no').prop("disabled", true);
		$("#sex").prop("disabled", true); // 성별
		$('#birthday').prop("disabled", true);
		$('#mail').prop("disabled", true);
		$('#hp1').prop("disabled", true);$('#hp2').prop("disabled", true); $('#hp3').prop("disabled", true); 
		$('#post_cd').attr("style", "width: 35%; height: 50%; cursor : default");
		$('#post_cd').attr('onclick', '').unbind('click');
		$('#detZip').prop("disabled", true);
		$('#addr').prop("disabled", true); 
		$('#det_addr').prop("disabled", true);
		$('#account').prop("disabled", true);

		$('#detStatusCd').prop("disabled", true); // 재직구분
		$('#st_date').prop("disabled", true);
		$('#ed_date').prop("disabled", true);
		$('#lvst_date').prop("disabled", true);
		$('#lved_date').prop("disabled", true);

		$('#year_pay').prop("disabled", true);
		$('#negoBtn').attr("style", "width: 27%; height: 100%; cursor :  default"); // 연봉
		$('#negoBtn').attr('onclick', '').unbind('click');

	} else { //재직자일 때
		$('#userProfile').addClass('profile');
		$('#userProfile').attr('onclick', 'document.all.profileUpload.click()').bind('click');
		$('#userProfile').attr("style", "cursor : pointer");
		$("#detSchoolCd").prop("disabled", false);
		$("#detBankCd").prop("disabled", false);
		$("#detDeptCd").prop("disabled", false);
		$("#detUserType").prop("disabled", false);
		$("#detRankCd").prop("disabled", false);
		$("#hp1").prop("style", "pointer-events : ''; width : 30%");
		$('#loginID').prop("disabled", true); $('#name').prop("disabled", true); 
		$('#emp_no').prop("disabled", true);
		$("#sex").prop("disabled", true); // 성별
		$('#birthday').prop("disabled", true);
		$('#mail').prop("disabled", false);
		$('#hp1').prop("disabled", false); $('#hp2').prop("disabled", false); $('#hp3').prop("disabled", false); 
		$('#post_cd').attr("style", "width: 35%; height: 50%; cursor : pointer");
		$('#post_cd').attr('onclick', 'execDaumPostcode()').bind('click');
		$('#detZip').prop("disabled", false);
		$('#addr').prop("disabled", false); 
		$('#det_addr').prop("disabled", false);
		$('#account').prop("disabled", false);
		$('#st_date').attr("disabled", false);
		$('#ed_date').prop("disabled", true); // 퇴사일
		$('#lvst_date').prop("disabled", true); // 휴직시작일
		$('#lved_date').prop("disabled", true); // 휴직종료일

		$('#detStatusCd').prop("disabled", true); // 재직구분
		$('#negoBtn').attr("style", "width: 27%; height: 100%; cursor : pointer"); // 연봉
		$('#negoBtn').attr('onclick', 'fnNego()').bind('click');
		$('#year_pay').prop("disabled", false);
	}
}

/* 사원 정보 수정 validation */
function validateEmp(){

	var school_cd = $('#detSchoolCd').val();
	var user_type = $('#detUserType').val();
	var rgemail = $('#mail').val();
	var zip_code = $('#detZip').val();
	var addr = $('#addr').val();
	var det_addr = $('#det_addr').val();
	var hp1 = $('#hp1').val();
	var hp2 = $('#hp2').val();
	var hp3 = $('#hp3').val();
	var bank_cd = $('#detBankCd').val();
	var account = $('#account').val();
	var st_date = $('#st_date').val();
	var rank_cd = $('#detRankCd').val();
	var dept_cd = $('#detDeptCd').val();

	if(school_cd == ""){
		swal("최종학력을 입력해주세요.").then(function() {
			$("#detSchoolCd").focus();
		  });
		return false;
	}
	if(rgemail.length < 1){
		swal("이메일을 입력하세요.").then(function() {
			$('#mail').focus();
			});
	return false;
	}
	if(hp1.length < 1){
		swal("전화번호를 입력하세요.").then(function() {
			$('#hp1').focus();
		  });
		return false;
	}
	
	if(hp2.length < 1){
		swal("전화번호를 입력하세요.").then(function() {
			$('#hp2').focus();
		  });
		return false;
	}
	
	if(hp3.length < 1){
		swal("전화번호를 입력하세요.").then(function() {
			$('#hp3').focus();
		  });
		return false;
	}
	if(zip_code.length < 1){
		swal("우편번호를 입력하세요.").then(function() {
			$('#detZip').focus();
		  });
		return false;
	}
	
	if(addr.length < 1){
		swal("주소를 입력하세요.").then(function() {
			$('#addr').focus();
		  });
		return false;
	}
	
	if(det_addr.length < 1){
		swal("상세주소를 입력하세요.");
		$('#det_addr').focus();
		return false;
	}
	if(bank_cd == "" ){
		swal("은행을 선택하세요.").then(function() {
			$('#detBankCd').focus();
		  });
		return false;
	}
	
	if(account.length <1 ){
		swal("계좌번호를 입력하세요.").then(function() {
			$('#account').focus();
		  });
		return false;
	}
	if(user_type == ""){
		swal("권한을 입력해주세요.").then(function() {
			$("#detUserType").focus();
		  });
		return false;
	}
	if(dept_cd == "" ){
		swal("부서를 선택하세요.").then(function() {
			$('#detDeptCd').focus();
		});
	return false;
	}
	if(rank_cd == "" ){
		swal("직급을 선택하세요.").then(function() {
			$('#detRankCd').focus();
		});
	return false;
	}
	if(st_date == "" ){
		swal("입사일을 입력하세요.").then(function() {
			$('#st_date').focus();
		});
	return false;
	}

	return true;
	
}

</script>

</head>
<body>
<form id="myForm" action=""  method="">
	<input type="hidden" name="action" id="action" value="">
	<input type="hidden" name="currentpage" id="currentpage" value="">
	<input type="hidden" name="currentEmpStatus" id="currentEmpStatus" value="">
	<%-- <input type="hidden" name="searchCheck" id="searchCheck" value=""> --%>
	<input type="hidden" name="hdSearchDeptCd" id="hdSearchDeptCd" value="">
	<input type="hidden" name="hdSearchRankCd" id="hdSearchRankCd" value="">
	<input type="hidden" name="hdSearchKey" id="hdSearchKey" value="">
	<input type="hidden" name="hdSearchWord" id="hdSearchWord" value="">
	<input type="hidden" name="hdSrcsdate" id="hdSrcsdate" value="">
	<input type="hidden" name="hdSrcedate" id="hdSrcedate" value="">
	
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
							<span class="btn_nav bold">인사/급여</span>
							<span class="btn_nav bold">인사 관리</span>
							<a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>인사 관리</span> 
						</p>
						<table style="margin-bottom : 10px; border: 1px #e2e6ed; border-style:solid !important;" height = "50px" width="100%" align="left">
	                        <tr>
	                           	<td width="7%" height="25" style="font-size: 120%; text-align : center;">부서</td>
	                           	<td width="9%" height="25" style="font-size: 100%; text-align:left;">
	     	                   		<select id="searchDeptCd" name="searchDeptCd" style="width: 70px;"></select>
								</td>
								<td width="7%" height="25" style="font-size: 120%; text-align:center;">직급</td>
								<td width="10%" height="25" style="font-size: 100%; text-align:left;">
	     	                    	<select id="searchRankCd" name="searchRankCd" style="width: 70px;"></select>
								</td>
								<td width="9%" height="25" style="font-size: 100%; text-align:left; padding-left: 14px;">
	     	                      <select id="searchKey" name="searchKey" style="width: 70px;">
										<option value="empNo" >사번</option>
										<option value="name" >사원명</option>
								</select>
								</td>
								<td width="20%" height="25">
	     	                       <input type="text" style="width: 180px; height: 25px;" id="searchWord" name="searchWord">                    
	                           	</td>
	                           	<td width = "*" height="25" align="right" style="padding-right : 7px;">
									<span class="fr">
										<p class="Location">
											<strong>입사일 조회&nbsp;</strong>
											<input type="date" id="srcsdate" name="srcsdate"> ~
											<input type="date" id="srcedate" name="srcedate">
											<a class="btn_icon search" name="search" id="btnSearch"><span id="searchEnter">조회</span></a>
											 <%-- href="javascript:searchEmpMgt()" --%>
										</p>
									</span>
	                           	</td>
	                        </tr>
                     	</table>
						<span class="fl" style="margin-bottom : 10px; !important;"> 
							<a id="showInEmp" class="btnType3 color2" href="javascript:searchEmpMgt(1, 'A')"><span>재직자</span></a> 
							<a id="showRestEmp" class="btnType3 color1" href="javascript:searchEmpMgt(1, 'B')"><span>휴직자</span></a> 
							<a id="showOutEmp" class="btnType3 color1" href="javascript:searchEmpMgt(1, 'C')"><span>퇴직자</span></a>
						</span>

						<%-- 재직중인 사원 목록 --%>
						<div class="divComGrpCodList">
							<table class="col">
								<caption>caption</caption>
									<colgroup>
										<col width="13%">
										<col width="12%">
										<col width="12%">
										<col width="10%">
										<col width="15%">
										<col width="10%">
										<col width="18%">
									</colgroup>
		
									<thead>
										<tr>
											<th scope="col">사번</th>
											<th scope="col">사원명</th>
											<th scope="col">부서명</th>
											<th scope="col">직급</th>
											<th scope="col">입사일자</th>
											<th scope="col">재직 구분</th>
											<th scope="col" id = "updateStatus">재직처리</th>
											<th scope="col" id = "edDate">퇴직일자</th>
											<th scope="col" id = "lvDay">휴직기간</th>
											<th scope="col" id = "comeback">복직처리</th>
										</tr>
									</thead>
								<tbody id="listEmpMgt"></tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="empMgtPagination"> </div>
						
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>
	</form>
	<form id="leave" action=""  method="">
	<!-- 모달영역 -->
	<!-- 휴직 처리 모달 -->
	<div id="leaveEmp" class="layerPop layerType2" style="width: 600px;">
			<dl>
			<dt>
				<strong>휴직처리</strong>
			</dt>
			<dd class="content">
				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="50%">
						<col width="10%">
						<col width="50%">
						<col width="10%">
					</colgroup>

					<tbody>
						<tr>
							<th scope="row">사번</th>
							<td><input type="text" class="inputTxt" id="leaveEmpNo" name="leaveEmpNo" readonly/>
							<input type="hidden" class="inputTxt" id="leaveLoginID" name="leaveLoginID">
							<input type="hidden" name="leaveJoinDate" id="leaveJoinDate" value=""></td>
							<th scope="row">사원명</th>
							<td><input type="text" class="inputTxt" id="leaveName" name="leaveName" readonly/></td>
						</tr>
						<tr>
							<th scope="row">휴직시작일<span class="font_red">*</span></th>
							<td><input type="date" id="leaveStartDate" style = "width : 90%; height : 80%"></td>
							<th scope="row">휴직종료일<span class="font_red">*</span></th>
							<td><input type="date" id="leaveEndDate" style = "width : 90%; height : 80%"></td>
						</tr>
					</tbody>
				</table>
				<div class="btn_areaC mt30">
					<a href="javascript:fnLeaveEmp()" class="btnType blue" id="btnEmpOut"><span>휴직처리</span></a>
					<a href="" class="btnType gray" id="btnClose"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
	</form>
	<form id="comeback" action=""  method="">
	<!-- 모달영역 -->
	<!-- 복직 처리 모달 -->
	<div id="comebackEmp" class="layerPop layerType2" style="width: 600px;">
			<dl>
			<dt>
				<strong>복직처리</strong>
			</dt>
			<dd class="content">
				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="50%">
						<col width="10%">
						<col width="50%">
						<col width="10%">
					</colgroup>

					<tbody>
						<tr>
							<th scope="row">사번</th>
							<td><input type="text" class="inputTxt" id="comebackEmpNo" name="comebackEmpNo" readonly/>
							<input type="hidden" class="inputTxt" id="comebackLoginID" name="comebackLoginID">
							</td>
							<th scope="row">사원명</th>
							<td><input type="text" class="inputTxt" id="comebackName" name="comebackName" readonly/></td>
						</tr>
						<tr>
							<th scope="row">휴직시작일</th>
							<td><input type="date" id="comebackStartDate" style = "width : 90%; height : 80%" readonly></td>
							<th scope="row">휴직종료일</th>
							<td><input type="date" id="comebackEndDate" style = "width : 90%; height : 80%" readonly></td>
						</tr>
					</tbody>
				</table>
				<div class="btn_areaC mt30">
					<a href="javascript:fnComebackEmp()" class="btnType blue" id="btnEmpOut"><span>복직처리</span></a>
					<a href="" class="btnType gray" id="btnClose"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
	</form>
	
	<form id="retire" action=""  method="">
	<!-- 퇴직 처리 모달 -->
	<div id="retireEmp" class="layerPop layerType2" style="width: 600px;">
		<dl>
			<dt>
				<strong>퇴직처리</strong>
			</dt>
			<dd class="content">
				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="50%">
						<col width="10%">
						<col width="50%">
						<col width="10%">
					</colgroup>

					<tbody>
						<tr>
							<th scope="row">사번 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt" id="retireEmpNo" name="retireEmpNo" readonly/>
								<input type="hidden" class="inputTxt" id="retireLoginID" name="retireLoginID"></td>
							<th scope="row">사원명 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt" id="retireName" name="retireName" readonly/></td>
						</tr>
						<tr>
							<th scope="row">입사일</th>
							<td><input type="date" id="retireStDate" style = "width : 90%; height : 80%" readonly></td>
							<th scope="row">퇴사일<span class="font_red">*</span></th>
							<td><input type="date" id="retireEdDate" style = "width : 90%; height : 80%"></td>
						</tr>
					</tbody>
				</table>
				<div class="btn_areaC mt30">
					<a href="javascript:fnRetireEmp()" class="btnType blue" id="btnEmpOut"><span>퇴직처리</span></a>
					<a href="" class="btnType gray" id="btnClose"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
	</form>

	<form id="detail" action=""  method="">
	<!-- 사원 상세 조회 모달 -->
	
	<input type ="hidden" name = "action" id = "action" value = "">
	<input type ="hidden" name = "pay_nego" id = "pay_nego" value = "">
	<input type ="hidden" name = "detLoginId" id = "detLoginId" value = "">
	<div id="layer1" class="layerPosition layerPop layerType2" style="width: 790px;">
		<dl>
			<dt>
				<strong>사원 정보</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="18%">
						<col width="14%">
						<col width="20%">
						<col width="14%">
						<col width="20%">
					</colgroup>

					<tbody>
						<tr>
							<td rowspan="3" id = "userProfile" class = "userProfile profile">
								<div id = "profilePreview">
								</div>
								<input type = "file" name = "profileUpload" id ="profileUpload" style = "display:none;">
							</td>
							<th scope="row">사번</th>
							<td><input type="text" class="inputTxt p100" name="emp_no" id="emp_no" readonly /></td>
							<th scope="row">ID</th>
							<td><input type="text" class="inputTxt p100" name="loginID" id="loginID" readonly /></td>
						</tr>
						<tr>
							<th scope="row">사원명</th>
							<td><input type="text" class="inputTxt p100" name="name" id="name" readonly/></td>
							<th scope="row">생년월일</th>
							<td><input type="text" class="inputTxt p100" name="birthday" id="birthday"
								readonly /></td>
							</td>
						</tr>
						<tr>
							<th scope="row">성별</th>
							<td>
								<select id="sex" name="sex" style="width: 65%;">
									<option value="남">남</option>
									<option value="여">여</option>
								</select>
							</td>
							<th scope="row">최종학력<span class="font_red">*</span></th>
							<td><select name="detSchoolCd" id="detSchoolCd" style="width: 50%;"></select>
							</td>
						</tr>

						
				</table>
				<table class="row" style="margin-top:0.5%;">
					<colgroup>
						<col width="12%">
						<col width="31%">
						<col width="12%">
						<col width="36%">
					</colgroup>
					
						<tr>
							<th scope="row">이메일<span class="font_red">*</span></th>
								<td>
									<input type="text" class="inputTxt p100" name="email" id="mail" />
								</td>
							<th scope="row">연락처<span class="font_red">*</span></th>
								<td><select name="hp1" id="hp1" style="width: 30%;">
										<option value="" selected="selected">선택</option>
										<option value="010">010</option>
										<option value="011">011</option>
										<option value="02">02</option>
									</select>
									 - <input class="inputTxt"
									style="width: 28%" maxlength="4" type="text" id="hp2"
									name="hp2"> - <input class="inputTxt"
									style="width: 28%" maxlength="4" type="text" id="hp3"
									name="hp3">
								</td>
						</tr>
						<tr>
							<th scope= "row" rowspan = "3">주소<span class="font_red">*</span></th>
								<td>
									<input type="text" class="inputTxt" style="width: 50%;" name="zip_code" id="detZip" readonly/>
									<input type="button" value="우편번호 찾기" onclick="execDaumPostcode()" id ="post_cd"
										style="width: 35%; height: 50%; cursor: pointer;" />
								</td>
							<th scope= "row">은행계좌<span class="font_red">*</span></th>
								<td>
									<select id="detBankCd" name="detBankCd" style="width: 40%;"></select>
									<input class="inputTxt"
										style="width: 63%" type="text" id="account" name="account">
								</td>
						</tr>
						<tr>
							<td>
								<input type="text" class="inputTxt" style="width: 90%" name="addr" id="addr" readonly />
							</td>
						</tr>
						<tr>
							<td>
								<input type="text" class="inputTxt p100" name="det_addr" id="det_addr" />
							</td>
						</tr>
					</tbody>
				</table>
				<table class="row" style="margin-top:0.5%;">
					<colgroup>
						<col width="13%">
						<col width="17%">
						<col width="12%">
						<col width="20%">
						<col width="11%">
						<col width="18%">
					</colgroup>
					<tbody>
						<tr>
							<th scope= "row">권한<span class="font_red">*</span></th>
							<td>
								<select id="detUserType" name="detUserType" style="width: 100%;"></select>
							</td>
							<th scope= "row">부서<span class="font_red">*</span></th>
							<td>
								<select  id="detDeptCd" name="detDeptCd" style="width: 65%;"></select>
							</td>
							<th scope= "row">직급<span class="font_red">*</span></th>
							<td>
								<select id="detRankCd" name="detRankCd" style="width: 65%;"></select>
							</td>
						</tr>
						<tr>
							<th scope= "row">입사일<span class="font_red">*</span></th>
							<td><input type="date" id="st_date" name = "st_date" style = "width : 90%; height : 80%"></td>
							<th scope= "row">재직구분</th>
							<td>
								<select id="detStatusCd" name="detStatusCd" style="width: 65%;"></select>
							</td>
							<th scope= "row">연봉<span class="font_red">*</span></th>
							<td>
								<input type="number" class="inputTxt" style="width: 67%"
									name="year_pay" id="year_pay" />
								<input type="button" value="" id="negoBtn" onclick="fnNego()"
									style="width: 27%; height: 100%; cursor: pointer;" />
							</td>
						</tr>
						<tr id="retirementDate">
							<th scope= "row">퇴사일</th>
							<td><input type="date" id="ed_date" name = "ed_date"  style = "width : 90%; height : 80%" readonly></td>
						</tr>
						<tr id="vacationPeriod">
							<th scope= "row" >휴직 시작일</th>
							<td><input type="date" id="lvst_date" name = "lvst_date" style = "width : 90%; height : 80%" readonly></td>
							<th scope= "row" >휴직 종료일</th>
							<td><input type="date" id="lved_date" name = "lved_date" style = "width : 90%; height : 80%" readonly></td>
						</tr>
					</tbody>
				</table>

				<div class="btn_areaC mt30" id="updateBtnArea">
					<a href="javascript:fnUpdateEmp()" class="btnType blue" ><span>수정</span></a> 
					<a href="" class="btnType gray" id="btnClose" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
	</form>

<%-- </form> --%>
</body>
</html>