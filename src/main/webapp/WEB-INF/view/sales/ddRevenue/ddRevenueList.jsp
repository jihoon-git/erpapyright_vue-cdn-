<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
 
 <!-- 검색날짜의 매출목록 불러오기  -->
      <c:if test="${totalCntddRevenue eq 0 }">
			<tr>
				<td colspan="8">데이터가 존재하지 않습니다.</td>
			</tr>
		</c:if>
      <c:if test="${totalCntddRevenue > 0 }">
      <c:set var="nRow" value="${pageSize*(currentPageddRevenue-1)}" />
         <c:forEach items="${ddRevenueList}" var="list">
               <tr>
                  <td>${list.contract_date}</td>
                  <td>${list.client_name}</td>
                  <td>${list.product_name}</td>
                  <td>${list.product_amt}EA</td>
                  <td><fmt:formatNumber value="${list.price}" pattern="#,###" />원</td>
                  <td><fmt:formatNumber value="${list.amt_price}" pattern="#,###" />원</td>
                  <td><fmt:formatNumber value="${list.tax}" pattern="#,###" />원</td>
                  <td><fmt:formatNumber value="${list.total_price}" pattern="#,###" />원</td>
               </tr>
            <c:set var="nRow" value="${nRow + 1}" />
         </c:forEach> 
		</c:if>
      
      <input type="hidden" id="totalCntddRevenue" name="totalCntddRevenue" value ="${totalCntddRevenue}"/>

