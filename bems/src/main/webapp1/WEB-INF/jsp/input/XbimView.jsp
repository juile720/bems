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

<script src="/js/xbim/xbim-viewer.debug.bundle.js"></script>
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
      </div>
      <div class="fr">
        <ul class="lnb_h_r">
        </ul>
      </div>
    </div>
  </div>
  <!-- //header --> 
  
  <!-- container -->
  <div id="container">
    <div class="grid_wrap">
      
      <div class="brick02-l">
        <div style="overflow:auto; height:685px " class="grid_inner mg_l15 " >
          <h2 class="t_04 mg_b20">데이터조회</h2>
         	<table class="type02 mg_b15">
             <colgroup>
				<col width="20%">
                <col>
             </colgroup>
                <tr>
                    <th scope="row">층선택</th>
                    <td>
                    <div class="select-style01 wt170">
                    <select id="cFloor" name="cFloor" onchange="selectXbimAndDatadesc(this.value)">
						<option value="">선택</option>
						<option value="4:1">4</option>
						<option value="5:3">5</option>
						<option value="6:5">6</option>
						<option value="7:7">7</option>
						<option value="8:9">8</option>
						<option value="9:11">9</option>
						<option value="10:13">10</option>
					</select>

                    </div>
                    층
                    </td>
                </tr>
            </table>

            <div style="overflow:auto" class="h490 mg_t15">
            	<table class="type03">
             <colgroup>
				<col width="10%">
                <col width="*">
                <col width="20%">
                <col width="20%">
             </colgroup>
                <thead>
                <tr>
                <th scope="col">결선번호</th>
                <th scope="col">설명</th>
                <th scope="col">측정시간</th>
                <th scope="col">사용량(WATT)</th>
                </tr>
                </thead>
                <tbody id="dataDescTable"></tbody>
                </table>  
               </div>
               
            </div>                      
        </div>
        
      <div class="brick02-r">
        <div class="grid_inner mg_b15 h685">
           <h2 class="t_04">xBim</h2>
    
          <div class="box_type08"> <!--  1920 일때 height: 270px; / 사용량 : #7cc576 / 목차 : #dde8ac  /외기온도 : #ffc600 / 외기습도 : #3ddcf7  <br>
            3840 일때 height: 560px; -->
            <canvas id="viewer" style="height: 580px;margin: 0 auto;width: 880px;" width="880" height="580"></canvas>
            <!-- <div id="container1" style="height: 265px; margin: 0 auto"></div> -->
            
	<script type="text/javascript">
	
		var viewer = null;
		
		function selectXbimAndDatadesc(obj) {
			var objArray = obj.split(":");
			var C_FLOOR = objArray[0];
			var C_SLAVE = objArray[1];
			
			// xBim Load Start
			var check = xViewer.check();
            if (check.noErrors) {
            	viewer = new xViewer('viewer');
                viewer.on('loaded', function () {
                    viewer.start();
                });

                viewer.on('error', function (arg) {
                    var container = document.getElementById('errors');
                    if (container) {
                        //preppend error report
                        container.innerHTML = "<pre style='color:red;'>" + arg.message + "</pre> <br />" + container.innerHTML;
                    }
                });

                var timer = 0;
                viewer.on('pick', function (args) {
                    var id = args.id;
                    //var id = "130337";

                    var span = document.getElementById('productId');
                    if (span) {
                        span.innerHTML = id;
                    }

                    //you can use ID for funny things like hiding or 
                    //recolouring which will be covered in one of the next tutorials

                    var time = (new Date()).getTime();
                    if (time - timer < 200)
                        viewer.zoomTo(id);
                    timer = time;
                });
                viewer.on('mouseDown', function (args) {
                    viewer.setCameraTarget(args.id);
                });
                viewer.on('dblclick', function (args) {
                	viewer.setCameraTarget(args.id);
                	$("#cc_id").val(args.id);
                });
                viewer.load("/xbim/"+C_FLOOR+"f.wexBIM");
            }
            else {
                var msg = document.getElementById('msg');
                msg.innerHTML = '';
                for (var i in check.errors) {
                    var error = check.errors[i];
                    msg.innerHTML += "<div style='color: red;'>" + error + "</div>";
                }
            }
            // xBim Load End
            
            $("#dataDescTable").empty();
            
            $.ajax({
    		    type:"POST",  
    		    url:"/selectDataList.do?c_slave=" + C_SLAVE,
    		    dataType: 'json',
    		    success:function(data) {
    		    	var row = "";
    		    	//console.log(data);
    		    	for(var i = 0; i < data.length; i++) {
    		    		var dd_DT = data[i].DT;
    		    		var dd_MASTER = data[i].C_MASTER;
    		    		var dd_SLAVE = data[i].C_SLAVE;
    		    		var dd_SLAVE1 = data[i].C_SLAVE1;
    		    		var dd_NUM = data[i].I_NUM;
    		    		var dd_DESC = data[i].C_DESC;
    		    		var dd_ID = data[i].C_ID;
    		    		var dd_WATT = data[i].I_W_NOW;
    		    		if (typeof dd_ID == "undefined") {
    		    			dd_ID = "";
    		    		}
    		    		row += "<tr>";
    		    		row += "<td align='center'><a href=\"javascript:fn_oneData("+dd_ID+");\">"+dd_NUM+"</a></td>";
    		    		row += "<td align='center'><a href=\"javascript:fn_oneData("+dd_ID+");\">"+dd_DESC+"</a></td>";
    		    		row += "<td align='center'>"+dd_DT+"</td>";
    		    		row += "<td align='center'>"+dd_WATT+"</td>";
    		    		row += "</tr>";
    		    	}
    		    	$("#dataDescTable").append(row);
    		    }
    		});
		}
        
		function fn_oneData(c_id) {
			viewer.zoomTo(c_id);
			//viewer.setCameraTarget(c_id);
			//viewer.setState(xState.HIGHLIGHTED, c_id);
		}
	</script>
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

	$("#write").on("click", function(e){ // 등록 버튼
		e.preventDefault();
		fn_updateCid();
	});

	function fn_updateCid() {
		
		var ii_num = $("#ii_num").val();
		var c_id = $("#cc_id").val();
		
		if(ii_num == "") {
			alert("결선리스트에서 결선번호를 선택하십시오");
			return false;
		}
		
		if(c_id == "") {
			alert("xBim 화면에서 설정할 ID를 더블클릭 하십시오");
			return false;
		}
		
		var comAjax = new ComAjax("frm");
		
        comAjax.addParam("cc_id", $("#cc_id").val());
        comAjax.addParam("cc_master", $("#cc_master").val());
        comAjax.addParam("cc_slave", $("#cc_slave").val());
        comAjax.addParam("cc_slave1", $("#cc_slave1").val());
        comAjax.addParam("ii_num", $("#ii_num").val());		
		comAjax.setUrl("<c:url value='/data/updateDataDescOne.do' />");
	    comAjax.setCallback("doReturn");
	    comAjax.ajax();
	}

	function doReturn(data){
		
		if (data == "SUCCESS"){
			alert("입력되었습니다");
		}
		$("input[name=cc_master]").attr("readonly",false);		$("#cc_master").val(""); $("input[name=cc_master]").attr("readonly",true);
		$("input[name=cc_slave]").attr("readonly",false);		$("#cc_slave").val(""); $("input[name=cc_slave]").attr("readonly",true);
		$("input[name=cc_slave1]").attr("readonly",false);		$("#cc_slave1").val(""); $("input[name=cc_slave1]").attr("readonly",true);
		$("input[name=ii_num]").attr("readonly",false);		$("#ii_num").val(""); $("input[name=ii_num]").attr("readonly",true);
		$("input[name=cc_desc]").attr("readonly",false);		$("#cc_desc").val(""); $("input[name=cc_desc]").attr("readonly",true);
		$("input[name=cc_id]").attr("readonly",false);		$("#cc_id").val(""); $("input[name=cc_id]").attr("readonly",true);
		
		var cFloor = $("#cFloor option:selected").val();
		selectXbimAndDatadesc(cFloor);

	}
	
</script>
</body>
</html>