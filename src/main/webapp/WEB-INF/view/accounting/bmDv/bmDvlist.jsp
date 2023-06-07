<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:if test="${userType eq 'B' || userType eq 'C'}">
	<c:if test="${countexpenselist eq 0 }">
		<tr>
			<td colspan="12">데이터가 존재하지 않습니다.</td>
		</tr>
	</c:if>

	<c:if test="${countexpenselist > 0 }">
		<c:forEach items="${expenselist}" var="list">
			<tr>
				<td><a href="javascript:fn_detailexpense('${list.exp_no}')">${list.exp_no}</a></td>
				<td>${list.loginID}</td>
				<td>${list.name}</td>
				<td>${list.detail_name}</td>
				<td>${list.account_name}</td>
				<td>${list.exp_date}</td>
				<td>${list.use_date}</td>
				<td>${list.exp_spent}</td>
				<c:choose>
					<c:when test="${list.exp_yn eq 'Y'}">
						<td>승인</td>
					</c:when>
					<c:when test="${list.exp_yn eq 'N'}">
						<td>반려</td>
					</c:when>
					<c:otherwise>
						<td><a class="btnType blue" href="javascript:fn_expenseapproval('${list.exp_no}')"><span>대기</span></a></td>
					</c:otherwise>
				</c:choose>
				<td>${list.yn_date}</td>
				<td>${list.exp_name}</td>
			</tr>
		</c:forEach>
	</c:if>
</c:if>
<c:if test="${userType eq 'D' }">
	<c:if test="${countexpenselist eq 0 }">
		<tr>
			<td colspan="10">데이터가 존재하지 않습니다.</td>
		</tr>
	</c:if>

	<c:if test="${countexpenselist > 0 }">
		<c:forEach items="${expenselist}" var="list">
			<tr>
				<td><a href="javascript:fn_detailexpense('${list.exp_no}')">${list.exp_no}</a></td>
				<td>${list.detail_name}</td>
				<td>${list.account_name}</td>
				<td>${list.exp_date}</td>
				<td>${list.use_date}</td>
				<td>${list.exp_spent}</td>
				<c:choose>
					<c:when test="${list.exp_yn eq 'Y'}">
						<td>승인</td>
					</c:when>
					<c:when test="${list.exp_yn eq 'N'}">
						<td>반려</td>
					</c:when>
					<c:otherwise>
						<td>대기</td>
					</c:otherwise>
				</c:choose>
				<td>${list.yn_date}</td>
				<td>${list.exp_name}</td>
			</tr>
		</c:forEach>
	</c:if>
</c:if>
<input type="hidden" id="countexpenselist" name="countexpenselist" value="${countexpenselist}" />