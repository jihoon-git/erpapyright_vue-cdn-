<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
							<c:if test="${cntempOnelist eq 0 }">
								<tr>
									<td colspan="10">데이터가 존재하지 않습니다.</td>
									<c:forEach items="${empOnelist}" var="list">
									<input type="hidden" id="oneeno" name="oneeno" value ="${list.oneeno}"/>
									<input type="hidden" id="onenm" name="onenm" value ="${list.onenm}"/>
									<input type="hidden" id="onedept" name="onedept" value ="${list.onedept}"/>
									<input type="hidden" id="onerank" name="onerank" value ="${list.onerank}"/>
									</c:forEach>
								</tr>
							</c:if>
							
							<c:if test="${cntempOnelist > 0 }">
								<c:forEach items="${empOnelist}" var="list">
									<tr>
										<td>${list.onedate}</td>
										<td><fmt:formatNumber value="${list.oneypay}" type="number"/></td>
										<td><fmt:formatNumber value="${list.onempay}" type="number"/></td>
										<td><fmt:formatNumber value="${list.onenins}" type="number"/></td>
										<td><fmt:formatNumber value="${list.onehins}" type="number"/></td>
										<td><fmt:formatNumber value="${list.oneeins}" type="number"/></td>
										<td><fmt:formatNumber value="${list.oneiins}" type="number"/></td>
										<td><fmt:formatNumber value="${list.onetax}" type="number"/></td>
										<td><fmt:formatNumber value="${list.oneextra}" type="number"/></td>
										<td><fmt:formatNumber value="${list.onerpay}" type="number"/> 원</td>
									</tr>
									<input type="hidden" id="oneeno" name="oneeno" value ="${list.oneeno}"/>
									<input type="hidden" id="onenm" name="onenm" value ="${list.onenm}"/>
									<input type="hidden" id="onedept" name="onedept" value ="${list.onedept}"/>
									<input type="hidden" id="onerank" name="onerank" value ="${list.onerank}"/>
								</c:forEach>
							</c:if>
							
							<input type="hidden" id="cntempOnelist" name="cntempOnelist" value ="${cntempOnelist}"/>