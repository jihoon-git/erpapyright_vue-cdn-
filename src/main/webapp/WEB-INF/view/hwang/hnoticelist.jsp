<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
						   
							<c:if test="${counthnoticelist eq 0 }">
								<tr>
									<td colspan="4">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							
							<c:if test="${counthnoticelist > 0 }">
								<c:forEach items="${hnoticelist}" var="list">
									<tr>
										<td>${list.notice_no}</td>
										<td>${list.writer}</td>
										<td><a href="javascript:fn_detailone('${list.notice_no}')">${list.notice_title}</a></td>
										<td>${list.notice_date}</td>
									</tr>
								</c:forEach>
							</c:if>
							
							<input type="hidden" id="counthnoticelist" name="counthnoticelist" value ="${counthnoticelist}"/>