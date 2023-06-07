<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
						   
							<c:if test="${countAcctitlelist eq 0 }">
								<tr>
									<td colspan="5">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							
							<c:if test="${countAcctitlelist > 0 }">
								<c:forEach items="${accTitlelist}" var="list">
									<tr>
										<td>${list.laccount_cd}</td>
										<td>${list.detail_name}</td>
										<td>${list.account_cd}</td>
										<td><a href="javascript:fn_detailacc('${list.account_cd}')">${list.account_name}</a></td>
										<c:if test="${list.account_type eq 'O'}">
											<td>지출</td>
										</c:if>
										<c:if test="${list.account_type eq 'X'}">
											<td>수입</td>
										</c:if>
									</tr>
								</c:forEach>
							</c:if>
							
							<input type="hidden" id="countAcctitlelist" name="countAcctitlelist" value ="${countAcctitlelist}"/>