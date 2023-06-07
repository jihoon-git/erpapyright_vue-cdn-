<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
						   
							<c:if test="${cntestmanagementlist eq 0 }">
								<tr>
									<td colspan="8">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							
							<c:if test="${cntestmanagementlist > 0 }">
								<c:forEach items="${estmanagementlist}" var="list">
									<tr>
										<td><a href="javascript:est_detail('${list.contract_no}')">${list.contract_date}</a></td>
										<td>${list.client_name}</td>
										<td>${list.product_name}</td>
										<td><fmt:formatNumber value="${list.price}" type="number"/></td>
										<td>${list.product_amt} EA</td>
										<td><fmt:formatNumber value="${list.amt_price}" type="number"/></td>
										<td><fmt:formatNumber value="${list.tax}" type="number"/></td>
										<td><fmt:formatNumber value="${list.total_price}" type="number"/> 원</td>
									</tr>
								</c:forEach>
							</c:if>
							
							<input type="hidden" id="cntestmanagementlist" name="cntestmanagementlist" value ="${cntestmanagementlist}"/>