<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
							<c:if test="${totalCnt eq 0 }">
								<tr>
									<td colspan="9">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							<c:if test="${totalCnt > 0}">
								<c:forEach items="${oEManagementList}" var="list">
									<tr>
											<td style="font-weight: bold;">${list.estimate_cd}</td>
											<td style="font-weight: bold;"><a href="javascript:contractDetaile('${list.order_cd}','${ list.product_no }');">${list.order_cd}</a></td>
											<td style="font-weight: bold;">${list.client_name}</td>
											<td style="font-weight: bold;">${list.product_name}</td>
											<td style="font-weight: bold;">${list.product_amt}EA</td>
											<td style="font-weight: bold;"><fmt:formatNumber value="${list.tax}" pattern="#,###" />원</td>
											<td style="font-weight: bold;"><fmt:formatNumber value="${list.price}" pattern="#,###" />원</td>
											<td style="font-weight: bold;"><fmt:formatNumber value="${list.amt_price}" pattern="#,###" />원</td>
											<td style="color: blue; font-weight: bold;"><fmt:formatNumber value="${list.total_price}" pattern="#,###" />원</td>
									</tr>
									<%-- <input type="hidden" id="product_no" name="product_no" value="${ list.product_no }"/> --%>
								</c:forEach>
						 	</c:if>
							<input type="hidden" id="totalCnt" name="totalCnt" value ="${totalCnt}"/>
  