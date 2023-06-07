<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
						   
							<c:if test="${countEmpdetail eq 0 }">
								<tr>
									<td colspan="3">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							
							<c:if test="${countEmpdetail > 0 }">
								<c:forEach items="${detailEmp}" var="list">
									<tr>
										<td>${list.prmtn_date}</td>
										<td>${list.rankname}</td>
										<td>${list.prmtn_name}</td>
										
									</tr>
								</c:forEach>
							</c:if>
							
							<input type="hidden" id="countEmpdetail" name="countEmpdetail" value ="${countEmpdetail}"/>