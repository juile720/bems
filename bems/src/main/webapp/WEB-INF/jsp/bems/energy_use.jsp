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
<link rel="stylesheet" type="text/css" href="/css/layout.css?ver=1">
<link rel="stylesheet" type="text/css" href="/css/common.css?ver=1">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css?ver=1">

<script src="http://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<script src="/js/wheather.js" charset="utf-8"></script><!-- 날씨 스크립트 -->

<script src="/highchart/highcharts.js"></script> <!-- 하이차트 스크립트 -->
<script src="/highchart/modules/exporting.js"></script>

<style> 
	.layerweek { display: none; width:200px; }
	.layerdate { display: none; width:120px; }
	.layer1week { display: none; width:200px; }
	.layer1date { display: none; width:120px; }
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
          <li class="active"><a href="#">에너지용도별</a> </li>
           <li> <a href="#" id="resource">에너지원별</a> </li>
          <li ><a href="#" id="facilities">에너지사용설비별</a> </li>  
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
          <li class="t14"> <span id="locationinfo"></span>/현재<br>습도 <span id="wetinfo"></span> </li>
        </ul>
      </div>
    </div>
  </div>
  <!-- //header --> 
  
  <!-- container -->
  <div id="container">
    <div class="grid_wrap ">
      <div class="brick01">
        <div class="grid_inner mg_b15 h490">
          <h2 class="t_04">에너지용도별 소비분석</h2>
          <div class="mg_t20 mg_l30">
          <span>건물 :</span>
            <div class="select-style">
              <select>
                <option value="본관">본관</option>
              </select>
            </div>
            <span class="mg_l10">기간 :</span>
            <div class="select-style">
              <select name='selecttop' id='selecttop'>
                <option value="1" selected="selected">월간</option>
                <option value="2">주간</option>
                <option value="3">일간</option>
              </select>
            </div>
            	<input type="text" id ="week-picker" class="layerweek">
	            <input type="text" id ="date-picker" class="layerdate">
<!--             
            <div class="select-style wt135">
            </div>
-->            
           <a href="#" class="btn_s" id="popstandard">기준값목록</a><a href="#" class="btn_s" id="pop_detailsearch1">상세조회</a> </div>
          <div class="both">
            <div class="fl l_01">
              <div class="box_type04"><!--  1920 일때 height: 330px; 3840 일때 height: 660px; <br>
                그래프색상 : 위에 선 #ffaa00 #26c4ff 네모그래프 #7cc576 #dbe7ad
                 -->
                 <div id="container1" style="height: 330px; margin: 0 auto"></div>
                 </div>
            </div>
            <div class="fr r_01 pd_l15">
              <div class="box_type04"> <!-- 1920 일때 height: 195px; 3840 일때 height: 390px;<br>
                냉방 : #3bafda / 난방 : #ffaa00 / 급탕 : #3ddcf7  / 환기 : #f5d14e / 조명 : #f15d45 / 콘센트 : #3ddcf7 -->
                <div id="container2" style="height: 330px; margin: 0 auto"></div> 
                </div>               
            </div>
          </div>
        </div>
      </div>
      <div class="brick02-l">
        <div class="grid_inner mg_b15 h455">
          <h2 class="t_04">단위면적당 소비량</h2>
          <div class="box_type06"> <!-- 1920 일때 height: 345px / 3840 일때 height: 700px; <br>
            그래프색상 : #05afb2 #f56954 -->
            <div id="container3" style="height: 345px; margin: 0 auto"></div>
            </div>
            <ul class="list_legend fr">
              <li><div class="em01"></div> 본관</li>
            </ul>
        </div>
      </div>
      <div class="brick02-r">
        <div class="grid_inner mg_l15 h455" >
          <h2 class="t_04">1인당 소비량</h2>
          <div class="box_type06"> <!--1920 일때 height: 345px / 3840 일때 height: 700px; <br>
            그래프색상 : #faba00 #3ca1d9 -->
            <div id="container4" style="height: 345px; margin: 0 auto"></div>
            </div>
            <ul class="list_legend fr">
              <li><div class="ye02"></div> 본관</li>
            </ul>
        </div>
      </div>
    </div>
  </div>
</div>
<script src="/js/common.js" charset="utf-8"></script>
<%@ include file="/WEB-INF/include/include-body.jspf" %>

<script type="text/javascript">
	
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
	
	$("#popstandard").on("click", function(e){ 
	    e.preventDefault();
	    fn_popstandard();
	});
	
	function fn_popstandard(){
    	var settings ='toolbar=0,directories=0,status=no,menubar=0,scrollbars=no,resizable=no,height=250,width=850,left=0,top=0';
    	winObject = window.open("/data/pop_standard.do", "기준값목록", settings);
    }
	
	$("#pop_detailsearch1").on("click", function(e){ 
	    e.preventDefault();
	    fn_pop_detailsearch1();
	});
	
	function fn_pop_detailsearch1(){
    	var settings ='toolbar=0,directories=0,status=no,menubar=0,scrollbars=yes,resizable=no,height=500,width=450,left=0,top=0';
    	winObject = window.open("/data/pop_detailsearch1.do", "상세조회1", settings);
    }
	
	$("#pop_trendLog").on("click", function(e){ 
	    e.preventDefault();
	    fn_pop_trendLog();
	});
	
	function fn_pop_trendLog(){
		var settings ='toolbar=0,directories=0,status=no,menubar=0,scrollbars=yes,resizable=no,height=500,width=850,left=0,top=0';
		winObject = window.open("/data/pop_trendLog.do", "사용실비누적비교", settings);
	}
	
	$(function() {
	    var startDate;
	    var endDate;
	    
	    $('#week-picker').datepicker( {
		    dateFormat: 'yy-mm-dd',
		    prevText: '이전 달',
		    nextText: '다음 달',
		    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		    dayNames: ['일','월','화','수','목','금','토'],
		    dayNamesShort: ['일','월','화','수','목','금','토'],
		    dayNamesMin: ['일','월','화','수','목','금','토'],
		    showMonthAfterYear: true,
		    changeMonth: true,
		    changeYear: true,
		    yearSuffix: '년',
		    
	        showOtherMonths: true,
	        selectOtherMonths: true,
			selectWeek:true,
	        onSelect: function(dateText, inst) { 
	            var date = $(this).datepicker('getDate');
	            //startDate = new Date(date.getFullYear(), date.getMonth(), date.getDate() - date.getDay() + 1);
	            startDate = new Date(date.getFullYear(), date.getMonth(), date.getDate() - date.getDay());
	            //endDate = new Date(date.getFullYear(), date.getMonth(), date.getDate() - date.getDay() + 5);
	            endDate = new Date(date.getFullYear(), date.getMonth(), date.getDate() - date.getDay() + 6);
				var dateFormat = 'yy/mm/dd'
	            startDate = $.datepicker.formatDate( dateFormat, startDate, inst.settings );
	            endDate = $.datepicker.formatDate( dateFormat, endDate, inst.settings );
	
				$('#week-picker').val(startDate + ' ~ ' + endDate);
	            
				$.ajax({ 
				    type:"POST",  
				    url:"/pageEnergyGraph.do?gb=2&day1="+startDate+"&day2="+endDate,
				    dataType: 'json',
				    success:function(data){
				    	options.xAxis[0].categories = [];
				    	for(var i = 0; i < data.categories.length; i++) {
				    		options.xAxis[0].categories.push(data.categories[i]);
				    	}
				    	data1=[], data2=[], data3=[];
			            $.each(data.series, function(i, seriesItem) {
			            	var series = { data: []	};
			            	
			            	if (seriesItem.name == "p1" || seriesItem.name == "p2" || seriesItem.name == "p3" 
			            		|| seriesItem.name == "p4" || seriesItem.name == "p5" || seriesItem.name == "p6"){

				                $.each(seriesItem.data, function(j, seriesItemData) {
				            		switch(seriesItem.name){
				            		case 'p1': 
				            			data1.push({name:'냉방',y:parseFloat(seriesItemData)});
					            		break;
				            		case 'p2':
				            			data1.push({name:'난방',y:parseFloat(seriesItemData)});
				            			break;
				            		case 'p3': 
				            			data1.push({name:'급탕',y:parseFloat(seriesItemData)});
				            			break;		            			
				            		case 'p4':
				            			data1.push({name:'환기',y:parseFloat(seriesItemData)});
			            				break;		            		
				            		case 'p5':
				            			data1.push({name:'조명',y:parseFloat(seriesItemData)});
			            				break;		            		
				            		case 'p6':
				            			data1.push({name:'콘센트',y:parseFloat(seriesItemData)});
			            				break;		            		
				            		}
				                });
			            	}else if (seriesItem.name == "g1" || seriesItem.name == "g2" || seriesItem.name == "g3" 
			            		|| seriesItem.name == "g4" || seriesItem.name == "g5" || seriesItem.name == "g6"){
				                $.each(seriesItem.data, function(j, seriesItemData) {
				            		switch(seriesItem.name){
				            		case 'g1': 
				            			data2.push({name:'냉방',y:parseFloat(seriesItemData)});
				            			data3.push({name:'냉방',y:parseFloat(seriesItemData) / 100});
					            		break;
				            		case 'g2':
				            			data2.push({name:'난방',y:parseFloat(seriesItemData)});
				            			data3.push({name:'난방',y:parseFloat(seriesItemData) / 100});
				            			break;
				            		case 'g3': 
				            			data2.push({name:'급탕',y:parseFloat(seriesItemData)});
				            			data3.push({name:'급탕',y:parseFloat(seriesItemData) / 100});
				            			break;		            			
				            		case 'g4':
				            			data2.push({name:'환기',y:parseFloat(seriesItemData)});
				            			data3.push({name:'환기',y:parseFloat(seriesItemData) / 100});
			            				break;		            		
				            		case 'g5':
				            			data2.push({name:'조명',y:parseFloat(seriesItemData)});
				            			data3.push({name:'조명',y:parseFloat(seriesItemData) / 100});
			            				break;		            		
				            		case 'g6':
				            			data2.push({name:'콘센트',y:parseFloat(seriesItemData)});
				            			data3.push({name:'콘센트',y:parseFloat(seriesItemData) / 100});
			            				break;		            		
				            		}
				                });
			            	}else {
				                series.name = seriesItem.name;
				                series.color = seriesItem.color;
				                series.type = seriesItem.type;

				                $.each(seriesItem.data, function(j, seriesItemData) {
				                    series.data.push(parseFloat(seriesItemData));
				                });
				                options.series[i] = series;	 
			            	}

			            });
			            
			            chart = new Highcharts.Chart(options);
			            chart = new Highcharts.Chart(options1);
			            chart = new Highcharts.Chart(options2);
			            chart = new Highcharts.Chart(options3);
				    }
				});
	            setTimeout("applyWeeklyHighlight()", 100);
	        },
			beforeShow : function() {
				setTimeout("applyWeeklyHighlight()", 100);
			}
	    });
	    
		$("#date-picker").datepicker({
		    dateFormat: 'yy-mm-dd',
		    prevText: '이전 달',
		    nextText: '다음 달',
		    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		    dayNames: ['일','월','화','수','목','금','토'],
		    dayNamesShort: ['일','월','화','수','목','금','토'],
		    dayNamesMin: ['일','월','화','수','목','금','토'],
		    showMonthAfterYear: true,
		    changeMonth: true,
		    changeYear: true,
		    yearSuffix: '년',
	        onSelect: function(dateText, inst) { 
	            var date = $(this).datepicker('getDate');
	            date = new Date(date.getFullYear(), date.getMonth(), date.getDate());
				var dateFormat = 'yy/mm/dd'
		        date = $.datepicker.formatDate( dateFormat, date, inst.settings );
				$('#date-picker').val(date);
	            
				$.ajax({ 
				    type:"POST",  
				    url:"/pageEnergyGraph.do?gb=3&day1="+date,
				    dataType: 'json',
				    success:function(data){
				    	options.xAxis[0].categories = [];
				    	for(var i = 0; i < data.categories.length; i++) {
				    		options.xAxis[0].categories.push(data.categories[i]);
				    	}
				    	data1=[], data2=[], data3=[];
			            $.each(data.series, function(i, seriesItem) {
			            	var series = { data: []	};
			            	
			            	if (seriesItem.name == "p1" || seriesItem.name == "p2" || seriesItem.name == "p3" 
			            		|| seriesItem.name == "p4" || seriesItem.name == "p5" || seriesItem.name == "p6"){

				                $.each(seriesItem.data, function(j, seriesItemData) {
				            		switch(seriesItem.name){
				            		case 'p1': 
				            			data1.push({name:'냉방',y:parseFloat(seriesItemData)});
					            		break;
				            		case 'p2':
				            			data1.push({name:'난방',y:parseFloat(seriesItemData)});
				            			break;
				            		case 'p3': 
				            			data1.push({name:'급탕',y:parseFloat(seriesItemData)});
				            			break;		            			
				            		case 'p4':
				            			data1.push({name:'환기',y:parseFloat(seriesItemData)});
			            				break;		            		
				            		case 'p5':
				            			data1.push({name:'조명',y:parseFloat(seriesItemData)});
			            				break;		            		
				            		case 'p6':
				            			data1.push({name:'콘센트',y:parseFloat(seriesItemData)});
			            				break;		            		
				            		}
				                });
			            	}else if (seriesItem.name == "g1" || seriesItem.name == "g2" || seriesItem.name == "g3" 
			            		|| seriesItem.name == "g4" || seriesItem.name == "g5" || seriesItem.name == "g6"){
				                $.each(seriesItem.data, function(j, seriesItemData) {
				            		switch(seriesItem.name){
				            		case 'g1': 
				            			data2.push({name:'냉방',y:parseFloat(seriesItemData)});
				            			data3.push({name:'냉방',y:parseFloat(seriesItemData) / 100});
					            		break;
				            		case 'g2':
				            			data2.push({name:'난방',y:parseFloat(seriesItemData)});
				            			data3.push({name:'난방',y:parseFloat(seriesItemData) / 100});
				            			break;
				            		case 'g3': 
				            			data2.push({name:'급탕',y:parseFloat(seriesItemData)});
				            			data3.push({name:'급탕',y:parseFloat(seriesItemData) / 100});
				            			break;		            			
				            		case 'g4':
				            			data2.push({name:'환기',y:parseFloat(seriesItemData)});
				            			data3.push({name:'환기',y:parseFloat(seriesItemData) / 100});
			            				break;		            		
				            		case 'g5':
				            			data2.push({name:'조명',y:parseFloat(seriesItemData)});
				            			data3.push({name:'조명',y:parseFloat(seriesItemData) / 100});
			            				break;		            		
				            		case 'g6':
				            			data2.push({name:'콘센트',y:parseFloat(seriesItemData)});
				            			data3.push({name:'콘센트',y:parseFloat(seriesItemData) / 100});
			            				break;		            		
				            		}
				                });
			            	}else {
				                series.name = seriesItem.name;
				                series.color = seriesItem.color;
				                series.type = seriesItem.type;

				                $.each(seriesItem.data, function(j, seriesItemData) {
				                    series.data.push(parseFloat(seriesItemData));
				                });
				                options.series[i] = series;	 
			            	}

			            });
			            
			            chart = new Highcharts.Chart(options);
			            chart = new Highcharts.Chart(options1);
			            chart = new Highcharts.Chart(options2);
			            chart = new Highcharts.Chart(options3);
				    }
				});
	            setTimeout("applyWeeklyHighlight()", 100);
	        },
		});
	});
	
	function applyWeeklyHighlight() {
		
		$('.ui-datepicker-calendar tr').each(function() {
	
			if ($(this).parent().get(0).tagName == 'TBODY') {
				$(this).mouseover(function() {
					$(this).find('a').css({
						'background' : '#ffffcc',
						'border' : '1px solid #191c1a'
					});
					$(this).find('a').removeClass('ui-state-default');
					$(this).css('background', '#ffffcc');
				});
				
				$(this).mouseout(function() {
					$(this).css('background', '#f2f2f2');
					$(this).find('a').css('background', '');
					$(this).find('a').addClass('ui-state-default');
				});
			}
	
		});
	}
	
	$('#selecttop').change(function() {
		var state = jQuery('#selecttop option:selected').val();
		if(state == '1') {
			jQuery('.layerweek').hide();
			jQuery('.layerdate').hide();
		}else if(state == '2') {
			jQuery('.layerweek').show();
			jQuery('.layerdate').hide();
		} else if(state == '3') {
			jQuery('.layerdate').show();
			jQuery('.layerweek').hide();
		}
	});

	var data1=[], data2=[], data3=[];

	var options = {
		    chart: {
		        zoomType: 'xy'
				,renderTo: 'container1'
				,marginTop: 30
				,marginRight: 230
				,marginBottom: 35
				,backgroundColor :'#f2f2f2'
		    },
			credits: {
				enabled: false
			},
			title: {
				text: '',
				x: -20 //center
			},
			subtitle: {
				text: '',
				x: -20
			},
		    xAxis: [{
		        categories: [],
		        crosshair: true,
	            labels: {
	                style: {
	                    color: 'black'
	                }
	            }
		    }],

		    yAxis: [{ // Primary yAxis
		        labels: {
		            format: '{value}'
		        },
		        title: {
		            text: '사용량(kWh)',
		            style: {
		                color: Highcharts.getOptions().colors[2]
		            }
		        },
		        opposite: true

		    }, { // Secondary yAxis
		        gridLineWidth: 0,
		        title: {
		            text: '외기온도 (°C)',
		            style: {
		                color: Highcharts.getOptions().colors[0]
		            }
		        },
		        labels: {
		            format: '{value} kWh',
		            style: {
		                color: Highcharts.getOptions().colors[0]
		            }
		        }

		    }, { // Tertiary yAxis
		        gridLineWidth: 0,
		        title: {
		            text: '외기습도(%)',
		            style: {
		                color: Highcharts.getOptions().colors[7]
		            }
		        },
		        labels: {
		            format: '{value} %',
		            style: {
		                color: Highcharts.getOptions().colors[7]
		            }
		        },
		        opposite: true
		    }],

			tooltip: {
		        shared: true
		    },

			legend: {
				layout: 'vertical',//'horizontal',
				align: 'right',
				x: -10,
				verticalAlign: 'top',
				y: 5,
				floating: false,// true,
				backgroundColor :'#f2f2f2',
				itemStyle:{color:'#0b4a45'}
				//backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#f2f2f2'
			},
			exporting: {
	            enabled: false
	        },
			series: []
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
		        ,backgroundColor :'#f2f2f2'
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
		        	size: '85%',
	                dataLabels: {
	                	format: '<b>{point.name}</b>: {point.percentage:.1f} %',
	                    distance: -45,
	                    color: "f2f2f2"
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
		        zoomType: 'xy'
				,renderTo: 'container3'
				,marginTop: 30
				,marginRight: 80
				,marginBottom: 25
				,backgroundColor :'#f2f2f2'
				,type:"column"
		    },
			credits: {
				enabled: false
			},
		    title: {
		        text: ''
		    },
		    xAxis: [{
		        categories: ['냉/난방','급탕','환기','조명','콘센트'],
		        crosshair: true,
	            labels: {
	                style: {
	                    color: 'black'
	                }
	            }
		    }],
		    yAxis: {
		        min: 0,
		        title: {
		            text: '단위면적당소비량 (kWh/㎥)'
		        }
		    },
		    tooltip: {
		        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
		        pointFormat: '<tr>' +
		            '<td style="padding:0"><b>{point.y:.1f} (kWh/㎥)</b></td></tr>',
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
/* 			legend: {
				layout: 'vertical',//'horizontal',
				align: 'right',
				x: 10,
				verticalAlign: 'top',
				y: 55,
				floating: true,// true,
				backgroundColor :'#f2f2f2',
				itemStyle:{color:'#0b4a45'}
			}, */
			exporting: {
	            enabled: false
	        },
		    series:[{showInLegend: false,data:data2}]
		    
		}
	
	var options3 = {
		    chart: {
		        zoomType: 'xy'
				,renderTo: 'container4'
				,marginTop: 30
				,marginRight: 80
				,marginBottom: 25
				,backgroundColor :'#f2f2f2'
				,type:"column"
		    },
			credits: {
				enabled: false
			},
		    title: {
		        text: ''
		    },
		    xAxis: [{
		        categories: ['냉/난방','급탕','환기','조명','콘센트'],
		        crosshair: true,
	            labels: {
	                style: {
	                    color: 'black'
	                }
	            }
		    }],
		    yAxis: {
		        min: 0,
		        title: {
		            text: '1인당소비량 (kWh/인)'
		        }
		    },
		    tooltip: {
		        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
		        pointFormat: '<tr>' +
		            '<td style="padding:0"><b>{point.y:.1f} (kWh/인)</b></td></tr>',
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
/* 			legend: {
				layout: 'vertical',//'horizontal',
				align: 'right',
				x: 10,
				verticalAlign: 'top',
				y: 55,
				floating: true,// true,
				backgroundColor :'#f2f2f2',
				itemStyle:{color:'#0b4a45'}
			}, */
			exporting: {
	            enabled: false
	        },
		    series:[{showInLegend: false,data:data3}]
		    
		}
	jQuery(function($){

		$.ajax({ 
		    type:"POST",  
		    url:"/pageEnergyGraph.do?gb=1",
		    dataType: 'json',
		    success:function(data){
		    	options.xAxis[0].categories = [];
		    	for(var i = 0; i < data.categories.length; i++) {
		    		options.xAxis[0].categories.push(data.categories[i]);
		    	}
	
	            $.each(data.series, function(i, seriesItem) {
	            	var series = { data: []	};
	            	
	            	if (seriesItem.name == "p1" || seriesItem.name == "p2" || seriesItem.name == "p3" 
	            		|| seriesItem.name == "p4" || seriesItem.name == "p5" || seriesItem.name == "p6"){

		                $.each(seriesItem.data, function(j, seriesItemData) {
		            		switch(seriesItem.name){
		            		case 'p1': 
		            			data1.push({name:'냉난방',y:parseFloat(seriesItemData)});
			            		break;
/* 		            		case 'p2':
		            			data1.push({name:'난방',y:parseFloat(seriesItemData)});
		            			break; */
		            		case 'p3': 
		            			data1.push({name:'급탕',y:parseFloat(seriesItemData)});
		            			break;		            			
		            		case 'p4':
		            			data1.push({name:'환기',y:parseFloat(seriesItemData)});
	            				break;		            		
		            		case 'p5':
		            			data1.push({name:'조명',y:parseFloat(seriesItemData)});
	            				break;		            		
		            		case 'p6':
		            			data1.push({name:'콘센트',y:parseFloat(seriesItemData)});
	            				break;		            		
		            		}
		                });
	            	}else if (seriesItem.name == "g1" || seriesItem.name == "g2" || seriesItem.name == "g3" 
	            		|| seriesItem.name == "g4" || seriesItem.name == "g5" || seriesItem.name == "g6"){
		                $.each(seriesItem.data, function(j, seriesItemData) {
		            		switch(seriesItem.name){
		            		case 'g1': 
		            			data2.push({name:'냉난방',y:parseFloat(seriesItemData)});
		            			data3.push({name:'냉난방',y:parseFloat(seriesItemData) / 100});
			            		break;
/* 		            		case 'g2':
		            			data2.push({name:'난방',y:parseFloat(seriesItemData)});
		            			data3.push({name:'난방',y:parseFloat(seriesItemData) / 100});
		            			break; */
		            		case 'g3': 
		            			data2.push({name:'급탕',y:parseFloat(seriesItemData)});
		            			data3.push({name:'급탕',y:parseFloat(seriesItemData) / 100});
		            			break;		            			
		            		case 'g4':
		            			data2.push({name:'환기',y:parseFloat(seriesItemData)});
		            			data3.push({name:'환기',y:parseFloat(seriesItemData) / 100});
	            				break;		            		
		            		case 'g5':
		            			data2.push({name:'조명',y:parseFloat(seriesItemData)});
		            			data3.push({name:'조명',y:parseFloat(seriesItemData) / 100});
	            				break;		            		
		            		case 'g6':
		            			data2.push({name:'콘센트',y:parseFloat(seriesItemData)});
		            			data3.push({name:'콘센트',y:parseFloat(seriesItemData) / 100});
	            				break;		            		
		            		}
		                });
	            	}else {
		                series.name = seriesItem.name;
		                series.color = seriesItem.color;
		                series.type = seriesItem.type;

		                $.each(seriesItem.data, function(j, seriesItemData) {
		                    series.data.push(parseFloat(seriesItemData));
		                });
		                options.series[i] = series;	 
	            	}

	            });
	            	            
	            chart = new Highcharts.Chart(options);
	            chart1 = new Highcharts.Chart(options1);
	            chart2 = new Highcharts.Chart(options2);
	            chart3 = new Highcharts.Chart(options3);
	            
		    }
		});
		
		//setTimeout("location.reload()",150000);
	});
	
</script>
</body>
</html>