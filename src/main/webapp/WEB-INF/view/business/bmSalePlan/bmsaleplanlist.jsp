<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
						<c:if test="${userType eq 'B' || userType eq 'A'}">
							<c:if test="${countbmsaleplan eq 0 }">
								<tr>
									<td colspan="10">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							
							<c:if test="${countbmsaleplan > 0 }">
								<c:forEach items="${bmsaleplanlist}" var="list">
									<tr>
										<td>${list.emp_no}</td>
										<td>${list.name}</td>
										<td>${list.client_name}</td>
										<td>${list.plan_date}</td>
										<td>${list.product_no}</td>
										<td>${list.product_name}</td>
										<td>${list.goal_amt}</td>
										<td>${list.now_amt}</td>
										<td>${list.acvm_rate}</td>
										<td>											
										</td>
									</tr>
								</c:forEach>
							</c:if>
						</c:if>
						<c:if test="${userType eq 'D' }">
							<c:if test="${countbmsaleplan eq 0 }">
								<tr>
									<td colspan=8>데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							
							<c:if test="${countbmsaleplan > 0 }">
								<c:forEach items="${bmsaleplanlist}" var="list">
									<tr>
										<td>${list.plan_date}</td>
										<td>${list.client_name}</td>
										<td>${list.product_no}</td>
										<td>${list.product_name}</td>
										<td>${list.goal_amt}</td>
										<td>${list.now_amt}</td>
										<td>${list.acvm_rate}</td>
										<td>											
										</td>
									</tr>
								</c:forEach>
							</c:if>
						</c:if>
							<input type="hidden" id="countbmsaleplan" name="countbmsaleplan" value ="${countbmsaleplan}"/>