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
.axis text {
  font: 10px sans-serif;
}

.axis path,
.axis line {
  fill: none;
  stroke: #000;
  shape-rendering: crispEdges;
}

.hexagon {
  fill: none;
  stroke: #000;
  stroke-width: .5px;
}
</style>
<script type="text/javascript">
	
	var config = false;
	var m0 = "TOTAL";
	var bubbleRep = function(obj){
		
		if (!config) {
			config = obj.data;
		}
		

		var lt = $("#container").position().left;
		var tt = $("#container").position().top;
		
		var margin = {top: 20, right: 20, bottom: 30, left: 40},
	    width = obj.container.clientWidth  - tt,
	    height = obj.container.clientHeight - lt;
		

	var randomX = d3.random.normal(width / 2, 80),
	    randomY = d3.random.normal(height / 2, 80),
	    points = d3.range(100).map(function() { return [randomX(), randomY()]; });

	var color = d3.scale.linear()
	    .domain([0, 20])
	    .range(["white", "steelblue"])
	    .interpolate(d3.interpolateLab);

	var hexbin = d3.hexbin()
	    .size([width, height])
	    .radius(20);

	var x = d3.scale.identity()
	    .domain([0, width]);

	var y = d3.scale.linear()
	    .domain([0, height])
	    .range([height, 0]);

	var xAxis = d3.svg.axis()
	    .scale(x)
	    .orient("bottom")
	    .tickSize(6, -height);

	var yAxis = d3.svg.axis()
	    .scale(y)
	    .orient("left")
	    .tickSize(6, -width);

	var svg = d3.select("body").append("svg")
	    .attr("width", width + margin.left + margin.right)
	    .attr("height", height + margin.top + margin.bottom)
	  .append("g")
	    	.attr("transform", "translate(" + lt + "," + tt + ")");

	svg.append("clipPath")
	    .attr("id", "clip")
	  .append("rect")
	    .attr("class", "mesh")
	    .attr("width", width)
	    .attr("height", height);

	svg.append("g")
	    .attr("clip-path", "url(#clip)")
	  .selectAll(".hexagon")
	    .data(hexbin(points))
	  .enter().append("path")
	    .attr("class", "hexagon")
	    .attr("d", hexbin.hexagon())
	    .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
	    .style("fill", function(d) { return color(d.length); });

	svg.append("g")
	    .attr("class", "y axis")
	    .call(yAxis);

	svg.append("g")
	    .attr("class", "x axis")
	    .attr("transform", "translate(0," + height + ")")
	    .call(xAxis);		

	return this;
};

	function init()
	{
		var view = new bubbleRep({
			data: data,
			container: document.getElementById("container"),
		});
	}

	</script>
</head>
<body onload="init()">
	<div><svg id="container" class="body"></svg><div>
	<h2>
		D3 Report<br> Rect packing
	</h2>
</body>
</html>