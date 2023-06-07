<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
						   
							<c:if test="${countdeptlist eq 0 }">
								<tr>
									<td colspan="2">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							
							<c:if test="${countdeptlist > 0 }">
								<c:forEach items="${deptlist}" var="list">
									<tr>
										<td><a href="javascript:fn_detaildept('${list.detail_code}' ,1, '${list.detail_name}')">${list.detail_name}</a></td>
										<td>${list.detail_code}</td>
									</tr>
								</c:forEach>
							</c:if>
							
							<input type="hidden" id="countdeptlist" name="countdeptlist" value ="${countdeptlist}"/>