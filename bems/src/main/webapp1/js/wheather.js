	jQuery(document).ready(function($) {
		var value1, value2, icon;

		$.ajax({
	  	  	url : "/getWheater.do",
		  	dataType : "json",
		  	success : function(data) {
		  		var response = data.results;
		  		for(var i = 0 ; i < response.length ; i ++){
		  			
					value1 = response[i].I_TEMP;
					value2 = response[i].I_HUMI;
					icon = response[i].C_CONDITION;
					
		  		}
/*		  		console.log(value1);
		  		console.log(value2);
		  		console.log(icon);*/
				// 눈 스크립트
				if(icon == "chanceflurries" || icon == "chancesleet" || icon == "chancesnow"
					|| icon == "flurries" || icon == "sleet" || icon == "snow" ) {
					$("#wid").html("<li><a href='' class='icon'><span class='weather_icon snow'></span>눈</a></li>");
				} //비 스크립트
				else if(icon == "chancerain" || icon == "chancetstorms" || icon == "rain" 
						|| icon == "tstorms" || icon == "unknown") {
					$("#wid").html("<li><a href='' class='icon'><span class='weather_icon rain'></span>비</a></li>");
				} // 해 스크립트
				else if(icon == "clear" || icon == "hazy" || icon == "mostlysunny" 
						|| icon == "partlysunny" || icon == "sunny") {
					$("#wid").html("<li><a href='' class='icon'><span class='weather_icon sun'></span>태양</a></li>");
				}// 구름 스크립트
				else if(icon == "cloudy" || icon == "mostlycloudy" || icon == "partlycloudy" 
					|| icon == "cloudy" || icon == "partlycloudy") {
				$("#wid").html("<li><a href='' class='icon'><span class='weather_icon clouds'></span>구름</a></li>");
				}
		  		
				$("#locationinfo").html("서울");
				$("#weatherinfo").html(value1);
				$("#wetinfo").html(value2);

		  	}
	  });
		
		$(function() {
			timer = setInterval( function () {
				//----------------------------------------------------------------------------------

				$.ajax({
			  	  	url : "/getWheater.do",
				  	dataType : "json",
				  	success : function(data) {
				  		var response = data.results;
				  		for(var i = 0 ; i < response.length ; i ++){
				  			
							value1 = response[i].I_TEMP;
							value2 = response[i].I_HUMI;
							icon = response[i].C_CONDITION;
							
				  		}
				  		console.log(value1);
				  		console.log(value2);
				  		console.log(icon);
						// 눈 스크립트
						if(icon == "chanceflurries" || icon == "chancesleet" || icon == "chancesnow"
							|| icon == "flurries" || icon == "sleet" || icon == "snow" ) {
							$("#wid").html("<li><a href='' class='icon'><span class='weather_icon snow'></span>눈</a></li>");
						} //비 스크립트
						else if(icon == "chancerain" || icon == "chancetstorms" || icon == "rain" 
								|| icon == "tstorms" || icon == "unknown") {
							$("#wid").html("<li><a href='' class='icon'><span class='weather_icon rain'></span>비</a></li>");
						} // 해 스크립트
						else if(icon == "clear" || icon == "hazy" || icon == "mostlysunny" 
								|| icon == "partlysunny" || icon == "sunny") {
							$("#wid").html("<li><a href='' class='icon'><span class='weather_icon sun'></span>태양</a></li>");
						}// 구름 스크립트
						else if(icon == "cloudy" || icon == "mostlycloudy" || icon == "partlycloudy" 
							|| icon == "cloudy" || icon == "partlycloudy") {
						$("#wid").html("<li><a href='' class='icon'><span class='weather_icon clouds'></span>구름</a></li>");
						}
				  		
						$("#locationinfo").html("서울");
						$("#weatherinfo").html(value1);
						$("#wetinfo").html(value2);

				  	}
			  });
				//----------------------------------------------------------------------------------
			}, 150000); // 15분에 한번씩 받아온다.
		});
	});