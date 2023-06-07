<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
						   
							<c:if test="${counttaApprovelist eq 0 }">
								<tr>
									<td colspan="9">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							
							<c:if test="${counttaApprovelist > 0 }">
								<c:forEach items="${taapprovelist}" var="list">
									<tr>
										<td>${list.atd_no}</td>	
										<td><a href="javascript:fn_detailone('${list.atd_no}')">${list.empno}</a></td>
										<td>${list.empname}</td>
										<td>${list.rest_cd}</td>										
										<td>${list.st_date}</td>
										<td>${list.ed_date}</td>
										<td>${list.app_date}</td>
										<td>${list.atd_name}</td>  
										<td>${list.atd_yn}</td> 
										
									</tr>
								</c:forEach>
							</c:if>
							
							<input type="hidden" id="counttaApprovelist" name="counttaApprovelist" value ="${counttaApprovelist}"/>