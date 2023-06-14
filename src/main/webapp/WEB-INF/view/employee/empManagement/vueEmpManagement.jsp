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

	var vuearea;
	var leaveEmpArea;
	var retireEmpArea;
	var comebackEmpArea;
	var detailEmpArea;
	
	/** OnLoad event */ 
	$(function() {
	
		//vue init 등록
		init();

		// 공통코드
		comcombo("dept_cd", "searchDeptCd", "all", ""); //부서
		comcombo("rank_cd", "searchRankCd", "all", ""); //직무

		// 사원목록
		searchEmpMgt();
		fRegisterButtonClickEvent();
		
	});
	
	function init(){
		
		vuearea = new Vue({
			el : "#wrap_area",
			data : {
				empMgtList : [],
				countEmpMgtList : '',
		        pageSize : 5,
		        pageBlockSize : 5,
		        empMgtPagination : '',
		        searchDeptCd : '',
		        searchRankCd : '',
		        searchKey : '',
		        searchWord : '',
		        srcsdate : '',
		        srcedate : '',
		        statusCd : '',
				clickBtn : '',
				currentpage : '',
				currentEmpStatus : '',
				updateStatus_show : true,
				edDate_show : false,
				lvDay_show : false,
				comeback_show : false,
				showInEmp : {			
					color1 : false,
					color2 : true,
				},
				showRestEmp : {			
					color1 : true,
					color2 : false,
				},
				showOutEmp : {			
					color1 : true,
					color2 : false,
				},
			},
		}),
		
		leaveEmpArea = new Vue({
			el : "#leaveEmp",
			data : {
				leaveLoginID : '',
				leaveEmpNo : '',
				leaveName : '',
				leaveJoinDate : '',
				leaveStartDate : '',
				leaveEndDate : '',
			},
			methods : {
				fn_leaveStJo : function(){
					if (leaveEmpArea.leaveStartDate < leaveEmpArea.leaveJoinDate) {
						alert("입사일 보다 휴직 시작일이 작을 수 없습니다.");
						leaveEmpArea.leaveStartDate='';
					}
				}
			}
		}),
		
		retireEmpArea = new Vue({
			el : "#retireEmp",
			data : {
				retireEmpNo : '',
				retireLoginID : '',
				retireName : '',
				retireStDate : '',
				retireEdDate : '',
			},
			methods : {
				fn_retireJo : function(){
						if (retireEmpArea.retireEdDate < retireEmpArea.retireStDate) {
							alert("입사일 보다 퇴사일이 작을 수 없습니다.");
							retireEmpArea.retireEdDate='';
						}
					}
				}
		}),
		
		comebackEmpArea = new Vue({
			el : "#comebackEmp",
			data : {
				comebackEmpNo : '',
				comebackLoginID : '',
				comebackName : '',
				comebackStartDate : '',
				comebackEndDate : '',
			}
		
		}),
		
		detailEmpArea = new Vue({
			el : "#layer1",
			data : {
				pay_nego : '',
				detLoginId : '',
				emp_no : '',
				loginID : '',
				name : '',
				birthday : '',
				sex : '',
				detSchoolCd : '',
				email : '',
				hp1 : '',
				hp2 : '',
				hp3 : '',
				zip_code : '',
				detBankCd : '',
				account : '',
				addr : '',
				det_addr : '',
				detUserType : '',
				detDeptCd : '',
				detRankCd : '',
				st_date : '',
				detStatusCd : '',
				year_pay : '',
				ed_date : '',
				lvst_date : '',
				lved_date : '',
				retirementDate : false,
				vacationPeriod : false,
				negoBtn_show : false,
				updateBtnArea_show : false,
			}
		
		})
		
	}
	
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
				
				if(vuearea.srcsdate!= '' && vuearea.srcedate!= ''){
					if(vuearea.srcsdate > vuearea.srcedate){
						alert("종료일이 시작일 보다 빠를 수 없습니다.");
						return;
					}
				}
				var numbercheck = /^[0-9]*$/;
				var namecheck = /^[a-zA-Z가-힣]*$/;
				if(vuearea.searchWord!= ''){
					if(vuearea.searchKey=="empNo"){
						if(!numbercheck.test(vuearea.searchWord)){
							alert("사번에는 숫자만 입력 가능합니다.");
							return;
						}
					} 
					if(vuearea.searchKey=="name"){
						if(!namecheck.test(vuearea.searchWord)){
							alert("사원명에는 문자만 입력 가능합니다.");
							return;
						}
					}
				}
				vuearea.clickBtn=''; //검색후 검색한것 초기화 용도
				vuearea.clickBtn='Z';
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
			vuearea.showInEmp.color1 = false;
			vuearea.showInEmp.color2 = true;
			vuearea.showRestEmp.color1 = true;
			vuearea.showRestEmp.color2 = false;
			vuearea.showOutEmp.color1 = true;
			vuearea.showOutEmp.color2 = false;
			vuearea.updateStatus_show = true;
			vuearea.edDate_show = false;
			vuearea.lvDay_show = false;
			vuearea.comeback_show = false;
		}
		if (statusCd == 'B') { //휴직
			vuearea.showInEmp.color1 = true;
			vuearea.showInEmp.color2 = false;
			vuearea.showRestEmp.color1 = false;
			vuearea.showRestEmp.color2 = true;
			vuearea.showOutEmp.color1 = true;
			vuearea.showOutEmp.color2 = false;
			vuearea.updateStatus_show = false;
			vuearea.edDate_show = false;
			vuearea.lvDay_show = true;
			vuearea.comeback_show = true;
		}
		if(statusCd == 'C'){ //퇴직
			vuearea.showInEmp.color1 = true;
			vuearea.showInEmp.color2 = false;
			vuearea.showRestEmp.color1 = true;
			vuearea.showRestEmp.color2 = false;
			vuearea.showOutEmp.color1 = false;
			vuearea.showOutEmp.color2 = true;
			vuearea.updateStatus_show = false;
			vuearea.edDate_show = true;
			vuearea.lvDay_show = false;
			vuearea.comeback_show = false;
		}

		// 검색시 재직상태 고정되는지 체크해봐야 함
		// $('#currentEmpStatus').val(statusCd);
		// vuearea.currentEmpStatus = statusCd;
		
		if(vuearea.clickBtn=='Z'){
			
			var param = {
					searchDeptCd : vuearea.searchDeptCd,
					searchRankCd : vuearea.searchRankCd,
					searchKey : vuearea.searchKey,
					searchWord : vuearea.searchWord,
					srcsdate : vuearea.srcsdate,
					srcedate : vuearea.srcedate,
					pageSize : vuearea.pageSize,
					cpage : cpage,
					statusCd : statusCd
			}
			
			
		} else {
			var param = {
					pageSize : vuearea.pageSize,
					cpage : cpage,
					statusCd : statusCd
			}

		}
		// console.log(param);
		
		var listcallback = function(returndata) {
	
			// console.log(returndata);
			
			// $("#listEmpMgt").empty().append(returndata);
			vuearea.empMgtList = returndata.empMgtList;
			// var countEmpMgtList = $("#countEmpMgtList").val();
			vuearea.countEmpMgtList  = returndata.countEmpMgtList;
			
			var paginationHtml = getPaginationHtml(cpage, returndata.countEmpMgtList, vuearea.pageSize, vuearea.pageBlockSize, 'searchEmpMgt',[statusCd]);
			
			vuearea.empMgtPagination = paginationHtml;
			// $("#empMgtPagination").empty().append(paginationHtml);
			
			//$("#currentpage").val(cpage);
			vuearea.currentpage = cpage;
 			//$("#currentEmpStatus").val(statusCd);
			vuearea.currentEmpStatus = statusCd;

		}
		
		callAjax("/employee/vueEmpMgtList.do", "post", "json", "false", param, listcallback) ;
	}
	
	// 휴직 모달
	function fModalLeaveEmp(leaveLoginID, leaveEmpNo, leaveName, leaveJoinDate){

		leaveEmpArea.leaveLoginID = leaveLoginID;	
		leaveEmpArea.leaveEmpNo = leaveEmpNo;
		leaveEmpArea.leaveName = leaveName;
		leaveEmpArea.leaveJoinDate = leaveJoinDate;
		leaveEmpArea.leaveStartDate = '';
		leaveEmpArea.leaveEndDate = '';

		gfModalPop("#leaveEmp");
	}
	
	// 휴직 처리
	function fnLeaveEmp(){

		var leaveStartDate = leaveEmpArea.leaveStartDate;
		var leaveEndDate = leaveEmpArea.leaveEndDate;

		if(leaveStartDate == ""){
			alert("휴직 시작일을 입력해주세요.");
			return;
		}
		if(leaveEndDate == ""){
			alert("휴직 종료일을 입력해주세요.");
			return;
		}
		if(leaveStartDate!= '' && leaveEndDate != ''){
			if(leaveStartDate>leaveEndDate){
				alert("휴직 종료일이 시작일 보다 빠를 수 없습니다.");
				leaveEmpArea.leaveStartDate='';
				leaveEmpArea.leaveEndDate='';
				return;
			}
		}

		var param = {
			loginID : leaveEmpArea.leaveLoginID,
			lvst_date : leaveEmpArea.leaveStartDate,
			lved_date : leaveEmpArea.leaveEndDate,
		}

		
		if(confirm("휴직 처리 하시겠습니까?")){
			var leaveCallback = function(returndata){
				if(returndata.result == "SUCCESS") {
					alert(returndata.resultMsg);
					gfCloseModal();
					searchEmpMgt(vuearea.currentpage);
				}else {
					alert("휴직처리에 실패하였습니다.");
				}
			};
			
			callAjax("/employee/leaveEmp.do", "post", "json", "false", param, leaveCallback);
			
		}
	}
	

	// 퇴직 모달
	function fModalRetireEmp(retireLoginID, retireEmpNo, retireName, retireStDate){
		
		retireEmpArea.retireLoginID=retireLoginID;
		retireEmpArea.retireEmpNo=retireEmpNo;
		retireEmpArea.retireName=retireName;
		retireEmpArea.retireStDate=retireStDate;
		gfModalPop("#retireEmp");
	}

	// 퇴직 처리
	function fnRetireEmp(){

		if(retireEmpArea.retireEdDate == ""){
			alert("퇴직일을 입력해주세요.")
			return;
		}

		var param = {
			loginID : retireEmpArea.retireLoginID,
			ed_date : retireEmpArea.retireEdDate
		}

		if(confirm("퇴직 처리 하시겠습니까?")){
			var retireCallback = function(returndata){

				if(returndata.result == "SUCCESS") {
					alert(returndata.resultMsg);
					gfCloseModal();
					searchEmpMgt(vuearea.currentpage);

				} else {
					alert("퇴직처리에 실패하였습니다.");
				}
			};
			
			callAjax("/employee/retireEmp.do", "post", "json", "false", param, retireCallback);
			
			}
		}
	

	// 복직 모달
	function fModalComebackEmp(comebackLoginID, comebackEmpNo, comebackName, comebackStartDate, comebackEndDate){

		comebackEmpArea.comebackLoginID = comebackLoginID;
		comebackEmpArea.comebackEmpNo = comebackEmpNo;
		comebackEmpArea.comebackName = comebackName;
		comebackEmpArea.comebackStartDate = comebackStartDate;
		comebackEmpArea.comebackEndDate = comebackEndDate;

		gfModalPop("#comebackEmp");
	}

	// 복직 처리
	function fnComebackEmp(){

		var param = {
			loginID : comebackEmpArea.comebackLoginID
		}

		if(confirm("복직 처리 하시겠습니까?")){
			var comebackCallback = function(returndata){
				if(returndata.result == "SUCCESS") {
					alert(returndata.resultMsg);
					gfCloseModal();
					searchEmpMgt(vuearea.currentpage);
				}else {
					alert("복직처리에 실패하였습니다.");
				}
			};
			
			callAjax("/employee/comebackEmp.do", "post", "json", "false", param, comebackCallback);
			
			}

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

	// 사원 상세 조회
	function empMgtDetInit(object){
			
		
			// 사원 정보 수정만 가능하기 때문에 object가 null 일때의 if문은 작성x
			empEmpDisabled(object.empMgtDet.status_cd); // 퇴직자의 경우 수정 불가하게 하는 함수

			// var splitMail = (object.empMgtDet.email ||'').split('@');;
			var splitHp = (object.empMgtDet.hp||'').split('-');;
			
			detailEmpArea.emp_no = object.empMgtDet.emp_no; // 사번
			detailEmpArea.loginID = object.empMgtDet.loginID; // 로그인ID
			detailEmpArea.detLoginId = object.empMgtDet.loginID; // 로그인ID
			detailEmpArea.name = object.empMgtDet.name; // 사원명
			detailEmpArea.birthday = object.empMgtDet.birthday; // 생년월일
			$("#sex").val(object.empMgtDet.sex).prop("selected", true);  // 성별
			comcombo("school_cd", "detSchoolCd", "sel", object.empMgtDet.school_cd); // 최종학력
			//debugger;

			// $('#mail1').val(splitMail[0]); $('#mail2').val(splitMail[1]); // 이메일
			detailEmpArea.email = object.empMgtDet.email; // 이메일
			$.each($("#hp1 > option"), function(index, item){
					if($(item).text() == splitHp[0]){
						$(item).prop("selected", true);
					}
				});//전화번호 앞자리
			detailEmpArea.hp2 = splitHp[1]; 
			detailEmpArea.hp3 = splitHp[2]; // 전화번호
			detailEmpArea.zip_code = object.empMgtDet.zip_code;
			detailEmpArea.addr = object.empMgtDet.addr;
			detailEmpArea.det_addr = object.empMgtDet.det_addr;

			comcombo("bank_cd", "detBankCd", "sel", object.empMgtDet.bank_cd); // 은행명
			detailEmpArea.account = object.empMgtDet.account; // 계좌번호
			comcombo("user_type", "detUserType", "sel", object.empMgtDet.user_type); // 권한
			comcombo("dept_cd", "detDeptCd", "sel", object.empMgtDet.dept_cd); // 부서
			comcombo("rank_cd", "detRankCd", "sel", object.empMgtDet.rank_cd); // 직급
			comcombo("status_cd", "detStatusCd", "sel", object.empMgtDet.status_cd); // 재직상태

			detailEmpArea.st_date = object.empMgtDet.st_date; // 입사일

			if(object.empMgtDet.pay_nego == 0){ // 연봉협상버튼
				$("#negoBtn").val("입력");
				detailEmpArea.year_pay = '';
				$("#year_pay").attr("placeholder", "미협상");
			} else {
				$("#negoBtn").val("수정");
				detailEmpArea.year_pay = object.empMgtDet.year_pay; // 연봉
			}
			detailEmpArea.pay_nego = object.empMgtDet.pay_nego; // 연봉협상유무 0이면 insert
			detailEmpArea.lvst_date = object.empMgtDet.lvst_date; // 휴직시작일
			detailEmpArea.lved_date = object.empMgtDet.lved_date; // 휴직종료일
			detailEmpArea.ed_date = object.empMgtDet.ed_date; // 퇴사일


			//재직/휴직/퇴직 경우 다르게 해야함
			if(object.empMgtDet.status_cd =='C'){ // 퇴직
				detailEmpArea.updateBtnArea_show = false;
				detailEmpArea.negoBtn_show = false;
				detailEmpArea.vacationPeriod = false;
				detailEmpArea.retirementDate = true;			

			}  else if (object.empMgtDet.status_cd =='B') { // 휴직
				detailEmpArea.updateBtnArea_show = true;
				detailEmpArea.negoBtn_show = true;
				detailEmpArea.vacationPeriod = true;
				detailEmpArea.retirementDate = false;	


			} else{ // 재직
				detailEmpArea.updateBtnArea_show = true;
				detailEmpArea.negoBtn_show = true;
				detailEmpArea.vacationPeriod = false;
				detailEmpArea.retirementDate = false;	

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
	
	<!-- 모달 배경 -->
	<div id="mask"></div>

	<div id="wrap_area">
		<input type="hidden" name="currentpage" id="currentpage" v-model="currentpage">
		<input type="hidden" name="currentEmpStatus" id="currentEmpStatus" v-model="currentEmpStatus">
		<input type="hidden" name="clickBtn" id="clickBtn" v-model="clickBtn">
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
	     	                   		<select id="searchDeptCd" name="searchDeptCd" style="width: 70px;" v-model="searchDeptCd"></select>
								</td>
								<td width="7%" height="25" style="font-size: 120%; text-align:center;">직급</td>
								<td width="10%" height="25" style="font-size: 100%; text-align:left;">
	     	                    	<select id="searchRankCd" name="searchRankCd" style="width: 70px;" v-model="searchRankCd"></select>
								</td>
								<td width="9%" height="25" style="font-size: 100%; text-align:left; padding-left: 14px;">
	     	                      <select id="searchKey" name="searchKey" style="width: 70px;" v-model="searchKey">
										<option value="" >선택</option>
										<option value="empNo" >사번</option>
										<option value="name" >사원명</option>
								</select>
								</td>
								<td width="20%" height="25">
	     	                       <input type="text" style="width: 180px; height: 25px;" id="searchWord" name="searchWord" v-model="searchWord">                    
	                           	</td>
	                           	<td width = "*" height="25" align="right" style="padding-right : 7px;">
									<span class="fr">
										<p class="Location">
											<strong>입사일 조회&nbsp;</strong>
											<input type="date" id="srcsdate" name="srcsdate" v-model="srcsdate"> ~
											<input type="date" id="srcedate" name="srcedate" v-model="srcedate">
											<a class="btn_icon search" name="search" id="btnSearch"><span id="searchEnter">조회</span></a>
											 <%-- href="javascript:searchEmpMgt()" --%>
										</p>
									</span>
	                           	</td>
	                        </tr>
                     	</table>
						<span class="fl" style="margin-bottom : 10px; !important;"> 
							<a id="showInEmp" class="btnType3" :class="showInEmp" href=""  @click.prevent="searchEmpMgt(1, 'A')"><span>재직자</span></a> 
							<a id="showRestEmp" class="btnType3" :class="showRestEmp"href=""  @click.prevent="searchEmpMgt(1, 'B')"><span>휴직자</span></a> 
							<a id="showOutEmp" class="btnType3" :class="showOutEmp"href=""  @click.prevent="searchEmpMgt(1, 'C')"><span>퇴직자</span></a>
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
											<th scope="col" id = "updateStatus" v-show="updateStatus_show">재직처리</th>
											<th scope="col" id = "edDate" v-show="edDate_show">퇴직일자</th>
											<th scope="col" id = "lvDay" v-show="lvDay_show">휴직기간</th>
											<th scope="col" id = "comeback" v-show="comeback_show">복직처리</th>
										</tr>
									</thead>
									
									<template v-if="countEmpMgtList == 0">
										<tbody>	
											<tr>
												<td colspan="8">데이터가 존재하지 않습니다.</td>
											</tr>
										</tbody>
									</template>
									<template v-else>
										<tbody id="listEmpMgt" v-for="(list, item) in empMgtList">
											<tr>										
												<td><a href="" @click.prevent="fnEmpMgtDet(list.loginID)">{{ list.emp_no }}</td>
												<td><a href="" @click.prevent="fnEmpMgtDet(list.loginID)">{{ list.name }}</a></td>
												<td>{{ list.dept_name }}</td>
												<td>{{ list.rank_name }}</td>
												<td>{{ list.st_date }}</td>
												<td>{{ list.status_name }}</td>
												<template v-if="list.status_cd == 'A'">
													<td>
														<a class="btnType3 color1" href="" @click.prevent="fModalLeaveEmp(list.loginID, list.emp_no, list.name, list.st_date)"><span>휴직처리</span></a>
														<a class="btnType3 color1" href="" @click.prevent="fModalRetireEmp(list.loginID, list.emp_no, list.name, list.st_date)"><span>퇴직처리</span></a>
													</td>
												</template>
												<template v-if="list.status_cd == 'B'">
													<td>{{ list.lv_date }}</td>
													<td><a class="btnType3 color1" href="" @click.prevent="fModalComebackEmp(list.loginID, list.emp_no, list.name, list.lvst_date, list.lved_date)"><span>복직처리</span></a></td>
												</template>
												<template v-if="list.status_cd == 'C'">
													<td>{{ list.ed_date }}</td>
												</template>
											</tr>
										
										</tbody>
								 	</template>		
							</table>
						</div>
	
						<div class="paging_area"  id="empMgtPagination" v-html="empMgtPagination"> </div>
						
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
							<td><input type="text" class="inputTxt" id="leaveEmpNo" v-model="leaveEmpNo" name="leaveEmpNo" readonly/>
							<input type="hidden" class="inputTxt" id="leaveLoginID"  v-model="leaveLoginID" name="leaveLoginID">
							<input type="hidden" name="leaveJoinDate" id="leaveJoinDate" v-model="leaveJoinDate"></td>
							<th scope="row">사원명</th>
							<td><input type="text" class="inputTxt" id="leaveName" v-model="leaveName" name="leaveName" readonly/></td>
						</tr>
						<tr>
							<th scope="row">휴직시작일<span class="font_red">*</span></th>
							<td><input type="date" id="leaveStartDate" style = "width : 90%; height : 80%" v-model="leaveStartDate" @change="fn_leaveStJo"></td>
							<th scope="row">휴직종료일<span class="font_red">*</span></th>
							<td><input type="date" id="leaveEndDate" style = "width : 90%; height : 80%" v-model="leaveEndDate"></td>
						</tr>
					</tbody>
				</table>
				<div class="btn_areaC mt30">
					<a href="" @click.prevent="fnLeaveEmp()" class="btnType blue" id="btnEmpOut"><span>휴직처리</span></a>
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
							<td><input type="text" class="inputTxt" id="comebackEmpNo" v-model="comebackEmpNo" name="comebackEmpNo" readonly/>
							<input type="hidden" class="inputTxt" id="comebackLoginID" v-model="comebackLoginID" name="comebackLoginID">
							</td>
							<th scope="row">사원명</th>
							<td><input type="text" class="inputTxt" id="comebackName" v-model="comebackName" name="comebackName" readonly/></td>
						</tr>
						<tr>
							<th scope="row">휴직시작일</th>
							<td><input type="date" id="comebackStartDate" v-model="comebackStartDate" style = "width : 90%; height : 80%" readonly></td>
							<th scope="row">휴직종료일</th>
							<td><input type="date" id="comebackEndDate" v-model="comebackEndDate" style = "width : 90%; height : 80%" readonly></td>
						</tr>
					</tbody>
				</table>
				<div class="btn_areaC mt30">
					<a href="" @click.prevent="fnComebackEmp()" class="btnType blue" id="btnEmpOut"><span>복직처리</span></a>
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
							<td><input type="text" class="inputTxt" id="retireEmpNo" v-model="retireEmpNo" name="retireEmpNo" readonly/>
								<input type="hidden" class="inputTxt" id="retireLoginID" v-model="retireLoginID" name="retireLoginID"></td>
							<th scope="row">사원명 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt" id="retireName" v-model="retireName" name="retireName" readonly/></td>
						</tr>
						<tr>
							<th scope="row">입사일</th>
							<td><input type="date" id="retireStDate" v-model="retireStDate" style = "width : 90%; height : 80%" readonly></td>
							<th scope="row">퇴사일<span class="font_red">*</span></th>
							<td><input type="date" id="retireEdDate" v-model="retireEdDate" style = "width : 90%; height : 80%" @change="fn_retireJo"></td>
						</tr>
					</tbody>
				</table>
				<div class="btn_areaC mt30">
					<a href="" @click.prevent="fnRetireEmp()" class="btnType blue" id="btnEmpOut"><span>퇴직처리</span></a>
					<a href="" class="btnType gray" id="btnClose"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
	</form>

	<form id="detail" action=""  method="">
	<!-- 사원 상세 조회 모달 -->
	
	<div id="layer1" class="layerPosition layerPop layerType2" style="width: 790px;">
	<input type ="hidden" name = "pay_nego" id = "pay_nego" v-model="pay_nego">
	<input type ="hidden" name = "detLoginId" id = "detLoginId" v-model="detLoginId">
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
							<td><input type="text" class="inputTxt p100" v-model="emp_no" name="emp_no" id="emp_no" readonly /></td>
							<th scope="row">ID</th>
							<td><input type="text" class="inputTxt p100" v-model="loginID" name="loginID" id="loginID" readonly /></td>
						</tr>
						<tr>
							<th scope="row">사원명</th>
							<td><input type="text" class="inputTxt p100" v-model="name" name="name" id="name" readonly/></td>
							<th scope="row">생년월일</th>
							<td><input type="text" class="inputTxt p100" v-model="birthday" name="birthday" id="birthday"
								readonly /></td>
							</td>
						</tr>
						<tr>
							<th scope="row">성별</th>
							<td>
								<select id="sex" v-model="sex" name="sex" style="width: 65%;">
									<option value="남">남</option>
									<option value="여">여</option>
								</select>
							</td>
							<th scope="row">최종학력<span class="font_red">*</span></th>
							<td><select name="detSchoolCd" v-model="detSchoolCd" id="detSchoolCd" style="width: 50%;"></select>
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
									<input type="text" class="inputTxt p100" v-model="email" name="email" id="mail" />
								</td>
							<th scope="row">연락처<span class="font_red">*</span></th>
								<td><select v-model="hp1" name="hp1" id="hp1" style="width: 30%;">
										<option value="" selected="selected">선택</option>
										<option value="010">010</option>
										<option value="011">011</option>
										<option value="02">02</option>
									</select>
									 - <input class="inputTxt"
									style="width: 28%" maxlength="4" type="text" v-model="hp2" id="hp2"
									name="hp2"> - <input class="inputTxt"
									style="width: 28%" maxlength="4" type="text" v-model="hp3" id="hp3"
									name="hp3">
								</td>
						</tr>
						<tr>
							<th scope= "row" rowspan = "3">주소<span class="font_red">*</span></th>
								<td>
									<input type="text" class="inputTxt" style="width: 50%;" v-model="zip_code" name="zip_code" id="detZip" readonly/>
									<input type="button" value="우편번호 찾기" onclick="execDaumPostcode()" id ="post_cd"
										style="width: 35%; height: 50%; cursor: pointer;" />
								</td>
							<th scope= "row">은행계좌<span class="font_red">*</span></th>
								<td>
									<select id="detBankCd" v-model="detBankCd" name="detBankCd" style="width: 40%;"></select>
									<input class="inputTxt"
										style="width: 63%" type="text" id="account" v-model="account" name="account">
								</td>
						</tr>
						<tr>
							<td>
								<input type="text" class="inputTxt" style="width: 90%" v-model="addr" name="addr" id="addr" readonly />
							</td>
						</tr>
						<tr>
							<td>
								<input type="text" class="inputTxt p100" v-model="det_addr" name="det_addr" id="det_addr" />
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
								<select id="detUserType" v-model="detUserType" name="detUserType" style="width: 100%;"></select>
							</td>
							<th scope= "row">부서<span class="font_red">*</span></th>
							<td>
								<select  id="detDeptCd" v-model="detDeptCd" name="detDeptCd" style="width: 65%;"></select>
							</td>
							<th scope= "row">직급<span class="font_red">*</span></th>
							<td>
								<select id="detRankCd" v-model="detRankCd" name="detRankCd" style="width: 65%;"></select>
							</td>
						</tr>
						<tr>
							<th scope= "row">입사일<span class="font_red">*</span></th>
							<td><input type="date" id="st_date" v-model="st_date" name = "st_date" style = "width : 90%; height : 80%"></td>
							<th scope= "row">재직구분</th>
							<td>
								<select id="detStatusCd" v-model="detStatusCd" name="detStatusCd" style="width: 65%;"></select>
							</td>
							<th scope= "row">연봉<span class="font_red">*</span></th>
							<td>
								<input type="number" class="inputTxt" style="width: 67%"
									v-model="year_pay" name="year_pay" id="year_pay" />
								<input type="button" value="" id="negoBtn" onclick="fnNego()"
									style="width: 27%; height: 100%; cursor: pointer;" v-show="negoBtn_show"/>
							</td>
						</tr>
						<tr id="retirementDate" v-show="retirementDate">
							<th scope= "row">퇴사일</th>
							<td><input type="date" id="ed_date" v-model="ed_date" name = "ed_date"  style = "width : 90%; height : 80%" readonly></td>
						</tr>
						<tr id="vacationPeriod" v-show="vacationPeriod">
							<th scope= "row" >휴직 시작일</th>
							<td><input type="date" id="lvst_date" v-model="lvst_date" name = "lvst_date" style = "width : 90%; height : 80%" readonly></td>
							<th scope= "row" >휴직 종료일</th>
							<td><input type="date" id="lved_date" v-model="lved_date" name = "lved_date" style = "width : 90%; height : 80%" readonly></td>
						</tr>
					</tbody>
				</table>

				<div class="btn_areaC mt30" id="updateBtnArea" v-show="updateBtnArea_show">
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