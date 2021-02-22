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

<!--<script src="/js/wheather.js" charset="utf-8"></script> 날씨 스크립트 -->
<script src="/js/jquery.lineProgressbar.js" charset="utf-8"></script> <!-- Line Progress -->

<script src="/highchart/highcharts.js"></script> <!-- 하이차트 스크립트 -->
<script src="/highchart/modules/exporting.js"></script>

<script src="/js/xbim/xbim-viewer.debug.bundle.js"></script>
</head>

<body>
<form name="frm" id="frm">
<table border="1" width="600">
	<tr>
		<td>구분</td>
		<td>
		<!-- 테이블 추가시 gubun 항목 추가 -->
			<select id="gubun" name="gubun">
				<option value="">선택</option>
				<option value="gas">가스</option>
				<option value="water">수도</option>
				<option value="electric">전기</option>
			</select>
		</td>
	<tr>
		<td>날짜</td>
		<td><input type="text" id="C_YYYYMMDD" name="C_YYYYMMDD"></td>
	</tr>
	<tr>
		<td>층</td>
		<td>
			<select id="C_FLOOR" name="C_FLOOR">
				<option value="">선택</option>
				<c:forEach var="i" begin="4" end="10" step="1">
					<option value="<c:out value="${i}" />"><c:out value="${i}" /></option>
				</c:forEach>
			</select>
		</td>
	</tr>
	<tr>
		<td>사용량</td>
		<td><input type="text" id="I_USE" name="I_USE"></td>
	</tr>
	<tr>
		<td>사용금액</td>
		<td><input type="text" id="I_USE_PAY" name="I_USE_PAY"></td>
	</tr>
</table>
</form>
<div>
	<button type="button" id="writeProc">저장</button>
	&nbsp;&nbsp;
	<button type="button" id="inputList">목록</button>
</div>

<script src="/js/common.js" charset="utf-8"></script>
<%@ include file="/WEB-INF/include/include-body.jspf" %>

<script>
$("#writeProc").on("click", function(e){
    e.preventDefault();
    fn_writeProc();
});

function fn_writeProc() {
	var gubun = $("#gubun option:selected").val();
	var C_YYYYMMDD = $("#C_YYYYMMDD").val();
	var C_FLOOR = $("#C_FLOOR option:selected").val();
	var I_USE = $("#I_USE").val();
	var I_USE_PAY = $("#I_USE_PAY").val();
	
	if(gubun == "") {
		alert("구분을 선택하십시오");
		$("#gubun").focus();
		return false;
	}
	
	if(C_YYYYMMDD == "") {
		alert("날짜를 입력하십시오");
		$("#C_YYYYMMDD").focus();
		return false;
	}
	
	var pattern = /[0-9]{4}-[0-9]{2}-[0-9]{2}/;
	if(!pattern.test(C_YYYYMMDD)) {
		alert("날짜형식을 XXXX-XX-XX 로 입력하십시오");
	    $("#C_YYYYMMDD").focus();
		return false;
	}
	
	if(C_YYYYMMDD.length != 10) {
		alert("날짜형식을 XXXX-XX-XX 로 입력하십시오");
	    $("#C_YYYYMMDD").focus();
		return false;
	}
	
	if(C_FLOOR == "") {
		alert("층을 선택하십시오");
		$("#C_FLOOR").focus();
		return false;
	}
	
	if(I_USE == "") {
		alert("사용량을 입력하십시오");
		$("#I_USE").focus();
		return false;
	}
	
	var comAjax = new ComAjax("frm");
	comAjax.setUrl("<c:url value='/data/inputWriteProc.do' />");
    comAjax.setCallback("doReturn");
    comAjax.ajax();
	
	/* var comSubmit = new ComSubmit();
	comSubmit.setUrl("<c:url value='/data/inputWriteProc.do' />");
	comSubmit.addParam("gubun", gubun);
	comSubmit.addParam("C_FLOOR", C_FLOOR);
	comSubmit.addParam("C_YYYYMMDD", C_YYYYMMDD);
	comSubmit.addParam("I_USE", I_USE);
	comSubmit.addParam("I_USE_PAY", I_USE_PAY);
    comSubmit.submit(); */
}

function doReturn(data){
	
	if (data == "SUCCESS"){
		alert("입력되었습니다");
	}

	var comSubmit = new ComSubmit("frm");
	comSubmit.setUrl("<c:url value='/data/inputList.do' />");
	comSubmit.submit();

}

$("#inputList").on("click", function(e){
    e.preventDefault();
    fn_inputList();
});

function fn_inputList(){
	var comSubmit = new ComSubmit("frm");
	comSubmit.setUrl("<c:url value='/data/inputList.do' />");
	comSubmit.submit();
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
 	$("#C_YYYYMMDD").datepicker({
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
			var sDate = $("#C_YYYYMMDD").val();
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
</body>
</html>