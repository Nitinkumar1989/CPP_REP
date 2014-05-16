var config = false;
var m0 = "TOTAL";
var wc = 0;
var m0y = "TOTAL";
var wcy = 0;
var historystack = new Array();
var HexBin = function(obj) {

	if (!config) {
		config = obj.data;
	}
	window.onresize = function(){
		new HexBin(obj);
	};
	var fields = config.fields;
	var appearance = config.appearance.header;
	var dsm = {};
	var sro = (appearance ? (appearance["font-size"] / appearance["font-factor"])
			/ appearance["font-factor"]
			: 1);
	var lt = $("#container").position().left;
	var tt = $("#container").position().top;


	var width = obj.container.clientWidth - lt, height = obj.container.clientHeight - lt;
/*	var randomX = d3.random.normal(width / 2, 80), 
		randomY = d3.random.normal(height / 2, 80), 
		points = d3.range(obj.data.children.length).map(function(i) {
		return [ randomX(), randomY(), obj.data.children[i]];
	});*/
	var rgb = "rgba(0,0,0,0)";
	rgb = rgb.substring(5).split(",");
	r = parseInt(rgb[0]);
	g = parseInt(rgb[1]);
	b = parseInt(rgb[2]);
	var color = d3.scale.linear().domain([ 0, 20 ]).range(
			[ "white", "rgb("+r+","+g+","+b+")" ]).interpolate(d3.interpolateLab);

	var xmin = Number.POSITIVE_INFINITY, ymin = Number.POSITIVE_INFINITY, xmax = Number.NEGATIVE_INFINITY, ymax = Number.NEGATIVE_INFINITY;
	
	var hexbin = d3.hexbin().size([ width, height ]).radius(20).x(function (d, i) {
		var val = d.measures[wc].metrics[m0];
		xmin = xmin > val ? val : xmin;
		xmax = xmax < val ? val : xmax;
		return val;
	}).y(function (d, i) {
		var val = d.measures[wcy].metrics[m0y];
		ymin = ymin > val ? val : ymin;
		ymax = ymax < val ? val : ymax;
		return val;
	});

	// tooltip
	var tbl = jQuery("table.measures");
	var name = tbl.find("#name");
	var value = tbl.find("#total");
	var tfld = tbl.find("#tfld");
	var tdist = tbl.find("svg.dist");
	var $dc = $(document);
	var hdiyl = function(chars, depth) {
		return (chars * sro * 5 * (depth / 10 + 2) + 20);
	};
 
	var details = function(dd) {
		metI = m0;
    	var ac = dd;
    	dd = (ac[0])[2];
			name.html(dd.name);
			var thmu = d3.select(value[0]).select(
					"thead.list tr").selectAll("th").data(
					[ undefined, undefined ].concat(Object
							.keys(config.metrics)),
					function(d, i) {
						return i;
					});
			thmu.exit().remove();
			thmu.enter().append("th").attr("no-wrap",
					"no-wrap").attr("class", "metric");
			thmu.html(function(d, i) {
				return d ? d : "";
			}).style("border", function(d, i) {
				if (!d)
					return "none";
			});
			var data = dd.measures;
			var tru = d3.select(value[0]).select(
					"tbody.list").selectAll("tr").data(
					data, function(d) {
						return d.id;
					});
			tru.exit().remove();
			tru.enter().append("tr");
			var tdu = tru.selectAll("td").data(
					function(d, i) {
						var tdd = new Array(0);
						tdd.push(d.color);
						tdd.push(d.name);
						for (met in d.metrics)
							tdd.push(d);
						return tdd;
					});
			var r = tbl.width() * 0.4 * 0.4 * 0.8;
			value.find("svg.tot").css({
				height : 2 * r * 1.2
			});
			var ttgu = d3.select(
					value.find("svg.tot g.arc")[0]).attr(
					"transform",
					"translate(" + (tbl.width() / 2) + ","
							+ r * 1.2 + ")").selectAll(
					"path").data(
					d3.layout.pie().value(function(d) {
						return d.metrics[metI];
					}).sort(null)(data), function(d, i) {
						return d.data.id;
					});
			ttgu.enter().append("path");
			var arc = d3.svg.arc().outerRadius(r)
					.innerRadius(1);
			ttgu.attr("d", function(d) {
				return arc(d);
			}).style("fill", function(d) {
				/* var r = d.data.color */
				return d.data.color;
			});
			ttgu.exit().remove();
			var toti = config.fields[config.totalFields[wc]];
			if (toti) {
				// toti =
				// config.fields[config.totalFields[wc]];
				tfld
						.html((config.fields[dd.fldid].flddesc
								+ " WISE "
								+ toti.name
								+ " [" + metI + "]" + (dd.parent.parent ? " under "
								+ dd.parent.name
								: "")).toUpperCase());
				if (appearance) {
					tfld.css({
						background : appearance.background,
						color : appearance.color
					});
				}

				for ( var i = 0; i < data.length; i++)
					if (data[i].fldid == toti.fldid) {
						toti = i;
						break;
					}
				toti = wc;
				if (typeof toti == 'number') {
					ttgu
							.select(
									function(d) {
										return d.data.fldid == dd.measures[toti].fldid ? this
												: null;
									}).style(
									"stroke-width", 1);
					var bw = 15;
					var x1 = (dsm[dd.depth]) / (sro * 1.8);

					var dtd = dd.parent.children;
					var xd = new Array();
					var bo = bw * (3 / 10);
					var ch = (dtd.length) * (bw + bo)
							* 1.12;
					tdist.height(ch);
					var plot = d3.select(tdist[0]);
					var ysc = d3.scale.ordinal().domain(
							d3.range(0, dtd.length))
							.rangeBands(
									[ 0, (ch - bw) * 0.6 ]);
					var yt = plot
							.select("g.ysc")
							.attr(
									"transform",
									"translate("
											+ x1
											+ ","
											+ (bw + (bw * 0.5))
											+ ")")
							.selectAll("text")
							.data(
									dtd,
									function(d) {
										xd
												.push(d.measures[toti].metrics[metI]);
										return d.name;
									});
					yt.exit().remove();
					yt.enter().append("text").attr(
							"text-anchor", "end").append(
							"tspan");
					yt
							.attr(
									"y",
									function(d, i) {
										return ysc(i)
												+ (ysc
														.rangeBand() / 2)
												+ (bo * i);
									}).attr("dx", "-0.5em")
							.selectAll("tspan").text(
									function(d) {
										return d.name;
									});

					var tc = 2;
					var pw = (d3.max(xd) + "").length * 10
							* tc * 3;
					if (pw < tbl.width())
						pw = tbl.width();
					tbl.width(pw);
					tdist.width("95%");
					var gw = (pw * 0.85 - x1 - ((d3.max(xd) + "").length * 8));

					var xsc = d3.scale.linear().domain(
							[ 0, d3.max(xd) ]).range(
							[ 0, gw ]);
					var xt = plot.select("g.xsc").attr(
							"transform",
							"translate(" + x1 + "," + bw
									+ ")")
							.selectAll("text").data(
									xsc.ticks(tc),
									function(d, i) {
										return i + "." + d;
									});
					xt.enter().append("text").attr(
							"text-anchor", "start").append(
							"tspan");
					xt.attr("x", xsc).attr("dx", 0).attr(
							"dy", -5).selectAll("tspan")
							.text(String);
					xt.exit().remove();

					var xl = plot.select("g.xsc")
							.selectAll("line").data(
									xsc.ticks(tc),
									function(d, i) {
										return i + "." + d;
									});
					xl.enter().append("line");
					xl.attr("x1", xsc).attr("x2", xsc)
							.attr("y1", 0).attr("y2",
									(ch * 0.9));
					xl.select(function(d, i) {
						return i == 0 ? this : null;
					}).style("stroke", "black").style(
							"stroke-width", 2);
					xl.exit().remove();

					var br = plot.select("g.rects").attr(
							"transform",
							"translate(" + x1 + ","
									+ (bw + (bw * 0.25))
									+ ")")
							.selectAll("rect").data(dtd);
					br.enter().append("rect");
					br
							.attr("y", function(d, i) {
								return ysc(i) + (bo * i);
							})
							.attr('height', ysc.rangeBand())
							.attr(
									'width',
									function(d) {
										return xsc(d.measures[toti].metrics[metI]);
									})
							.attr(
									'fill',
									function(d) {
										return dd.name == d.name ? "black"
												: d.measures[toti].color;
									}).attr("text-anchor",
									"end");
					br.exit().remove();

					var bt = plot
							.select("g.rects")
							.selectAll("text")
							.data(
									dtd,
									function(d, i) {
										return /* config. */toti
												+ d.measures[toti].metrics[metI];
									});
					bt.enter().append("text").attr(
							"text-anchor", "start").append(
							"tspan");
					bt
							.attr("dy", (bw - bo) * 0.4)
							.attr("dx", "0.5em")
							.attr(
									"y",
									function(d, i) {
										return ysc(i)
												+ (ysc
														.rangeBand() / 2)
												+ (bo * i);
									})
							.attr(
									'x',
									function(d, i) {
										return xsc(d.measures[toti].metrics[metI]);
									});
					bt
							.selectAll("tspan")
							.text(
									function(d) {
										return (d.measures[toti].metrics[metI]);
									});
					bt.exit().remove();
				}
			}
			tdu.enter().append("td").attr("no-wrap",
					"no-wrap").attr("class", "metric");
			tdu
					.html(
							function(d, i) {
								if (!d.indexOf
										|| d.indexOf("#") == -1) {
									return typeof d == 'object' ? d.metrics[Object
											.keys(config.metrics)[i - 2]]
											: i == 0 ? ""
													: d;
								}
							})
					.style(
							"background",
							function(d, i) {
								if (d.indexOf
										&& d
												.indexOf("rgba(") != -1)
									return d;
								else if (typeof d == 'object') {
									if (typeof toti == 'number') {
										if (d.id == dd.measures[toti].id
												&& Object
														.keys(config.metrics)[i - 2] == metI) {
											return "black";
										}
									} else if ((Object
											.keys(config.metrics)[i - 2] == metI)
											&& (d.id == dd.measures[wc].id))
										return "black";
								}
							})
					.style(
							"color",
							function(d, i) {
								if (d.indexOf
										&& d.indexOf("#") != -1)
									return d;
								else if (typeof d == 'object') {
									if (typeof toti == 'number') {
										if (d.id == dd.measures[toti].id
												&& Object
														.keys(config.metrics)[i - 2] == metI) {
											return "white";
										}
									} else if ((Object
											.keys(config.metrics)[i - 2] == metI)
											&& (d.id == dd.measures[wc].id))
										return "white";
								}
							})
					.style(
							"width",
							function(d) {
								if (d.indexOf
										&& d.indexOf("#") != -1)
									return "8%";
								else
									return "46%";
							});
			var radius = 50;
			var left = d3.event.clientX + 15 - tbl.width()
					- 2 * radius;
			var top = d3.event.clientY + 15 - tbl.height()
					- 2 * radius;
			top = top < 0 ? 0 : top;
			if (left < 0) {
				left = (d3.event.clientX) + 15 + 2 * radius;
			}
			tbl.css({
				left : left + $dc.scrollLeft(),
				top : top + $dc.scrollTop()
			});
			tbl.show();

			tbl.find("tfoot").show();
	};
	//eotooltip
	//measures
	var setWidth = d3.select("div#measures").selectAll("div").data(config.totalFields);
	setWidth.enter().append("div");
	setWidth.style("color", appearance.color);
	setWidth.html(function(d) {
		return fields[d].flddesc;
	}).attr("class", "total").append("input").attr("type", "radio").attr(
			"name", "wtotal").attr("value", function(d) {
		return d;
	}).attr("checked", function(d, i) {
		if (i == wc)
			return "checked";
	}).on("change", function(d, i) {
		wc = i;
		historystack.pop();
		HexBin(obj);
	});
	//eomeasures
	//metrics

	var mets = d3.select("#metrics").selectAll("div").data(
			Object.keys(config.metrics));
	mets.enter().append("div");
	mets.style("color", appearance.color);
	mets.html(function(d) {
		return d + "(" + config.metrics[d].unit + ")";
	}).attr("class", "metric").append("input").attr("type", "radio").attr(
			"name", "total").attr("value", function(d, i) {
		return d;
	}).attr("checked", function(d, i) {
		if (d == m0)
			return true;
	}).on("change", function(d, i) {
		m0 = d;
		historystack.pop();
		HexBin(obj);
	});
	//eometrics
	
	//measures-y
	var setWidth = d3.select("div#measures-y").selectAll("div").data(config.totalFields);
	setWidth.enter().append("div");
	setWidth.style("color", appearance.color);
	setWidth.html(function(d) {
		return fields[d].flddesc;
	}).attr("class", "total").append("input").attr("type", "radio").attr(
			"name", "wtotal-y").attr("value", function(d) {
		return d;
	}).attr("checked", function(d, i) {
		if (i == wcy)
			return "checked";
	}).on("change", function(d, i) {
		wcy = i;
		historystack.pop();
		HexBin(obj);
	});
	//eomeasures-y
	//metrics-y

	var mets = d3.select("#metrics-y").selectAll("div").data(
			Object.keys(config.metrics));
	mets.enter().append("div");
	mets.style("color", appearance.color);
	mets.html(function(d) {
		return d + "(" + config.metrics[d].unit + ")";
	}).attr("class", "metric").append("input").attr("type", "radio").attr(
			"name", "total-y").attr("value", function(d, i) {
		return d;
	}).attr("checked", function(d, i) {
		if (d == m0y)
			return true;
	}).on("change", function(d, i) {
		m0y = d;
		historystack.pop();
		HexBin(obj);
	});
	hexbin(obj.data.children);
	/*ymin = ymin < xmin ? ymin : xmin;*/
	//eometrics-y
	/*var x = d3.scale.identity().domain([ ymin, xmax ]).range([ width, 0 ]);*/
	var x = d3.scale.linear().domain([ xmin, xmax ]).range([ 0, width ]);
	var y = d3.scale.linear().domain([ ymin, ymax ]).range([ height, 0 ]);

	var xAxis = d3.svg.axis().scale(x).orient("bottom").tickSize(6, -height);

	var yAxis = d3.svg.axis().scale(y).orient("left").tickSize(6, -width);
	var svg = d3.select("svg#container").attr("width",width).attr("height",
			height).attr("transform",
			"translate(" + tt + "," + tt + ")");
/*
	svg.append("clipPath").attr("id", "clip").append("rect").attr("class",
			"mesh").attr("width", width).attr("height", height);
	*/
	
	svg.select("g.XaXIS").text("").transition().attr("class", "y axis").call(yAxis);

	svg.select("g.YaXIS").transition().attr("class", "x axis").attr("transform",
			"translate(0," + height + ")").call(xAxis);

	svg = svg.selectAll("g");/*
	svg.exit().remove();
	svgen = svg.enter().append("svg:g").on("mouseover",details).on("mousemove",details).on("mouseout",
			function(d) {
		tbl.hide();
	}).attr("class", function(d) {
		d.total = 0;
		d.click = false;
		return "chart";
	});
    svgen.append("path");
    svg.selectAll("path").transition().duration(1000).attr("class", "hexagon")
	.attr("d", hexbin.hexagon()).attr("transform", function(d) {
		return "translate(" + d.x + "," + d.y + ")";
	}).style("fill", function(d) {
		return color(d.length);
	});
    svgen.on("click", function(d, i) {
		if (d.children) {
			d.click = true;
			d.clickIndex = i;
			HexBin({
				data : d,
				container : obj.container
			});
		}
    });*/
	return this;
};