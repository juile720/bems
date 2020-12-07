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
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css?ver=1">
<link rel="stylesheet" href="/css/jquery.lineProgressbar.css?ver=1">

<script src="http://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<script src="/js/jquery.lineProgressbar.js" charset="utf-8"></script> <!-- Line Progress -->

<script src="/highchart/highcharts.js"></script> <!-- 하이차트 스크립트 -->
<script src="/highchart/modules/exporting.js"></script>

<script src="/js/xbim/xbim-viewer.debug.bundle.js"></script>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="/js/jquery.lineProgressbar.js"></script>

<style type="text/css">
#static1 {
    position: absolute;
    top: 40px;
    left: 0px;
}

#static2 {
	position: absolute;
    top: 420px;
    left: 0px;
}
#static3 {
	position: absolute;
    top: 20px;
    left: 420px;
}
</style>
</head>

<select id="cFloor" name="cFloor" onchange="selectXbimAndDatadesc(this.value)">
	<option value="">선택</option>
	<option value="4:1">4</option>
	<option value="5:3">5</option>
	<option value="6:5">6</option>
	<option value="7:7">7</option>
	<option value="8:9">8</option>
	<option value="9:11">9</option>
	<option value="10:13">10</option>
</select>층

<div id="static1">
	<canvas id="viewer" width="400" height="350"></canvas>
	<script type="text/javascript">
		function selectXbimAndDatadesc(obj) {
			var objArray = obj.split(":");
			var C_FLOOR = objArray[0];
			var C_SLAVE = objArray[1];
			
			// xBim Load Start
			var check = xViewer.check();
            if (check.noErrors) {
                var viewer = new xViewer('viewer');
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
            
            // datadescList Load Start
            $("#dataDescTable").empty();
            $.ajax({
		    type:"POST",  
		    url:"/data/selectDataDescList.do?c_slave=" + C_SLAVE,
		    dataType: 'json',
		    success:function(data) {
		    	var row = "<tr>";
		    	row += "<td>결선번호</td>";
	    		row += "<td>설명</td>";
    			row += "<td>ID</td>";
   				row += "</tr>";
		    	console.log(data);
		    	for(var i = 0; i < data.length; i++) {
		    		var dd_MASTER = data[i].C_MASTER;
		    		var dd_SLAVE = data[i].C_SLAVE;
		    		var dd_SLAVE1 = data[i].C_SLAVE1;
		    		var dd_NUM = data[i].I_NUM;
		    		var dd_DESC = data[i].C_DESC;
		    		var dd_ID = data[i].C_ID;
		    		if (typeof dd_ID == "undefined") {
		    			dd_ID = "";
		    		}
		    		row += "<tr>";
		    		row += "<td><a href=\"javascript:fn_oneData("+dd_MASTER+","+dd_SLAVE+","+dd_SLAVE1+","+dd_NUM+");\">"+dd_NUM+"</a></td>";
		    		row += "<td>"+dd_DESC+"</td>";
		    		row += "<td>"+dd_ID+"</td>";
		    		row += "</tr>";
		    	}
		    	$("#dataDescTable").append(row);
		    }
		});
            // datadesc Load End
		}
		function fn_oneData(c_master, c_slave, c_slave1, i_num) {
			$.ajax({
			    type:"POST",  
			    url:"/data/selectDataDescOne.do?c_master="+c_master+"&c_slave="+c_slave+"&c_slave1="+c_slave1+"&i_num="+i_num,
			    dataType: 'json',
			    success:function(data) {
			    	console.log(data);
			    	var dd_MASTER = data.C_MASTER;
			    	var dd_SLAVE = data.C_SLAVE;
			    	var dd_SLAVE1 = data.C_SLAVE1;
			    	var dd_NUM = data.I_NUM;
					var dd_DESC = data.C_DESC;
					var dd_ID = data.C_ID;
					if (typeof dd_ID == "undefined") {
		    			dd_ID = "";
		    		}
					$("#cc_master").val(dd_MASTER);
					$("#cc_slave").val(dd_SLAVE);
					$("#cc_slave1").val(dd_SLAVE1);
					$("#ii_num").val(dd_NUM);
					$("#cc_desc").val(dd_DESC);
					$("#cc_id").val(dd_ID);
			    }
			});
		}
	</script>
</div>

<div id="static2">
	<table id="dataDescTable" border="1" width="400">
	</table>
</div>

<div id="static3">
<button type="button" id="write">저장</button>
<br><br>
<form name="frm" id="frm">
	<table border="1">
		<tr>
			<td>결선번호</td>
			<td>
				<input type="text" name="ii_num" id="ii_num" readonly>
				<input type="hidden" name="cc_master" id="cc_master">
				<input type="hidden" name="cc_slave" id="cc_slave">
				<input type="hidden" name="cc_slave1" id="cc_slave1">
			</td>
		</tr>
		<tr>
			<td>설명</td>
			<td><input type="text" name="cc_desc" id="cc_desc" readonly></td>
		</tr>
		<tr>
			<td>xBim ID</td>
			<td><input type="text" name="cc_id" id="cc_id" readonly></td>
		</tr>
	</table>
</form>
</div>
<script src="/js/common.js" charset="utf-8"></script>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
<script type="text/javascript">
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
	comAjax.setUrl("<c:url value='/data/updateDataDescOne.do' />");
    comAjax.setCallback("doReturn");
    comAjax.ajax();
}

function doReturn(data){
	
	if (data == "SUCCESS"){
		alert("입력되었습니다");
	}
	
	$("#cc_master").val();
	$("#cc_slave").val();
	$("#cc_slave1").val();
	$("#ii_num").val();
	$("#cc_desc").val();
	$("#cc_id").val();
	
	var cFloor = $("#cFloor option:selected").val();
	selectXbimAndDatadesc(cFloor);

}

</script>
</body>
</html>
