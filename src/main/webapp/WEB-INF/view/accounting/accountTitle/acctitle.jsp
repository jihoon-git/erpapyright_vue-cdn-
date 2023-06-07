<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <title>계정과목관리</title>
            <!-- sweet alert import -->
            <script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
            <jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
            <!-- sweet swal import -->

            <script type="text/javascript">

                // 그룹코드 페이징 설정
                var pageSize = 5;
                var pageBlockSize = 5;




                /** OnLoad event */
                $(function () {
                	
                	// 콤보박스 계정대분류
                    comcombo("laccount_cd", "laccTitle", "all", "");
                	
                	 // 콤보박스 계정세부명
                    detileAccount("", "accTitle", "all", "");

                    searchacctitle();

                    fRegisterButtonClickEvent();

                });

            	 // 콤보박스 값 확인
                function chang() {
                     console.log("accTitle: " +$("#accTitle").val());
                    console.log("mlaccTitle: " + $("#mlaccTitle").val());
                    console.log("accounttype: " +$("#accounttype").val());
                    console.log("account_type: " +$("#account_type").val());
                    //$("#laccTitle_test").val($("#mlaccTitle").val());
                }
            	 
                /** 콤보박스 대분류에 따른 계정세부명 보이기 */
            	 function laccTitleChange(event){
            		 console.log($("#laccTitle").val());
            		 detileAccount($("#laccTitle").val(), "accTitle", "all", "");
            	 }
            	 
            	 
                /** 버튼 이벤트 등록 */
                function fRegisterButtonClickEvent() {
                    $('a[name=btn]').click(function (e) {
                        e.preventDefault();

                        var btnId = $(this).attr('id');

                        switch (btnId) {
                           case 'btnSearch':
                        	   $("#btnSearch").val("");
                        	   $("#btnSearch").val("S");
                        	    searchacctitle();
	                            break;
                            case 'btnSave':
                                fn_save();
                                break;
                            case 'btnDelete':
                                $("#action").val("D");
                                fn_save();
                                break;
                            case 'btnClose':
                            
                                gfCloseModal();
                                break;
                        }
                    });
                }

                /* 계정과목 목록 */
                function searchacctitle(cpage) {

                    cpage = cpage || 1;
                   // $("#currentpage").val(cpage);
                   
                   if($("#btnSearch").val() == "S"){
                	   var param = {
                               pageSize: pageSize,
                               cpage: cpage,
                               laccTitle: $("#laccTitle").val(),
                               accTitle: $("#accTitle").val(),
                               accounttype: $("#accounttype").val(),

                           };
                	   
                   } else {
                	   var param = {
                               pageSize: pageSize,
                               cpage: cpage,
                               

                           };
                   }

                    /* var param = {
                        pageSize: pageSize,
                        cpage: cpage,
                        laccTitle: $("#laccTitle").val(),
                        accTitle: $("#accTitle").val(),
                        accounttype: $("#accounttype").val(),

                    } */


                    var listcallback = function (returndata) {

                        console.log("searchacctitle returndata : " + returndata);

                        $("#listAcctitle").empty().append(returndata);

                        var countAcctitlelist = $("#countAcctitlelist").val();

                        var paginationHtml = getPaginationHtml(cpage, countAcctitlelist, pageSize, pageBlockSize, 'searchacctitle');

                        $("#acctitlePagination").empty().append(paginationHtml);

                        $("#currentpage").val(cpage);
                        

                        console.log("countAcctitlelist: " + countAcctitlelist);
                        console.log("cpage: " + cpage);

                    }

                    callAjax("/accounting/acctitlelist.do", "post", "text", "false", param, listcallback);
                }

                
                /* 계정과목 팝업 오픈 */
                function fn_openpopup() {

                    initpopup();

                    gfModalPop("#acctitlereg");

                }
                

                /* 계정과목 등록||수정 팝업  */
                function initpopup(object) {

                    console.log("object: " + object);
                    comcombo("laccount_cd", "mlaccTitle", "all", "");

                    if (object == "" || object == null || object == undefined) {
                        $("#laccount_name").val("");
                        $("#account_cd").val("");
                        $("#account_name").val("");
                        $("#account_type").val("");

                        $("#claccTitle").show();
                        $("#tlaccTitle").hide();
                        $("#btnDelete").hide();
                        $("#accnt_cd_test").show();
                        $("#accnt_cd_test2").hide();
                        $("#action").val("I");
                    } else {
                        $("#mlaccTitle2").val(object.detail_name);
                        $("#account_cd2").val(object.account_cd);
                        $("#account_cd").val(object.account_cd);
                        $("#account_name").val(object.account_name);
                        $("#account_type").val(object.account_type);
                       console.log("ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ");
                        console.log($("#laccTitle_test").val());
                        console.log($("#mlaccTitle").val());
                        
                        $("#accnt_cd_test").hide();
                        $("#accnt_cd_test2").show();
                        $("#tlaccTitle").show();
                        $("#claccTitle").hide();
                        $("#btnDelete").show();

                        $("#action").val("U");

                    }

                }

                /* 계정과목 상세조회  */
                function fn_detailacc(account_cd) {

                    var param = {
                        account_cd: account_cd
                    }

                    var detailacccallback = function (returndata) {
                     	
                    	$("#laccTitle_test").val(returndata.detailacc.laccount_cd);
                         
                        console.log($("#laccTitle_test").val());
                    	
                        initpopup(returndata.detailacc);
						
                        gfModalPop("#acctitlereg");
                        
                        console.log(returndata);
                        
                       


                    }

                    callAjax("/accounting/detailacc.do", "post", "json", "false", param, detailacccallback);
                }
                

                /* 계정과목 등록 저장  */
                function fn_save() {

                     if(!fValidate()) {
                        return;
                    } 

                    var param = {
                    	mlaccTitle: $("#laccTitle_test").val(),
                        account_cd: $("#account_cd").val(),
                        account_name: $("#account_name").val(),
                        account_type: $("#account_type").val(),
                        action: $("#action").val(),
                    }
					console.log(param);
                     var savecallback = function (returndata) {

                        console.log(JSON.stringify(returndata));

                        if(returndata.result == "FAILCD") {
            				swal("계정과목코드가 중복 되었습니다. \n 확인 후 다시 입력해주세요. ");
            			} else if (returndata.result == "FAILNM" ){
            				swal("계정코드명이 중복 되었습니다. \n 확인 후 다시 입력해주세요.");
            			}

                        if (returndata.result == "SUCCESS") {
                            alert("저장 되었습니다.");
                            gfCloseModal();

                            if ($("#action").val() == "U") {
                                searchacctitle($("#currentpage").val());
                            } else {
                                searchacctitle();
                            }

                        }
                    }

                    callAjax("/accounting/accTitlesave.do", "post", "json", "false", param, savecallback);
 
                }
                
                /* Validate */
                function fValidate() {
                	
            		var chk = checkNotEmpty(
            				[
            						
            						[ "account_cd", "계정과목코드를 입력해 주세요" ]
            					,	[ "account_name", "계정과목명을 입력해 주세요" ]
            					,	[ "account_type", "입출구분을 확인해 주세요" ]
            				]
            		);

            		if (!chk) {
            			return;
            		}

            		return true;
            	}



            </script>

        </head>

        <body>
            <form id="myForm" action="" method="">
                <input type="hidden" name="action" id="action" value="">
                <input type="hidden" name="loginId" id="loginId" value="${loginId}">
                <input type="hidden" name="userNm" id="userNm" value="${userNm}">
                <input type="hidden" name="currentpage" id="currentpage" value="">
                <input type="hidden" name="cpage" id="cpage" value="">
                <input type="hidden" name="laccTitle_test" id="laccTitle_test" value="">
                

                <!-- 모달 배경 -->
                <div id="mask"></div>

                <div id="wrap_area">

                    <h2 class="hidden">header 영역</h2>
                    <jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

                    <h2 class="hidden">컨텐츠 영역</h2>
                    <div id="container">
                        <ul>
                            <li class="lnb">
                                <!-- lnb 영역 -->
                                <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> <!--// lnb 영역 -->
                            </li>
                            <li class="contents">
                                <!-- contents -->
                                <h3 class="hidden">contents 영역</h3> <!-- content -->
                                <div class="content">

                                    <p class="Location">
                                        <a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a>
                                        <span class="btn_nav bold">회계</span>
                                        <span class="btn_nav bold">계정과목 관리</span>
                                        <a href="../accounting/acctitle.do" class="btn_set refresh">새로고침</a>
                                    </p>

                                    <p class="conTitle">
                                        <span>계정과목 관리</span> <span class="fr">
                                            <span>계정대분류</span><select name="laccTitle" id="laccTitle"
                                                style="width: 150px;" onchange="laccTitleChange()"></select>
                                            <span>계정세부명</span><select name="accTitle" id="accTitle"
                                                style="width: 150px;" onchange="chang()"></select>
                                            <span>구분</span><select name="accounttype" id="accounttype"
                                                style="width: 150px;" onchange="chang()">
                                                <option value="">전체</option>
                                                <option value="X">수입</option>
                                                <option value="O">지출</option>
                                            </select>

                                            <a class="btnType blue"  id="btnSearch"
                                                name="btn"><span>검색</span></a>
                                            <a class="btnType blue" href="javascript:fn_openpopup();"
                                                name="modal"><span>신규등록</span></a>

                                        </span>
                                    </p>

                                    <div class="divComGrpCodList">
                                        <table class="col">
                                            <caption>caption</caption>
                                            <colgroup>
                                                <col width="15%">
                                                <col width="20%">
                                                <col width="15%">
                                                <col width="40%">
                                                <col width="10%">
                                            </colgroup>
                                            <thead>
                                                <tr>
                                                    <th scope="col">계정대분류코드</th>
                                                    <th scope="col">계정대분류명</th>
                                                    <th scope="col">계정과목코드</th>
                                                    <th scope="col">계정과목명</th>
                                                    <th scope="col">입출구분</th>
                                                </tr>
                                            </thead>
                                            <tbody id="listAcctitle"></tbody>
                                        </table>
                                    </div>

                                    <div class="paging_area" id="acctitlePagination"> </div>

                                </div> <!--// content -->

                                <h3 class="hidden">풋터 영역</h3>
                                <jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
                            </li>
                        </ul>
                    </div>
                </div>

                <div id="acctitlereg" class="layerPop layerType2" style="width: 600px;">
                    <dl>
                        <dt>
                            <strong>계정과목 등록/수정</strong>
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
                                    <tr id="claccTitle"> <!-- insert 할때 -->
                                        <th scope="row">계정대분류명<span class="font_red">*</span></th>
                                        <td colspan="3">
                                            <select name="mlaccTitle" id="mlaccTitle" style="width: 200px;"
                                                onchange="chang()"></select>
                                        </td>
                                    </tr>
                                    <tr id="tlaccTitle"> <!-- update 할때 -->
                                        <th scope="row">계정대분류명<span class="font_red">*</span></th>
                                        <td colspan="3"><input type="text" class="inputTxt p100" name="mlaccTitle2"
                                                id="mlaccTitle2" readonly/></td>
                                    </tr>
                                    <tr id="accnt_cd_test">
                                        <th scope="row">계정과목코드<span class="font_red">*</span></th>
                                        <td colspan="3"><input type="text" class="inputTxt p100" name="account_cd"
                                                id="account_cd" /></td>
                                    </tr>
                                    <tr id="accnt_cd_test2">
                                        <th scope="row">계정과목코드<span class="font_red">*</span></th>
                                        <td colspan="3"><input type="text" class="inputTxt p100" name="account_cd"
                                                id="account_cd2" readonly /></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">계정과목명 <span class="font_red">*</span></th>
                                        <td colspan="3"><input type="text" class="inputTxt p100" name="account_name"
                                                id="account_name" /></td>
                                    </tr>
                                    <tr>

                                        <th scope="row">입출구분 <span class="font_red">*</span></th>
                                        <td colspan="3">
                                            <select name="account_type" id="account_type" style="width: 150px;"
                                                onchange="chang()">
                                                <option value="">선택</option>
                                                <option value="X">수입</option>
                                                <option value="O">지출</option>
                                            </select>

                                        </td>
                                    </tr>

                                </tbody>
                            </table>

                            <!-- e : 여기에 내용입력 -->

                            <div class="btn_areaC mt30">
                                <a href="" class="btnType blue" id="btnSave" name="btn"><span>저장</span></a>
                                <a href="" class="btnType blue" id="btnDelete" name="btn"><span>삭제</span></a>
                                <a href="" class="btnType gray" id="btnClose" name="btn"><span>취소</span></a>
                            </div>
                        </dd>
                    </dl>
                    <a href="" class="closePop"><span class="hidden">닫기</span></a>


                </div>

            </form>
        </body>

        </html>