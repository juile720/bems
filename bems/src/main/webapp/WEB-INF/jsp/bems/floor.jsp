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
<link rel="stylesheet" type="text/css" href="/css/layout.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="/css/jquery.lineProgressbar.css">

<script src="http://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<script src="/js/wheather.js" charset="utf-8"></script><!-- 날씨 스크립트 -->
<script src="/js/jquery.lineProgressbar.js" charset="utf-8"></script> <!-- Line Progress -->

<script src="/highchart/highcharts.js"></script> <!-- 하이차트 스크립트 -->
<script src="/highchart/modules/exporting.js"></script>

<script src="/js/xbim/xbim-viewer.debug.bundle.js"></script>

<script type="text/javascript">
jQuery(function($){
	var tab = $('.tab_face');
	tab.removeClass('js_off');
	function onSelectTab(){
		var t = $(this);
		var myclass = [];
		t.parentsUntil('.tab_face:first').filter('li').each(function(){
			myclass.push( $(this).attr('class') );
		});
		myclass = myclass.join(' ');
		if (!tab.hasClass(myclass)) tab.attr('class','tab_face').addClass(myclass);
	}
	tab.find('li>a').click(onSelectTab).focus(onSelectTab);
});
jQuery(function($){
	var tab = $('.tab_list');
	tab.removeClass('js_off');
	tab.css('height', tab.find('>ul>li>ul:visible').height()+40);
	function onSelectTab(){
		var t = $(this);
		var myClass = t.parent('li').attr('class');
		t.parents('.tab_list:first').attr('class', 'tab_list '+myClass);
		tab.css('height', t.next('ul').height()+40);
	}
	tab.find('>ul>li>a').click(onSelectTab).focus(onSelectTab);
});
</script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="/js/jquery.lineProgressbar.js"></script>
</head>

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
          <li><a href="#" id="resource">에너지원별</a> </li>
          <li><a href="#" id="facilities">에너지사용설비별</a> </li>
          <li class="active"><a href="#">층별관리</a> </li>
        </ul>
      </div>
      <div class="fr">
        <ul class="lnb_h_r">
<!--           <li><a href="#" class="btn_t01">층별상세조회(kwh)</a></li>
          <li><a href="#" class="btn_t01">층별사용량비중(%)</a></li>
 -->
          <li><a href="#" class="btn_t" id="pop_trendLog">TREND LOG</a></li>
          <li><a href="#" class="btn_t">SCHEDULE</a></li>
          <li class="t28">
            <div class="icon"> <strong class="screen_out">날씨</strong>  </div>
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
  
    <c:forEach var="row" items="${resultlist}" varStatus="status">
    	<c:set value="${row.EB}" var="eb"/>
    	<c:set value="${row.EP}" var="ep"/>
    	<c:set value="${row.GB}" var="gb"/>
    	<c:set value="${row.GP}" var="gp"/>
    	<c:set value="${row.WB}" var="wb"/>
    	<c:set value="${row.WP}" var="wp"/>
    	<c:set value="${row.I_DATA}" var="tdata"/>
    	<c:set value="${row.SUM}" var="tsum"/>
    	<c:set value="${row.PER}" var="per"/>
    	<c:set value="${row.PER1}" var="per1"/>
    </c:forEach>
         
    <c:set var= "sum1" value="${eb + wb + gb}"/>
	<c:set var= "sum2" value="${ep + wp + gp}"/>
	<c:set var= "per" value="${per}"/>
	<c:set var= "per1" value="${per1}"/>
  <!-- container -->
  <div id="container">
    <div class="grid_wrap">
      <div class="brick03-l">
        <div class="grid_inner mg_b15 h290">
          <h2 class="t_04">${C_FLOOR}층</h2>
			<div>
				<canvas id="viewer0" width="255" height="240"></canvas>
				<div id="viewerText" style="width:100px;height:30px"></div>
				<script type="text/javascript">
					var viewer0 = new xViewer('viewer0');
					viewer0.load('/xbim/${C_FLOOR}f.wexBIM');
					viewer0.start();
				</script>
			</div>
        </div>
        <div class="grid_inner01 h655">
            <div class="tab">
                <h2>보기방식</h2>
                <ul>
                <li>추의 / 누적 그래프</li>
                </ul>
            </div>
           <div class="tab_face m1 s1">
          	<h2>보기기준</h2>
            <ul>
            <li class="m1"><a href="#"><span>에너지 사용량</span></a>
                <ul>
                 <li class="none"><h2>에너지원</h2></li>
                <li>
                <input type="checkbox" id="totalfloor" class="checkbox-style" checked/><label for="전체">전체</label>
                <input type="checkbox" id="elect" class="checkbox-style" /><label for="전기">전기</label>
                <input type="checkbox" id="gas" class="checkbox-style" /><label for="가스">가스</label>
                <input type="checkbox" id="water" class="checkbox-style" /><label for="수도">수도</label>
                </li>
                <li class="none"><h2>보기방식</h2></li>
                <li>
                <input type="checkbox" id="totalenergy" class="checkbox-style"  checked/><label for="전체1">전체</label>
                <span class="mg"><input type="checkbox" id="열원" class="checkbox-style" /><label for="열원">열원</label></span>
               	<input type="checkbox" id="부하" class="checkbox-style" /><label for="부하">부하</label>
                <br>
                <input type="checkbox" id="전열" class="checkbox-style" /><label for="전열">전열</label>
                <span class="mg"><input type="checkbox" id="조명" class="checkbox-style" /><label for="조명">조명</label></span>
                <input type="checkbox" id="기타" class="checkbox-style" /><label for="기타">기타</label>
                </li>
                <li class="none"><h2>공간</h2></li>
<!--                 <li><em>&#183</em><a href="#">1층</a></li>
                <li><em>&#183</em><a href="#">2층</a></li>
                <li><em>&#183</em><a href="#">3층</a></li>
 -->
                <li><em>&#183</em><a href="#" id="floor4" >4층</a></li>
                <li><em>&#183</em><a href="#" id="floor5">5층</a></li>
                <li><em>&#183</em><a href="#" id="floor6">6층</a></li>
                <li><em>&#183</em><a href="#" id="floor7">7층</a></li>
                <li><em>&#183</em><a href="#" id="floor8">8층</a></li>
                <li><em>&#183</em><a href="#" id="floor9">9층</a></li>
                <li><em>&#183</em><a href="#" id="floor10">10층</a></li>
                </ul>
            </li>
            <li class="m2"><a href="#"><span>용도별 사용량</span></a>
                  <ul>
                 <li class="none"><h2>에너지원</h2></li>
                <li>
                <input type="checkbox" id="전체" class="checkbox-style" checked /><label for="전체">전체</label>
                <input type="checkbox" id="전기" class="checkbox-style" /><label for="전기">전기</label>
                <input type="checkbox" id="가스" class="checkbox-style" /><label for="가스">가스</label>
                <input type="checkbox" id="수도" class="checkbox-style" /><label for="수도">수도</label>
                </li>
                <li class="none"><h2>보기방식</h2></li>
                <li>
                <input type="checkbox" id="전체1" class="checkbox-style" checked /><label for="전체1">전체</label>
                <span class="mg"><input type="checkbox" id="열원" class="checkbox-style" /><label for="열원">열원</label></span>
               	<input type="checkbox" id="부하" class="checkbox-style" /><label for="부하">부하</label>
                <br>
                <input type="checkbox" id="전열" class="checkbox-style" /><label for="전열">전열</label>
                <span class="mg"><input type="checkbox" id="조명" class="checkbox-style" /><label for="조명">조명</label></span>
                <input type="checkbox" id="기타" class="checkbox-style" /><label for="기타">기타</label>
                </li>
                <li class="none"><h2>공간</h2></li>
<!--                 <li><em>&#183</em><a href="#">1층</a></li>
                <li><em>&#183</em><a href="#">2층</a></li>
                <li><em>&#183</em><a href="#">3층</a></li>
 -->
                <li><em>&#183</em><a href="#" id="floor4">4층</a></li>
                <li><em>&#183</em><a href="#" id="floor5">5층</a></li>
                <li><em>&#183</em><a href="#" id="floor6">6층</a></li>
                <li><em>&#183</em><a href="#" id="floor7">7층</a></li>
                <li><em>&#183</em><a href="#" id="floor8">8층</a></li>
                <li><em>&#183</em><a href="#" id="floor9">9층</a></li>
                <li><em>&#183</em><a href="#" id="floor10">10층</a></li>
                </ul>
            </li>
            </ul>
        </div>
        </div>
      </div>
      <div class="brick03-l01">
        <div class="grid_inner mg_b15 mg_l15 h685">
        	<div class="tab_list m1" style="height:112px;">
                <ul>
                <li class="m1"><a href="#"><span>추이 그래프</span></a>
                    <ul> 
                	<li> 
	                    <div class="box_type10"> <!-- 1920 일때 height: 515px; / 외기온도 : #2196f3 /실내온도 : #f51f6b  /외기온도 : #ffc600 / 에너지사용량 : #1ff5b1 / 전기 #a3fe00 / 가스 #ffaa00 / 수도 #3ddcf7<br>
	           				 3840 일때 height: 1030px; -->
	           				 <div id="container1" style="height: 180px; margin: 0 auto"></div>
	           				 <div id="container2"  style="height: 325px; margin: 25px auto 0"></div>
	           			</div>
                    </li>                 
                    </ul>
                </li>
                <li class="m2"><a href="#"><span>누적 그래프</span></a>
                     <ul>
                    <li class="tr">
                        <div class="list_legend">
                          <input type="checkbox" id="외기온도" class="checkbox-style" /><label for="외기온도"></label><div class="sk04"></div>외기온도
                          <input type="checkbox" id="실내온도" class="checkbox-style" /><label for="실내온도"></label><div class="pi02"></div>실내온도
                          <input type="checkbox" id="에너지사용량" class="checkbox-style" /><label for="에너지사용량"></label><div class="em03"></div>에너지사용량
                       </div>
                    </li> 
                    <li class="tr">
                        <div class="list_legend">
                           	<div class="gre01"></div>전기
                            <div class="ye"></div>가스
                            <div class="sk"></div>수도
                       </div>
                    </li>   
                	<li> 
                    <div class="box_type10"> 
                    <!-- 1920 일때 height: 515px; / 외기온도 : #2196f3 /실내온도 : #f51f6b  /외기온도 : #ffc600 / 에너지사용량 : #1ff5b1 / 전기 #a3fe00 / 가스 #ffaa00 / 수도 #3ddcf7<br>
           				 3840 일때 height: 1030px;  -->
           				 
           			</div>
                    </li>                 
                    </ul>
                </li>
                </ul>
            </div>
        </div>
      </div>
      <div class="brick03-r">
        <div class="grid_inner mg_b15 mg_l15 h685">
          <h2 class="t_04 mg_b10">SUMMARY</h2>
          <h2 class="mg_b10">에너지 사용량</h2>
          <table class="type04">
            <colgroup>
            <col width="30%">
            <col>
            <col>
            </colgroup>
            <thead>
              <tr>
                <th scope="col" colspan="3" class="t">전년 대비 ${per} %</th>
              </tr>
              <tr>
                <th scope="col">구분</th>
                <th scope="col">전년</th>
                <th scope="col">현재</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td class="b_lno tl">통합에너지(TOE)</td>
                <td>${sum1}</td>
                <td>${sum2}</td>
              </tr>
              <tr>
                <td class="b_lno tl">전기 (kwh)</td>
	                <td>${eb}</td>
	                <td>${ep}</td>                

              </tr>
              <tr>
                <td class="b_lno tl">가스 (kw3)</td>
	                <td>${gb}</td>
	                <td>${gp}</td>                
              </tr>
              <tr>
                <td class="b_lno tl">수도 (ton)</td>
	                <td>${wb}</td>
	                <td>${wp}</td>                
              </tr>
            </tbody>
          </table>
          <h2 class="mg_t15 mg_b10">환경정보</h2>
          <table class="type04">
            <colgroup>
            <col width="20%">
            <col>
            <col>
            </colgroup>
            <thead>
              <tr>
                <th scope="col" colspan="2">구분</th>
                <th scope="col">전년</th>
                <th scope="col">현재</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td class="b_lno tl" colspan="2">쾌적도</td>
                <td>보통</td>
                <td>보통</td>
              </tr>
              <tr>
                <td class="b_lno tl" rowspan="2" scope="rowgroup">온도(℃)</td>
                <td scope="row">최고</td>
                <c:forEach var="row" items="${resultlist}" varStatus="status">
	                <td>${row.B_MAXTEMP}</td>
	                <td>${row.P_MAXTEMP}</td>                
                </c:forEach>
              </tr>
              <tr>
                <td scope="row">최저</td>
                <c:forEach var="row" items="${resultlist}" varStatus="status">
	                <td>${row.B_MINTEMP}</td>
	                <td>${row.P_MINTEMP}</td>                
                </c:forEach>
              </tr>
              <tr> 
                <td class="b_lno tl" rowspan="2" scope="rowgroup">습도(%)</td>
                <td scope="row">최고</td>
                <c:forEach var="row" items="${resultlist}" varStatus="status">
	                <td>${row.B_MAXHUMI}</td>
	                <td>${row.P_MAXHUMI}</td>                
                </c:forEach>
              </tr>
              <tr>
                <td scope="row">최저</td>
                <c:forEach var="row" items="${resultlist}" varStatus="status">
	                <td>${row.B_MINHUMI}</td>
	                <td>${row.P_MINHUMI}</td>                
                </c:forEach>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      <div class="brick03-r01">
        <div class="grid_inner02 mg_l15 h260">
        	<div class="fl l_04">
          	 <h2 class="t_04 mg_t30">층별 실내환경분석</h2>
               <div class="list_legend mg_t20 t16">
                <div class="s_em"></div>외기온도
                <div class="s_gr"></div>실내온도
                <div class="s_re"></div>에너지사용량
               </div>
               <div class="status">
               <ul>
               	<li>${C_FLOOR}층</li>
               	
                <c:forEach var="row" items="${resultlist}" varStatus="status">
                	<c:set value="${row.I_TEMP}" var="temp1"/>
                	<c:set value="${row.I_HUMI}" var="humi"/>
                	<c:set value="${row.I_CO2}" var="co2"/>
                </c:forEach>

                <li><span class="normality">${temp1}</span><br>온도(℃)</li>
                <li><span class="caution">${humi}</span><br>습도(RH%)</li>
                <li><span class="caution">${co2}</span><br>CO2(ppm)</li>
                <li><span class="dangerous">0.1</span><br>PMV(불쾌지수)</li>
               </ul>                   
               </div>
            </div>
          	<div class="fl l_04">
            <h2 class="t_04 mg_t30">금일 에너지 성능평가</h2>
           		<div class="list_legend mg_t20 mg_b10 t16">
               		<div class="s_sk"></div>현재
               		<div class="s_dk"></div>전년
              	</div>
              	<div class="fl">
                <span class="i_graph ">
                	<ul>
                     <li>${eb} kWh <span class="g_bar" id="progressbar11" > <!-- <span class="g_action" style="width:50%"></span>  -->  </span>
                     <!-- <span id="progressbar11" ></div>  -->
                     <script type="text/javascript">
                     	var per = "";
						$('#progressbar11').LineProgressbar({
						  percentage: 85,
						  fillBackgroundColor: '#3bafda',
						  BackgroundColor: '#272d34',
						  height: '22px',
						  radius: '20px',
						  ShowProgressCount: false
						});
						</script>
                     </li>
                     <li>${ep} kWh <span class="g_bar" id="progressbar12"><!-- <span class="g_action" style="width:50%"></span>--> </span></li>
                     <script type="text/javascript">
                     	var per = "";
						$('#progressbar12').LineProgressbar({
						  percentage: 85,
						  fillBackgroundColor: '#3bafda',
						  BackgroundColor: '#272d34',
						  height: '22px',
						  radius: '20px',
						  ShowProgressCount: false
						});
						</script>
                    </ul>    
				</span>                                 
                </div>
                <div class="fr">
                <span class="g_percent">
               		<ul>
                     <li>전년대비</li>
                     <li><strong> ${per} %</strong></li>
                    </ul> 
                 </span>   
				</div>
            </div>
            <div class="fr l_04">
            <h2 class="t_04 mg_t30">금일 에너지 성능명가</h2>
             <div class="list_legend mg_t20 mg_b10 t16">
               	<div class="s_sk"></div>월 목표사용량
               	<div class="s_dk"></div>현재 누적사용량
             </div>
              <div class="fl">
                <span class="i_graph ">
                	<ul>
                     <li> ${tdata} kWh <span class="g_bar" id="progressbar21"><!-- <span class="g_action" style="width:50%"></span> --></span>  
                     <script type="text/javascript">
                     	var per = "${tdata}";
						$('#progressbar21').LineProgressbar({
						  percentage: 85,
						  fillBackgroundColor: '#3bafda',
						  BackgroundColor: '#272d34',
						  height: '22px',
						  radius: '20px',
						  ShowProgressCount: false
						});
						</script>

                     </li>
                     <li> ${tsum} kWh <span class="g_bar" id="progressbar22"><!-- <span class="g_action" style="width:50%"></span> --></span>
                     <script type="text/javascript">
                     	var per = "${tsum}";
						$('#progressbar22').LineProgressbar({
						  percentage: 85,
						  fillBackgroundColor: '#3bafda',
						  BackgroundColor: '#272d34',
						  height: '22px',
						  radius: '20px',
						  ShowProgressCount: false
						});
						</script>
                     
                     </li>
                    </ul>    
				</span>                                 
                </div>
                <div class="fr">
                <span class="g_percent">
               		<ul>
                     <li>목표대비사용률</li>
                     <li><strong>${per1}%</strong></li>
                    </ul> 
                 </span>   
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
	
	$("#floor4").on("click", function(e){ 
	    e.preventDefault();
	    fn_floor('4');
	});
	
	$("#floor5").on("click", function(e){ 
	    e.preventDefault();
	    fn_floor('5');
	});
	
	$("#floor6").on("click", function(e){ 
	    e.preventDefault();
	    fn_floor('6');
	});
	
	$("#floor7").on("click", function(e){ 
	    e.preventDefault();
	    fn_floor('7');
	});
	
	$("#floor8").on("click", function(e){ 
	    e.preventDefault();
	    fn_floor('8');
	});
	
	$("#floor9").on("click", function(e){ 
	    e.preventDefault();
	    fn_floor('9');
	});
	
	$("#floor10").on("click", function(e){ 
	    e.preventDefault();
	    fn_floor('10');
	});
	
	function fn_floor(floor){
	    var comSubmit = new ComSubmit();
	    comSubmit.setUrl("<c:url value='/data/floor.do' />");
	    comSubmit.addParam("C_FLOOR", floor);
	    comSubmit.submit();
	}
	
	var data1=[], data2=[], data3=[];
	
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
		    yAxis: {
		        min: 0,
		        title: {
		            text: '온도(℃)'
		        },
	            labels: {
	                style: {
	                    color: 'white'
	                }
	            }
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
	
	var options1 = {
		    chart: {
		        type: 'column',renderTo: 'container2'
		        ,backgroundColor :'#323b44'
		    },
			legend: {
				layout: 'horizontal',//'vertical',
				align: 'right',
				x: -10,
				verticalAlign: 'top',
				y: 5,
				floating: false,// true,
				backgroundColor :'#323b44',
				itemStyle:{color:'#f0f0f0'}
				//backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
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
		        categories: [],
		        crosshair: true,
	            labels: {
	                style: {
	                    color: 'white'
	                }
	            }
		    }],
		    yAxis: {
		        min: 0,
		        title: {
		            text: '사용량 (KWH)'
		        },
	            labels: {
	                style: {
	                    color: 'white'
	                }
	            }

		    },
		    tooltip: {
		        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
		        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
		            '<td style="padding:0"><b>{point.y:.1f} </b></td></tr>',
		        footerFormat: '</table>',
		        shared: true,
		        useHTML: true
		    },
		    plotOptions: {
		        column: {
//		        	stacking: 'percent'
		            pointPadding: 0.2,
		            borderWidth: 0
		        }
		    },
		    series: [{
		    	name: '전기',
		        data: data1
		    }, {
		    	name: '가스',
		        data: data2
		    }, {
		    	name: '수도',
		        data: data3
		    }]
		    
		}
	jQuery(function($){
		$.ajax({ 
		    type:"POST",  
		    url:"/pageFloorTemp.do",
		    dataType: 'json',
		    success:function(data1){
		    	options.xAxis[0].categories = [];
		    	for(var i = 0; i < data1.categories.length; i++) {
		    		options.xAxis[0].categories.push(data1.categories[i]);
		    	}
		    	
	            $.each(data1.series, function(i, seriesItem) {
	                var series = { data: []	};
	                
	                if (seriesItem.name == "I"){
	                	series.name = "실내온도";
	                }else {
	                	series.name = "외기온도";
	                }
	                //series.name = seriesItem.name;
	                series.color = seriesItem.color;
	                series.type = seriesItem.type;

	                $.each(seriesItem.data, function(j, seriesItemData) {
	                    series.data.push(parseFloat(seriesItemData));
	                });

	                options.series[i] = series;
	            });
	            
	            chart1 = new Highcharts.Chart(options);
	            
		    }
		});
		
		$.ajax({ 
		    type:"POST",  
		    url:"/pageFloorGrapgh.do",
		    dataType: 'json',
		    success:function(data){
		    	options1.xAxis[0].categories = [];
		    	for(var i = 0; i < data.categories.length; i++) {
		    		options1.xAxis[0].categories.push(data.categories[i]);
		    	}
	            $.each(data.series, function(i, seriesItem) {
	            	var series = {data: []};
	                if (seriesItem.name == "E"){
	                	series.name = "전기";
	                }else if (seriesItem.name == "G"){
	                	series.name = "가스";
	                }else if (seriesItem.name == "W"){
	                	series.name = "수도";
	                }
	                $.each(seriesItem.data, function(j, seriesItemData) {
	                	if (seriesItem.name == "E" ){
	                		data1.push({y:parseFloat(seriesItemData)});
	                	}else if (seriesItem.name == "G"){
	                		data2.push({y:parseFloat(seriesItemData)});
	                	}else if (seriesItem.name == "W"){
	                		data3.push({y:parseFloat(seriesItemData)});
	                	}
	                });	                	
	            });
	            
	            chart = new Highcharts.Chart(options1);
	            
		    }
		});
		
		//setTimeout("location.reload()",150000);

	});
</script>
</body>
</html>
