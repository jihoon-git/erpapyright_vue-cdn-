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
								<c:forEach items="${productList}" var="list" varStatus="status">
									<tr>
											<td style="font-weight: bold;">${list.product_no}</td>
											<td style="font-weight: bold;">${list.lcategory_name}</td>
											<td style="font-weight: bold;">${list.mcategory_name}</td>
											<td style="font-weight: bold;">${list.product_name}</td>
											<td style="font-weight: bold;"><fmt:formatNumber value="${list.price}" pattern="#,###" />원</td>
											<td style="font-weight: bold;">${list.stock}EA</td>
											<td style="display: flex;">
												<input type="text" id="addStock${status.index}" name="addStock" style="width: 80px; text-align-last: center;"/>
												<button type="button" onclick="insertStock('${list.product_no}','addStock${status.index}')" style="width: 50px;">추가</button>
											</td>
									</tr>
								</c:forEach>
						 	</c:if> 
							<input type="hidden" id="totalCnt" name="totalCnt" value ="${totalCnt}"/>
  