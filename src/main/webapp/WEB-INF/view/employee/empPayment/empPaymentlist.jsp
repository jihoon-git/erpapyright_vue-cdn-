<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

						   
							<c:if test="${cntempPaylist eq 0 }">
								<tr>
									<td colspan="15">데이터가 존재하지 않습니다.</td>
									
								</tr>
							</c:if>
							
							<c:if test="${cntempPaylist > 0 }">
								<c:forEach items="${empPaylist}" var="list">
									<tr>
										<td>${list.pay_date}</td>
										<td>${list.dept}</td>
										<td>${list.rank}</td>
										<td>${list.emp_no}</td>
										<td>
										<a href="javascript:fn_oneemp('${list.sloginID}')">${list.name}</a>
										</td>
										<td><fmt:formatNumber value="${list.year_pay}" type="number"/></td>
										<td><fmt:formatNumber value="${list.month_pay}" type="number"/></td>
										<td><fmt:formatNumber value="${list.ins_n}" type="number"/></td>
										<td><fmt:formatNumber value="${list.ins_h}" type="number"/></td>
										<td><fmt:formatNumber value="${list.ins_i}" type="number"/></td>
										<td><fmt:formatNumber value="${list.ins_e}" type="number"/></td>
										<td><fmt:formatNumber value="${list.tax}" type="number"/></td>
										<td><fmt:formatNumber value="${list.extra}" type="number"/></td>
										<td><fmt:formatNumber value="${list.total}" type="number"/> 원</td>
										<c:choose>
											<c:when test="${list.pay_yn eq 'y'}">
												<td>지급완료</td>
											</c:when>
											<c:otherwise>
												<td>
													<a style="color: red; font-weight: bold;" href="javascript:fn_loginsave('${list.sloginID}','${list.salary_no}','${list.exp_no}');"><span>지급대기</span></a>
												</td>
											</c:otherwise>
										</c:choose>
										
									</tr>
								</c:forEach>
							</c:if>
							<input type="hidden" id="yncheck" name="yncheck" value ="${checkyn}"/>
							<input type="hidden" id="cntempPaylist" name="cntempPaylist" value ="${cntempPaylist}"/>