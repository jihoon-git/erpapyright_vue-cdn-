<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
						   
							
								<c:forEach items="${yearList}" var="list">
									<tr>
										<td>${list.operating_pay}</td>
										<td>${list.operating_pay}</td>
										<td>${list.operating_pay}</td>
										<td>${list.operating_pay}</td>
										<td>${list.operating_pay}</td>
										<td>${list.operating_pay}</td>
										<td>${list.operating_pay}</td>
									</tr>
									<tr>
										<th scope="row">당기순이익</th>
										<td name="이익1" id="이익1" >
										</td>
										<td  name="c_income1" id="c_income" va >
										</td>
										<td  name="이익3" id="이익3" >
										</td>
									</tr>
									<tr>
										<th scope="row">영업이익</th>
										<td name="이익4" id="이익4" >
										</td>
										<td  name="c_take_pay1" id="c_take_pay" >
										</td>
										<td  name="이익6" id="이익6" >
										</td>
									</tr>
									<tr>
										<th scope="row">매출</th>
										<td name="이익7" id="이익7" >
										</td>
										<td  name="c_order_pay1" id="c_order_pay" >
										</td>
										<td  name="이익9" id="이익9" >
										</td>
									</tr>
									<tr>
										<th scope="row">인건비</th>
										<td name="이익10" id="이익10" >
										</td>
										<td  name="c_salay_pay1" id="c_salay_pay" >
										</td>
										<td  name="이익12" id="이익12" >
										</td>
									</tr>
									<tr>
										<th scope="row">기타지출</th>
										<td name="이익13" id="이익13" >
										</td>
										<td  name="c_expense_pay1" id="c_expense_pay" >
										</td>
										<td  name="이익15" id="이익15" >
										</td>
									</tr>
									<tr>
										<th scope="row">전년대비매출성장률</th>
										<td name="이익16" id="이익16" >
										</td>
										<td  name="c_take_pay_growth1" id="c_take_pay_growth" >
										</td>
										<td  name="이익18" id="이익18" >
										</td>
									</tr>
									<tr>
										<th scope="row">전년대비순이익성장률</th>
										<td name="이익19" id="이익19" >
										</td>
										<td  name="c_income__growth1" id="c_income__growth" >
										</td>
										<td  name="이익21" id="이익21" >
										</td>
									</tr>
								</c:forEach>
							
