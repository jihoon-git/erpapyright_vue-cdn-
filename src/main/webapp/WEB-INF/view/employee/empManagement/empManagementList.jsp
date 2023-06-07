<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

		<c:if test="${countEmpMgtList eq 0 }">
			<tr>
				<td colspan="8">데이터가 존재하지 않습니다.</td>
			</tr>
		</c:if>
		
		<c:if test="${countEmpMgtList > 0 }">
			<c:forEach items="${empMgtList}" var="list">
				<tr>
					<td><a href="javascript:fnEmpMgtDet('${list.loginID}')">${list.emp_no}</td>
					<td><a href="javascript:fnEmpMgtDet('${list.loginID}')">${list.name}</a></td>
					<td>${list.dept_name}</td>
					<td>${list.rank_name}</td>
					<td>${list.st_date}</td>
					<td>${list.status_name}</td>
					<c:if test = "${list.status_cd eq 'A' }"> <%-- 재직자 --%>
						<td>
							<a class="btnType3 color1" href="javascript:fModalLeaveEmp('${list.loginID}', '${list.emp_no}', '${list.name}', '${list.st_date}')"><span>휴직처리</span></a>
							<a class="btnType3 color1" href="javascript:fModalRetireEmp('${list.loginID}', '${list.emp_no}', '${list.name}', '${list.st_date}')"><span>퇴직처리</span></a>
						</td>
					</c:if>
					<c:if test ="${list.status_cd eq 'B' }"> <%-- 휴직자 --%>
						<td>${list.lv_date}</td>
						<td><a class="btnType3 color1" href="javascript:fModalComebackEmp('${list.loginID}', '${list.emp_no}', '${list.name}', '${list.lvst_date}', '${list.lved_date}')"><span>복직처리</span></a></td>
					</c:if>
					<c:if test ="${list.status_cd eq 'C' }"> <%-- 퇴직자 --%>
						<td>${list.ed_date}</td>
					</c:if>
				</tr>
			</c:forEach>
		</c:if>
		
		<input type="hidden" id="countEmpMgtList" name="countEmpMgtList" value ="${countEmpMgtList}"/>