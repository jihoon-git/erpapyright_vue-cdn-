<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>지출결의서</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<script type="text/javascript">
	// 그룹코드 페이징 설정
	var pageSize = 5; //한페이지에 몇개 볼것인가
	var pageBlockSize = 5;

	/** OnLoad event */
	$(function() {

		expenselist()

		fRegisterButtonClickEvent();

		comcombo("laccount_cd", "lctcd", "sel", "selvalue");
		comcombo("laccount_cd", "reglctcd", "sel", "selvalue");
		detileAccount("", "actcd", "sel", "selvalue");
		detileAccount("", "regactcd", "sel", "selvalue");

	});

	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {

		$('a[name=btn]').click(function(e) {
			e.preventDefault(); //이후의 예약 이벤트를 모두 소멸시킴

			var btnId = $(this).attr('id'); //해당 버튼의 아이디를 꺼내라

			switch (btnId) {
			case 'listsearch':
				if($("#stdate").val()!= '' && $("#eddate").val() != ''){
					if($("#stdate").val()>$("#eddate").val()){
						alert("날짜 검색조건을 확인하세요");
						break;
					}
					}
				var numbercheck = /[0-9]/g;
				var numberboolean = numbercheck.test($("#searchname").val())
				console.log(numberboolean)
				if(numberboolean){
					alert("이름 검색엔 숫자가 들어가지 않습니다.");
					break;
					
				}
				$("#scstdate").val($("#stdate").val())
				$("#sceddate").val($("#eddate").val())
				$("#sclctcd").val($("#lctcd").val())
				$("#scactcd").val($("#actcd").val())
				$("#scexpyn").val($("#expyn").val())
				$("#scname").val($("#searchname").val())
				expenselist()
				break;
			case 'btnSavereg':
				fn_save();
				break;
			case 'btnSaveapp':
				fn_appsave();
				break;
			case 'btnDeletereg':
				$("#action").val("D");
				fn_save();
			case 'btnCloseapp':
			case 'btnClosereg':
				gfCloseModal();
				break;
			}
		});

		/** 모달창에서 파일 업로드할 때 파일 미리보기 */
		var upfile = document.getElementById('regfile')

		upfile
				.addEventListener(
						'change',
						function(event) {
							$("#fileview").empty()
							$("#fileview").css("overflow-y", "");
							$("#fileview").css("height", "");

							var image = event.target;
							var imagepath = "";

							let
							i = 0;
							if (image.files[0]) {
								for (i = 0; i < image.files.length; i++) {

									imagepath = window.URL
											.createObjectURL(image.files[i])

									var filearr = image.files[i].name
											.split('.');

									var previewhtml = ""

									if (filearr[1] === "jpg"
											|| filearr[1] === "png") {
										previewhtml = "<img src='" + imagepath + "' style='width: 200px; height: 130px;'/>";
									} else {
										previewhtml = ""
									}

									console.log("previewhtml : ", previewhtml)
									$("#fileview").css("overflow-y", "auto");
									$("#fileview").css("height", "150px");
									$("#fileview").append(previewhtml);
								}
							}
						})

		$("input[name='approvalexpnese']").change(function() {
			var test = $("input[name='approvalexpnese']:checked").val();
			console.log(test)
			if (test === 'y') {
				$("#appreject").val("");
				$("#appreject").attr('readonly', true);
			} else if (test === 'n') {
				$("#appreject").attr('readonly', false);
			}
		})

	}

	/** 지출결의서 목록 조회 */
	function expenselist(cpage) {
		console.log("시작")
		var cpage = cpage || 1

		var userType = $("#userType").val();

		if (userType == 'B' || userType == 'C') {
			var param = {
				cpage : cpage,
				pagesize : pageSize,
				stdate : $("#scstdate").val(),
				eddate : $("#sceddate").val(),
				lctcd : $("#sclctcd").val(),
				actcd : $("#scactcd").val(),
				expyn : $("#scexpyn").val(),
				searchname : $("#scname").val()
			}
		} else if (userType == 'D') {
			var param = {
				cpage : cpage,
				pagesize : pageSize,
				stdate : $("#scstdate").val(),
				eddate : $("#sceddate").val(),
				lctcd : $("#sclctcd").val(),
				actcd : $("#scactcd").val(),
				expyn : $("#scexpyn").val(),
				loginID : $("#loginId").val()
			}
		}

		console.log("param : ", JSON.stringify(param))

		var listcallback = function(returndata) {
			console.log("returndata : ", returndata);

			$("#expenselist").empty().append(returndata);

			console.log("tot_cnt : " + $("#countexpenselist").val());

			var countexpenselist = $("#countexpenselist").val();

			var pagination = getPaginationHtml(cpage, countexpenselist,
					pageSize, pageBlockSize, 'expenselist');
			console.log("pagination : ", pagination);

			$("#bmDvPagination").empty().append(pagination);

			$("#currentpage").val(cpage);

		}

		callAjax("/accounting/expenselist.do", "post", "text", "false", param,
				listcallback)
	}

	/** 신규등록을 누를 때 팝업 창 */
	function fn_openpopup() {

		initpopup();
		gfModalPop("#expensereg");
	}

	/** 팝업창 초기값 설정 */
	function initpopup(object) {

		if (object === null || object === "" || object === undefined) {
			$("#regexpdet").prop("disabled", false)
			$("#loginIDreg").val($("#loginId").val());
			$("#regname").val($("#userNm").val());
			$("#reglctcd").val("");
			$("#regactcd").val("");
			$("#regdate").val(getToday());
			$("#regusedate").val("");
			$("#regspent").val("");
			$("#regfile").val("");
			$("#btnDeletereg").hide();
			$("#action").val("I");
			$("#fileview").empty()
			$("#regexpdet").val("");
			$("#rejecttr").hide()
			$("#btnSavereg").show();
			$("#fileview").css("overflow-y", "");
			$("#fileview").css("height", "");
		} else {
			$("#regexpno").val(object.exp_no)
			$("#loginIDreg").val(object.loginID);
			$("#regname").val(object.name);
			$("#reglctcd").val(object.laccount_cd);
			$("#regactcd").val(object.account_cd);
			$("#regdate").val(object.exp_date);
			$("#regusedate").val(object.use_date);
			$("#regspent").val(object.exp_spent);
			$("#regexpdet").val(object.exp_det);
			$("#regexpdet").prop("disabled", true)
			$("#action").val("U");
			$("#fileview").empty()
			$("#fileview").css("overflow-y", "");
			$("#fileview").css("height", "");
			$("#regreject").val(object.reject_rsn);
			$("#regfile").val("");
			if (object.file_cd != 0) {
				file_detail(object.file_cd)
			}
			if (object.exp_yn === "y") {
				$("#btnSavereg").hide();
				$("#btnDeletereg").hide();
				$("#rejecttr").hide()
			} else if (object.exp_yn === "n") {
				$("#btnSavereg").hide();
				$("#btnDeletereg").hide();
				$("#rejecttr").show()
			} else {
				if ($("#loginIDreg").val() !== $("#loginId").val()) {
					$("#btnSavereg").hide();
					$("#btnDeletereg").hide();
					$("#rejecttr").hide()
				} else {
					$("#btnSavereg").show();
					$("#btnDeletereg").show();
					$("#rejecttr").hide()
				}

			}
		}
	}

	/** 오늘 날짜 */
	function getToday() {
		var date = new Date();
		var year = date.getFullYear();
		var month = ("0" + (1 + date.getMonth())).slice(-2);
		var day = ("0" + date.getDate()).slice(-2);

		return year + "-" + month + "-" + day;
	}

	/** 지출결의서 저장 */
	function fn_save() {
		console.log($("#regfile").val())

		if ($("#action").val() != "D") {
			if (!fValidate()) {
				return;
			}
		}
		if($("#regusedate").val()>$("#regdate").val()){
			alert("사용일자가 신청일자 이후가 될 순 없습니다.")
			return;
		}

		var frm = document.getElementById('myForm');

		frm.enctype = "multipart/form-data";

		var check = document.getElementById('regfile');
		console.log(check.files)

		var datawithFile = new FormData(frm)

		var savecallback = function(returndata) {
			console.log("returndata : ", JSON.stringify(returndata));

			if (returndata.result === "Success") {
				gfCloseModal();
				if ($("#action").val() === "U") {
					expenselist($("#currentpage").val())
				} else {
					expenselist();
				}
			}
		}

		callAjaxFileUploadSetFormData("/accounting/expensesave.do", "post",
				"json", true, datawithFile, savecallback)
	}

	/* 저장할 때 발리데이션 체크 */
	function fValidate() {

		var chk = checkNotEmpty([ [ "reglctcd", "계정대분류명을 입력해주세요" ],
				[ "regactcd", "상세과목명을 입력해주세요" ],
				[ "regusedate", "사용일자를 입력해주세요" ],
				[ "regspent", "지출금액을 입력해주세요" ]

		]);

		if (!chk) {
			return;
		}

		return true;
	}

	/** 지출결의서 상세보기 */
	function fn_detailexpense(expno) {
		var param = {
			expno : expno
		}

		var listcallback = function(returndata) {
			console.log("returndata : " + JSON.stringify(returndata));

			initpopup(returndata.detailexpense);
			gfModalPop("#expensereg");
		}

		callAjax("/accounting/expensedetail.do", "post", "json", "false",
				param, listcallback)
	}

	/** 지출결의서 상세보기(승인/반려용) */
	function fn_expenseapproval(expno) {

		var param = {
			expno : expno
		}

		var listcallback = function(returndata) {
			console.log("returndata : " + JSON.stringify(returndata));

			appinitpopup(returndata.detailexpense);
			gfModalPop("#expenseapp");
		}

		callAjax("/accounting/expensedetail.do", "post", "json", "false",
				param, listcallback)

	}

	/** 승인 반려 저장 */
	function fn_appsave() {

		if ($("input[name='approvalexpnese']:checked").val() === null
				|| $("input[name='approvalexpnese']:checked").val() === ""
				|| $("input[name='approvalexpnese']:checked").val() === undefined) {
			alert("승인여부를 체크해주세요")
			return false
		} else if (($("input[name='approvalexpnese']:checked").val() === "n" && $(
				"#appreject").val() === null)
				|| ($("input[name='approvalexpnese']:checked").val() === "n" && $(
						"#appreject").val() === "")
				|| ($("input[name='approvalexpnese']:checked").val() === "n" && $(
						"#appreject").val() === undefined)) {
			console.log($("#appreject").val())
			alert("반려사유를 입력해주세요.")
			return false
		}

		var param = {
			expno : $("#appexpno").val(),
			approval : $("input[name='approvalexpnese']:checked").val(),
			rejectrsn : $("#appreject").val(),
			approvalname : $("#userNm").val(),
			approvaldate : getToday(),
			appspent : $("#appspent").val()
		}
		console.log(param);

		var approvalcallback = function(returndata) {
			console.log("returndata : " + JSON.stringify(returndata));

			if (returndata.result === "SUCCESS") {
				gfCloseModal();
				expenselist($("#currentpage").val());
			}
		}

		callAjax("/accounting/approvalexpense.do", "post", "json", "false",
				param, approvalcallback)
	}

	// 승인 반려 창 팝업
	function appinitpopup(object) {
		$("#loginIDapp").val(object.loginID);
		$("#appname").val(object.name);
		$("#applctname").val(object.detail_name);
		$("#appactname").val(object.account_name);
		$("#appdate").val(object.exp_date);
		$("#appusedate").val(object.use_date);
		$("#appspent").val(object.exp_spent);
		$("#appexpdet").val(object.exp_det);
		$("#appreject").val("");
		$("#appexpno").val(object.exp_no);
		$("#appfileview").empty();
		$("input[name='approvalexpnese']").prop('checked', false);
		if (object.file_cd != 0) {
			app_file_detail(object.file_cd)
			$("#appviewtr").show();
		} else {
			$("#appviewtr").hide();
		}

	}

	/** 승인 반려 창 열 때 파일이 있으면 다운로드 가능하게 보여주기 */
	function app_file_detail(filecd) {
		$("#appfileview").empty();
		var param = {
			filecd : filecd
		}

		var filecallback = function(returndata) {
			console.log("returndata : ", JSON.stringify(returndata))

			var previewhtml = ""

			for (var i = 0; i < returndata.filedetail.length; i++) {
				filearr = returndata.filedetail[i].file_name.split(".");
				console.log("filearr : ", filearr)
				if (filearr[1] == "jpg" || filearr[1] == "png") {
					previewhtml = "<a href='javascript:fn_downaload("
							+ returndata.filedetail[i].file_no
							+ ","
							+ returndata.filedetail[i].file_cd
							+ ")'>   <img src='" + returndata.filedetail[i].file_nadd + "' style='width: 200px; height: 130px;' />  </a>";
				} else {
					previewhtml = "<a href='javascript:fn_downaload("
							+ returndata.filedetail[i].file_no + ","
							+ returndata.filedetail[i].file_cd + ")'>"
							+ returndata.filedetail[i].file_name + "</a>";
				}

				$("#appfileview").append(previewhtml);
			}

		}

		callAjax("/accounting/detailfile.do", "post", "json", "false", param,
				filecallback)
	}

	/** 지출결의서 상세보기 할 때 파일 미리보기*/
	function file_detail(filecd) {
		$("#fileview").empty();
		var param = {
			filecd : filecd
		}

		var filecallback = function(returndata) {
			console.log("returndata : ", JSON.stringify(returndata))

			var previewhtml = ""

			for (var i = 0; i < returndata.filedetail.length; i++) {
				filearr = returndata.filedetail[i].file_name.split(".");
				console.log("filearr : ", filearr)
				if (filearr[1] == "jpg" || filearr[1] == "png") {
					previewhtml = " <img src='" + returndata.filedetail[i].file_nadd + "' style='width: 200px; height: 130px;' />  </a>";
				}
				$("#fileview").css("overflow-y", "auto");
				$("#fileview").css("height", "150px");
				$("#fileview").append(previewhtml);
			}

		}

		callAjax("/accounting/detailfile.do", "post", "json", "false", param,
				filecallback)
	}

	/** 승인 반려창에서 파일 다운로드 */
	function fn_downaload(fileno, filecd) {

		var params = "<input type='hidden' name='filecd' value='" + filecd + "' /> <input type='hidden' name='fileno' value='" + fileno + "' />";

		jQuery(
				"<form action='/accounting/expensefiledownload.do' method='post'>"
						+ params + "</form>").appendTo('body').submit()
				.remove();
	}

	/** 계정과목분류명이 변할 때마다 상세분류명도 같이 */
	function laccountchange(event) {
		console.log($("#lctcd").val())
		detileAccount($("#lctcd").val(), "actcd", "sel", "selvalue");
	}

	/** 지출결의서 신청할 때 계정과목분류명이 변할 때마다 상세분류명도 같이 */
	function reglaccountchange(event) {
		console.log($("#reglctcd").val())
		detileAccount($("#reglctcd").val(), "regactcd", "sel", "selvalue");
	}
</script>

</head>
<body>
	<form id="myForm" action="" method="">
		<input type="hidden" name="loginId" id="loginId" value="${loginId}">
		<input type="hidden" name="userNm" id="userNm" value="${userNm}">
		<input type="hidden" name="userType" id="userType" value="${userType}">
		<input type="hidden" name="currentpage" id="currentpage" value="">
		<input type="hidden" name="action" id="action" value=""> <input
			type="hidden" name="scstdate" id="scstdate" value=""> <input
			type="hidden" name="sceddate" id="sceddate" value=""> <input
			type="hidden" name="sclctcd" id="sclctcd" value=""> <input
			type="hidden" name="scactcd" id="scactcd" value=""> <input
			type="hidden" name="scexpyn" id="scexpyn" value=""> <input
			type="hidden" name="scname" id="scname" value="">

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
								<span class="btn_nav bold">회계</span> <span class="btn_nav bold">지출결의서</span>
								<a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
							</p>
							<p class="conTitle">
								<span>지출결의서</span> <span class="fr"> <a
									class="btnType blue" href="" id="listsearch" name="btn"><span>조회</span></a>
								</span>
							</p>

							<div>
								<p>
									신청일자<input type="date" name="stdate" id="stdate"> ~ <input
										type="date" name="eddate" id="eddate">
									<c:if test="${userType eq 'B' || userType eq 'C'}">
								사원명<input type="text" name="searchname" id="searchname">
									</c:if>
									<a class="btnType blue" href="javascript:fn_openpopup()"
										name="modal" style="float: right;"><span>신규등록</span></a>
								</p>
								<br>
								<p>
									계정대분류명<select name="lctcd" id="lctcd"
										onchange="laccountchange()"></select> 상세분류명 <select
										name="actcd" id="actcd"></select> 승인여부 <select name="expyn"
										id="expyn">
										<option value="">전체</option>
										<option value="Y">승인</option>
										<option value="W">승인대기</option>
										<option value="N">반려</option>
									</select>
								</p>
							</div>
							<br />

							<div class="divComGrpCodList">
								<table class="col">
									<caption>caption</caption>
									<c:if test="${userType eq 'D'}">
										<colgroup>
											<col width="10%">
											<col width="10%">
											<col width="10%">
											<col width="11%">
											<col width="10%">
											<col width="10%">
											<col width="13%">
											<col width="13%">
											<col width="13%">
										</colgroup>
										<thead>
											<tr>
												<th scope="col">결의번호</th>
												<th scope="col">계정대분류명</th>
												<th scope="col">상세분류명</th>
												<th scope="col">신청일자</th>
												<th scope="col">사용일자</th>
												<th scope="col">지출금액</th>
												<th scope="col">승인여부</th>
												<th scope="col">승인/반려일자</th>
												<th scope="col">승인/반려자</th>
											</tr>
										</thead>
									</c:if>
									<c:if test="${userType eq 'B' || userType eq 'C'}">
										<colgroup>
											<col width="8%">
											<col width="9%">
											<col width="6%">
											<col width="11%">
											<col width="10%">
											<col width="10%">
											<col width="10%">
											<col width="8%">
											<col width="9%">
											<col width="10%">
											<col width="10%">
										</colgroup>
										<thead>
											<tr>
												<th scope="col">결의번호</th>
												<th scope="col">아이디</th>
												<th scope="col">사원명</th>
												<th scope="col">계정대분류명</th>
												<th scope="col">상세분류명</th>
												<th scope="col">신청일자</th>
												<th scope="col">사용일자</th>
												<th scope="col">지출금액</th>
												<th scope="col">승인여부</th>
												<th scope="col">승인/반려일자</th>
												<th scope="col">승인/반려자</th>
											</tr>
										</thead>
									</c:if>
									<tbody id="expenselist"></tbody>
								</table>
							</div>

							<div class="paging_area" id="bmDvPagination"></div>

						</div> <!--// content -->

						<h3 class="hidden">풋터 영역</h3> <jsp:include
							page="/WEB-INF/view/common/footer.jsp"></jsp:include>
					</li>
				</ul>
			</div>
		</div>

		<!-- 지출결의서 신청 팝업 창 -->
		<div id="expensereg" class="layerPop layerType2"
			style="width: 600px; overflow-y: auto">
			<input type="hidden" name="regexpno" id="regexpno">
			<dl>
				<dt>
					<strong>지출결의서 등록/수정</strong>
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
								<th scope="row">아이디</th>
								<td><input type="text" class="inputTxt p100"
									name="loginIDreg" id="loginIDreg" readonly /></td>
							</tr>
							<tr>
								<th scope="row">사원명</th>
								<td><input type="text" class="inputTxt p100" name="regname"
									id="regname" readonly /></td>
							</tr>
							<tr>
								<th scope="row">계정대분류명<span class="font_red">*</span></th>
								<td><select name="reglctcd" id="reglctcd"
									onchange="reglaccountchange()">
								</select></td>
							</tr>
							<tr>
								<th scope="row">상세과목명<span class="font_red">*</span></th>
								<td><select name="regactcd" id="regactcd">
								</select></td>
							</tr>
							<tr>
								<th scope="row">신청일자</th>
								<td><input type="text" class="inputTxt p100" name="regdate"
									id="regdate" readonly /></td>
							</tr>
							<tr>
								<th scope="row">사용일자<span class="font_red">*</span></th>
								<td><input type="date" class="inputTxt p100"
									name="regusedate" id="regusedate" /></td>
							</tr>
							<tr>
								<th scope="row">지출금액<span class="font_red">*</span></th>
								<td><input type="number" class="inputTxt p100"
									name="regspent" id="regspent" /></td>
							</tr>
							<tr>
								<th scope="row">비고</th>
								<td><textarea name="regexpdet" id="regexpdet"></textarea></td>
							</tr>
							<tr id="filetr">
								<th scope="row">증빙서류</th>
								<td><input multiple="multiple" type="file"
									class="inputTxt p100" name="regfile" id="regfile" />
									<div id="fileview"></div></td>
							</tr>
							<tr id="rejecttr">
								<th scope="row">반려사유</th>
								<td><textarea name="regreject" id="regreject" readonly></textarea></td>
							</tr>
						</tbody>
					</table>

					<!-- e : 여기에 내용입력 -->

					<div class="btn_areaC mt30">
						<a href="" class="btnType blue" id="btnSavereg" name="btn"><span>저장</span></a>
						<a href="" class="btnType blue" id="btnDeletereg" name="btn"><span>삭제</span></a>
						<a href="" class="btnType gray" id="btnClosereg" name="btn"><span>취소</span></a>
					</div>
				</dd>
			</dl>
			<a href="" class="closePop"><span class="hidden">닫기</span></a>


		</div>

		<!-- 지출결의서 승인 팝업 창 -->
		<div id="expenseapp" class="layerPop layerType2" style="width: 600px;">
			<input type="hidden" name="appexpno" id="appexpno">
			<dl>
				<dt>
					<strong>지출결의서 승인/반려</strong>
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
								<th scope="row">아이디</th>
								<td><input type="text" class="inputTxt p100"
									name="loginIDapp" id="loginIDapp" readonly /></td>
							</tr>
							<tr>
								<th scope="row">사원명</th>
								<td><input type="text" class="inputTxt p100" name="appname"
									id="appname" readonly /></td>
							</tr>
							<tr>
								<th scope="row">계정대분류명</th>
								<td><input type="text" class="inputTxt p100"
									name="applctname" id="applctname" readonly /></td>
							</tr>
							<tr>
								<th scope="row">상세과목명</th>
								<td><input type="text" class="inputTxt p100"
									name="appactname" id="appactname" readonly /></td>
							</tr>
							<tr>
								<th scope="row">신청일자</th>
								<td><input type="text" class="inputTxt p100" name="appdate"
									id="appdate" readonly /></td>
							</tr>
							<tr>
								<th scope="row">사용일자</th>
								<td><input type="date" class="inputTxt p100"
									name="appusedate" id="appusedate" readonly /></td>
							</tr>
							<tr>
								<th scope="row">지출금액</th>
								<td><input type="text" class="inputTxt p100"
									name="appspent" id="appspent" readonly /></td>
							</tr>
							<tr>
								<th scope="row">상세내용</th>
								<td><textarea name="appexpdet" id="appexpdet" readonly></textarea></td>
							</tr>
							<tr id="appviewtr">
								<th scope="row">증빙서류</th>
								<td><div id="appfileview"
										style="overflow-y: auto; height: 150px;"></div></td>
							</tr>
							<tr>
								<th scope="row">승인구분 <span class="font_red">*</span></th>
								<td>
									<div>
										<input type="radio" name="approvalexpnese" id="approvalyes"
											value="y" /> 승인 <input type="radio" name="approvalexpnese"
											id="approvalno" value="n" /> 반려
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row">반려사유</th>
								<td><textarea name="appreject" id="appreject"></textarea></td>
							</tr>
						</tbody>
					</table>

					<!-- e : 여기에 내용입력 -->

					<div class="btn_areaC mt30">
						<a href="" class="btnType blue" id="btnSaveapp" name="btn"><span>저장</span></a>
						<a href="" class="btnType gray" id="btnCloseapp" name="btn"><span>취소</span></a>
					</div>
				</dd>
			</dl>
			<a href="" class="closePop"><span class="hidden">닫기</span></a>


		</div>
	</form>
</body>
</html>