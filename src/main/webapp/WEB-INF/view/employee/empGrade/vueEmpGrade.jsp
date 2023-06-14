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
            
            	var vuearea;
            	var hiddenarea;
            	var empGradereg;

                /** OnLoad event */
                $(function () {
                	
                	init();
                	
                	
                    comcombo("dept_cd", "srcdetp", "all", ""); // 콤보박스 부서
                    comcombo("rank_cd", "srcrank", "all", ""); // 콤보박스 직급
                	
                	searchempgrade();
                    vuearea.empDetail = false;  // 상세조회 테이블 숨기기	
                	
                	fRegisterButtonClickEvent();
                    

                });

              // 콤보박스 값 확인
                function chang() {
                    console.log("srcdetp: " + vuearea.srcdetp );
                    console.log("srcrank: " + vuearea.srcrank );
                    console.log("prankCd: " + vuearea.prankCd );
                   
                } 
            	 
            	 
                /** 버튼 이벤트 등록 */
                function fRegisterButtonClickEvent() {
                    $('a[name=btn]').click(function (e) {
                        e.preventDefault();

                        var btnId = $(this).attr('id');

                        switch (btnId) {
	                        case 'btnSearch':
	                           vuearea.btnSearch = '';//검색후 검색한것 초기화 용도
	                           vuearea.btnSearch = 'S';
	                           
	                     	   //$("#btnSearch").val("");
	                     	   //$("#btnSearch").val("S");
	                     	  searchempgrade();
		                            break;
                            case 'btnSave':
                                fn_save();
                                break;
                            case 'btnClose':
                           		gfCloseModal();
                                break;
                        }
                    });
                }//버튼이벤트 끝
                
              //vue init 등록
                function init(){
                	vuearea = new Vue({
                		el : "#wrap_area",
                		
                		data : {
                			pageSize : 5,
                			pageBlockSize : 5,
                			egradelist: [],
                			egradelistcnt : '',
                			empGradePagination : '',
                			detailEmpPagination : '',
                			empDetailshow : '',
                			dpageSize : 5,
                			dpageBlockSize : 5,
                			detailgrade:[],
                			detailcnt:'',
                			action:'',
                			
                			emp_no:'',
                			name:'',
                			deptname:'',
                			rankname:'',
                			
                			srcdetp:'',
                			srcrank:'',
                			srcempno:'',
                			srcsdate:'',
                			srcedate:'',
                			
                			btnSearch:'',
                			

                			
                		},
                		methods : {
                			fn_searchempgrade : function(){
                				searchempgrade();
                			},
                			fun_detailempgrade : function(a,b,c,d,e){
                				fn_detailempgrade(a,b,c,d,e);
                			},
                			fun_openpopup : function(){
                				fn_openpopup();
                			},
                			
                		}
                	});
                	
                	empGradereg = new Vue({
                		el : "#empGradereg",
                		data : {
                			ploginID : '',
                        	prmtn_date : '',
                        	prmtn_name : '',
                        	prankCd : '',
                        	action : '',
                		}
                		
                	});
                	
            		hiddenarea = new Vue({
            			el : "#hiddenarea",
            			data : {
            				empno : '',
            				hname : '',
            				hdeptname : '',
            				hrankname : '',
            				rankId : '',
            				
            				currentpage : '',
            				loginId : '',
            				userNm : '',
            								
            			}
            		});                	
                }//init-end
                
                
                /* 승진내역 목록 */
                function searchempgrade(cpage) {
                	
                	vuearea.empDetail = false; //하단 상세 조회 페이지 안뜨게              

                    cpage = cpage || 1;
                    console.log("cpage 확인 : " + cpage);
                    
                    
                     if(vuearea.btnSearch == 'S'){
                    	console.log("여기");
                    	if(vuearea.srcsdate!= '' && vuearea.srcedate != ''){
        					if(vuearea.srcsdate > vuearea.srcedate){
        						swal("종료일이 시작일 보다 빠를 수 없습니다.");
        						return;
        						}
        					} 
                    	
                    	  var param = {
                                  pageSize: vuearea.pageSize,
                                  cpage: cpage,
                                  
                                  srcdetp: vuearea.srcdetp,
                                  srcrank: vuearea.srcrank,
                                  srcempno: vuearea.srcempno,
                                  srcsdate: vuearea.srcsdate,
                                  srcedate: vuearea.srcedate,               

                              }
                     } else {
                    	 var param = {
                    			 pageSize: vuearea.pageSize,
                                 cpage: cpage,
                             }
                    } 

					
                    var listcallback = function (returndata) {

                        console.log("searchempgrade returndata : " + JSON.stringify(returndata));
                        
                        vuearea.egradelist = returndata.empGradelist;
                        vuearea.egradelistcnt = returndata.countEmpgradelist;
                        console.log(vuearea.egradelistcnt);
                        var paginationHtml = getPaginationHtml(cpage, returndata.countEmpgradelist, vuearea.pageSize, vuearea.pageBlockSize, 'searchempgrade');
               
                        vuearea.empGradePagination = paginationHtml;
                        
                        hiddenarea.currentpage = cpage;

                        //console.log("countEmpgradelist: " + returndata.countEmpgradelist);
                        // console.log("cpage: " + cpage);
                        

                    }

                    callAjax("/employee/vueEmpGradelist.do", "post", "json", "false", param, listcallback);
                }//searchempgrade-end
                
                /* 승진내역 상세조회 번호 받아오기 */
                function fn_detailempgrade(loginId, empno, name, deptname, rankname) {
                	
                	//hidden.rankId = vuearea.rankId;
                	//$("#rankId").val(rank);
                	
                   // console.log($("#"+rankId).html());
                	
                    console.log("vuearea.emp_no : " + vuearea.emp_no);	
                    hiddenarea.loginId = loginId;
                    hiddenarea.empno = empno;
                    hiddenarea.hname = name;
                    hiddenarea.hdeptname = deptname;
                    hiddenarea.hrankname = rankname;
            		
            		vuearea.emp_no = hiddenarea.empno;
            		vuearea.name = hiddenarea.hname;
            		vuearea.deptname = hiddenarea.hdeptname;
            		vuearea.rankname = hiddenarea.hrankname;
            		
            		console.log("loginId : "+loginId + "empno : "+ empno+ "name : "+ name+ "deptname : "+ deptname+ "rankname : "+ rankname);

            		detailempgrade();
            	} 
                
                /* 승진내역 상세조회  */
                function detailempgrade(cpage) {
            		
                	vuearea.empDetailshow = true;
            		
                	cpage = cpage || 1;

            		var param = {
            				pageSize: vuearea.dpageSize,
                            cpage: cpage, 
                            loginId : hiddenarea.loginId,               
                             
                            
            		}
            		 console.log("pageSize: " + vuearea.dpageSize);

            		var listcallback = function(dereturndata) {
            			console.log("asdf");
            			console.log("dereturndata : " + dereturndata);
            			console.log(  JSON.stringify(dereturndata)  );
            			
						vuearea.detailgrade = dereturndata.detailEmp;
						vuearea.detailcnt = dereturndata.countEmpdetail;
            			
            			 var dpaginationHtml = getPaginationHtml(cpage, dereturndata.countEmpdetail, vuearea.dpageSize, vuearea.dpageBlockSize, 'detailempgrade');
            			 vuearea.detailEmpPagination = dpaginationHtml;


                         //$("#currentpage").val(cpage);

                         console.log("detailEmp: " + dereturndata.detailEmp);
                         console.log("countEmpdetail: " + dereturndata.countEmpdetail);
                         console.log("cpage: " + cpage);
                         console.log("dpageSize: " + vuearea.dpageSize);
                         console.log("dpageBlockSize: " + vuearea.dpageBlockSize);
                         console.log("loginID:" + hiddenarea.loginId );
                         hiddenarea.userNm = '${userNm}';
                         console.log("userNm:" + hiddenarea.userNm );
            		};

            		callAjax("/employee/vueDetailEmp.do", "post", "json", "false", param, listcallback);

            	}//detailempgrade-end
            	

                /* 승진내역 등록 팝업 오픈 */
                 function fn_openpopup() {
            		
            		console.log("fn_openpopup() 안");

                    initpopup();
                    

                    gfModalPop("#empGradereg");

                }
            	
             	/** 오늘 날짜 */
             	function getToday() {
             		var date = new Date();
             		var year = date.getFullYear();
             		var month = ("0" + (1 + date.getMonth())).slice(-2);
             		var day = ("0" + date.getDate()).slice(-2);

             		return year + "-" + month + "-" + day;
             	}

                /* 승진내역 등록 팝업  */
                function initpopup(object) {

                
                    //console.log("object: " + object);
                    comcombo("rank_cd", "prankCd", "all", "");
                    
                    if (object === "" || object === null || object === undefined) {
						
                    	console.log("hiddenarea.loginId : " + hiddenarea.loginId);
                    	console.log("hiddenarea.userNm : " + hiddenarea.userNm);
                    	
                    	empGradereg.ploginID = hiddenarea.loginId;                    	
                    	empGradereg.prmtn_date = getToday();
                    	empGradereg.prmtn_name = hiddenarea.userNm;
                    							
                        //empGradereg.action = "I";
                        //$("#action").val("I");
                        
                    }

                }
                
                /* 승진내역 등록 저장  */
                function fn_save() {
					
                      if(!fValidate()) {
                        return;
                    }  
                      
                    var param = {
                    		
                       	ploginID : empGradereg.ploginID,
                      	prmtn_no : empGradereg.prmtnno,
                      	prmtn_name : empGradereg.prmtn_name,
                      	prankCd : empGradereg.prankCd,	
                    		
                    		
                    	//ploginID: $("#ploginID").val(),
                   		//prmtn_no: $("#prmtnno").val(),
                   		//prmtn_name: $("#prmtn_name").val(),
                   		//prankCd: $("#prankCd").val(),
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
                
                
            	
                
            </script>

        </head>

        <body>
            <form id="myForm" action="" method="">
            <div  id="hiddenarea">
                <input type="hidden" name="action" id="action" value="">
                <input type="hidden" name="loginId" id="loginId" " v-model="loginId" >
                <input type="hidden" name="userNm" id="userNm" " v-model="userNm">
                <input type="hidden" name="currentpage" id="currentpage"  v-model="currentpage">
                <input type="hidden" name="empno" id="empno" v-model="empno">
                <input type="hidden" name="hname" id="hname"  v-model="hname">
                <input type="hidden" name="hdeptname" id="hdeptname"  v-model="hdeptname">
                <input type="hidden" name="hrankname" id="hrankname" v-model="hrankname">
                <input type="hidden" name="rankId" id="rankId"v-model="rankId">
			</div>
                <!-- 모달 배경 -->
                <div id="mask"></div>

                <div id="wrap_area">
					<input type="hidden" name="btnSearch" id="btnSearch" v-model="btnSearch">
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
                                           <span>부서</span>&nbsp;<select name="srcdetp" id="srcdetp" v-model= "srcdetp"
                                                style="width: 100px; height:20px;" @change="chang()"></select>
                                            <span>직급</span>&nbsp;<select name="srcrank" id="srcrank" v-model= "srcrank"
                                                style="width: 100px; height:20px;" @change="chang()"></select>
			                            	  사번 &nbsp;
			                               <input type="text" id="srcempno" name="srcempno" v-model="srcempno" 
			                               	oninput="javascript: this.value = this.value.replace(/[^0-9.]/g, '');"	 
			                               	style="width: 100px; height:20px;" />
			                              	 발령일자 &nbsp;
                                            <input type="date" id="srcsdate" name="srcsdate" v-model="srcsdate" style=" height:20px;" /> ~
                              				<input type="date" id="srcedate" name="srcedate" v-model="srcedate" style=" height:20px;" />&nbsp;&nbsp;

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
                                            
                                            <template v-if="egradelistcnt == 0">
	                                            <tbody>
					                                <tr>
														<td colspan="5">데이터가 존재하지 않습니다.</td>
													</tr>
												</tbody>	
                                            </template>
                                            
                                            <template v-else>
	                                            <tbody id="listEmpGrade" v-for= "(list,item) in egradelist ">
				                                    <tr>
														<td>{{list.emp_no}}</td>
														<%-- <td><a href="javascript:fn_detailempgrade('${list.loginID}', '${list.emp_no}', '${list.name}', '${list.deptname}', '${list.rankname}')">${list.name}</a></td> --%>
														<td ><a href="" @click.prevent="fun_detailempgrade(list.loginID, list.emp_no, list.name, list.deptname, list.rankname )">{{list.name}}</a></td>
														<td>{{list.deptname}}</td>
														<td>{{list.rankname}}</td>
														<td>{{list.prmtn_date}}</td>
														
													</tr>
	                                            </tbody>
                                            </template>
                             
                                        </table>
                                    </div>

                                    <div class="paging_area" id="empGradePagination" v-html="empGradePagination"> </div>

                                </div> <!--// content -->
                                
                                
                                
                                <div class="content" id="empDetail" v-show="empDetailshow">

                                    <p class="conTitle">
                                        <span>승진내역 상세조회</span>
                                    </p> 
                                   <p class="">
                                        <span class="fr">
                                           <span>사번</span>&nbsp;<input type="text" id="emp_no" name="emp_no" style="width: 100px; height:20px;" v-model="emp_no" readonly ></input>
                                           <span>사원명</span>&nbsp;<input type="text" id="name" name="name"	 style="width: 100px; height:20px;" v-model="name" readonly  />
                                           <span>부서명</span>&nbsp;<input type="text" id="deptname" name="deptname"	 style="width: 100px; height:20px;" v-model="deptname" readonly />
                                           <span>현재직급</span>&nbsp;<input type="text" id="rankname" name="rankname"	 style="width: 100px; height:20px;" v-model="rankname" readonly />&nbsp;&nbsp;
                                           <a class="btnType blue" @click="javascript:fn_openpopup();"
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
                                            <tbody id="detailEmpGrade" v-for="(list,item) in detailgrade ">
			                                    <tr>
													<td>{{list.prmtn_date}}</td>
													<td>{{list.rankname}}</td>
													<td>{{list.prmtn_name}}</td>		
												</tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <div class="paging_area" id="detailEmpPagination" v-html="detailEmpPagination"> </div>

                                </div> <!--// content -->

                                <h3 class="hidden">풋터 영역</h3>
                                <jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
                            </li>
                        </ul>
                    </div>
                </div>

				<div id="empGradereg" class="layerPop layerType2" style="width: 600px;">
				<input type="hidden" name="loginId" id="loginId" v-model="loginId" >  
				<input type="hidden" name="userNm" id="userNm" v-model="userNm" >  
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
                                        <td colspan="3"><input type="text" class="inputTxt p100" name="ploginID" v-model="ploginID"
                                                id="ploginID" readonly /></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">발령일자 <span class="font_red">*</span></th>
                                        <td colspan="3"><input  type="date" class="inputTxt p100" name="prmtn_date" v-model="prmtn_date"
                                                id="prmtn_date" readonly/></td>
                                    </tr>
                                    <tr> 
                                        <th scope="row">발령내용<span class="font_red">*</span></th>
                                        <td colspan="3">
                                            <select name="prankCd" id="prankCd" style="width: 200px;"
                                                @change="chang()" v-model = "prankCd"></select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">승인자 <span class="font_red">*</span></th>
                                        <td colspan="3"><input type="text" class="inputTxt p100" name="prmtn_name" v-model="prmtn_name"
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