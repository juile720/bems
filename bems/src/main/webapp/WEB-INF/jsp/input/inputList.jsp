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
<div>
<!-- 테이블 추가시 gubun 항목 추가 -->
	구분 : <select id="gubun" name="gubun">
		<option value="">선택</option>
		<option value="gas" <c:if test="${gubun == 'gas'}">selected="selected"</c:if>>가스</option>
		<option value="water" <c:if test="${gubun == 'water'}">selected="selected"</c:if>>수도</option>
		<option value="electric" <c:if test="${gubun == 'electric'}">selected="selected"</c:if>>전기</option>
	</select>
	&nbsp;&nbsp;
	<select id="cFloor" name="cFloor">
		<option value="">선택</option>
		<c:forEach var="i" begin="4" end="10" step="1">
			<option value="<c:out value="${i}" />" <c:if test="${cFloor == i}">selected="selected"</c:if>><c:out value="${i}" /></option>
		</c:forEach>
	</select> 층
	&nbsp;&nbsp;
	<select id="cYear" name="cYear">
		<option value="">선택</option>
		<c:forEach var="i" begin="0" end="3" step="1">
			<option value="<c:out value="${defaultYear-i}" />" <c:if test="${cYear == defaultYear-i}">selected="selected"</c:if>><c:out value="${defaultYear-i}" /></option>
		</c:forEach>
	</select> 년
	&nbsp;&nbsp;
	<select id="cMonth" name="cMonth">
		<option value="">선택</option>
		<option value="01" <c:if test="${cMonth == 01}">selected="selected"</c:if>>01</option>
		<option value="02" <c:if test="${cMonth == 02}">selected="selected"</c:if>>02</option>
		<option value="03" <c:if test="${cMonth == 03}">selected="selected"</c:if>>03</option>
		<option value="04" <c:if test="${cMonth == 04}">selected="selected"</c:if>>04</option>
		<option value="05" <c:if test="${cMonth == 05}">selected="selected"</c:if>>05</option>
		<option value="06" <c:if test="${cMonth == 06}">selected="selected"</c:if>>06</option>
		<option value="07" <c:if test="${cMonth == 07}">selected="selected"</c:if>>07</option>
		<option value="08" <c:if test="${cMonth == 08}">selected="selected"</c:if>>08</option>
		<option value="09" <c:if test="${cMonth == 09}">selected="selected"</c:if>>09</option>
		<option value="10" <c:if test="${cMonth == 10}">selected="selected"</c:if>>10</option>
		<option value="11" <c:if test="${cMonth == 11}">selected="selected"</c:if>>11</option>
		<option value="12" <c:if test="${cMonth == 12}">selected="selected"</c:if>>12</option>
	</select> 월
	&nbsp;&nbsp;
	<button type="button" id="search">조회</button>
	&nbsp;&nbsp;
	<button type="button" id="write">등록</button>
</div>
<table border="1" width="600">
	<tr>
		<td>날짜</td>
		<td>층</td>
		<td>사용량</td>
		<td>사용금액</td>
	</tr>
	<c:if test="${fn:length(list) > 0}">
		<c:forEach var="row" items="${list}" varStatus="status">
			<tr>
				<td>
					<a href="#this" name="title">${row.C_YYYYMMDD}</a>
					<input type="hidden" id="C_GUBUN" value="${row.C_GUBUN }">
					<input type="hidden" id="C_YYYYMMDD" value="${row.C_YYYYMMDD }">
					<input type="hidden" id="C_FLOOR" value="${row.C_FLOOR }">
				</td>
				<td>${row.C_FLOOR} 층</td>
				<td>${row.I_USE}</td>
				<td>${row.I_USE_PAY}</td>
			</tr>
		</c:forEach>
	</c:if>
	<c:if test="${fn:length(list) == 0}">
		<tr>
			<td colspan="4" style="vertical-align:middle;text-align:center;">조회된 결과가 없습니다.</td>
		</tr>
	</c:if>
</table>

<script src="/js/common.js" charset="utf-8"></script>
<%@ include file="/WEB-INF/include/include-body.jspf" %>

<script type="text/javascript">
$("#search").on("click", function(e){
    e.preventDefault();
    fn_search();
});

function fn_search() {
	var gubun = $("#gubun option:selected").val();
	var cFloor = $("#cFloor option:selected").val();
	var cYear = $("#cYear option:selected").val();
	var cMonth = $("#cMonth option:selected").val();
	
	if(gubun == "") {
		alert("구분을 선택하십시오");
		$("#gubun").focus();
		return false;
	}
	
	if(cFloor == "") {
		alert("층을 선택하십시오");
		$("#cFloor").focus();
		return false;
	}
	
	if(cYear == "") {
		alert("년도를 선택하십시오");
		$("#cYear").focus();
		return false;
	}
	
	var comSubmit = new ComSubmit();
	comSubmit.setUrl("<c:url value='/data/inputList.do' />");
	comSubmit.addParam("gubun", gubun);
	comSubmit.addParam("cFloor", cFloor);
	comSubmit.addParam("cYear", cYear);
	comSubmit.addParam("cMonth", cMonth);
    comSubmit.submit();
}

$("#write").on("click", function(e){
    e.preventDefault();
    fn_write();
});

function fn_write() {
	var comSubmit = new ComSubmit();
	comSubmit.setUrl("<c:url value='/data/inputWrite.do' />");
	
	var gubun = $("#gubun option:selected").val();
	var cFloor = $("#cFloor option:selected").val();
	var cYear = $("#cYear option:selected").val();
	var cMonth = $("#cMonth option:selected").val();
	
	comSubmit.addParam("gubun", gubun);
	comSubmit.addParam("cFloor", cFloor);
	comSubmit.addParam("cYear", cYear);
	comSubmit.addParam("cMonth", cMonth);
    comSubmit.submit();
}

$("a[name='title']").on("click", function(e){
    e.preventDefault();
    fn_inputUpdate($(this));
});

function fn_inputUpdate(obj){
    var comSubmit = new ComSubmit();
    comSubmit.setUrl("<c:url value='/data/inputUpdate.do' />");
    comSubmit.addParam("C_GUBUN", obj.parent().find("#C_GUBUN").val());
    comSubmit.addParam("C_YYYYMMDD", obj.parent().find("#C_YYYYMMDD").val());
    comSubmit.addParam("C_FLOOR", obj.parent().find("#C_FLOOR").val());
    comSubmit.submit();
}

</script>
</body>
</html>