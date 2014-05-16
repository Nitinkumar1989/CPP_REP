<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>D3 Test</title>
<script type="text/javascript" src="JS/data.js"></script>
<script type="text/javascript" src="JS/d3.min.js"></script>
<script type="text/javascript" src="JS/nv.d3.min.js"></script>
<script type="text/javascript" src="JS/tooltip.js"></script>
<script type="text/javascript" src="JS/stream_layers.js"></script>
<style>
.body {
	text-align: center;
	width: 80%;
	height: 80%;
	position: absolute;
	top: 10%;
	left: 10%;
	background: transparent;
}




</style>
<script type="text/javascript">
	var chart;
	var config = false;

	var groupbar = function(obj) {

		if (!config) {
			config = obj.data;
		}
		var test_data = stream_layers(3, 10 + Math.random() * 100, .1).map(
				function(obj, i) {
					return {
						key : 'Stream' + i,
						values : obj
					};
				});

	
		var negative_test_data = new d3.range(0, 3)
				.map(function(d, i) {
					return {
						key : 'Stream' + i,
						values : new d3.range(0, 11)
								.map(function(f, j) {
									return {
										y : 10
												+ Math.random()
												* 100
												* (Math
														.floor(Math.random() * 100) % 2 ? 1
														: -1),
										x : j
									}
								})
					};
				});
		nv.addGraph(function() {
			chart = nv.models.multiBarChart().barColor(
					d3.scale.category20().range()).margin({
				bottom : 100
			}).rotateLabels(45).groupSpacing(
					0.1);

			chart.multibar.hideable(true);

			chart.reduceXTicks(false).staggerLabels(true);

			chart.xAxis.axisLabel("Current Index").showMaxMin(true).tickFormat(
					d3.format(',.6f'));

			chart.yAxis.tickFormat(d3.format('2d..'));
			
			chart.tooltips();

			d3.select('svg#container').datum(negative_test_data).call(chart);

			nv.utils.windowResize(chart.update);

			chart.dispatch.on('stateChange', function(e) {
				nv.log('New State:', JSON.stringify(e));
			});

			return chart;
		});
		return this;
	};

	function init() {
		var view = new groupbar({
			data : data,
			container : document.getElementById("container"),
		});
	}
</script>
</head>
<body onload="init()">
	
		<svg id="container" class="body"></svg>
		
			<h2>
				D3 Report<br> Rect packing
			</h2>
</body>
</html>