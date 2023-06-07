<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
							<c:if test="${totalCnt eq 0 }">
								<tr>
									<td colspan="9">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							<c:if test="${totalCnt > 0}">
								<c:forEach items="${accSlipFList}" var="list" varStatus="status">
									<tr>
										<c:if test="${list.account_no ne 0 and !empty list.order_cd and list.exp_no eq 0 }">
											<td>${status.index+1}</td>
											<td>${list.account_no}</td>
											<td>${list.contContract_date}</td>
											<td><a href="javascript:contractDetaile('${list.order_cd}');">${list.order_cd}</a></td>
											<td>${list.contAccount_cd}</td>
											<td>${list.contAccount_name}</td>
											<td>${list.contUserName}</td>
											<td>${list.contClient_name}</td>
											<td style="color: blue; font-weight: bold;">${list.contTotal_price}원</td>
										</c:if>
										<c:if test="${list.account_no ne 0 and empty list.order_cd and list.exp_no ne 0 }">
											<td>${status.index+1}</td>
											<td>${list.account_no}</td>
											<td>${list.expYn_date}</td>
											<td><a href="javascript:expDetaile('${list.exp_no}');" >${list.exp_no}</a></td>
											<td>${list.exptAccount_cd}</td>
											<td>${list.exptaccount_name}</td>
											<td>${list.exptUserName}</td>
											<td> - </td>
											<td style="color: red; font-weight: bold;">-${list.expt_spent}원</td>
										</c:if>
									</tr>
								</c:forEach>
							</c:if>
							<input type="hidden" id="totalCnt" name="totalCnt" value ="${totalCnt}"/>
  