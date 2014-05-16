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
.body {
	text-align: center;
	width: 80%;
	height: 80%;
	position: absolute;
	top: 10%;
	left: 10%;
	background: transparent;
}
#chart, #header, #footer {
  position: absolute;
  top: 0;
}

#header, #footer {
  z-index: 1;
  display: block;
  font-size: 36px;
  font-weight: 300;
  text-shadow: 0 1px 0 #fff;
}

#header.inverted, #footer.inverted {
  color: #fff;
  text-shadow: 0 1px 4px #000;
}

#header {
  top: 80px;
  left: 140px;
  width: 1000px;
}

#footer {
  top: 680px;
  right: 140px;
  text-align: right;
}

rect {
  fill: none;
  pointer-events: all;
}

pre {
  font-size: 18px;
}

line {
  stroke: #000;
  stroke-width: 1.5px;
}

.string, .regexp {
  color: #f39;
}

.keyword {
  color: #00c;
}

.comment {
  color: #777;
  font-style: oblique;
}

.number {
  color: #369;
}

.class, .special {
  color: #1181B8;
}

a:link, a:visited {
  color: #000;
  text-decoration: none;
}

a:hover {
  color: #666;
}

.hint {
  position: absolute;
  right: 0;
  width: 1280px;
  font-size: 12px;
  color: #999;
}
</style>
<script type="text/javascript">
	
	var config = data;
	var m0 = "TOTAL";
	var bubbleReport = function(obj){
		var w = obj.container.clientWidth;
		var h = obj.container.clientHeight;
	    var x = d3.scale.linear().range([0, w]),
	    y = d3.scale.linear().range([0, h]),
	    color = d3.scale.category20c(),
	    root,
	    node;

	var treemap = d3.layout.treemap()
	    .round(false)
	    .size([w, h])
	    .sticky(true)
	    .value(function(d,i) { return d.measures[i].metrics[m0]; });
	var lt = $("#container").position().left;
	var tt = $("#container").position().top;
	var svg = d3.select("svg#container")/* .append("div") */
	    .attr("class", "chart")
	    .style("width", w + "px")
	    .style("height", h + "px")
	  .append("svg:svg")
	    .attr("width", w)
	    .attr("height", h)
	  .append("svg:g")
	    .attr("transform", "translate(" + lt + "," + tt + ")");
	  node = root = config;

	  var nodes = treemap.nodes(root)
	      .filter(function(d) { return !d.children; });

	  var cell = svg.selectAll("g")
	      .data(nodes)
	    .enter().append("svg:g")
	      .attr("class", "cell")
	      .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
	      .on("click", function(d) { return zoom(node == d.parent ? root : d.parent); });

	  cell.append("svg:rect")
	      .attr("width", function(d) { return d.dx - 1; })
	      .attr("height", function(d) { return d.dy - 1; })
	      .style("fill", function(d) { return color(d.parent.name); });

	  cell.append("svg:text")
	      .attr("x", function(d) { return d.dx / 2; })
	      .attr("y", function(d) { return d.dy / 2; })
	      .attr("dy", ".35em")
	      .attr("text-anchor", "middle")
	      .text(function(d) { return d.name; })
	      .style("opacity", function(d) { d.w = this.getComputedTextLength(); return d.dx > d.w ? 1 : 0; });

	  d3.select(window).on("click", function() { zoom(root); });

	  d3.select("select").on("change", function() {
	    treemap.value(this.value == "size" ? size : count).nodes(root);
	    zoom(node);
	  });

	function size(d) {
	  return d.size;
	}

	function count(d) {
	  return 1;
	}

 	function zoom(d) {
	  var kx = w / d.dx, ky = h / d.dy;
	  x.domain([d.x, d.x + d.dx]);
	  y.domain([d.y, d.y + d.dy]);

	  var t = svg.selectAll("g.cell").transition()
	      .duration(d3.event.altKey ? 7500 : 750)
	      .attr("transform", function(d) { return "translate(" + x(d.x) + "," + y(d.y) + ")"; });

	  t.select("rect")
	      .attr("width", function(d) { return kx * d.dx - 1; })
	      .attr("height", function(d) { return ky * d.dy - 1; })
 
	  t.select("text")
	      .attr("x", function(d) { return kx * d.dx / 2; })
	      .attr("y", function(d) { return ky * d.dy / 2; })
	      .style("opacity", function(d) { return kx * d.dx > d.w ? 1 : 0; });
 
	  node = d;
	  d3.event.stopPropagation();
	}
 
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
	<div><svg id="container" class="body"></svg><div>
	<h2>
		D3 Report<br> Rect packing
	</h2>
</body>
</html>