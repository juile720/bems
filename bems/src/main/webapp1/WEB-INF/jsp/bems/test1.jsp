<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>test graph</title>

<script type='text/javascript' src='http://code.jquery.com/jquery-1.6.2.js'></script>
<script src="/highchart/highcharts.js"></script>
<script src="/highchart/modules/exporting.js"></script>
</head>
<body>
<div id="container" style="min-width: 400px; height: 400px; margin: 0 auto"></div>
<div id="container1" style="min-width: 400px; height: 400px; margin: 0 auto"></div>
</body>
<script type="text/javascript">

/*
	var options = {
		chart: {
			zoomType: 'xy',
			renderTo: 'container',
			//type: 'line',
			marginRight: 130,
			marginBottom: 25
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
		xAxis: {
			categories: []
		},
		yAxis: {
			title: {
				text: 'CO2'
			},
			plotLines: [{
				value: 0,
				width: 1,
				color: '#808080'
				}]
			},
			tooltip: {
				formatter: function() {
					return '<b>'+ this.series.name +'</b>'+this.x +': '+ this.y;
				}
			},
//			legend: {
//				layout: 'vertical',
//				align: 'left',
//				verticalAlign: 'top',
//				x: -10,
//				y: 100,
//				borderWidth: 0
//			},
		    legend: {
		        layout: 'vertical',
		        align: 'left',
		        x: 80,
		        verticalAlign: 'top',
		        y: 55,
		        floating: true,
		        backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
		    },
			series: []
		}
*/

var charts = {
    chart: {
        renderTo: 'container',
        zoomType: 'xy',
		marginTop:90
    },
    title: {
        text: '',
		y: 30
    },
    subtitle: {
        text: ''
    },

    xAxis: [{
		categories: [],
		labels: {
			enabled: false
		}
	}],
    yAxis: [{ // Primary yAxis
        labels: {
            formatter: function() {
                return this.value +' RPM';
            },
            style: {
                color: '#89A54E'
            }
        },
        title: {
            text: 'RPM',
            style: {
                color: '#89A54E'
            }
        },				
        opposite: true,
        showEmpty: false

    }, { // Secondary yAxis
        gridLineWidth: 0,
        title: {
            text: 'SPEED',
            style: {
                color: '#4572A7'
            }
        },
        labels: {
            formatter: function() {
                return this.value +' Km/H';
            },
            style: {
                color: '#4572A7'
            }
        },
        showEmpty: false
    }
	],
    tooltip: {
		pointFormat: '{series.name}: <b>{point.y}</b><br/>',
		crosshairs: [true, true],
		shared: true
    },
    legend: {
        //layout: 'vertical',
		layout: 'horizontal',
        align: 'center',
        x: 0,
        verticalAlign: 'top',
        y: 0,
        floating: true,
        backgroundColor: '#FFFFFF'
    },
	
plotOptions: {
    series: {
        cursor: 'pointer',
        point: {
            events: {
                click: function() {

                },
                mouseOver: function() {

                }
            }
        }
    }
},
    series: []
}

	var options = {
		    chart: {
		        zoomType: 'xy'
				,renderTo: 'container'
				,marginTop: 30
				,marginRight: 20
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
		        categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
		                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
		        crosshair: true
		    }],
		    yAxis: [{ // Primary yAxis
		        labels: {
		            format: '{value} mm',
		            style: {
		                color: Highcharts.getOptions().colors[2]
		            }
		        },
		        title: {
		            text: 'CO2',
		            style: {
		                color: Highcharts.getOptions().colors[2]
		            }
		        },
		        opposite: true

		    }, { // Secondary yAxis
		        gridLineWidth: 0,
		        title: {
		            text: '냉방',
		            style: {
		                color: Highcharts.getOptions().colors[0]
		            }
		        },
		        labels: {
		            format: '{value} kwh',
		            style: {
		                color: Highcharts.getOptions().colors[0]
		            }
		        }
			}
		    ],
			tooltip: {
		        shared: true
		    },
			legend: {
				layout: 'horizontal',//'vertical',
				align: 'right',
				x: -80,
				verticalAlign: 'top',
				y: 55,
				floating: false,// true,
				backgroundColor :'#323b44',
				itemStyle:{color:'#0b4a45'}
				//backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
			},
			series: []
		}
			
		jQuery(function($){
			$.ajax({ 
			    type:"POST",  
			    url:"/data/getgraph.do",
			    dataType: 'json',
			    success:function(data){
			    	console.log(data);
			    	var result = eval(data.categories);

			    	console.log(result);

			    	options.xAxis.categories = result;
			    	//options.xAxis.categories = data.categories;
			    	
		            $.each(data.series, function(i, seriesItem) {
		                console.log(seriesItem) ;
		                var series = {
		                    data: []
		                };
		                series.name = seriesItem.name;
		                series.color = seriesItem.color;
		                series.type = seriesItem.type;

		                $.each(seriesItem.data, function(j, seriesItemData) {
//		                    console.log("Data (" + j +"): "+seriesItemData) ;
		                    series.data.push(parseFloat(seriesItemData));
		                });

		                options.series[i] = series;
		            });
/*
			    	var series = {data: []};
		            $.each(data.data, function(i, seriesItem) {
		                console.log(seriesItem) ;
		                
	                    console.log("Data (" + i +"): "+seriesItem) ;
	                    series.data.push(parseFloat(seriesItem));
						
		            });
		            series.name = data.name; 
		            options.series[0] = series;
*/
			    	chart = new Highcharts.Chart(options);
//					chart = new Highcharts.Chart(charts);
			    	
			    }
			});
		});

		</script>
</html>
