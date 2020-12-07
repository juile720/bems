<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>EAN BEMS</title>
<script src="http://code.jquery.com/jquery-1.8.2.min.js"></script>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>


	<script src="http://code.jquery.com/mobile/1.2.0/jquery.mobile-1.2.0.min.js"></script>
	<script>
	jQuery(document).ready(function($) {

		$.ajax({
	  	// 결과를 한글로 받을 수 있다.
		  url : "http://api.wunderground.com/api/2d16ff2e3edbe396/geolookup/conditions/lang:KR/q/Korea/Seoul.json",
		  dataType : "jsonp",
		  success : function(parsed_json) {
	  	 // location
	  	 var location = parsed_json.location;
	  	 var location_s = "<p>국가명(country_name):  "+location.country_name+"</p>";
	  	 location_s+= "<p>도시명(city_name):  "+location.city+"</p>";
	  	 location_s+= "<p>경도(lat):  "+location.lat+"</p>";
	  	 location_s+= "<p>위도(lon):  "+location.lon+"</p>";
		 $("#locationinfo").append(location_s);
	  	 // 관측지에 대한 정보
	  	 var observ = parsed_json.current_observation;
	  	 var observ_s = "<p>관측지 주소 전체 : "+observ.display_location.full+"</p>";
	  	 observ_s += "<p>관측지 주소 국가 : "+observ.display_location.state_name+"</p>";
	  	 observ_s += "<p>관측지 주소 도시 : "+observ.display_location.city+"</p>";
	  	 observ_s += "<p>관측지 경도(latitude) : "+observ.display_location.latitude+"</p>";
		 observ_s += "<p>관측지 위도(longitude) : "+observ.display_location.longitude+"</p>";
		 observ_s += "<p>관측지 해발고도(elevation) : "+observ.display_location.elevation+"</p>";
		 $("#observinfo").append(observ_s);
		// 날씨정보
		 var weather_s = "<p>업데이트 정보:  "+observ.observation_time+"</p>";
		 weather_s +="<p>현재 날씨 :  "+observ.weather+"</p>";
		 weather_s +="<p>현재 온도 화씨(섭씨):  "+observ.temperature_string+"</p>";
		 weather_s +="<p>현재 온도 화씨:  "+observ.temp_f+"</p>";
		 weather_s +="<p>현재 온도 섭씨:  "+observ.temp_c+"</p>";
		 weather_s +="<p>상대 습도 :  "+observ.relative_humidity+"</p>";
		 weather_s +="<p>바람 정보 전체 :  "+observ.wind_string+"</p>";
		 weather_s +="<p>풍향 :  "+observ.wind_dir+"</p>";
		 weather_s +="<p>풍속 (mph):  "+observ.wind_mph+"</p>";
		 weather_s +="<p>풍속 (kph):  "+observ.wind_kph+"</p>";
		 weather_s +="<p>자외선 양:  "+observ.UV+"</p>";
		 weather_s +="<p>아이콘 : "+observ.icon+"</p>";
		 weather_s +="<p>아이콘 그림 :  "+"<img src='"+observ.icon_url+"'/></p>";
		 $("#weatherinfo").append(weather_s);
	  }
	  });
	});
	</script>
</head>
<body>
<div data-role="page">

	<div data-role="header">
		<h1>Wunderground</h1>
	</div><!-- /header -->

	<div data-role="content">	
		<p><h1>서울의 현재 날씨</h1></p>
		<div id="locationinfo">
			<h2>위치정보</h2>
		</div>
		<div id="observinfo">
			<h2>관측지 정보</h2>
		</div>
		<div id="weatherinfo">
			<h2>날씨 정보</h2>
		</div>
		
		<div id="status1">
			<h2>SKPLANET</h2>
		</div>

	</div><!-- /content -->

</div><!-- /page -->
</body>
</html>