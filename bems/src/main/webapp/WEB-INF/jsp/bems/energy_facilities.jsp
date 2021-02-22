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
<link rel="stylesheet" type="text/css" href="/css/layout.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

<script src="http://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<script src="/js/wheather.js" charset="utf-8"></script><!-- 날씨 스크립트 -->

<script src="/highchart/highcharts.js"></script> <!-- 하이차트 스크립트 -->
<script src="/highchart/modules/exporting.js"></script>

<style>
	.layermonth { display: none; width:80px; } 
	.layerweek { display: none; width:180px; }
	.hide-calendar .ui-datepicker-calendar {display: none;}
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
           <li class="active"><a href="#">에너지사용설비별</a> </li>  
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
      <div class="brick01-l">
        <div class="grid_inner mg_b15 h472">
           <h2 class="t_04">에너지 사용설비별 조회</h2>
          <div class="mg_t20 mg_l30">
         	 <span>건물 :</span>
            <div class="select-style">
              <select>
                <option value="본관">본관</option>
              </select>
            </div>
            <span>설비명 :</span>
            <div class="select-style wt135">
				<select name="C_SLAVE" id="C_SLAVE">
					<option value="">설비선택 </option>
					<c:forEach var="code" items="${list}" varStatus="status2">
						<option value="<c:out value="${code.C_SLAVE }" />"
							<c:if test="${C_SLAVE == code.C_SLAVE }">selected="selected"</c:if>>
							<c:out value="${code.C_NAME}" />
						</option>
					</c:forEach>
				</select>													

            </div>
            <div class="pd_t10">
            	<span>기간 :</span>
	            <div class="select-style">
	              <select name='selecttop' id='selecttop'>
	                <option value="1" selected="selected">월간</option>
	                <option value="2">주간</option>
	              </select>
	            </div>

	            	<input type="text" id ="month-picker" class="layermonth">
	            	<input type="text" id ="week-picker" class="layerweek">
             	<a href="#" class="btn_s" id="pop_energy_cumulative">누적비교표</a>
             </div>
          </div>         
          <div class="box_type08"> <!--  1920 일때 height: 270px; / 사용량 : #7cc576 / 목차 : #dde8ac  /외기온도 : #ffc600 / 외기습도 : #3ddcf7  <br>
            3840 일때 height: 560px; -->
            
            <div id="container1" style="height: 265px; margin: 0 auto"></div>
          </div>
          <!-- 
              <ul class="list_legend fr">
                <li><div class="gre02"></div>사용량</li>
                <li><div class="r_gre"></div>목차or베이스라인</li>
                <li><div class="ye"></div>외기온도</li>
                <li><div class="sk"></div>외기습도</li>
              </ul>
 			-->
        </div>
        <div class="grid_inner h472">
          <h2 class="t_04">성능 및 효율분석 <a href="#" class="btn_s mg_l10" id="pop_performance_cumulative">누적비교표</a></h2>
          <div class="box_type09"> <!-- 1920 일때 height: 360px; / 당일cop : #00b4ef / 전일cop : #ff1e6d<br>
            3840 일때 height: 730px; 
             -->
			<div id="container2" style="height: 260px; margin: 0 auto"></div>
          </div>
          <!-- 
              <ul class="list_legend fr">
                <li><div class="sk02"></div>당일COP</li>
                <li><div class="pi01"></div>전일COP</li>
              </ul>
           -->
        	</div>
      	</div>
      <div class="brick01-r">
        <div class="grid_inner mg_l15 h960" >
          <h2 class="t_04 mg_b20">기준값 입력 · 수정</h2>
         	<table class="type02 mg_b15">
             <colgroup>
				<col width="20%">
                <col>
             </colgroup>
                <tr>
                    <th scope="row">항목명</th>
                    <td>
                    <div class="select-style01 wt170">
						<select name="C_SLAVE1" id="C_SLAVE1">
							<option value="">설비선택 </option>
							<c:forEach var="code" items="${list}" varStatus="status2">
								<option value="<c:out value="${code.C_SLAVE }" />"
									<c:if test="${C_SLAVE == code.C_SLAVE }">selected="selected"</c:if>>
									<c:out value="${code.C_NAME}" />
								</option>
							</c:forEach>
						</select>													
                    </div>
                    <input type="text" accesskey="s" id="C_DESC" name="C_DESC" />
                    </td>
                </tr>
                <tr>
                    <th scope="row">사용여부</th>
                    <td>
                    <div class="select-style01"><input type="text" accesskey="s" id="C_USEYN" name="C_USEYN" />
                    </div>
                    </td>
                </tr>
                <tr>
                    <th scope="row">단위</th>
                    <td>
                    <div class="select-style01">
						<input type="text" accesskey="s" id="C_POINT" name="C_POINT" />
                    </div>
                    </td>
                </tr>
                 <tr>
                    <th scope="row">기준값</th>
                    <td>
                    <strong>상한</strong> <input type="text" accesskey="s" title="상한" id="I_MAX" name="I_MAX" /> <strong>하안</strong> <input type="text" accesskey="s" title="하안" id="I_MIN" name="I_MIN" />
                    </td>
                </tr>
            </table>
            <a href="#" class="btn_s">기준값 목록</a><a href="#" class="btn_s">실시간 예측</a>
            <div style="overflow:auto" class="h330 mg_t15">
            	<table class="type03">
                <thead>
                <tr>
                <th scope="col">번호</th>
                <th scope="col">항목</th>
                <th scope="col">에너지관리 요소</th>
                <th scope="col">상한값</th>
                <th scope="col">하안값</th>
                <th scope="col">사용여부</th>
                <th scope="col"></th>
                </tr>
                </thead>
                <tbody>

		            <c:choose>
		                <c:when test="${fn:length(list1) > 0}">
		                    <c:forEach var="row" items="${list1}" varStatus="status">
		                        <tr>
		                        	<td align="center"><c:out value="${ status.count }" />
    								</td>
		                            <td align="center">${row.C_NAME}</td>
		                            <td class="center">${row.C_DESC}</td>
		                            <td align="center">${row.I_MAX}</td>
		                            <td align="center">${row.I_MIN}</td>
		                            <td align="center">
										<c:choose>
		                					<c:when test="${row.C_USEYN eq '1'}">사용</c:when>
		                					<c:when test="${row.C_USEYN eq '2'}">중지</c:when>
		                				</c:choose>
		                            </td>
		                            <td align="center"></td>
		                        </tr>
		                    </c:forEach>  

		                </c:when>
		                <c:otherwise>
		                    <tr>
		                        <td colspan="20" align="center">조회된 결과가 없습니다.</td>
		                    </tr>
		                </c:otherwise>
		            </c:choose>
                <tr>
                </tbody>
                </table>  
               </div>
                <h2 class="t_04 mg_t15 mg_b15">경보 · 조치방법관리</h2>  
               <div style="overflow:auto" class="h240 mg_t15">
           		<table class="type03">
                <thead>
                <tr>
                <th scope="col">발행일시</th>
                <th scope="col">경보내용</th>
                <th scope="col">조치방법</th>
                </tr>
                </thead>
                <tbody>
                </tbody>
                </table> 
               </div>               
            </div>                      
        </div>
      </div>
    </div>
  </div>
<!-- </div>  -->

<script src="/js/common.js" charset="utf-8"></script>
<%@ include file="/WEB-INF/include/include-body.jspf" %>

<script type="text/javascript">
	
	$("#pop_energy_cumulative").on("click", function(e){ 
	    e.preventDefault();
	    fn_pop_energy_cumulative();
	});
	
	function fn_pop_energy_cumulative(){
		var settings ='toolbar=0,directories=0,status=no,menubar=0,scrollbars=yes,resizable=no,height=250,width=850,left=0,top=0';
		winObject = window.open("/data/pop_energy_cumulative.do", "사용실비누적비교", settings);
	}
	
	$("#pop_performance_cumulative").on("click", function(e){ 
	    e.preventDefault();
	    fn_pop_performance_cumulative();
	});
	
	function fn_pop_performance_cumulative(){
		var settings ='toolbar=0,directories=0,status=no,menubar=0,scrollbars=yes,resizable=no,height=250,width=850,left=0,top=0';
		winObject = window.open("/data/pop_performance_cumulative.do", "효율분석누적비교", settings);
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
	
	$("#floor").on("click", function(e){ 
	    e.preventDefault();
	    fn_floor();
	});
	
	function fn_floor(floor){
	    var comSubmit = new ComSubmit();
	    comSubmit.setUrl("<c:url value='/data/floor.do' />");
	    comSubmit.addParam("C_FLOOR", "4");
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
//		            ,
//		            style: {
//		                color: Highcharts.getOptions().colors[0]
//		            }
		        },
		        labels: {
		            format: '{value} KWH'
//		            ,
//		            style: {
//		                color: Highcharts.getOptions().colors[0]
//		            }
		        },

		        opposite: true

		    }, { // Secondary yAxis
		        gridLineWidth: 0,
		        title: {
		            text: '가스'
//		            ,
//		            style: {
//		                color: Highcharts.getOptions().colors[1]
//		            }
		        },
		        labels: {
		            format: '{value} ㎥'
//		            ,
//		            style: {
//		                color: Highcharts.getOptions().colors[1]
//		            }
		        },opposite: true
			}, { // 3th yAxis
		        gridLineWidth: 0,
		        title: {
		            text: '수도'
//		            ,
//		            style: {
//		                color: Highcharts.getOptions().colors[2]
//		            }
		        },
		        labels: {
		            format: '{value}㎥'
//		            ,
//		            style: {
//		                color: Highcharts.getOptions().colors[2]
//		            }
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
		        categories: [],//['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
		        crosshair: true,
	            labels: {
	                style: {
	                    color: 'white'
	                }
	            }
		    }],


			tooltip: {
		        shared: true
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
				if ($('#ui-datepicker-div').hasClass("hide-calendar")){
					$('#ui-datepicker-div').removeClass('hide-calendar');					
				}
				
				setTimeout("applyWeeklyHighlight()", 100);
			}
	    });
	    
	    $('#month-picker').datepicker( {
		    dateFormat: 'yy-mm',
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
		    weekHeader: 'Wk',
	      	showOtherMonths: true,
			selectWeek:true,
			beforeShow: function(input, inst) {
				$('#ui-datepicker-div').addClass('hide-calendar');
			},
	    	onChangeMonthYear: function (year, month, inst) {
	        	$('#month-picker').val(year + "-" + getStrMonth(month)); // 현재 년월 세팅
	        	setTimeout("applyWeeklyHighlight()", 100);
	        },
	    });
	    
	});
	
    function getStrMonth(Month) {
        Month = Month + "";
        if (Month.length == 1) {
            Month = "0" + Month;
        }
        return Month;
    }
    
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
	$('#C_SLAVE1').change(function() {
		var C_SLAVE = jQuery('#C_SLAVE1 option:selected').val();

		$.ajax({ 
		    type:"POST",  
		    url:"/data/getFacilitiesdata.do?c_slave=" + C_SLAVE,
		    dataType: 'json',
		    success:function(data){
				console.log(data);
				if (data.C_USEYN == "1"){$("#C_USEYN").val("사용");}
				if (data.C_USEYN == "2"){$("#C_USEYN").val("사용안함");}
				$("#C_DESC").val(data.C_DESC);$("#C_POINT").val(data.C_POINT);
				$("#I_MAX").val(data.I_MAX);$("#I_MIN").val(data.I_MIN);
				$("#C_POINT").val(data.C_POINT);
		    }
		}); 
	});
	
	$('#selecttop').change(function() {
		var state = jQuery('#selecttop option:selected').val();
		if(state == '1') {
			jQuery('.layermonth').show();
			jQuery('.layerweek').hide();
		}else if(state == '2') {
			jQuery('.layermonth').hide();
			jQuery('.layerweek').show();
		}
	});
	
	jQuery(function($){
		jQuery('.layermonth').show();
		jQuery('.layerweek').hide();
				
		var tmp = $.datepicker.formatDate('yymmdd', new Date());
		var year=tmp.substring(0,4);
		var month= tmp.substring(4,6);
//		console.log(year + "/" + month);
		$('#month-picker').val(year + "-" + month); // 현재 년월 세팅

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
		
		$.ajax({ 
		    type:"POST",  
		    url:"/pagemidGraph.do",
		    dataType: 'json',
		    success:function(data1){
		    	options1.xAxis[0].categories = [];
		    	for(var i = 0; i < data1.categories.length; i++) {
		    		options1.xAxis[0].categories.push(data1.categories[i]);
		    	}
		    	
	            $.each(data1.series, function(i, seriesItem) {
	                var series = { data: []	};
	                
	                series.name = seriesItem.name;
	                series.color = seriesItem.color;
	                series.type = seriesItem.type;

	                $.each(seriesItem.data, function(j, seriesItemData) {
	                    series.data.push(parseFloat(seriesItemData));
	                });

	                options1.series[i] = series;
	            });
	            
	            chart1 = new Highcharts.Chart(options1);
	            
		    }
		});
		
	});
	

</script>
</body>
</html>