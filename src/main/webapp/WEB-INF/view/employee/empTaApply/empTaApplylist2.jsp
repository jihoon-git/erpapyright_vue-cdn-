<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
						   
							
								<c:forEach items="${total_rest}" var="list">
									<tr>
										<td>${list.total_rest}</td>
										<td>${list.use_rest}</td>										
										<td>${list.remain_rest}</td>
									</tr>
								</c:forEach>
							
							
							