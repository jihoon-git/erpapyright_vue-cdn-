<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <title>승진내역 관리</title>
            <!-- sweet alert import -->
            <script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
            <jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
            <!-- sweet swal import -->

            <script type="text/javascript">

                // 그룹코드 페이징 설정
                var pageSize = 5;
                var pageBlockSize = 5;
                
                var dpageSize = 5;
                var dpageBlockSize = 5;




                /** OnLoad event */
                $(function () {
                	
                	
                    comcombo("dept_cd", "srcdetp", "all", ""); // 콤보박스 부서
                    comcombo("rank_cd", "srcrank", "all", ""); // 콤보박스 직급
                	
                	searchempgrade();

                	$("#empDetail").hide();	// 상세조회 테이블 숨기기
                	
                	fRegisterButtonClickEvent();
                    

                });

             	// 콤보박스 값 확인
                function chang() {
                    console.log("srcdetp: " +$("#srcdetp").val());
                    console.log("srcrank: " +$("#srcrank").val());
                    console.log("prankCd: " +$("#prankCd").val());
                   
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
	                     	  searchempgrade();
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

                /* 승진내역 목록 */
                function searchempgrade(cpage) {
                	
                	$("#empDetail").hide();

                    cpage = cpage || 1;
                    
                    if($("#btnSearch").val() == "S"){
                    	
                    	if($("#srcsdate").val()!= '' && $("#srcedate").val() != ''){
        					if($("#srcsdate").val()>$("#srcedate").val()){
        						swal("종료일이 시작일 보다 빠를 수 없습니다.");
        						return;
        						}
        					}
                    	
                    	  var param = {
                                  pageSize: pageSize,
                                  cpage: cpage,
                                  srcdetp: $("#srcdetp").val(),
                                  srcrank: $("#srcrank").val(),
                                  srcempno: $("#srcempno").val(),
                                  srcsdate : $("#srcsdate").val(),
                  				srcedate : $("#srcedate").val(),
                                  

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
                        srcdetp: $("#srcdetp").val(),
                        srcrank: $("#srcrank").val(),
                        srcempno: $("#srcempno").val(),
                        srcsdate : $("#srcsdate").val(),
        				srcedate : $("#srcedate").val(),
                        

                    } */
					
                    var listcallback = function (returndata) {

                        console.log("searchempgrade returndata : " + returndata);

                        $("#listEmpGrade").empty().append(returndata);

                        var countEmpgradelist = $("#countEmpgradelist").val();

                        var paginationHtml = getPaginationHtml(cpage, countEmpgradelist, pageSize, pageBlockSize, 'searchempgrade');

                        $("#empGradePagination").empty().append(paginationHtml);

                        $("#currentpage").val(cpage);

                        console.log("countEmpgradelist: " + countEmpgradelist);
                        console.log("cpage: " + cpage);

                    }

                    callAjax("/employee/empGradelist.do", "post", "text", "false", param, listcallback);
                }
                
                /* 승진내역 상세조회 번호 받아오기 */
                function fn_detailempgrade(loginId, empno, name, deptname, rankname, rank) {
					
                	//alert(rank);
                	
                	
                	$("#rankId").val(rank);
                	
                   // console.log($("#"+rankId).html());
                	
                	
            		$("#loginId").val(loginId);
            		$("#empno").val(empno);
            		$("#hname").val(name);
            		$("#hdeptname").val(deptname);
            		$("#hrankname").val(rankname);
            		console.log("loginId : "+loginId + "empno : "+ empno+ "name : "+ name+ "deptname : "+ deptname+ "rankname : "+ rankname);

            		detailempgrade();
            	}

                /* 승진내역 상세조회  */
                function detailempgrade(cpage) {
            		
                	$("#empDetail").show();
            		
                	cpage = cpage || 1;

            		var param = {
            				pageSize: dpageSize,
                            cpage: cpage,
                            loginId : $("#loginId").val()
            		}
            		 console.log("pageSize: " + pageSize);

            		var listcallback = function(dereturndata) {
            			console.log("dereturndata : " + dereturndata);
            			console.log(  JSON.stringify(dereturndata)  );

            			$("#detailEmpGrade").empty().append(dereturndata);

            			var countEmpdetail = $("#countEmpdetail").val();
            			
            			 var paginationHtml = getPaginationHtml(cpage, countEmpdetail, dpageSize, dpageBlockSize, 'detailempgrade');

                         $("#detailEmpPagination").empty().append(paginationHtml);

                         $("#currentpage").val(cpage);

                         console.log("countEmpdetail: " + countEmpdetail);
                         console.log("cpage: " + cpage);
                         console.log("dpageSize: " + dpageSize);
                         console.log("dpageBlockSize: " + dpageBlockSize);
                         
                         $("#emp_no").val($("#empno").val());
                         $("#name").val($("#hname").val());
                         $("#deptname").val($("#hdeptname").val());
                         $("#rankname").val($("#hrankname").val());
                         console.log("emp_no: " + $("#empno").val()); 

            			

            		};

            		callAjax("/employee/detailEmp.do", "post", "text", "false", param, listcallback);

            	}
               
                /* 승진내역 등록 팝업 오픈 */
                function fn_openpopup() {

                    initpopup();
                    

                    gfModalPop("#empGradereg");

                }

                /* 승진내역 등록 팝업  */
                function initpopup(object) {
					
                
                	
                    console.log("object: " + object);
                    comcombo("rank_cd", "prankCd", "all", "");
                    if (object == "" || object == null || object == undefined) {
                        $("#ploginID").val($("#loginId").val());
                        $("#prmtn_date").val(getToday());
                        $("#prmtn_name").val($("#userNm").val());
						
                        //$("#action").val("I");
                    } 

                }
                
                /* 승진내역 등록 저장  */
                function fn_save() {
					
                      if(!fValidate()) {
                        return;
                    }  
                      
                    var param = {
                    	ploginID: $("#ploginID").val(),
                   		prmtn_no: $("#prmtnno").val(),
                   		prmtn_name: $("#prmtn_name").val(),
                   		prankCd: $("#prankCd").val(),
                        //action: $("#action").val(),
                    }
					console.log(param);
                     var savecallback = function (returndata) {

                        console.log(JSON.stringify(returndata));

                        if (returndata.result == "SUCCESS") {
                            alert("저장 되었습니다.");
                            gfCloseModal();

                           /*  if ($("#action").val() == "U") {
                            	detailempgrade($("#currentpage").val());
                            } else {
                            	detailempgrade();
                            } */
                            
                        	/* var rankId = $("#rankId").val();
                        	[value=$("#prankCd").val()]
                        	console.log($($("#prankCd").val()).html());

                        	console.log($("#prankCd").val().html());
                            
                            $("#"+rankId).html(); */
                            
                            location.reload();
                           
                            //$("#content2").load(location.href + " #content2");
                        }
                    }

                    callAjax("/employee/empGradesave.do", "post", "json", "false", param, savecallback);
 
                }
                
                /* Validate */
                function fValidate() {
                	
            		var chk = checkNotEmpty(
            				[
            						[ "prmtn_date", "발령일자를 입력해 주세요" ]
            					,	[ "prankCd", "발령내용을 확인해 주세요" ]
            				]
            		);

            		if (!chk) {
            			return;
            		}

            		return true;
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
                <input type="hidden" name="currentpage" id="currentpage" value="">
                <input type="hidden" name="empno" id="empno" value="">
                <input type="hidden" name="hname" id="hname" value="">
                <input type="hidden" name="hdeptname" id="hdeptname" value="">
                <input type="hidden" name="hrankname" id="hrankname" value="">
                <input type="hidden" name="hrankname" id="hrankname" value="">
                <input type="hidden" name="rankId" id="rankId" value="">

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
                                <div class="content2">

                                    <p class="Location">
                                        <a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a>
                                        <span class="btn_nav bold">인사·급여</span>
                                        <span class="btn_nav bold">승진내역 관리</span>
                                        <a href="../employee/empGrade.do" class="btn_set refresh">새로고침</a>
                                    </p>

                                    <p class="conTitle">
                                        <span>승진내역 조회</span>
                                    </p> 
                                   <p class="">
                                        <span class="fr">
                                           <span>부서</span>&nbsp;<select name="srcdetp" id="srcdetp"
                                                style="width: 100px; height:20px;" onchange="chang()"></select>
                                            <span>직급</span>&nbsp;<select name="srcrank" id="srcrank"
                                                style="width: 100px; height:20px;" onchange="chang()"></select>
			                            	  사번 &nbsp;
			                               <input type="text" id="srcempno" name="srcempno" oninput="this.value = this.value.replace(/[^0-9.]/g, '');"	 style="width: 100px; height:20px;" />
			                              	 발령일자 &nbsp;
                                            <input type="date" id="srcsdate" name="srcsdate" style=" height:20px;" /> ~
                              				<input type="date" id="srcedate" name="srcedate" style=" height:20px;" />&nbsp;&nbsp;

                                            <a class="btnType blue"  id="btnSearch"
                                                name="btn"><span>검색</span></a>
                                            

                                        </span>
                                    </p><br><br>

                                    <div class="divComGrpCodList">
                                        <table class="col">
                                            <caption>caption</caption>
                                            <colgroup>
                                                <col width="15%">
                                                <col width="15%">
                                                <col width="25%">
                                                <col width="25%">
                                                <col width="20%">
                                            </colgroup>
                                            <thead>
                                                <tr>
                                                    <th scope="col">사번</th>
                                                    <th scope="col">사원명</th>
                                                    <th scope="col">부서명</th>
                                                    <th scope="col">직급</th>
                                                    <th scope="col">발령일자</th>
                                                </tr>
                                            </thead>
                                            <tbody id="listEmpGrade"></tbody>
                                        </table>
                                    </div>

                                    <div class="paging_area" id="empGradePagination"> </div>

                                </div> <!--// content -->
                                
                                
                                
                                <div class="content" id="empDetail">

                                    <p class="conTitle">
                                        <span>승진내역 상세조회</span>
                                    </p> 
                                   <p class="">
                                        <span class="fr">
                                           <span>사번</span>&nbsp;<input type="text" id="emp_no" name="emp_no" style="width: 100px; height:20px;" readonly ></input>
                                           <span>사원명</span>&nbsp;<input type="text" id="name" name="name"	 style="width: 100px; height:20px;"  readonly  />
                                           <span>부서명</span>&nbsp;<input type="text" id="deptname" name="deptname"	 style="width: 100px; height:20px;" readonly />
                                           <span>현재직급</span>&nbsp;<input type="text" id="rankname" name="rankname"	 style="width: 100px; height:20px;" readonly />&nbsp;&nbsp;
                                           <a class="btnType blue" href="javascript:fn_openpopup();"
                                                name="modal"><span>신규등록</span></a>                                           

                                        </span>
                                    </p><br><br>

                                    <div class="divComGrpCodList">
                                        <table class="col">
                                            <caption>caption</caption>
                                            <colgroup>
                                                <col width="40%">
                                                <col width="30%">
                                                <col width="30%">
                                                
                                            </colgroup>
                                            <thead>
                                                <tr>
                                                    <th scope="col">발령일자</th>
                                                    <th scope="col">발령내용</th>
                                                    <th scope="col">승인자</th>
                                                </tr>
                                            </thead>
                                            <tbody id="detailEmpGrade"></tbody>
                                        </table>
                                    </div>

                                    <div class="paging_area" id="detailEmpPagination"> </div>

                                </div> <!--// content -->

                                <h3 class="hidden">풋터 영역</h3>
                                <jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
                            </li>
                        </ul>
                    </div>
                </div>

				<div id="empGradereg" class="layerPop layerType2" style="width: 600px;">
                    <dl>
                        <dt>
                            <strong>승진내역 등록</strong>
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
                                        <th scope="row">아이디<span class="font_red">*</span></th>
                                        <td colspan="3"><input type="text" class="inputTxt p100" name="ploginID"
                                                id="ploginID" readonly /></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">발령일자 <span class="font_red">*</span></th>
                                        <td colspan="3"><input  type="date" class="inputTxt p100" name="prmtn_date"
                                                id="prmtn_date" readonly/></td>
                                    </tr>
                                    <tr> 
                                        <th scope="row">발령내용<span class="font_red">*</span></th>
                                        <td colspan="3">
                                            <select name="prankCd" id="prankCd" style="width: 200px;"
                                                onchange="chang()"></select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">승인자 <span class="font_red">*</span></th>
                                        <td colspan="3"><input type="text" class="inputTxt p100" name="prmtn_name"
                                                id="prmtn_name" readonly /></td>
                                    </tr>
                                    

                                </tbody>
                            </table>

                            <!-- e : 여기에 내용입력 -->

                            <div class="btn_areaC mt30">
                                <a href="" class="btnType blue" id="btnSave" name="btn"><span>저장</span></a>
                                <a href="" class="btnType gray" id="btnClose" name="btn"><span>취소</span></a>
                            </div>
                        </dd>
                    </dl>
                    <a href="" class="closePop"><span class="hidden">닫기</span></a>


                </div>
                

            </form>
        </body>

        </html>