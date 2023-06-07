<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
 
 <script>
	/*그래프 데이터 변수 선언*/
	var dateArr = new Array();  //일별날짜
	var salesArr = new Array();  //매출
	var cumsalesArr = new Array(); //매출총이익
</script>

<c:forEach items="${ddRevChartModel}" var="list">
	<script>

      // 배열에 리스트에 담아온 데이터를 push
		dateArr.push("${list.contract_date}");
		salesArr.push("${list.sum_sales}");
		cumsalesArr.push("${list.cumsum_sales}");
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
	data.addColumn('string','Date');
	data.addColumn('number','매출');
	data.addColumn('number','누적매출');
	
      // 데이터를 배열로 넣어준다
      // data.addRows([ 
      //    ['피자',5],
      //    ['치킨',2],
      //    ['햄버거',3]]);
      
      // substring(2) : 날짜 표시 2023-05-16 -> 23-05-16 
      // parseInt해야함
	for(var i=0;i<dateArr.length;i++){
      data.addRow([dateArr[i].substring(2),parseInt(salesArr[i]),parseInt(cumsalesArr[i])]);
	}

   // 차트 타이틀과 크기, 옵션을 지정
	var options = {
			legend: {'position':'top','alignment':'center'},
            height:400,
            label:'top',
            hAxis: {showTextEvery: 1,
            	fontSize:'5',
            	slantedText: true,
            	slantedTextAngle:45}, 
            vAxes: {0: {
            	title:'단위:원'
            }, 
            1: {
            	title:'단위:원'
            }},
            chartArea : {
				height: '70%',
				width : '60%'
			},
			animation : { //차트가 뿌려질때 실행될 애니메이션 효과
				startup : true,
				duration : 1000,
				easing : 'linear'
			},
			seriesType : 'bars',
			color:'blue',
			series : {1: {type:'line',
						  targetAxisIndex: 1,
						  color:'red'}}
          };

    var chart = new google.visualization.ComboChart(document.getElementById('chartDiv'));

    chart.draw(data, options);
	}
</script> 

<%-- 차트를 그리려면 div 요소가 필요 --%>
<div id="chartDiv"></div>