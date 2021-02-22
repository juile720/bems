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
<link rel="stylesheet" type="text/css" href="/css/layout.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

<script src="http://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<script src="/js/wheather.js" charset="utf-8"></script><!-- 날씨 스크립트 -->
<script src="/js/xbim/xbim-viewer.debug.bundle.js"></script>

<script src="/highchart/highcharts.js"></script> <!-- 하이차트 스크립트 -->
<script src="/highchart/modules/exporting.js"></script>

<style type="text/css"> 
	.layerweek { display: none; width:200px; }
	.layerdate { display: none; width:120px; }
	.layer1week { display: none; width:200px; }
	.layer1date { display: none; width:120px; }
    #viewer{z-index:9}
    #viewer,#viewerText{position:relative}
    #viewerText{margin-top:-150px;z-index:999999;}
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
          <li class="active"><a href="#">메인화면</a> </li>
          <li> <a href="#" id="use" >에너지용도별</a> </li>
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
          <li class="t14"> <span id="locationinfo"></span>/현재<br>습도 <span id="wetinfo"></span>% </li>
        </ul>
      </div>
    </div>
  </div>
  <!-- //header --> 
  
  <!-- container -->
  <div id="container">
    <div class="grid_wrap ">
      <div class="brick01">
        <div class="grid_inner mg_b15 h270">
          <div class="both">
            <div class="t_01 title fl">
              <select name='selecttop' id='selecttop'>
                <option value="1" selected="selected">에너지별 사용현황(월간)</option>
                <option value="2">에너지별 사용현황(주간)</option>
                <option value="3">에너지별 사용현황(일간)</option>
              </select>
              
            </div>
            
            <input type="text" id ="week-picker" class="layerweek">
            <input type="text" id ="date-picker" class="layerdate">
            <div class="fr">
              <ul class="list_legend">
                <li><div class="gre"></div>전기</li>
                <li><div class="ye"></div>가스</li>
                <li><div class="sk"></div>수도</li>
              </ul>
            </div>
          </div>
          <div class="box_type01"> 
          <!-- 1920 일때 height: 195px; / 전기 : #a3fe00 / 가스 : #ffc600 / 수도 : #3ddcf7 <br>
            3840 일때 height: 390px;
             -->
				<div id="container1" style="height: 195px; margin: 0 auto"></div>
        	</div>
        </div>
      </div>
      <div class="brick01-l">
        <div class="grid_inner mg_b15 h330">
          <div class="both">
            <div class="t_02 title fl">
              <select name='selectmid' id='selectmid'>
                <option value="1" selected="selected">에너지용도별 사용현황(월간)</option> 
                <option value="2" >에너지용도별 사용현황(주간)</option>
                <option value="3">에너지용도별 사용현황(일간)</option>
              </select>
            </div>
            
            <input type="text" id ="week-picker1" class="layer1week">
            <input type="text" id ="date-picker1" class="layer1date">
            
            <div class="fr">
              <ul class="list_legend">
                <li>
                 <div class="sk"></div>냉난방</li> 
                <li><div class="em"></div>급탕</li>
                <li><div class="pe"></div>환기</li>
            	<li><div class="pi"></div>조명</li> 
                <li><div class="or"></div> 콘센트</li>
              </ul>
            </div>
          </div>
          <div class="box_type02">
			<div id="container2" style="height: 260px; margin: 0 auto"></div>
           <!-- 1920 일때 height: 195px; / 냉방 : #3bafda / 난방 : #ffaa00 / 급탕 : #3ddcf7  / 환기 : #a3fe00 / 조명 : #ffc600 / 콘센트 : #3ddcf7 <br>
            3840 일때 height: 390px;
             --> 

            </div>
        </div>
        <div class="grid_inner h330">
          <div class="both">
            <div class="t_03 title fl">
              <select >
                <option selected>에너지 성능평가</option>
<!--                 <option>옵션1</option>
                <option>옵션2</option>
                <option>옵션3</option>
 -->
              </select>
            </div>
            <div class="fr">
              <ul class="list_legend">
                <li><div class="em"></div>정상</li>
                <li><div class="gr"></div>주의</li>
                <li><div class="sk01"></div> 위험</li>
              </ul>
            </div>
          </div>
          <div class="box_type02"> 
          <!--  1920 일때 height: 255px; / 정상 : #00b19d / 주의 : #dcdcdc / 위험 : #3bafda<br>
            3840 일때 height: 510px; -->
			<div id="container3" style="height: 255px; margin: 0 auto"></div>
          </div>
        </div>
      </div>
      <div class="brick01-r">
        <div class="grid_inner mg_l15 h675" >
          <h2 class="t_04 fl">층별관리</h2>
          <div><!--<a href="url"> 
           <img src="img/building.png" border="0"></a> -->
          	<div id="group0">
				<canvas id="viewer0" width="600" height="600"></canvas>
				<div id="viewerText" style="width:100px;height:30px"></div>
				<script type="text/javascript">
					var viewer0 = new xViewer('viewer0');
					viewer0.load('/xbim/total.wexBIM');
					viewer0.start();
				</script>
			</div>
          </div>
          <div class="btn"><a href="#" class="btn_b" id="floor" >층별상세조회(Kwh)</a><a href="#"  class="btn_b">층별사용량비중(%)</a> </div>
        </div>
      </div>
    </div>
  </div>
</div>
<script src="/js/common.js" charset="utf-8"></script>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
<script type="text/javascript">
	var gb = null;
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
		    yearSuffix: '년'
		});
		
	    $('#week-picker1').datepicker( {
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
	            startDate = new Date(date.getFullYear(), date.getMonth(), date.getDate() - date.getDay());
	            endDate = new Date(date.getFullYear(), date.getMonth(), date.getDate() - date.getDay() + 6);
				var dateFormat = 'yy/mm/dd'
	            startDate = $.datepicker.formatDate( dateFormat, startDate, inst.settings );
	            endDate = $.datepicker.formatDate( dateFormat, endDate, inst.settings );
	
				$('#week-picker1').val(startDate + ' ~ ' + endDate);
 	            gb = "2";
 	          
 	           	midgraph(gb, startDate, endDate);

 	           	setTimeout("applyWeeklyHighlight()", 100);
	        },
			beforeShow : function() {
				setTimeout("applyWeeklyHighlight()", 100);
			}
	    });
	    
		$("#date-picker1").datepicker({
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
		    selectDate:false,
	        onSelect: function(dateText, inst) { 
	            var date = $(this).datepicker('getDate');
	            var dateFormat = 'yy/mm/dd'
	            startDate = new Date(date.getFullYear(), date.getMonth(), date.getDate());
	            startDate = $.datepicker.formatDate( dateFormat, startDate, inst.settings );
	            $('#date-picker1').val(startDate);

 	            gb = "3";
 	           	midgraph(gb, startDate, "");

 	           	setTimeout("applyWeeklyHighlight()", 100);
	        },
			beforeShow : function() {
				setTimeout("applyWeeklyHighlight()", 100);
			}
		});
	});
	
	function applyWeeklyHighlight() {
	
		$('.ui-datepicker-calendar tr').each(function() {
	
			if ($(this).parent().get(0).tagName == 'TBODY') {
				$(this).mouseover(function() {
					$(this).find('a').css({
						'background' : '#ffffcc',
						'border' : '1px solid #dddddd'
					});
					$(this).find('a').removeClass('ui-state-default');
					$(this).css('background', '#ffffcc');
				});
				
				$(this).mouseout(function() {
					$(this).css('background', '#ffffff');
					$(this).find('a').css('background', '');
					$(this).find('a').addClass('ui-state-default');
				});
			}
	
		});
	}
	
	function getGraphData() {
		
		$.ajax({ 
		    type:"POST",  
		    url:"/pagetopGraph.do",
		    dataType: 'json',
		    success:function(data){
		    	console.log(data);
		    	var result = data.categories;
		    	options.xAxis.categories = JSON.parse(result); //"'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'";
	
	            $.each(data.series, function(i, seriesItem) {
	                console.log(i + " " + seriesItem) ;
	                var series = { data: []	};
	                
	                series.name = seriesItem.name;
	                series.color = seriesItem.color;
	                series.type = seriesItem.type;

	                $.each(seriesItem.data, function(j, seriesItemData) {
	                    series.data.push(parseFloat(seriesItemData));
	                });

	                options.series[i] = series;
	            });
	            
	            chart = new Highcharts.Chart(options);
	            
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

	$('#selectmid').change(function() {
		var state = jQuery('#selectmid option:selected').val();
		if(state == '1') {
			jQuery('.layer1week').hide();
			jQuery('.layer1date').hide();
			
		}else if(state == '2') {
			jQuery('.layer1week').show();
			jQuery('.layer1date').hide();
		} else if(state == '3') {
			jQuery('.layer1date').show();
			jQuery('.layer1week').hide();
		}
	});
	
	var options = {
	    chart: {
	        zoomType: 'xy'
			,renderTo: 'container1'
			,marginTop: 30
			,marginRight: 70
			,marginBottom: 25
			,backgroundColor :'#323b44'
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
	        categories: [],//['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
	        crosshair: true,
            labels: {
                style: {
                    color: 'white'
                }
            }
	    }],

	    yAxis: [{ // Primary yAxis
	        title: {
	            text: '전기'
//	            ,
//	            style: {
//	                color: Highcharts.getOptions().colors[0]
//	            }
	        },
	        labels: {
	            format: '{value} KWH'
//	            ,
//	            style: {
//	                color: Highcharts.getOptions().colors[0]
//	            }
	        },

	        opposite: true

	    }, { // Secondary yAxis
	        gridLineWidth: 0,
	        title: {
	            text: '가스'
//	            ,
//	            style: {
//	                color: Highcharts.getOptions().colors[1]
//	            }
	        },
	        labels: {
	            format: '{value} ㎥'
//	            ,
//	            style: {
//	                color: Highcharts.getOptions().colors[1]
//	            }
	        },opposite: true
		}, { // 3th yAxis
	        gridLineWidth: 0,
	        title: {
	            text: '수도'
//	            ,
//	            style: {
//	                color: Highcharts.getOptions().colors[2]
//	            }
	        },
	        labels: {
	            format: '{value}㎥'
//	            ,
//	            style: {
//	                color: Highcharts.getOptions().colors[2]
//	            }
	        },opposite: true
		}
	    ],

		tooltip: {
	        shared: true
	    },

		legend: {
			layout: 'horizontal',//'vertical',
			align: 'right',
			x: 580,
			verticalAlign: 'top',
			y: 55,
			floating: false,// true,
			backgroundColor :'#323b44',
			itemStyle:{color:'#f0f0f0'}
			//backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
		},
		exporting: {
            enabled: false
        },
		series: []
	}
	
	var options1 = {
	    chart: {
	        zoomType: 'xy'
			,renderTo: 'container2'
			,marginTop: 30
			,marginRight: 70
			,marginBottom: 25
			,backgroundColor :'#323b44'
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
            	format: '{value}',
                style: {
                    color: 'white'
                }
            }
	    }],
	    yAxis: {
	        min: 0,
            labels: {
            	format: '{value} Kwh',
                style: {
                    color: 'white'
                }
            },
            title: {
                text: null
            }
	    },
		tooltip: {
			shared: true,
			crosshairs: true,
			valueSuffix: 'Kwh' // '\xB0C'
	    },
		legend: {
			layout: 'horizontal',//'vertical',
			align: 'right',
			x: 580,
			verticalAlign: 'top',
			y: 55,
			floating: true,// true,
			backgroundColor :'#323b44',
			itemStyle:{color:'#f0f0f0'}
			//backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
		},
		exporting: {
            enabled: false
        },
		series: []
	}

	var data1=[];
	
	var options2 = {
	    chart: {
	        type: 'bar'
			,renderTo: 'container3'
			,marginTop: 30
			,marginRight: 70
			,marginBottom: 25
			,backgroundColor :'#323b44'
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
	        categories: ['냉/난방', '급탕', '환기', '조명', '콘센트'],
            labels: {
                style: {
                    color: 'white'
                }
            }
	    }],
	    yAxis: {
	        min: 0,
            labels: {
//            	formatter: function() {
//                    return 1000; // parseInt((this.value  * this.value ) + 1);
//                 },
                style: {
                    color: 'white'
                }
            }
	    },
		tooltip: {
			formatter:function(){
                console.log(this);
                // return 'x value: ' + this.key + ' y value ' + this.y;
                return ' ' + this.key + ' : ' + this.y + ' Kwh';
            } 
/*,
	    
			shared: true,
			crosshairs: true,
			valueSuffix: 'Kwh' // '\xB0C'
*/
	    },
/* 		legend: {
			reversed: true
		}, */
		exporting: {
            enabled: false
        },
		series: []
	}
	
	jQuery(function($){
		gb = "1"; 

		$.ajax({ 
		    type:"POST",  
		    url:"/pagetopGraph.do",
		    dataType: 'json',
		    success:function(data){
		    	options.xAxis[0].categories = [];
		    	for(var i = 0; i < data.categories.length; i++) {
		    		options.xAxis[0].categories.push(data.categories[i]);
		    	}

	
	            $.each(data.series, function(i, seriesItem) {
	                var series = { data: []	};
	                
	                series.name = seriesItem.name;
	                series.color = seriesItem.color;
	                series.type = seriesItem.type;

	                $.each(seriesItem.data, function(j, seriesItemData) {
	                    series.data.push(parseFloat(seriesItemData));
	                });

	                options.series[i] = series;
	            });
	            
	            chart = new Highcharts.Chart(options);
	            
		    }
		}); 
		
 		//midgraph(gb, "", "");
		//midgraph(gb, "2018/08/12", "2018/08/18");
		
		$.ajax({ 
		    type:"POST",  
		    url:"/pagebottomGraph.do",
		    dataType: 'json',

		    success:function(data){

            	var color1 = '#00b19d', color2 = '#f0f0f0', color3 = '#3baeda';
            	var total;
            	var series = {showInLegend:false,data:[]};
            	
            	$.each(data.series, function(i, seriesItem) {
            		console.log(seriesItem.name);
            		if(seriesItem.name == "total"){
	                	$.each(seriesItem.data, function(j, seriesItemData) {
	                		total = parseFloat(seriesItemData);
	                	});
	                }
            	});
            	
            	$.each(data.series, function(i, seriesItem) {
            		if(seriesItem.name != "total"){
	            		$.each(seriesItem.data, function(j, seriesItemData) {
	                        series.data.push(parseFloat(seriesItemData));
	                        var avg = (parseFloat(seriesItemData)/total * 100)  / 1067;
	                        
	                        if (i ==0){
		    		            if (avg < 24.2){series.color = color1;}
		    		            else if (avg > 24.1 && avg < 44.2){series.color = color2;}
		    		            else if (avg > 44.1){series.color = color3;}
	                        }else if(i == 1){
		    		            if (avg < 22.2){series.color = color1;}
		    		            else if (avg > 22.1 && avg < 42.2){series.color = color2;}
		    		            else if (avg > 42.1){series.color = color3;}
	                        }else if(i == 2){
		    		            if (avg < 3.3){series.color = color1;}
		    		            else if (avg > 3.4 && avg < 43.4){series.color = color2;}
		    		            else if (avg > 43.3){series.color = color3;}
	                        }else if(i == 3){
		    		            if (avg < 15.3){series.color = color1;}
		    		            else if (avg > 15.2 && avg < 65.4){series.color = color2;}
		    		            else if (avg > 65.3){series.color = color3;}
	                        }else if(i == 4){
		    		            if (avg < 15.2){series.color = color1;}
		    		            else if (avg > 15.1 && avg < 65.4){series.color = color2;}
		    		            else if (avg > 65.3){series.color = color3;}
	                        }/* else if(i == 5){
		    		            if (avg < 15.3){series.color = color1;}
		    		            else if (avg > 15.2 && avg < 65.4){series.color = color2;}
		    		            else if (avg > 65.3){series.color = color3;}
	                        } */
	                        options2.series[i] = series;
	                    });	                	
	                }
            	});

	            chart2 = new Highcharts.Chart(options2);
	            
		    }
		});
		
		//setTimeout("location.reload()",150000);
	});

	
	$("#use").on("click", function(e){ 
	    e.preventDefault();
	    fn_use();
	});
	
	function fn_use(){
	    var comSubmit = new ComSubmit();
	    comSubmit.setUrl("<c:url value='/data/energyUse.do' />");
	    comSubmit.submit();
	}
	
	$("#floor").on("click", function(e){ 
	    e.preventDefault();
	    fn_floor();
	});
	
	function fn_floor(floor){
	    var comSubmit = new ComSubmit();
	    comSubmit.setUrl("<c:url value='/data/floor.do' />");
	    comSubmit.addParam("C_FLOOR", floor);
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
	
	$("#pop_trendLog").on("click", function(e){ 
	    e.preventDefault();
	    fn_pop_trendLog();
	});
	
	function fn_pop_trendLog(){
		var settings ='toolbar=0,directories=0,status=no,menubar=0,scrollbars=yes,resizable=no,height=500,width=850,left=0,top=0';
		winObject = window.open("/data/pop_trendLog.do", "사용실비누적비교", settings);
	}
	
	function midgraph(gb, day1, day2){
		$.ajax({ 
		    type:"POST",  
		    url:"/totalmiddle.do?gb="+gb+"&day1="+day1+"&day2="+day2,
		    dataType: 'json',
		    success:function(data1){
		    	options1.xAxis[0].categories = [];
		    	for(var i = 0; i < data1.categories.length; i++) {
		    		options1.xAxis[0].categories.push(data1.categories[i]);
		    	}
		    	
	            $.each(data1.series, function(i, seriesItem) {
	                var series = { data: []	};
	                if (seriesItem.name == "1"){
	                	series.name = "냉난방";
	                }else if (seriesItem.name == "3"){
	                	series.name = "급탕";
	                }else if (seriesItem.name == "4"){
	                	series.name = "환기";
	                }else if (seriesItem.name == "5"){
	                	series.name = "조명";
	                }else if (seriesItem.name == "6"){
	                	series.name = "콘센트";
	                }
	                //series.name = seriesItem.name;
	                series.color = seriesItem.color;
	                series.type = seriesItem.type;

	                $.each(seriesItem.data, function(j, seriesItemData) {
	                    series.data.push(parseFloat(seriesItemData.toFixed(2)));
	                });

	                options1.series[i] = series;
	            });
	            
	            chart1 = new Highcharts.Chart(options1);
	            
		    }
		});
	}
</script>
</body>
</html>