<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>공지사항</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<script type="text/javascript">

	// 그룹코드 페이징 설정
	var pageSize = 10;			//한페이지에 몇개 볼것인가
	var pageBlockSize = 5;
	

	
	
	/** OnLoad event */ 
	$(function() {
		
		searchnotice();
		
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
	
	function searchnotice(cpage){		//cpage라는 파라미터 값을 받을 것
		
		cpage = cpage || 1;		//undefined 면 1로 셋팅
		
		//먼저 파라미터, callback 지정해줘야함
		var param = {
				scrtitle : $("#srctitle").val(),
				srcsdate : $("#srcsdate").val(),
				srcedate : $("#srcedate").val(),
				pageSize : pageSize,
				cpage : cpage, 	//페이지번호를 넘김
				
		} //{}json 형태
		
		var listcallback = function(returndata){
			console.log(returndata);
			
			
			
			$("#listNotice").empty().append(returndata);
			
			console.log("totcnt: " + $("#counthnoticelist").val());
			var counthnoticelist = $("#counthnoticelist").val();
			
			var paginationHtml = getPaginationHtml(cpage, counthnoticelist, pageSize, pageBlockSize, 'searchnotice');
			console.log("paginationHtml : " + paginationHtml);
			//swal(paginationHtml);
			$("#noticePagination").empty().append( paginationHtml );
			
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
		 
		 callAjax("/hwang/hnoticelist.do", "post", "text", "false", param, listcallback);
		 
	}
	
	/* 신규 등록 || 수정  */
	function initpopup(object) {		
		
		if(object == "" || object == null || object == undefined ){
		
			$("#writer").val($("#userNm").val());
			$("#notice_date").val(getToday());
			
			$("#notice_title").val("");
			$("#notice_det").val("");
			
			$("#btnDelete").hide();
			
			$("#action").val("I");
		
		} else {
			$("#writer").val($(object.writer));
			$("#notice_date").val(object.notice_date);
			
			$("#notice_title").val(object.notice_title);
			$("#notice_det").val(object.notice_det);
			
			$("#btnDelete").show();
			
			$("#action").val("U");
		}
	}
	
	function fn_openpopup(){
		
		initpopup();
		
		gfModalPop("#noticereg");
	}
	
	function fn_save() {
			
			var param = {
					notice_no : $("#noticeno").val(),
				    notice_title : $("#notice_title").val(),
				    notice_det : $("#notice_det").val(),
					action : $("#action").val(),
			}
			
			var savecallback = function(returndata) {
							
				console.log(  JSON.stringify(returndata) );
				
				if(returndata.result == "SUCCESS") {
					alert("저장 되었습니다.");
					gfCloseModal();
					searchnotice();
				}
			}
			
			callAjax("/hwang/hnoticesave.do", "post", "json", "false", param, savecallback) ;
			
		}
	
	function fn_openpopupfile(){
		gfModalPop("#noticeregfile");
	}
	
	function fn_detailone(notice_no){
		
		var param = {
				notice_no : notice_no
				
		}
		
		var detailonecallback = function (returndata){
			console.log(  JSON.stringify(returndata) );
			console.log(returndata.detailone.notice_no);
			
			initpopup(returndata.detailone);
			
			gfModalPop("#noticereg");
		}
		
		callAjax("/hwang/detailone.do", "post", "json", "false", param, detailonecallback) ;
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
<form id="myForm" action=""  method="">
	<input type="hidden" name="action" id="action" value="">
	<input type="hidden" name="loginId" id="loginId" value="${loginId}">
	<input type="hidden" name="userNm" id="userNm" value="${userNm}">
	<input type="hidden" name="noticeno" id="noticeno" value="">
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
							<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a> <span
								class="btn_nav bold">실습</span> <span class="btn_nav bold">공지사항
								관리</span> <a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>공지사항</span> <span class="fr"> 
							   제목
                               <input type="text" id="srctitle" name="srctitle"	 />
                               <input type="date" id="srcsdate" name="srcsdate"	 /> ~
                               <input type="date" id="srcedate" name="srcedate"	 />						   
							   <a	class="btnType blue" href="javascript:searchnotice();" name="modal" ><span>검색</span></a>
							   <a	class="btnType blue" href="javascript:fn_openpopup();" name="modal"><span>신규등록</span></a>
							   <a	class="btnType blue" href="javascript:fn_openpopupfile();" name="modal"><span>신규등록 파일</span></a>
							</span>
						</p>
						
						<div class="divComGrpCodList">
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="6%">
									<col width="17%">
									<col width="57%">
									<col width="20%">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">번호</th>
										<th scope="col">작성자</th>
										<th scope="col">제목</th>
										<th scope="col">작성일자</th>
									</tr>
								</thead>
								<tbody id="listNotice"></tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="noticePagination"> </div>
						
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>
	
	<div id="noticereg" class="layerPop layerType2" style="width: 600px;">
	     <dl>
			<dt>
				<strong>공지사항 등록/수정</strong>
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
							<th scope="row">작성자 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" name="writer" id="writer"  readonly /></td>
							<th scope="row">작성일자 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" name="notice_date" id="notice_date" readonly /></td>
						</tr>
						<tr>
							<th scope="row">제목 <span class="font_red">*</span></th>
							<td colspan="3">
							     <input type="text" class="inputTxt p100"	name="notice_title" id="notice_title" />
							</td>
						</tr>

						<tr>
							<th scope="row">내용 <span class="font_red">*</span></th>
							<td colspan="3">
							     <textarea class="inputTxt p100"	name="notice_det" id="notice_det" > </textarea>
							</td>
						</tr>
							
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSave" name="btn"><span>저장</span></a> 
					<a href="" class="btnType blue" id="btnDelete" name="btn"><span>삭제</span></a> 
					<a href=""	class="btnType gray"  id="btnClose" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	
	
	</div>
	
     <div id="noticeregfile" class="layerPop layerType2" style="width: 600px;">
	     <dl>
			<dt>
				<strong>공지사항 등록/수정</strong>
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
							<th scope="row">작성자 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" name="writerfile" id="writerfile"  readonly /></td>
							<th scope="row">작성일자 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" name="notice_datefile" id="notice_datefile" readonly /></td>
						</tr>
						<tr>
							<th scope="row">제목 <span class="font_red">*</span></th>
							<td colspan="3">
							     <input type="text" class="inputTxt p100"	name="notice_titlefile" id="notice_titlefile" />
							</td>
						</tr>

						<tr>
							<th scope="row">내용 <span class="font_red">*</span></th>
							<td colspan="3">
							     <textarea class="inputTxt p100"	name="notice_detfile" id="notice_detfile" > </textarea>
							</td>
						</tr>
							
						<tr>
							<th scope="row">파일 <span class="font_red">*</span></th>
							<td><input type="file" class="inputTxt p100" name="addfile" id="addfile"  readonly /></td>
							<td colspan="2"><div id="fileview"></div></td>
						</tr>
							
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSavefile" name="btn"><span>저장</span></a> 
					<a href="" class="btnType blue" id="btnDeletefile" name="btn"><span>삭제</span></a> 
					<a href=""	class="btnType gray"  id="btnClosefile" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	
	
	</div>	

</form>
</body>
</html>