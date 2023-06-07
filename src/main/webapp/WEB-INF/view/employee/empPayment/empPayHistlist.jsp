<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
							<c:if test="${cntempHislist eq 0 }">
								<tr>
									<td colspan="10">데이터가 존재하지 않습니다.</td>
									<c:forEach items="${empHislist}" var="list">
									<input type="hidden" id="hiseno" name="hiseno" value ="${list.myEno}"/>
									<input type="hidden" id="hisnm" name="hisnm" value ="${list.myNm}"/>
									<input type="hidden" id="hisdept" name="hisdept" value ="${list.myDept}"/>
									<input type="hidden" id="hisrank" name="hisrank" value ="${list.myRank}"/>
									</c:forEach>
								</tr>
							</c:if>
							
							<c:if test="${cntempHislist > 0 }">
								<c:forEach items="${empHislist}" var="list">
									<tr>
										<td>
										<a href="javascript:hisdetail('${list.myDate}')">${list.myDate}</a>
										</td>
										<td><fmt:formatNumber value="${list.myYpay}" type="number"/></td>
										<td><fmt:formatNumber value="${list.myMpay}" type="number"/></td>
										<td><fmt:formatNumber value="${list.myNins}" type="number"/></td>
										<td><fmt:formatNumber value="${list.myHins}" type="number"/></td>
										<td><fmt:formatNumber value="${list.myIins}" type="number"/></td>
										<td><fmt:formatNumber value="${list.myEins}" type="number"/></td>
										<td><fmt:formatNumber value="${list.myTax}" type="number"/></td>
										<td><fmt:formatNumber value="${list.myExtra}" type="number"/></td>
										<td><fmt:formatNumber value="${list.myRpay}" type="number"/> 원</td>
									</tr>
									<input type="hidden" id="hiseno" name="hiseno" value ="${list.myEno}"/>
									<input type="hidden" id="hisnm" name="hisnm" value ="${list.myNm}"/>
									<input type="hidden" id="hisdept" name="hisdept" value ="${list.myDept}"/>
									<input type="hidden" id="hisrank" name="hisrank" value ="${list.myRank}"/>
								</c:forEach>
							</c:if>
							
							<input type="hidden" id="cntempHislist" name="cntempHislist" value ="${cntempHislist}"/>