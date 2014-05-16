<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>D3 Test</title>
<script type="text/javascript" src="JS/d3.v3.min.js"></script>
<script type="text/javascript" src="JS/topojson.js"></script>
<style>


.graticule {
  fill: none;
  stroke: #777;
  stroke-width: .5px;
  stroke-opacity: .5;
}

.land {
  fill: #222;
}

.boundary {
  fill: none;
  stroke: #fff;
  stroke-width: .5px;
}


</style>
</head>
<body>
	<script type="text/javascript">


	var width = document.documentElement.scrollWidth -20,
	    height = document.documentElement.scrollHeight - 20;
	var c = 7;
	var projection = d3.geo.equirectangular()
	       .scale(width / c, height / c)
	    .translate([width / 2, height / 2]);
	
	var path = d3.geo.path()
	    .projection(projection);

	var graticule = d3.geo.graticule();

	var svg = d3.select("body").append("svg")
	    .attr("width", width)
	    .attr("height", height);
	
		d3.json("JS/countries-topo.json", function(error, map) {
			var data = topojson.feature(map, map.objects["countries-geo"]).features;
			svg.selectAll("path").data(data).enter().append("path").attr("d", path)
			.style("fill", "Green").style("Opacity", 0.8).on("mouseover",function(d){
				d3.select(this).transition().duration(300).style("fill", "orange");
			}).on("mouseout", function() {
			    d3.select(this)
			    .transition().duration(500)
			    .style("fill", "Green").style("Opacity", 0.8);});
		});
		
		/*svg.append("path")
		    .datum(graticule)
		    .attr("class", "graticule")
		    .attr("d", path);

		d3.json("JS/countries-topo.json", function(error, world) {
		  svg.insert("path", ".graticule")
		      .datum(topojson.feature(world, world.objects["countries-geo"]))
		      .attr("class", "land")
		      .attr("d", path).on("mouseover",function(d,i){
		    	  console.log(this.d);

		  svg.insert("path", ".graticule")
		      .datum(topojson.mesh(world, world.objects["countries-geo"], function(a, b) { return a !== b; }))
		      .attr("class", "boundary")
		      .attr("d", path);
		      });
		});
		 */
	</script>
	<!-- <div class="vertical-line" style="height : 150px"/> -->
</body>
</html>