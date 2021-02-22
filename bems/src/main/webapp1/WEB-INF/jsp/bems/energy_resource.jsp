<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.Date" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Style-Type" content="text/css">
<title>EAN BEMS</title>
<link rel="stylesheet" type="text/css" href="/css/layout.css?ver=1">
<link rel="stylesheet" type="text/css" href="/css/common.css?ver=1">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css?ver=1">

<script src="http://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<script src="/js/wheather.js" charset="utf-8"></script><!-- 날씨 스크립트 -->

<script src="/highchart/highcharts.js"></script> <!-- 하이차트 스크립트 -->
<script src="/highchart/modules/exporting.js"></script>

<style> 
	.layerweek { display: none; width:180px; }
	.layerdate { display: none; width:80px; }
	.layer1week { display: none; width:180px; }
	.layer1date { display: none; width:80px; }
	
	table.ui-datepicker-calendar { display:none; }
</style>

</head>
<body>
<div id="wrap"> 
  <!-- header -->
  <div id="header">
    <div class="both">
      <div class="fl">
        <div class="top_uit">
          <li><a href="../index.jsp"><img src="../../../../img/logo2.png" ></a></li>
        </div>
        <ul class="lnb_h">
          <li><a href="#" id="total">메인화면</a> </li>
          <li><a href="#" id="use">에너지용도별</a> </li>
           <li> <a href="#" id="resource">에너지원별</a> </li> 
          <li><a href="#" id="facilities">에너지사용설비별</a> </li> 
          <li><a href="#" id="floor">층별관리</a></li>
        </ul>
      </div>
      <div class="fr">
        <ul class="lnb_h_r">
          <li> <a href="#" class="btn_t" id="pop_trendLog">TREND LOG</a> </li>
          <li> <a href="#" class="btn_t">SCHEDULE</a> </li>
          <li class="t28">
            <div class="icon"> <strong class="screen_out">날씨</strong>
              <div class="basis">
				<%@ include file="/WEB-INF/include/include-wheather.jspf" %>
              </div>
            </div>
            <span id="weatherinfo"></span>℃</li>
          <li><span class="at_bar"></span></li>
          <li class="t14"> <span id="locationinfo"></span>/현재<br>습도 <span id="wetinfo"></span>% </li>
        </ul>
      </div>
    </div>
  </div>
  <!-- //header --> 
  
  <!-- container -->
  <div id="container">
    <div class="grid_wrap">
      <div class="brick02-l">
        <div class="grid_inner mg_b15 h490">
          <h2 class="t_04">에너지별 소비분석</h2>
          <div class="mg_t20 mg_l30">
          <span>건물 :</span>
            <div class="select-style">
              <select>
                <option value="본관">본관</option>
              </select>
            </div>
			<a href="#" class="btn_s" id="pop_detailsearch2">상세조회</a>
           <span class="">기간 :</span>
            <div class="select-style">
              <select name='selectmid' id='selectmid'>
                <option value="1" selected="selected">월간</option>
                <option value="2">년간</option>
              </select>
            </div>
            	<input type="text" id ="month-picker" class="layerweek">
				<select id="selYear" name="bsnsYear" class="layerdate">
					<!-- <option value="">전체</option> -->
					<c:set var="now" value="<%=new java.util.Date()%>" />
					<fmt:formatDate value="${now}" pattern="yyyy" var="yearStart"/> 
					<c:forEach begin="0" end="10" var="result" step="1">
					<option value="<c:out value="${yearStart - result}" />" <c:if test="${(yearStart - result) == searchVO.bsnsYear}"> selected="selected"</c:if>><c:out value="${yearStart - result}" /></option>
					</c:forEach>
         		</select>
          </div>
           <div class="fl l_02">
          	<div class="box_type07 pd_t10 pd_l30">
          	 <ul class="fl lst_type l_05 mg_b10">
                <li><strong>전체 사용량</strong> <em>( <span id="itotal"></span> kWh )</em></li>
                <li>- 전력  <span id="ielect"></span> kWh</li>
                <li>- 가스  <span id="igas"></span> kWh</li>
                <li>- 유류  <span id="iwater"></span> m³</li>
                <li>- 사용요금</li>
             </ul>
             <div class="fr lst_type box_type_s01 r_05">
<!--                원그래프 넣는곳<br>
              1920 height: 160px <br>3840 height: 320px;
               <br>전력#f5d14e<br>가스#f15d45<br>수도#3ddcf7 -->
               <div id="container1" style="height: 160px; margin: 0 auto"></div>
             </div>
             <table class="type01">
             <colgroup>
				<col width="20%">
                <col>
             </colgroup>
                <tr>
                    <th scope="row">전력</th>
                    <td> <span id="ielectwon"></span> 원</td>
                </tr>
                <tr>
                    <th scope="row">가스</th>
                    <td><span id="igaswon"></span> 원</td>
                </tr>
                <tr>
                    <th scope="row">유류</th>
                    <td><span id="iwaterwon"></span> 원</td>
                </tr>
                 <tr>
                    <th scope="row">사용요금</th>
                    <td><span id="itotwon"></span> 원</td>
                </tr>
            </table>
            </div>                    
          </div>
          <div class="fl l_02 pd_l15 ">
          	<div class="box_type07 pd_t10 pd_r30">
            	<ul class="fl lst_type l_02 mg_b10">
                <li><strong>전체 생산량</strong> <em>( <span id="ptotal"></span> kWh )</em></li>
                <li>- 태양광  <span id="psunlight"></span> kWh</li>
                <li>- 태양열  <span id="psunheat"></span> kWh</li>
                <li>- 지열  <span id="pgeotherm"></span> kWh</li>
                <li>- 환산요금(절감비용)</li>
             </ul>
             <div class="fr lst_type box_type_s01 l_02">
<!--                원그래프 넣는곳<br>
               1920 height: 160px <br>3840 height: 320px; <br>
            태양광 #14edb7 <br>태양열#fd7969 <br>지열#fad462 -->
            <div id="container2" style="height: 160px; margin: 0 auto"></div>
             </div>
             <table class="type01">
             <colgroup>
				<col width="20%">
                <col>
             </colgroup>
                <tr>
                    <th scope="row">태양광</th>
                    <td><span id="psunlightwon"></span> 원</td>
                </tr>
                <tr>
                    <th scope="row">태양열</th>
                    <td> <span id="psunheatwon"></span> 원</td>
                </tr>
                <tr>
                    <th scope="row">지열</th>
                    <td><span id="pgeothermwon"></span> 원</td>
                </tr>
                 <tr>
                    <th scope="row">합계</th>
                    <td><span id="ptotwon"></span>원</td>
                </tr>
            </table>
            </div>        
          </div>
        </div>
      </div>
      
      <div class="brick02-r">
        <div class="grid_inner mg_l15 h490">
          <h2 class="t_04">전년 동월 대비 사용량</h2>
          <div class="fl l_04">
          	<div class="box_type11 pd_t10">  
            <h3>전기</h3>  
            	<div id="container3" style="height: 380px; margin: 0 auto"></div>
<!--            그래프 : 금월 #a3fe00  전년#ffd876 -->   	 
            </div> 
<!--             <ul class="list_legend01 fr">
              <li><div class="gre"></div>금월 소비 전력량</li>
              <li><div class="ye03"></div>전년 동원 소비 전력량</li>
            </ul>
             -->                 
          </div>
          <div class="fl l_04 pd_l10">
          	<div class="box_type11 pd_t10"> 
            <h3>가스</h3>  
            	<div id="container4" style="height: 380px; margin: 0 auto"></div>
<!--             920 일때 height: 345px; 3840 일때 height: 700px;
            그래프 : 금월 #f15d45  전년#6fdd9e  -->   	         	
            </div>
<!-- 
            <ul class="list_legend01 fr">
              <li><div class="ye"></div>금월 소비 전력량</li>
              <li><div class="em02"></div>전년 동원 소비 전력량</li>
            </ul>
 -->
          </div>
          <div class="fl l_04 pd_l10">
          	<div class="box_type11 pd_t10">  
             <h3>유류</h3>
             	<div id="container5" style="height: 380px; margin: 0 auto"></div>  
<!--             그래프 : 금월 #3ddcf7  전년#f66a54 -->   	        	
            </div>
<!-- 
            <ul class="list_legend01 fr">
              <li><div class="sk"></div>금월 소비 전력량</li>
              <li><div class="or02"></div>전년 동원 소비 전력량</li>
            </ul>
 -->
          </div>       
        </div>
      </div>
      <div class="brick01">
        <div class="grid_inner h455">
          <h2 class="t_04">단위면적당 소비량</h2>
          <div class="mg_t20 mg_l30">        
            <span class="">기간 :</span>
            <div class="select-style">
              <select name='selectmid' id='selectmid'>
                <option value="1" selected="selected">월간</option>
                <option value="2">년간</option>
              </select>
            </div>
            	<input type="text" id ="month-picker1" class="layer1week">
				<select id="selYear1" name="bsnsYear1" class="layer1date">
					<!-- <option value="">전체</option> -->
					<c:set var="now" value="<%=new java.util.Date()%>" />
					<fmt:formatDate value="${now}" pattern="yyyy" var="yearStart"/> 
					<c:forEach begin="0" end="5" var="result" step="1">
					<option value="<c:out value="${yearStart - result}" />" <c:if test="${(yearStart - result) == searchVO.bsnsYear1}"> selected="selected"</c:if>><c:out value="${yearStart - result}" /></option>
					</c:forEach>
         		</select>
         		
           <a href="#" class="btn_s" id="pop_cumulative">누적비교표</a><a href="#" class="btn_s" id="pop_goal">목표값 설정관리</a>
             <div class="select-style">
              <select>
                <option value="ALL" id='selectoption'>전체</option>
                <option value="1">전기</option>
                <option value="2">가스</option>
                <option value="3">유류</option>
              </select>
            </div>
          </div>
          <div class="fl l_02">
	          <div style="width:50%;height:330px;margin:15px 0;float: left;"> <!-- 1920 일때 height: 330px; 3840 일때 height: 660px; <br>
	            그래프색상 :목표 #05afb2 사용 #f56954</div>
	            <ul class="list_legend fr">
	              <li><div class="em01"></div>목표량</li>
	              <li><div class="or01"></div>사용량</li>
	            </ul>
	             -->
	             <div id="container6" style="height: 290px; margin: 0 auto "></div>
	          </div>
	          <div style="width:50%;height:330px;margin:15px 0;float: left;"> <!-- 1920 일때 height: 330px; 3840 일때 height: 660px; <br>
	            그래프색상 :목표 #05afb2 사용 #f56954</div>
	            <ul class="list_legend fr">
	              <li><div class="em01"></div>목표량</li>
	              <li><div class="or01"></div>사용량</li>
	            </ul>
	             -->
	             <div id="container7" style="height: 290px; margin: 0 auto "></div>
	          </div>
           </div>
          <div class="fl r_02 pd_l15">
          <div class="box_type04"> <!-- 1920 일때 height: 330px; 3840 일때 height: 660px; <br>
            그래프색상 : 목표 #f76397 실사 #00b4ef 예측 #ffd876</div>
            <ul class="list_legend fr">
              <li><div class="pi01"></div>목표사용량</li>
              <li><div class="sk02"></div>실사용량</li>
              <li><div class="ye03"></div>예측사용량</li>
            </ul>
             -->
             <div id="container8" style="height: 290px; margin: 0 width: 100px"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
 </div>
<script src="/js/common.js" charset="utf-8"></script>
<%@ include file="/WEB-INF/include/include-body.jspf" %>

<script type="text/javascript">

	$("#pop_detailsearch2").on("click", function(e){ 
	    e.preventDefault();
	    fn_pop_detailsearch2();
	});
	
	function fn_pop_detailsearch2(){
		var settings ='toolbar=0,directories=0,status=no,menubar=0,scrollbars=yes,resizable=no,height=500,width=450,left=0,top=0';
		winObject = window.open("/data/pop_detailsearch2.do", "상세조회1", settings);
	}
	
	$("#pop_cumulative").on("click", function(e){ 
	    e.preventDefault();
	    fn_pop_cumulative();
	});
	
	function fn_pop_cumulative(){
		var settings ='toolbar=0,directories=0,status=no,menubar=0,scrollbars=yes,resizable=no,height=300,width=850,left=0,top=0';
		winObject = window.open("/data/pop_cumulative.do", "상세조회1", settings);
	}
	
	$("#pop_goal").on("click", function(e){ 
	    e.preventDefault();
	    fn_pop_goal();
	});
	
	function fn_pop_goal(){
		var settings ='toolbar=0,directories=0,status=no,menubar=0,scrollbars=yes,resizable=no,height=400,width=850,left=0,top=0';
		winObject = window.open("/data/pop_goal.do", "상세조회1", settings);
	}
	
	$("#pop_trendLog").on("click", function(e){ 
	    e.preventDefault();
	    fn_pop_trendLog();
	});
	
	function fn_pop_trendLog(){
		var settings ='toolbar=0,directories=0,status=no,menubar=0,scrollbars=yes,resizable=no,height=500,width=850,left=0,top=0';
		winObject = window.open("/data/pop_trendLog.do", "사용실비누적비교", settings);
	}
	
	$("#total").on("click", function(e){ 
	    e.preventDefault();
	    fn_total();
	});
	
	function fn_total(){
	    var comSubmit = new ComSubmit();
	    comSubmit.setUrl("<c:url value='/data/graphView.do' />");
	    comSubmit.submit();
	}
	
	$("#use").on("click", function(e){ 
	    e.preventDefault();
	    fn_use();
	});
	
	function fn_use(){
	    var comSubmit = new ComSubmit();
	    comSubmit.setUrl("<c:url value='/data/energyUse.do' />");
	    comSubmit.submit();
	}

	$("#resource").on("click", function(e){ 
	    e.preventDefault();
	    fn_resource();
	});
	
	function fn_resource(){
	    var comSubmit = new ComSubmit();
	    comSubmit.setUrl("<c:url value='/data/energyResource.do' />");
	    comSubmit.submit();
	}

	$("#facilities").on("click", function(e){ 
	    e.preventDefault();
	    fn_facilities();
	});
	
	function fn_facilities(){
	    var comSubmit = new ComSubmit();
	    comSubmit.setUrl("<c:url value='/data/energyFacilities.do' />");
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
	
	$('#selecttop').change(function() {
		var state = jQuery('#selecttop option:selected').val();
		if(state == '1') {
			jQuery('.layerweek').show();
			jQuery('.layerdate').hide();
		}else if(state == '2') {
			jQuery('.layerweek').hide();
			jQuery('.layerdate').show();
		}
	});
	
	$('#selectmid').change(function() {
		var state = jQuery('#selectmid option:selected').val();
		if(state == '1') {
			jQuery('.layer1week').show();
			jQuery('.layer1date').hide();
		}else if(state == '2') {
			jQuery('.layer1week').hide();
			jQuery('.layer1date').show();
		}
	});
	
	$.datepicker.regional['ko'] = {
	        closeText: '닫기',
	        prevText: '이전달',
	        nextText: '다음달',
	        currentText: '오늘',
	        monthNames: ['1월(JAN)','2월(FEB)','3월(MAR)','4월(APR)','5월(MAY)','6월(JUN)',
	        '7월(JUL)','8월(AUG)','9월(SEP)','10월(OCT)','11월(NOV)','12월(DEC)'],
	        monthNamesShort: ['1월','2월','3월','4월','5월','6월',
	        '7월','8월','9월','10월','11월','12월'],
	        dayNames: ['일','월','화','수','목','금','토'],
	        dayNamesShort: ['일','월','화','수','목','금','토'],
	        dayNamesMin: ['일','월','화','수','목','금','토'],
	        weekHeader: 'Wk',
	        dateFormat: 'yy-mm-dd',
	        firstDay: 0,
	        isRTL: false,
	        showMonthAfterYear: true,
	        yearSuffix: '',
	        showOn: 'both',
//	        buttonText: "달력",
	        changeMonth: true,
	        changeYear: true,
//	        showButtonPanel: true,
	        yearRange: 'c-99:c+99',
	    };
	$.datepicker.setDefaults($.datepicker.regional['ko']);
	
	var datepicker_default = {
	        showOn: 'both',
//	        buttonText: "달력",
	        currentText: "이번달",
	        changeMonth: true,
	        changeYear: true,
//	        showButtonPanel: true,
	        yearRange: 'c-99:c+99',
	        showOtherMonths: true,
	        selectOtherMonths: true
	    }
	  
    datepicker_default.closeText = "선택";
    datepicker_default.dateFormat = "yy-mm";
    datepicker_default.onClose = function (dateText, inst) {
        var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
        var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
        $(this).datepicker( "option", "defaultDate", new Date(year, month, 1) );
        $(this).datepicker('setDate', new Date(year, month, 1));
    }
  
    datepicker_default.beforeShow = function () {
        var selectDate = $("#month-picker").val().split("-");
        var year = Number(selectDate[0]);
        var month = Number(selectDate[1]) - 1;
        $(this).datepicker( "option", "defaultDate", new Date(year, month, 1) );
    }
	 
    $("#month-picker").datepicker(datepicker_default);
    $("#month-picker1").datepicker(datepicker_default);
    
	var data1=[], data2=[], data11=[], data22=[], 
		data3=[], data4=[], data5=[], data6=[], data7=[], data8=[], data9=[], data10=[] ;
	
	var options = {
		    chart: {
		        margin: [0, 0, 0, 0],
		        spacingTop: 0,
		        spacingBottom: 0,
		        spacingLeft: 0,
		        spacingRight: 0,
		        plotBackgroundColor: null,
		        plotBorderWidth: null,
		        plotShadow: false,
		    	zoomType: 'xy'
		        ,type: 'pie'
		        ,renderTo: 'container1'
		        ,backgroundColor :'#7bbf2c'
		    },
			credits: {
				enabled: false
			},
		    title: {
		        text: ''
		    },
		    tooltip: {
		        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
		    },
		    plotOptions: {
		        pie: {
		        	size: '110%',
	                dataLabels: {
	                	format: '<b>{point.name}</b>: {point.percentage:.1f} %',
	                    distance: -45,
	                    color: "7bbf2c"
	                }
		        }
		    },
			exporting: {
	            enabled: false
	        },
		    series://[]
		    [ {        
		    	data:data1
		    }]
	}
	
	var options1 = {
		    chart: {
		        margin: [0, 0, 0, 0],
		        spacingTop: 0,
		        spacingBottom: 0,
		        spacingLeft: 0,
		        spacingRight: 0,
		        plotBackgroundColor: null,
		        plotBorderWidth: null,
		        plotShadow: false,
		    	zoomType: 'xy'
		        ,type: 'pie'
		        ,renderTo: 'container2'
		        ,backgroundColor :'#7bbf2c'
		    },
			credits: {
				enabled: false
			},
		    title: {
		        text: ''
		    },
		    tooltip: {
		        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
		    },
		    plotOptions: {
		        pie: {
		        	size: '110%',
	                dataLabels: {
	                	format: '<b>{point.name}</b>: {point.percentage:.1f} %',
	                    distance: -45,
	                    color: "7bbf2c"
	                }
		        }
		    },
			exporting: {
	            enabled: false
	        },
		    series://[]
		    [ {        
		    	data:data2
		    }]
		    
		}
	
	var options2 = {
		    chart: {
		        type: 'spline'
		        ,renderTo: 'container3'
		        ,backgroundColor :'#7bbf2c'
		    },
		    title: {
		        text: ''
		    },
			exporting: {
	            enabled: false
	        },
			credits: {
				enabled: false
			},
	        legend: {
	              itemStyle: {
	                 color: 'white'
	              }
	        },
		    xAxis: {
		    	categories : [],
		        labels: {
		            overflow: 'justify',
		            style:{color:'black'}
		        }
		    },
		    yAxis: {
		        title: {
		            text: '사용량 (KW)',style:{color:'black'}
		        },
		        minorGridLineWidth: 0,
		        gridLineWidth: 0,
		        alternateGridColor: null
		    },
		    tooltip: {
		        valueSuffix: ' KW'
		    },
		    plotOptions: {
		        spline: {
		            lineWidth: 4,
		            states: {
		                hover: {
		                    lineWidth: 5
		                }
		            },
		            marker: {
		                enabled: false
		            }
		        }
		    },
		    series: [{
		    	color:'#2b908f',
		        name: '금월소비전력량',
		        data: data11

		    }, {
		    	color:'#90ee7e',
		        name: '작년동월소비전력량',
		        data: data22
		    }] 
		    ,
		    navigation: {
		        menuItemStyle: {
		            fontSize: '10px'
		        }
		    }
	}

	var options3 = {
		    chart: {
		        type: 'spline'
		        ,renderTo: 'container4'
		        ,backgroundColor :'#7bbf2c'
		    },
		    title: {
		        text: ''
		    },
			exporting: {
	            enabled: false
	        },
			credits: {
				enabled: false
			},
	        legend: {
	              itemStyle: {
	                 color: 'white'
	              }
	        },
		    xAxis: {
		    	categories : [],
		        labels: {
		            overflow: 'justify',
		            style:{color:'black'}
		        }
		    },
		    yAxis: {
		        title: {
		            text: '사용량 (KW)',style:{color:'black'}
		        },
		        minorGridLineWidth: 0,
		        gridLineWidth: 0,
		        alternateGridColor: null
		    },
		    tooltip: {
		        valueSuffix: ' KW'
		    },
		    plotOptions: {
		        spline: {
		            lineWidth: 4,
		            states: {
		                hover: {
		                    lineWidth: 5
		                }
		            },
		            marker: {
		                enabled: false
		            }
		        }
		    },
		    series: [{
		    	color:'#2b908f',
		        name: '금월소비전력량',
		        data: data3

		    }, {
		    	color:'#90ee7e',
		        name: '작년동월소비전력량',
		        data: data4 
		    }] 
		    ,
		    navigation: {
		        menuItemStyle: {
		            fontSize: '10px'
		        }
		    }
		    
	}
	
	var options4 = {
		    chart: {
		        type: 'spline'
		        ,renderTo: 'container5'
		        ,backgroundColor :'#7bbf2c'
		    },
		    title: {
		        text: ''
		    },
			exporting: {
	            enabled: false
	        },
			credits: {
				enabled: false
			},
	        legend: {
	              itemStyle: {
	                 color: 'white'
	              }
	        },
		    xAxis: {
		    	categories : [],
		        labels: {
		            overflow: 'justify',
		            style:{color:'black'}
		        }
		    },
		    yAxis: {
		        title: {
		            text: '사용량 (m3)',
		            style:{color:'black'}
		        },
		        minorGridLineWidth: 0,
		        gridLineWidth: 0,
		        alternateGridColor: null
		    },
		    tooltip: {
		        valueSuffix: ' m3'
		    },
		    plotOptions: {
		        spline: {
		            lineWidth: 4,
		            states: {
		                hover: {
		                    lineWidth: 5
		                }
		            },
		            marker: {
		                enabled: false
		            }
		        }
		    },
		    series: [{
		    	color:'#2b908f',
		        name: '금월소비량     ',
		        data: data5

		    }, {
		    	color:'#90ee7e',
		        name: '작년동월소비량',
		        data: data6 
		    }] 
		    ,
		    navigation: {
		        menuItemStyle: {
		            fontSize: '10px'
		        }
		    }
		    
		}

	var options5 = {
		    chart: {
		        type: 'column',renderTo: 'container6'
		        ,backgroundColor :'#7bbf2c'
		    },
			exporting: {
	            enabled: false
	        },
			credits: {
				enabled: false
			},
		    title: {
		        text: ''
		    },
		    subtitle: {
		        text: ''
		    },
	        legend: {
	              itemStyle: {
	                 color: 'white'
	              }
	        },
		    xAxis: {
		        categories: ['전기','가스'],
		        crosshair: true,
		        labels: {
		            overflow: 'justify',
		            style:{color:'black'}
		        }
		    },
		    yAxis: {
		        min: 0,
		        title: {
		            text: '단위면적당 소비량 (KW)',
			        style:{color:'black'}
		        }
		    },
		    tooltip: {
		        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
		        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
		            '<td style="padding:0"><b>{point.y:.1f} mm</b></td></tr>',
//		        footerFormat: '</table>',
//		        shared: true,
//		        useHTML: true
		    },
		    plotOptions: {
		        column: {
		            pointPadding: 0.2,
		            borderWidth: 0
		        }
		    },
		    series: [{
		    	name: '사용량',
		        data: data7

		    }, {
		    	name: '목표량',
		        data: data8

		    }]
		    
		}
	
	var options6 = {
		    chart: {
		        type: 'column',renderTo: 'container7'
		        ,backgroundColor :'#7bbf2c'
		    },
			exporting: {
	            enabled: false
	        },
			credits: {
				enabled: false
			},
		    title: {
		        text: ''
		    },
		    subtitle: {
		        text: ''
		    },
	        legend: {
	              itemStyle: {
	                 color: 'white'
	              }
	        },
		    xAxis: {
		        categories: ['유류'],
		        crosshair: true,
		        labels: {
		            overflow: 'justify',
		            style:{color:'black'}
		        }
		    },
		    yAxis: {
		        min: 0,
		        title: {
		            text: '단위면적당 소비량 (㎥/㎥)',
			        style:{color:'black'}
		        }
		    },
		    tooltip: {
		        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
		        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
		            '<td style="padding:0"><b>{point.y:.1f} mm</b></td></tr>',
		        footerFormat: '</table>',
		        shared: true,
		        useHTML: true
		    },
		    plotOptions: {
		        column: {
		            pointPadding: 0.2,
		            borderWidth: 0
		        }
		    },
		    series: [{
		    	name: '사용량',
		        data: data9

		    }, {
		    	name: '목표량',
		        data: data10

		    }]
		    
		}
	
	var options7 = {
		    chart: {
		        renderTo: 'container8'
		        ,backgroundColor :'#7bbf2c'
		    },
			exporting: {
	            enabled: false
	        },
			credits: {
				enabled: false
			},
		    title: {
		        text: ''
		    },
		    subtitle: {
		        text: ''
		    },
		    xAxis: [{
		        categories: [],//['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
		        crosshair: true
		    }],

		    yAxis: {
		        min: 0,
		        title: {
		            text: '사용량 (KW)'
		        }
		    },
		    tooltip: {
		        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
		        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
		            '<td style="padding:0"><b>{point.y:.1f} mm</b></td></tr>',
		        footerFormat: '</table>',
		        shared: true,
		        useHTML: true
		    },
		    plotOptions: {
		        column: {
		            pointPadding: 0.2,
		            borderWidth: 0
		        }
		    },
		    series: []
		    
		}
	function numberWithCommas(x) {
	    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}


	jQuery(function($){
		jQuery('.layerweek').show();
		jQuery('.layerdate').hide();
		
		jQuery('.layer1week').show();
		jQuery('.layer1date').hide();
		
		var tmp = $.datepicker.formatDate('yymmdd', new Date());
		var year=tmp.substring(0,4);
		var month= tmp.substring(4,6);
		console.log(year + "/" + month);
		$('#month-picker').val(year + "-" + month); // 현재 년월 세팅
		$('#month-picker1').val(year + "-" + month); // 현재 년월 세팅
		
		$.ajax({ 
		    type:"POST",  
		    url:"/pageEResourceGraph1.do",
		    dataType: 'json',
		    success:function(data){
//				console.log(data);
				var tot1= 0,tot1won= 0, tot2= 0, tot2won = 0;
				
				$.each(data.series, function(i, seriesItem) {
					//console.log(seriesItem.name);
					switch(seriesItem.name){
            		case '전력':data1.push({name:seriesItem.name,y:parseFloat(seriesItem.data)});
	            		break;
            		case '가스':data1.push({name:seriesItem.name,y:parseFloat(seriesItem.data)});
            			break;
            		case '유류':data1.push({name:seriesItem.name,y:parseFloat(seriesItem.data)});
            			break;
            		case '전력val':
            			tot1 = tot1 + parseFloat(seriesItem.data);$("#ielect").html(numberWithCommas(parseFloat(seriesItem.data)));
            			break;
	        		case '가스val':
	        			tot1 = tot1 + parseFloat(seriesItem.data);$("#igas").html(numberWithCommas(parseFloat(seriesItem.data)));
	        			break;
	        		case '유류val':
	        			tot1 = tot1 + parseFloat(seriesItem.data);$("#iwater").html(numberWithCommas(parseFloat(seriesItem.data)));
	        			break;		            			
            		case '전력금액':
            			tot1won = tot1won + parseFloat(seriesItem.data);
            			$("#ielectwon").html(numberWithCommas(parseFloat(seriesItem.data)));
	        			break;
	        		case '가스금액':
            			tot1won = tot1won + parseFloat(seriesItem.data);
            			$("#igaswon").html(numberWithCommas(parseFloat(seriesItem.data)));
	        			break;
	        		case '유류금액':
            			tot1won = tot1won + parseFloat(seriesItem.data);
            			$("#iwaterwon").html(numberWithCommas(parseFloat(seriesItem.data)));
	        			break;		            			
            		case '태양광':data2.push({name:seriesItem.name,y:parseFloat(seriesItem.data)});
            			break;
	        		case '태양열':data2.push({name:seriesItem.name,y:parseFloat(seriesItem.data)});
	        			break;
	        		case '지열':data2.push({name:seriesItem.name,y:parseFloat(seriesItem.data)});
	        			break;
	        		case '태양광val':
	        			tot2 = tot2 + parseFloat(seriesItem.data);$("#psunlight").html(numberWithCommas(parseFloat(seriesItem.data)));
	        			break;
	        		case '태양열val':
	        			tot2 = tot2 + parseFloat(seriesItem.data);$("#psunheat").html(numberWithCommas(parseFloat(seriesItem.data)));
	        			break;
	        		case '지열val':
	        			tot2 = tot2 + parseFloat(seriesItem.data);$("#pgeotherm").html(numberWithCommas(parseFloat(seriesItem.data)));
	        			break;		            			
	        		case '태양광금액':
	        			tot2won = tot2won + parseFloat(seriesItem.data);
	        			$("#psunlightwon").html(numberWithCommas(parseFloat(seriesItem.data)));
	        			break;
	        		case '태양열금액':
	        			tot2won = tot2won + parseFloat(seriesItem.data);
	        			$("#psunheatwon").html(numberWithCommas(parseFloat(seriesItem.data)));
	        			break;
	        		case '지열금액':
	        			tot2won = tot2won + parseFloat(seriesItem.data);
	        			$("#pgeothermwon").html(numberWithCommas(parseFloat(seriesItem.data)));
	        			break;		            			
            		}

				});

				$("#itotal").html(numberWithCommas(tot1));$("#itotwon").html(numberWithCommas(tot1won));
				$("#ptotal").html(numberWithCommas(tot2));$("#ptotwon").html(numberWithCommas(tot2won));
				
	            chart = new Highcharts.Chart(options);
	            chart = new Highcharts.Chart(options1);
	            
		    }
		});
		
		$.ajax({ 
		    type:"POST",  
		    url:"/pageEResourceGraph2.do?day1=" + $("#month-picker").val(),
		    dataType: 'json',
		    success:function(data){
	            $.each(data.series, function(i, seriesItem) {
	            	var series = {data: []};
	            	
	            	if (seriesItem.name == "A" || seriesItem.name == "B" ){
		                $.each(seriesItem.data, function(j, seriesItemData) {
		                	
		            		switch(seriesItem.name){
		            		case 'A':
		            			data11.push({y:parseFloat(seriesItemData)});
			            		break;
		            		case 'B':
		            			data22.push({y:parseFloat(seriesItemData)});
			            		break;
		            		}
		                });
	            	}
	            });
	            
	            chart = new Highcharts.Chart(options2);
	            
	            $.each(data.series, function(i, seriesItem) {
	            	var series = {data: []};
	            	
	            	if (seriesItem.name == "C" || seriesItem.name == "D" ){
		                $.each(seriesItem.data, function(j, seriesItemData) {
		                	
		            		switch(seriesItem.name){
		            		case 'C':
		            			data3.push({y:parseFloat(seriesItemData)});
			            		break;
		            		case 'D':
		            			data4.push({y:parseFloat(seriesItemData)});
			            		break;
		            		}
		                });
	            	}
	            });
	            
	            chart = new Highcharts.Chart(options3);
	            
	            $.each(data.series, function(i, seriesItem) {
	            	var series = {data: []};
	            	
	            	if (seriesItem.name == "E" || seriesItem.name == "F" ){
		                $.each(seriesItem.data, function(j, seriesItemData) {
		                	
		            		switch(seriesItem.name){
		            		case 'E':
		            			data5.push({y:parseFloat(seriesItemData)});
			            		break;
		            		case 'F': 
		            			data6.push({y:parseFloat(seriesItemData)});
			            		break;
		            		}
		                });
	            	}
	            });

	            chart = new Highcharts.Chart(options4);
		    }
		});
		
		$.ajax({ 
		    type:"POST",  
		    url:"/pageEResourceGraph3.do?day1=" + $("#month-picker1").val(),
		    dataType: 'json',
		    success:function(data){
	            $.each(data.series, function(i, seriesItem) {
	            	//console.log("1111111--->" + data);
	            	var series = {data: []};
	            	if (seriesItem.name == "A" || seriesItem.name == "B"
	            		|| seriesItem.name == "C" || seriesItem.name == "D"){
		                $.each(seriesItem.data, function(j, seriesItemData) {
		                	if (seriesItem.name == "A" ){
		                		data7.push({y:parseFloat(seriesItemData)});
		                	}else if (seriesItem.name == "B"){
		                		data8.push({y:parseFloat(seriesItemData)});
		                	}else if (seriesItem.name == "C"){
		                		data7.push({y:parseFloat(seriesItemData)});
		                	}else if (seriesItem.name == "D"){
		                		data8.push({y:parseFloat(seriesItemData)});
		                	}
		                	
		                });
	            	}else if(seriesItem.name == "E" || seriesItem.name == "F"){
		                $.each(seriesItem.data, function(j, seriesItemData) {
		                	if (seriesItem.name == "E" ){
		                		data9.push({y:parseFloat(seriesItemData)});
		                	}else if (seriesItem.name == "F"){
		                		data10.push({y:parseFloat(seriesItemData)});
		                	}
		                });
	            	}
	            });
	            
	            chart = new Highcharts.Chart(options5);
	            chart = new Highcharts.Chart(options6);
	            
		    }
		});
		
		$.ajax({ 
		    type:"POST",  
		    url:"/pageEResourceGraph4.do?day1=" + $("#month-picker1").val(),
		    dataType: 'json',
		    success:function(data){
		    	for(var i = 0; i < data.categories.length; i++) {
		    		options7.xAxis[0].categories.push(data.categories[i]);
		    	}

	            $.each(data.series, function(i, seriesItem) {
	                var series = { data: []	};
                	if (seriesItem.name == "A" ){
                		series.name = '전기사용량';
                	}else if (seriesItem.name == "B"){
                		series.name = '전기목표량';
                	}else if (seriesItem.name == "C"){
                		series.name = '가스사용량';
                	}else if (seriesItem.name == "D"){
                		series.name = '가스목표량';
                	}else if (seriesItem.name == "E"){
                		series.name = '유류사용량';
                	}else if (seriesItem.name == "F"){
                		series.name = '유류목표량';
                	}	                

	                series.color = seriesItem.color;

	                $.each(seriesItem.data, function(j, seriesItemData) {
	                	series.data.push(parseFloat(seriesItemData));
		                options7.series[i] = series;
	                });
	            });
	            
	            chart = new Highcharts.Chart(options7);
		    }
		});
	});

</script>
</body>
</html>