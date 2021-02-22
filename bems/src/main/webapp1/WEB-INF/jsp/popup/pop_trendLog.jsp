<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Style-Type" content="text/css">
<title>EAN BEMS</title>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="/css/jquery.lineProgressbar.css">

<script src="http://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<script src="/js/xbim/xbim-viewer.debug.bundle.js"></script>

<script src="/highchart/highcharts.js"></script> <!-- 하이차트 스크립트 -->
<script src="/highchart/modules/exporting.js"></script>

<style type="text/css"> 
	.layerweek { display: none; width:180px; }
	.layerdate { display: none; width:80px; }
	.layer1week { display: none; width:180px; }
	.layer1date { display: none; width:80px; }
    #viewer{z-index:9}
    #viewer,#viewerText{position:relative}
    #viewerText{margin-top:-150px;z-index:999999;}
</style>

</head>

<body>
<form name="frm" id="frm" method="post">
<div>
<!-- 테이블 추가시 gubun 항목 추가 -->
	층 <select id="cFloor" name="cFloor">
		<option value="">선택</option>
		<!-- value 층:전기:co2 -->
		<option value="4:1:2" <c:if test="${cFloor == '4:1:2'}">selected="selected"</c:if>>4</option>
		<option value="5:3:4" <c:if test="${cFloor == '5:3:4'}">selected="selected"</c:if>>5</option>
		<option value="6:5:6" <c:if test="${cFloor == '6:5:6'}">selected="selected"</c:if>>6</option>
		<option value="7:7:8" <c:if test="${cFloor == '7:7:8'}">selected="selected"</c:if>>7</option>
		<option value="8:9:10" <c:if test="${cFloor == '8:9:10'}">selected="selected"</c:if>>8</option>
		<option value="9:11:12" <c:if test="${cFloor == '9:11:12'}">selected="selected"</c:if>>9</option>
		<option value="10:13:14" <c:if test="${cFloor == '10:13:14'}">selected="selected"</c:if>>10</option>
	</select>
	&nbsp;&nbsp;
	날짜 <input type="text" id="T_DATETIME1" name="T_DATETIME1" value="${T_DATETIME1}" readonly> - <input type="text" id="T_DATETIME2" name="T_DATETIME2" value="${T_DATETIME2}" readonly>
	&nbsp;&nbsp;
	<button type="button" id="search">조회</button>
	&nbsp;&nbsp;
	<button type="button" id="excelDownload">엑셀</button>
</div>
<br>
<div id="dvData">
<table id="tPrint" border="1" cellpadding="0" cellspacing="0">
	<tr>
		<td>층</td>
		<td>날짜시간</td>
		<td>구분</td>
		<td>KWH</td>
		<td>CO2(ppm)</td>
		<td>실내온도</td>
		<td>실내습도</td>
	</tr>
	<c:if test="${fn:length(list) > 0}">
		<c:forEach var="row" items="${list}" varStatus="status">
			<tr>
				<td>${row.C_FLOOR}</td>
				<td>${row.DT}</td>
				<td>${row.C_DESC}</td>
				<td>${row.WATT}</td>
				<td>${row.CO2}</td>
				<td>${row.TEMP}</td>
				<td>${row.HUMI}</td>
			</tr>
		</c:forEach>
	</c:if>
	<c:if test="${fn:length(list) == 0}">
		<tr>
			<td colspan="7" style="vertical-align:middle;text-align:center;">조회된 결과가 없습니다.</td>
		</tr>
	</c:if>
</table>
</div>
<input type="hidden" name="excel_data" id="excel_data">
<input type="hidden" name="excelName" id="excelName">
</form>
</body>
<script src="/js/common.js" charset="utf-8"></script>
<%@ include file="/WEB-INF/include/include-body.jspf" %>

<script type="text/javascript">

	$("#search").on("click", function(e){
	    e.preventDefault();
	    fn_search();
	});
	
	function fn_search() {
		var cFloor = $("#cFloor option:selected").val();
		var T_DATETIME1 = $("#T_DATETIME1").val();
		var T_DATETIME2 = $("#T_DATETIME2").val();
		
		if(cFloor == "") {
			alert("층을 선택하십시오");
			$("#cFloor").focus();
			return false;
		}
		
		if(T_DATETIME1 == "") {
			alert("시작날짜를 선택하십시오");
			$("#T_DATETIME1").focus();
			return false;
		}
		
		if(T_DATETIME2 == "") {
			alert("종료날짜를 선택하십시오");
			$("#T_DATETIME2").focus();
			return false;
		}
		
		var comSubmit = new ComSubmit();
		comSubmit.setUrl("<c:url value='/data/pop_trendLog.do' />");
		comSubmit.addParam("cFloor", cFloor);
		comSubmit.addParam("T_DATETIME1", T_DATETIME1);
		comSubmit.addParam("T_DATETIME2", T_DATETIME2);
	    comSubmit.submit();
	}
	$("#excelDownload").on("click", function(e){ 
	    e.preventDefault();
	    fn_excelDownload();
	});
	
	function fn_excelDownload() {
    	
    	$("#excel_data").val(document.getElementById("tPrint").outerHTML);
    	$("#excelName").val("trendLogExcel.xls");
    	document.frm.action = "/data/htmlExcelDownload.do";
    	document.frm.submit();
    	
    }
	
	var holidays = {
			"0101":{type:0, title:"신정", year:""},
			"0301":{type:0, title:"삼일절", year:""},
			"0501":{type:0, title:"근로자의날", year:""},
			"0505":{type:0, title:"어린이날", year:""},
			"0606":{type:0, title:"현충일", year:""},
			"0815":{type:0, title:"광복절", year:""},
			"1003":{type:0, title:"개천절", year:""},
			"1009":{type:0, title:"한글날", year:""},
			"1225":{type:0, title:"크리스마스", year:""}
			// 가변적 공휴일
			/* "0127":{type:0, title:"설날", year:"2017"},
			"0128":{type:0, title:"설날", year:"2017"},
			"0129":{type:0, title:"설날", year:"2017"},
			"0130":{type:0, title:"설날", year:"2017"},
			"1004":{type:0, title:"추석", year:"2017"},
			"1005":{type:0, title:"추석", year:"2017"},
			"1006":{type:0, title:"추석", year:"2017"},
			"0503":{type:0, title:"석가탄신일", year:"2017"} */
		};
	 	$("#T_DATETIME1, #T_DATETIME2").datepicker({
			dateFormat: 'yy-mm-dd',
		    prevText: '이전 달',
		    nextText: '다음 달',
		    monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		    monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		    dayNames: ['일', '월', '화', '수', '목', '금', '토'],
		    dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
		    dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
		    showMonthAfterYear: true,
		    yearSuffix: '년',
	        onSelect: function (dateText, inst) {
	        // 일자 선택된 후 이벤트 발생
				var sDate = $("#T_DATETIME1").val();
				var eDate = $("#T_DATETIME2").val();
				var arr1 = sDate.split('-');
				var arr2 = eDate.split('-');
				if ((!arr1[0] == "") && (!arr2[0] == "")) {
					var dat1 = new Date(arr1[0], arr1[1], arr1[2]);
					var dat2 = new Date(arr2[0], arr2[1], arr2[2]);
					// 날짜 차이 알아 내기 
					var diff = (dat2 - dat1);
					var currDay = 24 * 60 * 60 * 1000;// 시 * 분 * 초 * 밀리세컨
					
					var currMonth = currDay * 30;// 월 만듬
					var currYear = currMonth * 12; // 년 만듬
					
					var curr = parseInt(diff/currDay) + 1;
					$("#differday").html("  * 신청일 : " + curr + " 일<br/>");
					

				}
				//document.write("* 일수 차이 : " + parseInt(diff/currDay) + " 일<br/>");
	        },
	        beforeShowDay: function(day) {
		    	var result;
		    	// 포맷에 대해선 다음 참조(http://docs.jquery.com/UI/Datepicker/formatDate)
		    	var holiday = holidays[$.datepicker.formatDate("mmdd",day )];
		    	var thisYear = $.datepicker.formatDate("yy", day);

		    	// exist holiday?
		    	if (holiday) {
	    			if(thisYear == holiday.year || holiday.year == "") {
	    				result =  [true, "date-holiday", holiday.title];
	    			}
				}
		    	if(!result) {
		    		switch (day.getDay()) {
		    			case 0: // is sunday?
	    					result = [true, "date-sunday"];
		    				break;
		    			case 6: // is saturday?
		    				result = [true, "date-saturday"];
		    				break;
		    			default:
		    				result = [true, ""];
		    				break;
		    		}
		    	}
		    	return result;
	    	}
		});
</script>
		<style>
			.date-holiday .ui-state-default { color:red; }
			.date-sunday .ui-state-default { color:red; }
			.date-saturday .ui-state-default { color:blue; }
		</style>
</html>