<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>D3 Test</title>
<script type="text/javascript" src="JS/data.js"></script>
<script type="text/javascript" src="JS/d3.v3.min.js"></script>
<script type="text/javascript" src="JS/topojson.js"></script>
<script type="text/javascript" src="JS/jquery-1.10.2.js"></script>
<style>
text {
	font-size: 11px;
	pointer-events: none;
}

text.parent {
	fill: #1f77b4;
}

circle {
	fill: #ccc;
	stroke: #999;
	pointer-events: all;
}

circle.parent {
	fill: #1f77b4;
	fill-opacity: .1;
	stroke: steelblue;
}

circle.parent:hover {
	stroke: #ff7f0e;
	stroke-width: .5px;
}

circle.child {
	pointer-events: none;
}

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
	
	var config = data;
	var m0 = "TOTAL";
	var bubbleReport = function(obj){
	var w = obj.container.clientWidth;
	var h = obj.container.clientHeight;
    var	r = w / 2;
    	 x = d3.scale.linear().range([0, r]),
    	y = d3.scale.linear().range([0, r]); 
    var node = root = config;
	var pack = d3.layout.pack()
   		.size([r, r])
    	.value(function(d,i) { return d.measures[i].metrics[m0]; });

	var lt = $("#container").position().left;
	var tt = $("#container").position().top;
	var vis = d3.select("svg#container")
    	.attr("width", w)
    	.attr("height", h)
  		.append("svg:g")
    	.attr("transform", "translate(" + lt + "," + tt + ")");
	var nodes = pack.nodes(root);
	vis.selectAll("circle")
    .data(nodes)
  .enter().append("svg:circle")
    .attr("class", function(d) { return d.children ? "parent" : "child"; })
    .attr("cx", function(d) { return d.x; })
    .attr("cy", function(d) { return d.y; })
    .attr("r", function(d) { return d.r; })
    .on("click", function(d) { return zoom(node == d ? root : d); });
	
	vis.selectAll("text")
    .data(nodes)
  .enter().append("svg:text")
    .attr("class", function(d) { return d.children ? "parent" : "child"; })
    .attr("x", function(d) { return d.x; })
    .attr("y", function(d) { return d.y; })
    .attr("dy", ".35em")
    .attr("text-anchor", "middle")
    .style("opacity", function(d) { return d.r > 20 ? 1 : 0; })
    .text(function(d) { return d.name; });
	  d3.select(window).on("click", function() { zoom(root); });
	function zoom(d, i) {
		  var k = r / d.r / 2;
		  x.domain([d.x - d.r, d.x + d.r]);
		  y.domain([d.y - d.r, d.y + d.r]);

		  var t = vis.transition()
		      .duration(d3.event.altKey ? 7500 : 750);

		  t.selectAll("circle")
		      .attr("cx", function(d) { return x(d.x); })
		      .attr("cy", function(d) { return y(d.y); })
		      .attr("r", function(d) { return k * d.r; });

		  t.selectAll("text")
		      .attr("x", function(d) { return x(d.x); })
		      .attr("y", function(d) { return y(d.y); })
		      .style("opacity", function(d) { return k * d.r > 20 ? 1 : 0; });

		  node = d;
		  d3.event.stopPropagation();
		} 
	console.log("Hello");
	return this;
};
function init()
{
	var view = new bubbleReport({
		data: data,
		container: document.getElementById("container"),
	});
}	
	</script>
</head>
<body onload="init()">
	<svg id="container" class="body"></svg>
	<h2>
		D3 Report<br> circle packing
	</h2>
</body>
</html>