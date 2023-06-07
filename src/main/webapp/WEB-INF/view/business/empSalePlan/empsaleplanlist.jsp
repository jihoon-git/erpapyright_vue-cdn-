<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
 							<c:if test="${countempsaleplan eq 0 }">
								<tr>
									<td colspan=8>데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							<c:if test="${countempsaleplan > 0 }">
								<c:forEach items="${empsaleplanlist}" var="list">
									<tr>
										<td>${list.plan_date}</td>
										<td>${list.client_name}</td>
										<td>${list.mcname}</td>
										<td>${list.pdname}</td>
										<td>${list.product_name}</td>
										<td>${list.goal_amt}</td>
										<td>${list.now_amt}</td>
										<td></td>
									</tr>
								</c:forEach>
							<</c:if>
							<input type="hidden" id="countempsaleplan" name="countempsaleplan" value ="${countempsaleplan}"/>