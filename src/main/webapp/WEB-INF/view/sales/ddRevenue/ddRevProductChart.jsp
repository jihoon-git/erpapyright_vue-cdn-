<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
 
 <script>
	// 파이에 넣을 변수 선언
	var productArr = new Array();  //제품명
	var pSalesArr = new Array();  //매출
</script>

<c:forEach items="${ddRevProductChartModel}" var="list">
	<script>

      // 배열에 리스트에 담아온 데이터를 push
		productArr.push("${list.product_name}");
		pSalesArr.push("${list.sum_p_sales}");
	</script>
</c:forEach>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
google.charts.load('current', {packages: ['corechart']});
google.charts.setOnLoadCallback(drawChart);


function drawChart() {
	
   // 차트에 들어갈 데이터
	var data = new google.visualization.DataTable();
	data.addColumn('string','제품명');
	data.addColumn('number','비중');
	
	// 데이터를 배열로 넣어준다
	// data.addRows([ 
	//    ['피자',5],
	//    ['치킨',2],
	//    ['햄버거',3]]);

   //parseInt해야함
	for(var i=0;i<productArr.length;i++){
      data.addRow([productArr[i],parseInt(pSalesArr[i])]);
	}

   // 차트 타이틀과 크기, 옵션을 지정
	var options = {
			legend:'none',
            height:400,
            label:'top',
            hAxis: {showTextEvery: 1,
            	fontSize:'5',
            	slantedText: true,
            	slantedTextAngle:45}, 
			animation : { //차트가 뿌려질때 실행될 애니메이션 효과
				startup : true,
				duration : 1000,
				easing : 'linear'
			},
			pieSliceText:'label'
          };
	var chart = new google.visualization.PieChart(document.getElementById('PieChartDiv'));

    chart.draw(data, options);
	}
</script> 

<%-- 차트를 그리려면 div 요소가 필요 --%>
<div id="PieChartDiv"></div>