<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
						   
							<c:if test="${countEmpgradelist eq 0 }">
								<tr>
									<td colspan="5">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							
							<c:if test="${countEmpgradelist > 0 }">
								<c:forEach items="${empGradelist}" var="list">
									<tr>
										<td>${list.emp_no}</td>
										<td><a href="javascript:fn_detailempgrade('${list.loginID}', '${list.emp_no}', '${list.name}', '${list.deptname}', '${list.rankname}')">${list.name}</a></td>
										<td>${list.deptname}</td>
										<td>${list.rankname}</td>
										<td>${list.prmtn_date}</td>
										
									</tr>
								</c:forEach>
							</c:if>
							
							<input type="hidden" id="countEmpgradelist" name="countEmpgradelist" value ="${countEmpgradelist}"/>