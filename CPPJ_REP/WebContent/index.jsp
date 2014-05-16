<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>D3 Test</title>
<script type="text/javascript" src="JS/data.js"></script>
<script type="text/javascript" src="JS/d3.min.js"></script>
<script type="text/javascript" src="JS/hexbin.js"></script>
<script type="text/javascript" src="JS/topojson.js"></script>
<script type="text/javascript" src="JS/jquery-1.10.2.js"></script>
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
svg {
stroke-size: 0.5; 
}

</style>
<script type="text/javascript">
	
	var config = false;
	var m0 = "TOTAL";
	var wc = 0;
	var m0y = "TOTAL";
	var wcy = 0;
	var xmin = Number.POSITIVE_INFINITY, ymin = Number.POSITIVE_INFINITY, xmax = Number.NEGATIVE_INFINITY, ymax = Number.NEGATIVE_INFINITY;
	
	
	var lineDrawing = function(obj){
		/* 
		if(!config){
			config = obj.data;
		}
		
		var lt = $("#container").position.left;
		var tt = $("#container").position.top;
		
		var hex = d3.hexbin().size([width, height]).radius(20).x(function (d, i) {
			var val = d.measures[wc].metrics[m0];
			xmin = xmin > val ? val : xmin;
			xmax = xmax < val ? val : xmax;
			return val;
		}).y(function (d, i) {
			var val = d.measures[wcy].metrics[m0y];
			ymin = ymin > val ? val : ymin;
			ymax = ymax < val ? val : ymax;
			return val;
		}); */
		var width = obj.container.clientWidth, height = obj.container.clientHeight;
		width = 1200;height = 600;
		var d = 100;
		var x = d3.scale.linear().domain([0,d]).range([0,width]);
		var y = d3.scale.linear().domain([0,d]).range([height,0]);
		var axis = d3.svg.axis()
	    	.scale(x);
		var yaxis = d3.svg.axis()
    	.scale(y).orient("left");
		var svg = d3.select("svg#container")
					.attr("width", width)
					.attr("height", height);
	    var interval = setInterval(function (e) {
	    	try {
		    	x.domain([0, d = d * 2]);
		    	y.domain([0, d]);
		    	svg.select("g.x").attr("transform", "translate(0, " + height + ")").call(axis);
		    	svg.select("g.y").call(yaxis);
	    	} catch(ex) {
	    		clearInterval(interval);
	    	}
	    }, 1000);
		
		
	return this;
};

	function init()
	{
		 var view = new lineDrawing({
			data: data,
			container: document.getElementById("container"),
		}); 
	}

	</script>
</head>
<body onload="init()">
	<div><svg id="container" class="body"><G class="x"></G><g class="y"></g></svg><div>
	<h2>
		D3 Report<br> Rect packing
	</h2>
</body>
</html>