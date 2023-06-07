<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>근태관리</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<style type="text/css">
	
#date{margin:20px 5px 10px 5px;}
#text1{font-size:105%; font-weight:normal;}
.inputt{width:100px;}
#accbig{width:10%; margin-left:1%;}
#accsmall{width:10%; margin-left:1%;}
#payment{width:10%; margin-left:1%;}
#use{width:10%; margin-left:1%;}


#text2{margin-left:2%}
#text3{margin-left:2%}
#text4{margin-left:2%}

.inputT p100{width:10%;}

.right{
		align:right;
	}
.left{
		align:left;
	}
.center{
		display:flex;
		justify-content:center;
	}
.middle{
		vertical-align:middle;
	}
.title{
		font-size:40px;
		padding:30px;
	}
.sa{
		display:flex;
		justify-content:space-around;
	}

.hei{
		height:30px;
		margin: 0px 20px 0px 20px;
		width:200px;
	}

</style>

<script type="text/javascript">

	// 페이징 설정
	var pageSize = 5;
	var pageBlockSize = 5;
	
	/** OnLoad event */ 
	$(function() {
		
		searchapprove();
		
		fRegisterButtonClickEvent();
		
		
	 	  // 반려사유 버튼 선택시 활성&비활성 
	  
		$("#atd_radio_yes").click(function(){
			//alert($("#atd_radio_yes").val());
			$("#rejectshow").hide();
		})
		$("#atd_radio_no").click(function(){
			//alert($("#atd_radio_no").val());
			$("#rejectshow").show();
		})
	
		
	});
	
	/** 버튼 이벤트 등록 */
	  function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();

			var btnId = $(this).attr('id');
		
			switch (btnId) {
			    case 'btnUpdate' :
				fn_update();
				break;
				case 'btnClose' :
					gfCloseModal();
					break;
			}

		});
	
	}
	
	
	  /** 근태관리 목록 조회 **/
	
	 function searchapprove(cpage) {
		
		cpage = cpage || 1;
		
		//검색 조건에서 날짜 검색 시 시작 날짜가 끝 날짜보다 높아도 검색이 안되게 막음.
		if($("#appsdate").val()!= '' && $("#appedate").val() != ''){
			if($("#appsdate").val()>$("#appedate").val()){
			   		alert("날짜 검색조건을 확인하세요");
	            }
		}
		
				// 파라메터,  callback
		var param = {
				appsdate : $("#appsdate").val(),
				appedate : $("#appedate").val(),
				empno : $("#empno").val(),
				empname : $("#empname").val(),
				atdyn : $("#atdyn").val(),	
				pageSize : pageSize,
				cpage : cpage,
		}
		
		var listcallback = function(returndata) {
						
			console.log(returndata);
			
			$("#listTaapprove").empty().append(returndata);
			
			console.log("totcnt: " + $("#counttaApprovelist").val());
			
			var counttaApprovelist = $("#counttaApprovelist").val();
			
			var paginationHtml = getPaginationHtml(cpage, counttaApprovelist, pageSize, pageBlockSize, 'searchapprove');
			
			$("#taApprovePagination").empty().append(paginationHtml);
			
			$("#currentpage").val(cpage);
			
		}
		
		callAjax("/employee/taapprovelist.do", "post", "text", "false", param, listcallback) ;
	}
	
		  //오늘 날짜
    function getToday(){
        var date = new Date();
        var year = date.getFullYear();
        var month = ("0" + (1 + date.getMonth())).slice(-2);
        var day = ("0" + date.getDate()).slice(-2);

        return year + "-" + month + "-" + day;
    }
    
    
    function initpopup(object) {
		 
		$("#deptcd").val(object.deptcd);    
		$("#rest_cd").val(object.rest_cd);
		$("#empnamepop").val(object.empnamepop);
		$("#empnopop").val(object.empnopop); 
		$("#tell").val(object.tell);
		$("#st_date").val(object.st_date);
		$("#ed_date").val(object.ed_date);
		$("#rest_rsn").val(object.rest_rsn);
		$("#app_date").val(object.app_date);
		$("#atd_yn").val(object.atd_yn);
		if(object.reject_rsn == 'null'){	
			$("#reject_rsn").val("");
		} else {
			$("#reject_rsn").val(object.reject_rsn);
		}
		
		console.log(object.atd_yn);
		
		 if(object.atd_yn == "y"){
		 	$("#atd_radio_yes").val(object.atd_yn);
			$("input:radio[name ='atd_radio']:input[value='y']").prop("checked", true);
			$("input:radio[name ='atd_radio']:input[value='y']").prop("disabled", true);
			$("#reject_rsn").attr("disabled","disabled");
			$("#btnUpdate").hide();
	            // 승인: radio 버튼의 value 값이 y이라면 반려사유창 비활성화
	     }else if(object.atd_yn == "n"){
		 	$("#atd_radio_no").val(object.atd_yn);
	        $("input:radio[name ='atd_radio']:input[value='n']").prop("checked", true);
	        $("input:radio[name ='atd_radio']:input[value='n']").prop("disabled", true);
	        $("#reject_rsn").attr("disabled","disabled");
	        $("#btnUpdate").hide();
	        	// 반려: radio 버튼의 value 값이 n이라면 반려사유창 활성화
	     }else {
	    	 $("#btnUpdate").show();
	    	$("#atd_radio").val(object.atd_yn);
	    	console.log($("#atd_radio").val());
			$("input:radio[name ='atd_radio']:input[value='y']").prop("checked", false);
			$("input:radio[name ='atd_radio']").each(function() {
			    $(this).prop('disabled', false);
			});
	        $("input:radio[name ='atd_radio']:input[value='n']").prop("checked", false);
	      //  $("input:radio[name ='atd_radio']:input[value='n']").prop("disabled", false);
	        $("#reject_rsn").removeAttr("disabled");
	     }
		
		 
		 $("#atd_name").val(object.atd_name);
		 $("#action").val("U");
		
		}  
    
    function fn_openpopup() {
		
		initpopup();
		
		gfModalPop("#atdreg");
		
	}
    
    
 	/** 모달창 승인/반려 업데이트 **/
 
	function fn_update() {
		
 		//alert($("#action").val());
 		
		var param = {
				atd_no : $("#atd_no").val(),
				atd_yn : $("input:radio[name ='atd_radio']:checked").val(),
				reject_rsn : $("#reject_rsn").val(),
			 	action : $("#action").val(),
			 	name : $("#userName").val(),
		}
		console.log(param)
		
		var updatecallback = function(returndata) {
						
			console.log(  JSON.stringify(returndata) );
			
			
			if(returndata.result == "SUCCESS") {
				//alert("저장 되었습니다.");
				gfCloseModal();
				searchapprove($("#currentpage").val());
			} 
				
		}
		
		callAjax("/employee/taapproveupdate.do", "post", "json", "false", param, updatecallback) ;
		
	}
    
 	
	 
 	 
 	 /* 근태관리 상세 조회 */
 	 
	  function fn_detailone(atd_no) {
 		 
		  $("#atd_no").val(atd_no)
		 
		  console.log( "여기까지" + atd_no);
		  
				
    	var param = {
    			atd_no : atd_no
    			
    	}
    	
    	var detailonecallback = function(returndata) {
    		
    		console.log(  JSON.stringify(returndata)  );
    		console.log( returndata.detailone.atd_no);
    		
    		initpopup(returndata.detailone);
    		
        	gfModalPop("#atdreg");
        	
    	}
    	
    	callAjax("/employee/detailone.do", "post", "json", "false", param, detailonecallback) ;
    	
    }  
    
	  
</script>

</head>
<body>
<form id="myForm" action=""  method="">
	<input type="hidden" name="action" id="action" value="">
	<input type="hidden" name="loginID" id="loginID" value="${loginID}">
	<input type="hidden" name="userName" id="userName" value="${userNm}">
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
							<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a> <span
								class="btn_nav bold">인사/급여</span> 
								<span class="btn_nav bold">근태 관리</span> 
								<a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>근태 관리</span> 
						</p>
						
						<p class="conTitle">
								 신청일자 
                               <input type="date" id="appsdate" name="appsdate" style="height:20px; width:120px;"/> ~
                               <input type="date" id="appedate" name="appedate"	 style="height:20px; width:120px;"/>						   
							   사번
                               <input type="text" id="empno" name="empno"  onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" style="height:18px; width:100px;"/> &nbsp;&nbsp;&nbsp;&nbsp; 
							   사원명  
                               <input type="text" id="empname" name="empname"  onKeyup="this.value=this.value.replace(/[^a-z|A-Z|ㄱ-ㅎ|가-힣]/g,'');" style="height:18px; width:100px;"/> &nbsp;&nbsp;&nbsp;&nbsp;
							   승인여부
								<select id=atdyn name="atdyn" class="boxx" style="margin-right:6%; width:80px;">
	    							<option value="" selected>전체</option>
	    							<option value="y" >승인</option>
	    							<option value="w" >승인대기</option>
	    							<option value="n" >반려</option>
	  							</select>                    
							   <a	class="btnType blue" href="javascript:searchapprove();" name="modal" ><span>검색</span></a>
							</span>
						</p>
						
						<div class="divComGrpCodList">
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="6%">
									<col width="8%">
									<col width="8%">
									<col width="8%">
									<col width="15%">
									<col width="15%">
									<col width="15%">
									<col width="15%">
									<col width="15%">
									
								</colgroup>
								<thead>
									<tr>
										<th scope="col">번호</th>
										<th scope="col">사번</th>
										<th scope="col">사원명</th>
										<th scope="col">신청구분</th>
										<th scope="col">시작일자</th>
										<th scope="col">종료일자</th>
										<th scope="col">신청일자</th>
										<th scope="col">승인자</th>
										<th scope="col">승인여부</th>
									</tr>
								</thead>
								<tbody id="listTaapprove"></tbody>
							</table>
						</div>
	
						<div class="paging_area"  id=taApprovePagination> </div>
						
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>
	
     <div id="atdreg" class="layerPop layerType2" style="width: 800px; height:800px;"> 
      <dl>
         <dt>
            <strong>근태신청</strong>
         </dt>
         <dd class="content" style=" width: 740px; height: 500px; padding-bottom: 0px;">
         
            <table class="col" style="background-color:rgb(220,225,230);">
               <colgroup>
                  <col width="20%">
                  <col width="30%">
                  <col width="20%">
                  <col width="30%">
               </colgroup>
				<h1 class="center title">휴가 신청서</h1>
				<thead class="middle">
					<tr>
						<th scope="col">근무부서</th>
							<td  scope="col" style="padding:0px; width:200px;">
								<input style="width:200px; height:30px; padding:0px; text-align:center; display:block; margin: 0 auto;" type="text" id="deptcd" name="deptcd" readonly>
							</td>
						<th scope="col">근태종류</th>
						<td scope="col" class="center" style="width:200px; height:30px; padding:0px; text-align:center; display:block; margin: 0 auto;">
							<input style="width:200px; height:30px; padding:0px; text-align:center; display:block; margin: 0 auto;" type="text" id="rest_cd" name="rest_cd" readonly>
					</tr>
					<tr class="left">
						<th scope="col">성명</th>
							<td  scope="col" style="padding:0px; width:200px;">
								<input style="width:200px; height:30px; padding:0px; text-align:center; display:block; margin: 0 auto;" type="text" id="empnamepop" name="empnamepop" readonly>
							</td>
					</tr>
					<tr style="margin-bottom:20px;">
						<th scope="col">사번</th>
							<td  scope="col" style="padding:0px; width:200px;">
								<input style="width:200px; height:30px; padding:0px; text-align:center; display:block; margin: 0 auto;" type="text" id="empnopop" name="empnopop" readonly>
							</td>
					</tr>
					<tr style="margin-bottom:20px;">
						<th scope="col">비상연락처</th>
							<td  scope="col" style="padding:0px; width:200px;">
								<input style="width:200px; height:30px; padding:0px; text-align:center; display:block; margin: 0 auto;" type="text" id="tell" name="tell" readonly>
							</td>
					</tr>
				</thead>
				
            </table>
            
            <table class="col" style="background-color:rgb(220,225,230);">
            <colgroup>
                  <col width="20%">
                  <col width="80%">
               </colgroup>
            	<thead>
            		<tr scope="col">
						<th scope="col">기간</th>
						<td scope="col" >
							<span  style="position: relative;width:100%; height:30px; padding:0px; text-align:center; display:block; margin: 0 auto;">
								<input type="text" id="st_date" name="st_date" class="hei" readonly>~<input type="text" id="ed_date" name="ed_date" class="hei" readonly>
							</span>
						</td>
					</tr>
					<tr scope="col" style="height:100px;">
						<th scope="col">휴가사유</th>
						<td style="" class="center">
							<input type="text" style="height:100px; margin:6px 9.5px 6px 9.5px; width:100%" id=rest_rsn name="rest_rsn" readonly>
						</td>
					</tr>
					<tr>
						<th scope="col"></th>
						<td class="center">
							<span style="font-size:15px; padding-top:10px">상기와 같은 사유로 휴가를 신청합니다.</span>
						</td>
					</tr>
					<tr>
						<th scope="col"></th>
						<td class="center">
							<span style="padding-top:13px; font-size: 13px;">신청일</span>
								<input type="text" style="height:30px; margin:6px 9.5px 6px 9.5px; width:50%" id="app_date" name="app_date" readonly>
						</td>
					</tr>
            	</thead>
            </table>
            
             <table class="col" style="background-color:rgb(220,225,230);">
            <colgroup>
                  <col width="20%">
                  <col width="80%">
               </colgroup>
            	<thead>		
								<tr>
								<th scope="row">승인구분 <span class="font_red">*</span></th>
								<td colspan="3" style="padding-left: 10px; font-size: 13px;">
								<input type="radio" id="atd_radio_yes" name="atd_radio" value="y"> <label for="atdy">승인</label>
								<input type="radio" id="atd_radio_no" name="atd_radio" value="n"> <label for="atdn">반려</label></td>
								</tr>
				 
					<tr scope="col" style="height:100px;" id="rejectshow">
						<th scope="col">반려사유</th>
						<td style="" class="center">
							<input type="text" style="height:100px; margin:6px 9.5px 6px 9.5px; width:100%" name = "reject_rsn" id="reject_rsn">
						</td>
					</tr>
					
            	</thead>
            </table>
            
         </dd>
      </dl>
      
      <a href="" class="closePop"><span class="hidden">닫기</span></a>
      
            <div class="btn_areaC mt20" style="position:absolute; bottom:20px;">
               <a href="" class="btnType blue" id="btnUpdate" name="btn"><span>확인</span></a>
               <a href="" class="btnType blue" id="btnClose" name="btn"><span>닫기</span></a>
            </div>
   </div>
	
</form>
</body>
</html>