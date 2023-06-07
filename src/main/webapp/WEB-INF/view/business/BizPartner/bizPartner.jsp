<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>거래처 관리</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<script type="text/javascript">

	// 그룹코드 페이징 설정
	var pageSize = 3;			//한페이지에 몇개 볼것인가
	var pageBlockSize = 5;
	
	/** OnLoad event */ 
	$(function() {
		fRegisterButtonClickEvent();
		clientsearch();
		
		$("#bpname").change(function(){
			var koreanRules = /^[\D]+$/;
	        if(!koreanRules.test($("#bpname").val())){
	           alert("이름 검색엔 한글과 영어만 작성 가능합니다.");
	           $("#bpname").val("");
	        }
		})
	});
	
	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();		//이후의 예약 이벤트를 모두 소멸시킴

			var btnId = $(this).attr('id');	//해당 버튼의 아이디를 꺼내라

			switch (btnId) {
			case 'clientsearch':
					$("#sbpname").val($("#bpname").val());
					$("#spageSize").val($("#spageSize").val());
					$("#scpage").val($("#cpage").val());
					clientsearch($("#scpage").val(), $("#sbpname").val());
					break;
			case 'btnSave' :
					fn_save();
					break;
			case 'btnDelete' :
					$("#action").val("D");
					fn_save();
					break;
			case 'btnClose' :
					gfCloseModal();
					break;
			}
		});
	}
	
	//상단 리스트
	function clientsearch(cpage, bpname){
		cpage = cpage || 1;
		$("#currentPage").val(cpage);
		$("#bpname").val(bpname);
		
		var param = {
				bpname : $("#bpname").val(),
				pageSize : pageSize,
				cpage : cpage,
		}
		console.log(param);
		console.log($("#userType").val());
		
		var listcallback = function(data) {
			//console.log(data);
			$("#BPclientlist").empty().append(data);
			
			var countclientlist = $("#countclientlist").val();
			
			var paginationHtml = getPaginationHtml(cpage, countclientlist, pageSize, pageBlockSize, 'clientsearch');
			
			$("#clientlistPagination").empty().append(paginationHtml);
		}
		callAjax("/business/clientlist.do", "post", "text", "false", param, listcallback) ;
	}
	
	//거래처 리스트에서의 거래처번호 백업 
	function fn_detailclient(client_no){
		console.log('거래처이름클릭 + no  : ' + client_no);
		
		//clientno의 hidden값에 clientno 저장
		$("#clientno").val(client_no);
		
		
		detailclient();
		
		//detailinitpop(client_no);
	}
	
	//거래처 디테일 데이터 가져오는 부분.
	function detailclient(){
		
		var param = {
				client_no : $("#clientno").val(),
		}
		console.log(param);
		var listcallback = function(data) {
			//console.log(JSON.stringify(data));
			gfModalPop("#clientmodal");
			detailinitpop(data.clientdetail);
		}
		callAjax("/business/clientdetail.do", "post", "json", "false", param, listcallback) ;
		
	}
	
	//거래처 리스트에서 거래처명을 눌렀을 때 뜨는 디테일 팝업   readonlydetail     notreadonlydetail
 	function detailinitpop(data){
 		console.log(data);
 		
 		if(data == '' || data == null || data == undefined){
 			$("#readonlydetail").show();
 			$("#notreadonlydetail").hide();
 			$("#updatedetail").hide();
 			//하단 버튼 부분
 			$("#deleteshow").hide();//notdelete
 			$("#notdelete").show();
 			//$("#detailshow").hide();
 			//데이터 부분
 			$("#det_permit_no").val("");
 			$("#client_no").val("");
 			$("#det_client_name").val("");
 			$("#det_manager_name").val("");
 			$("#det_zip_code").val("");
 			$("#det_addr").val("");
 			$("#det_det_addr").val("");
 			$("#det_manager_hp").val("");
 			$("#det_manager_email").val("");
 			$("#det_client_tel").val("");
 			$("#det_fax_tel").val("");
 			//action 값이 I 일때, readonly 걸어준 부분 삭제
 			$("#det_permit_no").removeAttr("readonly");
 			$("#det_client_name").removeAttr("readonly");
 			//신규 저장 action 값
 			$("#action").val("I");
 		}else {
 			//값이 있을 때 수정 버튼만 보이게.
 			$("#readonlydetail").show();
 			$("#notreadonlydetail").hide();
 			$("#updatedetail").hide();
 			//하단 버튼 부분
 			$("#deleteshow").show();
 			$("#notdelete").hide();
 			//$("#detailshow").show();
 			//데이터 부분
 			$("#det_permit_no").val(data.permit_no);
 			$("#client_no").val(data.client_no);
 			$("#det_client_name").val(data.client_name);
 			$("#det_manager_name").val(data.manager_name);
 			$("#det_zip_code").val(data.zip_code);
 			$("#det_addr").val(data.addr);
 			$("#det_det_addr").val(data.det_addr);
 			$("#det_manager_hp").val(data.manager_hp);
 			$("#det_manager_email").val(data.manager_email);
 			$("#det_client_tel").val(data.client_tel);
 			$("#det_fax_tel").val(data.fax_tel);
 			//action 값이 U 일 때, readonly 넣어주기
 			$("#det_permit_no").attr("readonly","readonly");
 			$("#det_client_name").attr("readonly","readonly");
 			//기존 업데이트 action 값
 			$("#action").val("U");
 		}
	}
	
	//거래처 등록 버튼을 눌렀을 때
	function fn_newBizPartner(){
		
		detailinitpop();
		gfModalPop("#clientmodal");
	}
	//디테일 확인 부분에서 수정 버튼을 눌렀을 때
	function fn_savebt(){
		var param = {
				client_no : $("#client_no").val(),
				det_permit_no : $("#det_permit_no").val(),
	            det_client_name : $("#det_client_name").val(),
	            det_zip_code : $("#det_zip_code").val(),
	            det_addr : $("#det_addr").val(),
	            det_det_addr : $("#det_det_addr").val(),
	            det_manager_name : $("#det_manager_name").val(),
	            det_manager_hp : $("#det_manager_hp").val(),
	            det_client_tel : $("#det_client_tel").val(),
	            det_fax_tel : $("#det_fax_tel").val(),
	            det_manager_email : $("#det_manager_email").val(),
	            action : $("#action").val(),
		}
		
		console.log("저장버튼 param : ");
		console.log(param);
		
		var listcallback = function(data) {
			console.log(JSON.stringify(data));
			gfCloseModal();
			clientsearch($("#currentPage").val());
		}
		callAjax("/business/clientsave.do", "post", "json", "false", param, listcallback) ;
	}
	//디테일 팝업에서 저장 버튼을 눌렀을 때 정규식(+거래처번호 중복 안되게 설정 후 수정으로 넘어감)
	function fn_save(){
		
		//저장할 때 정규식 
		var emailRules = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
		var addrRules = /[0-9]{5}/;
		var telRules = /^\d{2,3}-\d{3,4}-\d{4}$/;
		var hpRules = /^\d{3}-\d{3,4}-\d{4}$/;
		var perRules = /^\d{3}-\d{2}-\d{5}$/;
		var koreanRules = /^[가-힣a-zA-Z]+$/;
		
		if(!perRules.test($("#det_permit_no").val())){
			swal("사업자 번호를 확인해주세요. 000-00-00000 양식입니다.").then(function() {
				$("#det_permit_no").focus();
			  })
			  return false;
		} else if(!koreanRules.test($("#det_client_name").val())){
			swal("거래처 이름을 확인해주세요.").then(function() {
				$("#det_client_name").focus();
			  })
			  return false;
		} else if(!koreanRules.test($("#det_manager_name").val())){
			swal("담당자 이름을 확인해주세요.").then(function() {
				$("#det_manager_name").focus();
			  })
			  return false;
		} else if (!addrRules.test($("#det_zip_code").val())){
			swal("우편번호를 확인해주세요.(숫자 5글자 입니다.)").then(function() {
				$("#det_zip_code").focus();
			  })
			  return false;
		} else if(!koreanRules.test($("#det_addr").val())){
			swal("주소를 확인해주세요.").then(function() {
				$("#det_addr").focus();
			  })
			  return false;
		} else if(!koreanRules.test($("#det_det_addr").val())){
			swal("상세주소를 확인해주세요.").then(function() {
				$("#det_det_addr").focus();
			  })
			  return false;
		} else if (!hpRules.test($("#det_manager_hp").val())){
			swal("휴대폰번호를 확인해주세요. (-) 포함입니다.").then(function() {
				$("#det_manager_hp").focus();
			  })
			  return false;
		} else if(!emailRules.test($("#det_manager_email").val())){
			swal("이메일 형식을 확인해주세요.").then(function() {
				$("#det_manager_email").focus();
			  })
			  return false;
		} else if (!telRules.test($("#det_client_tel").val())){
			swal("전화번호를 확인해주세요. (-) 포함입니다.").then(function() {
				$("#det_client_tel").focus();
			  })
			  return false;
		} else if (!telRules.test($("#det_fax_tel").val())){
			swal("팩스번호를 확인해주세요. (-) 포함입니다.").then(function() {
				$("#det_fax_tel").focus();
			  })
			  return false;
		} 
		
		
		///정규식 종료
		if(!fValidate()) {
			return;
		}
		
		console.log('저장버튼');
		
		var param = {
				det_permit_no : $("#det_permit_no").val(),
		}
		
		console.log("저장버튼 param : ");
		console.log(param);
		
		var listcallback = function(data) {
			console.log(" 여기이이이:"+$("#action").val());
			console.log(JSON.stringify(data));
			if($("#action").val() === "I" ){
				if(data.clientdetail != null && data.clientdetail.permit_no === $("#det_permit_no").val()){
					swal("사업자 번호가 중복 되었습니다. 확인 부탁드립니다.");
				} else {
					gfCloseModal();
					//clientsearch($("#currentPage").val());
					fn_savebt();
				}
			} else {
				console.log(" Update :"+$("#action").val());
				fn_savebt();
				
			}
				
			
		}
		callAjax("/business/clientdetail.do", "post", "json", "false", param, listcallback) ;
	}
	
	//Validate 체크 하는 부분
	function fValidate() {

	      var chk = checkNotEmpty(
	            [
	                   [ "det_permit_no", "사업자 번호 을 입력해 주세요" ]
	               ,   [ "det_client_name", "거래처 이름을 입력을 입력해 주세요." ]
	               ,   [ "det_manager_name", "담당자 이름을 입력을 입력해 주세요." ]
	               ,   [ "det_zip_code", "우편번호를 입력해 주세요" ]
		           ,   [ "det_addr", "주소을 입력을 입력해 주세요." ]
		           ,   [ "det_det_addr", "상세주소를 입력을 입력해 주세요." ]
	               ,   [ "det_manager_hp", "담당자 연락처를 입력을 입력해 주세요." ]
	               ,   [ "det_manager_email", "담당자 이메일을 입력을 입력해 주세요." ]
	               ,   [ "det_client_tel", "거래처 연락처를 입력을 입력해 주세요." ]
	               ,   [ "det_fax_tel", "거래처 팩스 번호를 입력을 입력해 주세요." ]
	            ]
	      );

	      if (!chk) {
	    	  
	         return;
	      } else{
	    	  
	   	  return true;
	      }
	      
	   }
</script>

</head>
<body>
<form id="myForm" action=""  method="">
	<input type="hidden" name="action" id="action" value="" />
	<input type="hidden" name="clientno" id="clientno" value="" />
	<input type="hidden" name="userType" id="userType" value="${userType}" />
	<input type="hidden" name="currentPage" id="currentPage" value="" />
	<input type="hidden" name="sbpname" id="sbpname" value="" />
	<input type="hidden" name="spageSize" id="spageSize" value="" />
	<input type="hidden" name="scpage" id="scpage" value="" />
	
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
							<span>거래처 관리</span>
							<span class="fr"> 
							   <a class="btnType blue" href="javascript:fn_newBizPartner();" name="modal"><span>거래처 등록</span></a>
							</span>
						</p>
						<p class="conTitle">
							<span>검색 관리</span>
							<span class="fr">
							 <!-- <select>
							 	<option>거래처명</option>
							 	<option>작성자 휴대폰번호</option>
							 </select> -->
								<input type="text" id="bpname" name="bpname" placeholder="거래처명을 입력해 주세요." style="height:25px;" />
								<a	class="btnType blue" href=""  id="clientsearch" name="btn"  ><span>검색</span></a>
                            </span>
						</p>
						
						<div class="divComGrpCodList">
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="10%">
									<col width="20%">
									<col width="15%">
									<col width="15%">
									<col width="15%">
									<col width="15%">
									<col width="10%">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">거래처 번호</th>
										<th scope="col">거래처 이름</th>
										<th scope="col">담당자</th>
										<th scope="col">담당자전화</th>
										<th scope="col">email</th>
										<th scope="col">펙스 번호</th>
										<th scope="col"></th>
									</tr>
								</thead>
								<tbody id="BPclientlist"></tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="clientlistPagination"> </div>
						
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>
	
	
	
	<div id="clientmodal" class="layerPop layerType2" style="width: 600px; margin-top: 120px; ">
		<form id="clientForm" method="post">
	     <dl>
			<dt>
				<strong>거래처 정보</strong>
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
					
					<!-- 디테일 팝업 -->
					<tbody id="readonlydetail">	
						<tr>
							<th scope="row">거래처 번호</th>
							<td><input type="text" class="inputTxt p100" name="client_no" id="client_no" placeholder="자동으로 입력됩니다." readonly /></td>
							<th scope="row">사업자 번호<span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" name="det_permit_no" id="det_permit_no" placeholder="000-00-00000" /></td>
						</tr>
						<tr>
							<th scope="row">거래처 이름<span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" name="det_client_name" id="det_client_name" /></td>
							<th scope="row">담당자 이름<span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" name="det_manager_name" id="det_manager_name" /></td>
						</tr>
						<tr>
							<th scope="row">우편번호<span class="font_red">*</span></th>
							<td colspan="3">
							     <input type="text" class="inputTxt p100"	name="det_zip_code" id="det_zip_code" placeholder="숫자 5자 입니다." />
							</td>
						</tr>
						<tr>
							<th scope="row">주소<span class="font_red">*</span></th>
							<td colspan="3">
							     <input type="text" class="inputTxt p100"	name="det_addr" id="det_addr" />
							</td>
						</tr>
						<tr>
							<th scope="row">상세주소<span class="font_red">*</span></th>
							<td colspan="3">
							     <input type="text" class="inputTxt p100"	name="det_det_addr" id="det_det_addr" />
							</td>
						</tr>
						<tr>
							<th scope="row">담당자 연락처<span class="font_red">*</span></th>
							<td>
							     <input type="text" class="inputTxt p100"	name="det_manager_hp" id="det_manager_hp" />
							</td>
							<th scope="row">담당자 이메일<span class="font_red">*</span></th>
							<td>
							     <input type="text" class="inputTxt p100"	name="det_manager_email" id="det_manager_email" />
							</td>
						</tr>
						<tr>
							<th scope="row">거래처 연락처<span class="font_red">*</span></th>
							<td>
							     <input type="text" class="inputTxt p100"	name="det_client_tel" id="det_client_tel" />
							</td>
							<th scope="row">거래처 팩스 번호<span class="font_red">*</span></th>
							<td>
							     <input type="text" class="inputTxt p100"	name="det_fax_tel" id="det_fax_tel" />
							</td>
						</tr>
						</tbody>
						
				</table>

				<!-- e : 여기에 내용입력 -->
				
				<div class="btn_areaC mt30">
				<div id="deleteshow">  <!-- 거래처 수정에서 쓸 부분-->
					<%-- <c:if test="${userType eq 'A'}"> --%> <!-- A만 쓸수있게 막을려했는데 보류 -->
					<a href="" class="btnType blue" id="btnSave" name="btn"><span>저장</span></a> 
					<a href="" class="btnType blue" id="btnDelete" name="btn"><span>삭제</span></a>
					<a href=""	class="btnType gray"  id="btnClose" name="btn"><span>취소</span></a>
					<%-- </c:if> --%>
				</div>
				<div id="notdelete"> <!-- 거래처 등록에서 쓸 부분-->
					<a href="" class="btnType blue" id="btnSave" name="btn"><span>저장</span></a> 
					<a href=""	class="btnType gray"  id="btnClose" name="btn"><span>취소</span></a>
				</div>
				</div> 
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
		</form>
	</div>
	
	
</form>
</body>
</html>