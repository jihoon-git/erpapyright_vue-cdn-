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

	// 페이징 설정
	var pageSize = 5;
	var pageBlockSize = 5;
	var vuearea;
	var hiddenarea;
	var newplan;
	
	/** OnLoad event */ 
	$(function() {
	
		init();
		
		fRegisterButtonClickEvent();
	
		//searchnotice();
		vuearea.fn_searchnotice();
		
		
	});
	
	function init(){
		vuearea = new Vue({
			el : "#wrap_area",
			data : {
				pageSize : 5,
				pageBlockSize : 5,
				
				grouplist :[],
				countnoticelist : 0,
				paginationHtml : '',	
				
				srctitle : '',
				srcsdate : '',
				srcedate : '',

				
				notice_no : '',
				notice_title : '',
				writer : '',
				notice_date : '',				
				
			    notice_det : '',				
				
				detailone : [],
				btnDeletefile : false,

				
			},
			methods : {
				fn_searchnotice : function(){
					hiddenarea.srctitle = vuearea.srctitle;
					hiddenarea.srcsdate = vuearea.srcsdate;
					hiddenarea.srcedate = vuearea.srcedate;
					searchnotice();
					
				}
			}
			
		}),
		
		hiddenarea = new Vue({
			el : "#hiddenarea",
			data : {
				srctitle : '',
				srcsdate : '',
				srcedate : '',
				currentpage : '',
				
				loginId : '',
				userNm : '',
				userType : '',
				action : '',
				
			},
			methods : {
				
			}
		}),
		
		noticeregfile = new Vue({
			el : "#noticeregfile",
			data : {
				noticeno : '',
				
				writerfile : '',
				notice_datefile : '',
				notice_titlefile1 : '',
				notice_detfile1 : '',				
				fileview : '',
				loginId : '',
				addfile : '',
				
			},
			methods : {
				
			}
		})
	}
	
	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();

			var btnId = $(this).attr('id');
			
			switch (btnId) {
			    case 'btnSavefile' :
					fn_savefile();
					break;	
			    case 'btnDeletefile' :
			    	$("#action").val("D");
			    	fn_savefile();
					break;	
				case 'btnClose' :
				case 'btnClosefile' :
					gfCloseModal();
					break;
			}
		});
		
		var upfile = document.getElementById('addfile');
		upfile.addEventListener('change',
						function(event) {
							$("#fileview").empty();
							var image = event.target;
							var imgpath = "";
							if (image.files[0]) {								
								imgpath = window.URL.createObjectURL(image.files[0]);
								
								console.log(imgpath);
								
								var filearr = $("#addfile").val().split(".");

								var previewhtml = "";

								if (filearr[1] == "jpg" || filearr[1] == "png") {
									previewhtml = "<img src='" + imgpath + "' style='width: 200px; height: 130px;' />";
								} else {
									previewhtml = "";
								}

								$("#fileview").empty().append(previewhtml);
							}
						});
	}
	
	
	function searchnotice(cpage) {	
		
		if(hiddenarea.srcsdate != "" && hiddenarea.srcedate == ""){
			alert("종료일을 선택하세요."); 
		} else if(hiddenarea.srcsdate == "" && hiddenarea.srcedate !="") {
			alert("시작일을 선택하세요.");
		} else if(hiddenarea.srcsdate !="" && hiddenarea.srcedate !="" && hiddenarea.srcsdate > hiddenarea.srcedate){
			alert("날짜를 확인해 주세요.");
		} else {
			cpage = cpage || 1;
			
			// 파라메터,  callback
			var param = {
					scrtitle : hiddenarea.srctitle,
					srcsdate : hiddenarea.srcsdate,
					srcedate : hiddenarea.srcedate,
					pageSize : pageSize,
					cpage : cpage,
			}
			
			var listcallback = function(returndata) {
							
				console.log(returndata);
				console.log(returndata.vueNoticelist);
				console.log(returndata.countnoticelist);
				
				//$("#listNotice").empty().append(returndata);
				
				vuearea.grouplist = returndata.vueNoticelist;
				
				//var countnoticelist = $("#countnoticelist").val();
				vuearea.countnoticelist = returndata.countnoticelist;
				
				var paginationHtml = getPaginationHtml(cpage, returndata.countnoticelist, pageSize, pageBlockSize, 'searchnotice');
				
				//$("#noticePagination").empty().append(paginationHtml);
				vuearea.paginationHtml = paginationHtml;
				 
				//$("#currentpage").val(cpage);
				hiddenarea.currentpage = cpage;
								
			}
			
			callAjax("/system/vueNoticeList.do", "post", "json", "false", param, listcallback) ;
			}
			
	}
	
    function getToday(){
        var date = new Date();
        var year = date.getFullYear();
        var month = ("0" + (1 + date.getMonth())).slice(-2);
        var day = ("0" + date.getDate()).slice(-2);

        return year + "-" + month + "-" + day;
    }
	
	
	function fn_save() {
		
		var param = {
				notice_no  : vuearea.noticeno,  
			    notice_title : vuearea.notice_title,
			    notice_det : vuearea.notice_det,
				action : vuearea.action,
		}
		
		var savecallback = function(returndata) {
						
			console.log(  JSON.stringify(returndata) );
			
			if(returndata.result == "SUCCESS") {
				alert("저장 되었습니다.");
				gfCloseModal();
				
				if($("#action").val() == "U") {
					searchnotice($("#currentpage").val());
				} else {
					searchnotice();
				}
				
			}
		}
		
		callAjax("/system/vueNoticeListSave.do", "post", "json", "false", param, savecallback) ;
		
	}
	
	function openPop(){
		initpopup()
		gfModalPop("#noticeregfile");
	}
	
	/* 공지사항디테일 */
    function fn_detailone(notice_no) {
    	//vuearea.notice_no = notice_no;
		console.log("notice_no : " + notice_no);
    	var param = {
    			//notice_no : vuearea.notice_no
    			notice_no : notice_no
    	}
    	
    	var detailonecallback = function(returndata) {
    		console.log(  JSON.stringify(returndata)  );
    		
    		console.log( returndata.detailone.notice_no);
    		
    			initpopup(returndata.detailone);
    			
    			//vuearea.detailone = returndata.detailone;
    			vuearea.loginId = returndata.loginId;
        		gfModalPop("#noticeregfile");
    		
    	}
    	
    	callAjax("/system/vueNoticeDetailone.do", "post", "json", "false", param, detailonecallback) ;
    }    
     
    
    /*  init폼 */
    function initpopup(object) {	
		console.log("object1 : " + JSON.stringify(object));
		if( object == "" || object == null || object == undefined) {
			
			noticeregfile.writerfile = vuearea.detailone.writer;
			noticeregfile.notice_datefile = getToday();
			noticeregfile.notice_titlefile = '';
			noticeregfile.notice_detfile = '';
			noticeregfile.addfile = '';
			noticeregfile.fileview = '';
			//$("#writerfile").val($("#userNm").val());
			//$("#notice_datefile").val(getToday());				
			//$("#notice_titlefile").val("");
			//$("#notice_detfile").val("");
			//$("#addfile").val("");
			//$("#fileview").empty();
			
			//$("#btnDeletefile").hide();
			vuearea.btnDeletefile = false;
			
			//$("#action").val("I");
			hiddenarea.action = "I";
		} else {			
			// {"notice_no":17,"loginID":"admin","writer":"변경","notice_title":"test","notice_date":"2023-05-08","notice_det":"test","file_name":null,"file_size":0,"file_nadd":null,"file_madd":null}
			console.log("object2 : " + JSON.stringify(object));
			noticeregfile.noticeno = object.notice_no;
			noticeregfile.writerfile = object.writer;			
			noticeregfile.notice_datefile = object.notice_date;
			
			noticeregfile.notice_titlefile1 = object.notice_title;			
			console.log("object.notice_title : " + object.notice_title);
			console.log("noticeregfile.notice_titlefile1 : " + noticeregfile.notice_titlefile1);
			noticeregfile.notice_detfile1= object.notice_det;			
			noticeregfile.addfile = '';
			
			//$("#noticeno").val(object.notice_no);
			//$("#writerfile").val(object.writer);
			//$("#notice_datefile").val(object.notice_date);
			
			//$("#notice_titlefile").val(object.notice_title);
			//$("#notice_detfile").val(object.notice_det);
			//$("#addfile").val("");
			var file_name = object.file_name;
			var filearr = [];
			var previewhtml = "";
			console.log("file_name : " + file_name);

			
			if( file_name == "" || file_name == null || file_name == undefined) {
				console.log("Zzz");
				previewhtml = "";
			} else {
				filearr = file_name.split(".");
				
				
				if (filearr[1] == "jpg" || filearr[1] == "png") {
					previewhtml = "<a href='javascript:fn_downaload()'>   <img src='" + object.file_nadd + "' style='width: 200px; height: 130px;' />  </a>";
				} else {
					previewhtml = "<a href='javascript:fn_downaload()'>" + object.file_name  + "</a>";
				}
			}
			

			//$("#fileview").empty().append(previewhtml);
			noticeregfile.fileview = previewhtml;
			//$("#btnDeletefile").show();
			vuearea.btnDeletefile = true;
			//$("#action").val("U");
			hiddenarea.action = "U";
			//gfModalPop("#noticeregfile");
		}
		
	}
	
    function fn_downaload() {
    	alert($("#noticeno").val());
    	
    	var params = "<input type='hidden' name='notice_no' value='"+ $("#noticeno").val() +"' />";
	 	
	 	jQuery("<form action='/system/noticefiledownaload.do' method='post'>"+params+"</form>").appendTo('body').submit().remove();
		 
    	
    }
    
    function fn_savefile() {
		console.log($("#notice_titlefile").val());
    	if($("#notice_titlefile").val() == null || $("#notice_titlefile").val() == ''){
    		alert("제목을 입력해 주세요.");
    	} else if($("#notice_detfile").val() == null || $("#notice_detfile").val() == '') {
    		alert("내용을 입력해 주세요.");
    	} else {
	 	    var frm = document.getElementById("myForm");
		    frm.enctype = 'multipart/form-data';
		    var dataWithFile = new FormData(frm);
			
			var savecallback = function(returndata) {
							
				console.log(  JSON.stringify(returndata) );
				
				if(returndata.result == "SUCCESS") {
					alert("저장 되었습니다.");
					gfCloseModal();
					
					if($("#action").val() == "U") {
						searchnotice($("#currentpage").val());
					} else {
						searchnotice();
					}
					
				}
			}
			
			callAjaxFileUploadSetFormData("/system/noticesavefile.do", "post", "json", true, dataWithFile, savecallback);
    	}
	}
    
    function close(){
    	gfCloseModal();
    }
    
    ////파일 첨부 끝
    

</script>

</head>
<body>
<form id="myForm" action=""  method="">
	<div id="hiddenarea">
	<input type="hidden" name="action" id="action" value="" v-model="action">
	<input type="hidden" name="loginId" id="loginId" value="${loginId}">
	<input type="hidden" name="userNm" id="userNm" value="${userNm}">
	<input type="hidden" name="noticeno" id="noticeno" value="">
	<input type="hidden" name="currentpage" id="currentpage" value="">
	<input type="hidden" name="srctitle" v-model="srctitle"/>
    <input type="hidden" name="srcsdate" v-model="srcsdate" /> 
    <input type="hidden" name="srcedate" v-model="srcedate" />
    </div>
	
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
							<span class="btn_nav bold">실습</span>
							<span class="btn_nav bold">공지사항	관리</span>
							<a href="../system/vueNotice.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>공지사항</span>
							<span class="fr"> 
							   제목 <input type="text" id="srctitle" name="srctitle" v-model="srctitle"/>
                               <input type="date" id="srcsdate" name="srcsdate"	 v-model="srcsdate"/> ~
                               <input type="date" id="srcedate" name="srcedate"	 v-model="srcedate"/>						   
							   <a	class="btnType blue" href="" @click.prevent="fn_searchnotice()" name="modal" ><span>검색</span></a>
							</span>
						</p>
						<div align="right">
						<c:if test="${sessionScope.userType eq 'A'}">
						<a class="btnType blue" href="javascript:openPop();" name="modal"><span>등록</span></a>
						</c:if>
						</div>
						<div class="divComGrpCodList">
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="6%">
									<col width="57%">
									<col width="17%">
									<col width="20%">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">번호</th>
										<th scope="col">제목</th>
										<th scope="col">작성자</th>
										<th scope="col">날짜</th>
									</tr>
								</thead>								
								
								<template v-if="countnoticelist == 0 ">
									<tbody>
										<tr>
											<td colspan="4">데이터가 존재하지 않습니다.</td>
										</tr>
									</tbody>
								</template>
							
								<template v-else>
									<tbody v-for="(list,index) in grouplist">
										<tr>
											<td>{{list.notice_no}}</td>
											<td><a href="" @click.prevent="fn_detailone(list.notice_no)">{{list.notice_title}}</a></td>
											<td>{{list.writer}}</td>
											<td>{{list.notice_date}}</td>
										</tr>
									</tbody>
								</template>
							
								
							</table>
						</div>
	
						<div class="paging_area"  id="noticePagination" v-html="paginationHtml"> </div>
						
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
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
							<td><input type="text" class="inputTxt p100" name="writerfile" id="writerfile" v-model="writerfile" readonly /></td>
							<th scope="row">작성일자 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" name="notice_datefile" id="notice_datefile" v-model="notice_datefile" readonly /></td>
						</tr>
						<tr>
							<th scope="row">제목 <span class="font_red">*</span></th>
							<td colspan="3">
							     <input type="text" class="inputTxt p100"	name="notice_titlefile1" id="notice_titlefile1" v-model="notice_titlefile1"/>
							</td>
						</tr>

						<tr>
							<th scope="row">내용 <span class="font_red">*</span></th>
							<td colspan="3">
							     <textarea class="inputTxt p100"	name="notice_detfile1" id="notice_detfile1" v-model="notice_detfile1"> </textarea>
							</td>
						</tr>
							
						<tr>
							<th scope="row">파일 <span class="font_red">*</span></th>
							<td>
							     <!-- input type="file" class="inputTxt p100" name="addfile" id="addfile"  onChange="fn_filechange(event)"  / -->
							     <input type="file" class="inputTxt p100" name="addfile" id="addfile" v-model="writerfile"/>
							</td>
							<td colspan="2"><div id="fileview" v-html="fileview"></div></td>
						</tr>
							
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
				<c:if test="${sessionScope.userType eq 'A'}">
					<a href="" class="btnType blue" id="btnSavefile" name="btn"><span>저장</span></a> 
					<a href="" class="btnType blue" id="btnDeletefile" v-show="vuearea.btnDeletefile" name="btn"><span>삭제</span></a>
				</c:if>	 
					<a href="" @click.prevent="close()"	class="btnType gray"  id="btnClosefile"><span>닫기</span></a>
				</div>
			</dd>
		</dl>
		<a href="" @click.prevent="close()" class="closePop"><span class="hidden">닫기</span></a>	
	</div>	

</form>
</body>
</html>