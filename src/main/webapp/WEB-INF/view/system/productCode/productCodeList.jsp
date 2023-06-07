<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
						   
							<c:if test="${countproductlist eq 0 }">
								<tr>
									<td colspan="4">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							
							<c:if test="${countproductlist > 0 }">
								<c:forEach items="${productCodelist}" var="list">
									<tr>
										<td><a href="javascript:fn_detailone('${list.detail_code}')">${list.detail_name}</a></td>										
										<td>${list.detail_code}</td>
									</tr>
								</c:forEach>
							</c:if>
							
							<input type="hidden" id="countproductlist" name="countproductlist" value ="${countproductlist}"/>