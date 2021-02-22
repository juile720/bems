<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Style-Type" content="text/css">

<title>EAN BEMS</title>
<link rel="stylesheet" type="text/css" href="/css/main_layout.css?ver=1"> 
<link rel="stylesheet" type="text/css" href="/css/common.css?ver=1"> 
<!--  <link rel="stylesheet" href="http://code.jquery.com/mobile/1.2.0/jquery.mobile-1.2.0.min.css" /> -->
<script src="http://code.jquery.com/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>

<script src="http://code.jquery.com/mobile/1.2.0/jquery.mobile-1.2.0.min.js"></script>

<script src="/js/wheather.js" charset="utf-8"></script> <!--날씨 스크립트 -->
	
</head>

<div id="wrap">
	<!-- header -->
<div id="header">
  <div class="both">
    <div class="fl">
      <div class="top_uit">
        <h1><a href="10.1.1.49:8085" title="메인페이지 바로가기" class="screen_out">EAN BEMS_Logo</a></h1>
      </div>
      <ul class="lnb_h">
        <li> <a href="#" id="total">메인화면</a> </li>
        <li> <a href="#" id="use">에너지용도별</a> </li>
         <li> <a href="#" id="resource">에너지원별</a> </li> 
         <li> <a href="#" id="facilities">에너지사용설비별</a> </li>  
         <li><a href="#" id="floor">층별관리</a></li>
      </ul>
    </div>
    <div class="fr">
      <ul class="lnb_h_r">
        <li> <a href="#" class="btn_t" id="pop_trendLog">TREND LOG</a> </li>
        <li> <a href="#" class="btn_t">SCHEDULE</a> </li>
        <li class="t28 mg_t05">
          <div class="icon"> <strong class="screen_out">날씨</strong>
            <div class="basis">
            <%@ include file="/WEB-INF/include/include-wheather.jspf" %>
<!--
              <ul class="list">
              	<span id="wid"></span>
                <li><a href="" class="icon"><span class="weather_icon sun"></span>태양</a></li>-->
                <!--<li><a href='' class="icon"><span class="weather_icon clouds"></span>구름</a></li>--> 
                <!--<li><a href='' class="icon"><span class="weather_icon rain"></span>비</a></li> -->
                <!--<li><a href='' class="icon"<span class="weather_icon snow"></span>눈</a></li>-->
                <!--<li><a href='' class="icon"><span class="weather_icon wind"></span>바람</a></li>
              </ul>
              -->
            </div>
          </div>
          <span id="weatherinfo"></span>℃</li>
        <li><span class="at_bar"></span></li>
        <li class="t14 mg_t05"> <span id="locationinfo"></span>/ 현재<br>
          습도 <span id="wetinfo"></span>%</li>
      </ul>
    </div>
  </div>
  <!-- //header --> 
</div>

<script type="text/javascript">
	$("#total").on("click", function(e){ 
	    e.preventDefault();
	    fn_total();
	});
	
	function fn_total(){
	    var comSubmit = new ComSubmit();
	    //comSubmit.setUrl("<c:url value='/data/graphView.do' />");
	    comSubmit.setUrl("<c:out value='/data/graphView.do' />");
	    comSubmit.submit();
	}

	$("#use").on("click", function(e){ 
	    e.preventDefault();
	    fn_use();
	});
	
	function fn_use(){
	    var comSubmit = new ComSubmit();
	    //comSubmit.setUrl("<c:url value='/data/energyUse.do' />");
	    comSubmit.setUrl("<c:url value='/data/energyUse.do' />");
	    comSubmit.submit();
	}
	
	$("#resource").on("click", function(e){ 
	    e.preventDefault();
	    fn_resource();
	});
	
	function fn_resource(){
	    var comSubmit = new ComSubmit();
	    //comSubmit.setUrl("<c:url value='/data/energyResource.do' />");
	    comSubmit.setUrl("<c:out value='/data/energyResource.do' />");
	    comSubmit.submit();
	}
	
	$("#facilities").on("click", function(e){ 
	    e.preventDefault();
	    fn_facilities();
	});
	
	function fn_facilities(){
	    var comSubmit = new ComSubmit();
	    //comSubmit.setUrl("<c:url value='/data/energyFacilities.do' />");
	    comSubmit.setUrl("<c:out value='/data/energyFacilities.do' />");
	    comSubmit.submit();
	}
	$("#floor").on("click", function(e){ 
	    e.preventDefault();
	    fn_floor();
	});
	
	function fn_floor(){
	    var comSubmit = new ComSubmit();
	    comSubmit.setUrl("<c:url value='/data/floor.do' />");
	    comSubmit.addParam("C_FLOOR", "4");
	    comSubmit.submit();
	}
	
	$("#pop_trendLog").on("click", function(e){ 
	    e.preventDefault();
	    fn_pop_trendLog();
	});
	
	function fn_pop_trendLog(){
		var settings ='toolbar=0,directories=0,status=no,menubar=0,scrollbars=yes,resizable=no,height=500,width=850,left=0,top=0';
		winObject = window.open("/data/pop_trendLog.do", "사용실비누적비교", settings);
	}
</script>
<script src="/js/common.js" charset="utf-8"></script>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
</body>
</html>