<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
						   
							<c:if test="${counttaApplylist eq 0 }">
								<tr>
									<td colspan="8">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							
							<c:if test="${counttaApplylist > 0 }">
								<c:forEach items="${taApplylist}" var="list">
									<tr>
										<td>${list.atd_no}</td>
										<td>${list.rest_name}</td>										
										<td>${list.st_date}</td>
										<td>${list.ed_date}</td>
										<td>${list.atd_name}</td>
										<td>
											<c:if test="${list.atd_yn == '반려'}">
												<a href="javascript:fn_rest_reject('${list.atd_no}')" >${list.atd_yn}</a>
											</c:if>
											<c:if test="${list.atd_yn != '반려'}">
												${list.atd_yn}
											</c:if>
										</td>
									</tr>
								</c:forEach>
							</c:if>
							
							<input type="hidden" id="counttaApplylist" name="counttaApplylist" value ="${counttaApplylist}"/>