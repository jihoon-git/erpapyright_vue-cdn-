<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
						   
							<c:if test="${countclientlist eq 0 }">
								<tr>
									<td colspan="7">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							
							<c:if test="${countclientlist > 0 }">
								<c:forEach items="${clientlist}" var="list">
									<tr>
										<td>${list.client_no}</td>
										<td>${list.client_name}</td>
										<td>${list.manager_name}</td>
										<td>${list.manager_hp}</td>
										<td>${list.manager_email}</td>
										<td>${list.fax_tel}</td>
										<td><a href="javascript:fn_detailclient('${list.client_no}')" class="btnType gray" id="btnSavefile" name="btn"><span>확인</span></a> </td>
									</tr>
								</c:forEach>
							</c:if>
							
							<input type="hidden" id="countclientlist" name="countclientlist" value ="${countclientlist}"/>