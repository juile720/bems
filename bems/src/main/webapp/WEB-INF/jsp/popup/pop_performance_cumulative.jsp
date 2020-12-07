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
<div id="dTitle">누적비교표&nbsp;&nbsp;<button type="button" id="excelDownload">엑셀</button></div>
<div id="dvData">
<table id="tPrint" border="1" cellpadding="0" cellspacing="0">
	<tr>
		<td>구분</td>
		<c:forEach var="i" begin="1" end="24" step="1">
			<td>${i}</td>
		</c:forEach>
		<td>평균</td>
	</tr>
	<tr>
		<td>금일COP</td>
		<c:forEach var="i" begin="1" end="25" step="1">
			<td>&nbsp;</td>
		</c:forEach>
	</tr>
	<tr>
		<td>전일COP</td>
		<c:forEach var="i" begin="1" end="25" step="1">
			<td>&nbsp;</td>
		</c:forEach>
	</tr>
	<tr>
		<td>증감율(%)</td>
		<c:forEach var="i" begin="1" end="25" step="1">
			<td>&nbsp;</td>
		</c:forEach>
	</tr>
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
    	$("#excelName").val("performance_cumulativeExcel.xls");
    	document.frm.action = "/data/htmlExcelDownload.do";
    	document.frm.submit();
    	
    }
</script>
</html>