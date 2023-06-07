<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- 월별 손익 통계 테이블 상반기 -->
	
 	<c:if test="${empty mmRevenuelist1 and empty mmRevenuelist2}">
		<colgroup>
			<col width="10%">
			<col width="12%">
			<col width="12%">
			<col width="12%">
			<col width="12%">
			<col width="12%">
			<col width="12%">
		</colgroup>
										
		<thead>
			<tr>
				<th colspan="7" scope="col"></th>
			</tr>
		</thead>
		<tbody>

			<tr>
				<td colspan="7">데이터가 존재하지 않습니다.</td>
			</tr>
		</tbody>	
	</c:if> 
							   
	<c:if test="${not empty mmRevenuelist1}">
	
		<colgroup>
			<col width="10%">
			<col width="12%">
			<col width="12%">
			<col width="12%">
			<col width="12%">
			<col width="12%">
			<col width="12%">
		</colgroup>
		
										
		<thead>
			<tr>
				<th scope="col"></th>
				<c:forEach items="${mmRevenuelist1}" var="list">
					<th scope="col">${list.ym_date}</th>
				</c:forEach>
			</tr>
		</thead>
		<tbody>
			<tr>
			<th scope="row">주문건수</th>
				<c:forEach items="${mmRevenuelist1}" var="list">
					<td scope="col">${list.order_amt} (건)</td>
				</c:forEach>
			</tr>
			
			<tr>
			<th scope="row">매출</th>
				<c:forEach items="${mmRevenuelist1}" var="list">
					<td scope="col"><fmt:formatNumber value="${list.outgo}" pattern="#,###"/></td>
				</c:forEach>
			</tr>
	
			<tr>
			<th scope="row">영업비</th>
				<c:forEach items="${mmRevenuelist1}" var="list">
					<td scope="col"><fmt:formatNumber value="${list.sales_exp}" pattern="#,###"/></td>
				</c:forEach>
			</tr>		
	
			<tr>
			<th scope="row">영업이익</th>
				<c:forEach items="${mmRevenuelist1}" var="list">
					<td scope="col"><fmt:formatNumber value="${list.sales_profit}" pattern="#,###"/></td>
				</c:forEach>
			</tr>
			
			<tr>
			<th scope="row">영업이익률</th>
				<c:forEach items="${mmRevenuelist1}" var="list">
					<td scope="col">${list.profit_rate}</td>
				</c:forEach>
			</tr>		
					
		</tbody>
	</c:if>
	
<!-- 월별 손익 통계 테이블 하반기 -->
	
<%-- 	<c:if test="${empty mmRevenuelist2}">
		<colgroup>
			<col width="10%">
			<col width="12%">
			<col width="12%">
			<col width="12%">
			<col width="12%">
			<col width="12%">
			<col width="12%">
		</colgroup>
										
		<thead>
			<tr>
				<th colspan="7" scope="col"></th>
			</tr>
		</thead>
		<tbody>

			<tr>
				<td colspan="7">데이터가 존재하지 않습니다.</td>
			</tr>
		</tbody>	
	</c:if> --%>
	
	<c:if test="${not empty mmRevenuelist2}">
	
		<colgroup>
			<col width="10%">
			<col width="12%">
			<col width="12%">
			<col width="12%">
			<col width="12%">
			<col width="12%">
			<col width="12%">
		</colgroup>
		
										
		<thead>
			<tr>
				<th scope="col"></th>
				<c:forEach items="${mmRevenuelist2}" var="list">
					<th scope="col">${list.ym_date}</th>
				</c:forEach>
			</tr>
		</thead>
		<tbody>
			<tr>
			<th scope="row">주문건수</th>
				<c:forEach items="${mmRevenuelist2}" var="list">
					<td scope="col">${list.order_amt}</td>
				</c:forEach>
			</tr>
			
			<tr>
			<th scope="row">매출</th>
				<c:forEach items="${mmRevenuelist2}" var="list">
					<td scope="col">${list.outgo}</td>
				</c:forEach>
			</tr>
	
			<tr>
			<th scope="row">영업비</th>
				<c:forEach items="${mmRevenuelist2}" var="list">
					<td scope="col">${list.sales_exp}</td>
				</c:forEach>
			</tr>		
	
			<tr>
			<th scope="row">영업이익</th>
				<c:forEach items="${mmRevenuelist2}" var="list">
					<td scope="col">${list.sales_profit}</td>
				</c:forEach>
			</tr>
			
			<tr>
			<th scope="row">영업이익률</th>
				<c:forEach items="${mmRevenuelist2}" var="list">
					<td scope="col">${list.profit_rate}</td>
				</c:forEach>
			</tr>		
					
		</tbody>
	</c:if>
	

	
	
	
							