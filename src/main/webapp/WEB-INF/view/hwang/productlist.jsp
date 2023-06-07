<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
						   
							<c:if test="${countproductlist eq 0 }">
								<tr>
									<td colspan="6">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							
							<c:if test="${countproductlist > 0 }">
								<c:forEach items="${productlist}" var="list">
									<tr>
										<td>${list.product_no}</td>
										<td>${list.lcategory_name}</td>
										<td>${list.company}</td>
										<td>${list.product_name}</td>
										<td>${list.price}</td>
										<td>${list.stock}</td>
										<td></td>
									</tr>
								</c:forEach>
							</c:if>
							
							<input type="hidden" id="countproductlist" name="countproductlist" value ="${countproductlist}"/>