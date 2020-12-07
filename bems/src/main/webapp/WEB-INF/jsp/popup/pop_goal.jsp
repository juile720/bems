<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Style-Type" content="text/css">
<title>EAN BEMS</title>

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
<div id="dTitle">목표값 설정관리&nbsp;&nbsp;<button type="button" id="excelDownload">엑셀</button></div>
<div id="dvData">
<table id="tPrint" border="1" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center">&nbsp;</td>
		<td align="center">분류 구분</td>
		<td align="center">내 용</td>
		<td align="center">실사용량(kWh)</td>
		<td align="center">목표사용량(kWh)</td>
		<td align="center">비 고</td>
	</tr>
	<tr>
		<td align="center">1</td>
		<td align="center">에너지원별 사용량</td>
		<td align="center">전력</td>
		<td align="center">200</td>
		<td align="center">150</td>
		<td align="center">&nbsp;</td>
	</tr>
	<c:forEach var="i" begin="2" end="20" step="1">
	<tr>
		<td align="center">${i}</td>
		<td align="center">&nbsp;</td>
		<td align="center">&nbsp;</td>
		<td align="center">&nbsp;</td>
		<td align="center">&nbsp;</td>
		<td align="center">&nbsp;</td>
	</tr>
	</c:forEach>
</table>
</div>
<input type="hidden" name="excel_data" id="excel_data">
<input type="hidden" name="excelName" id="excelName">
</form>
</body>
<script src="/js/common.js" charset="utf-8"></script>
<%@ include file="/WEB-INF/include/include-body.jspf" %>

<script type="text/javascript">
	$("#excelDownload").on("click", function(e){ 
	    e.preventDefault();
	    fn_excelDownload();
	});
	
	function fn_excelDownload() {
    	
    	$("#excel_data").val(document.getElementById("tPrint").outerHTML);
    	$("#excelName").val("goalExcel.xls");
    	document.frm.action = "/data/htmlExcelDownload.do";
    	document.frm.submit();
    	
    }
</script>
</html>