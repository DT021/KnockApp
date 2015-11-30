function makeGraphsForNodeBeacon(error, aggregatecpus, heartbeats, rams) {

	//Clean Json data
	aggregatecpus.forEach(function(d) {
		d["val_float"] = parseFloat(d["val"]);
		var date = new Date(d["timestamp"]*1000);
		d["datetime"] =date;
	});
	heartbeats.forEach(function(d) {
		var date = new Date(d["timestamp"]*1000);
		d["datetime"] =date;
		d["val_float"]=0;

		for (i=1; i<d["period"]+1; i++) {
			var d_tmp = JSON.parse(JSON.stringify(d));
			d_tmp["timestamp"] = d_tmp["timestamp"]+i;
			var date_new = new Date(d_tmp["timestamp"]*1000);
			d_tmp["datetime"] =date_new;
			if (i==d["period"])
				d_tmp["val_float"] = 0;
			else
				d_tmp["val_float"] = 1;
			heartbeats.push(d_tmp);
		}
	});
	rams.forEach(function(d) {
		d["val_float"] = parseFloat(d["val"]);
		var date = new Date(d["timestamp"]*1000);
		d["datetime"] =date;
	});

	//Create a Crossfilter instance
	var ndx = crossfilter(aggregatecpus);
	var ndx_heartbeats = crossfilter(heartbeats);
	var ndx_rams = crossfilter(rams);

	//Define Dimensions
	var datetimeDim = ndx.dimension(function(d) { return d["datetime"]; });
	var datetimeDim_heartbeats = ndx_heartbeats.dimension(function(d) { return d["datetime"]; });
	var datetimeDim_rams = ndx_rams.dimension(function(d) { return d["datetime"]; });

	//Calculate metrics
	var datetimeDimGroup = datetimeDim.group().reduceSum(function(d) {
		return d["val_float"];
	});
	var datetimeDimGroup_heartbeats = datetimeDim_heartbeats.group().reduceSum(function(d) {
		return d["val_float"];
	});
	var datetimeDimGroup_rams = datetimeDim_rams.group().reduceSum(function(d) {
		return d["val_float"];
	});

	ndx.groupAll();
	ndx_heartbeats.groupAll();
	ndx_rams.groupAll();

	var minDate = datetimeDim.bottom(1)[0]["datetime"];
	var maxDate = datetimeDim.top(1)[0]["datetime"];

	var minDate_heartbeats = datetimeDim_heartbeats.bottom(1)[0]["datetime"];
	var maxDate_heartbeats = datetimeDim_heartbeats.top(1)[0]["datetime"];
	// var maxDate_heartbeats = Date.now() / 1000 | 0;
	// var maxDate_heartbeats = new Date();
	// console.log(minDate_heartbeats+" "+maxDate_heartbeats);

	var minDate_rams = datetimeDim_rams.bottom(1)[0]["datetime"];
	var maxDate_rams = datetimeDim_rams.top(1)[0]["datetime"];

    //Charts
	var cpuStatusChart = dc.lineChart("#cpu-status-row-chart");
	var heartbeatsChart = dc.lineChart("#heartbeats-bar-chart");
	var ramsChart = dc.lineChart("#rams-bar-chart");

	cpuStatusChart
        .width(600)
        .height(200)
        .transitionDuration(500)
        .dimension(datetimeDim)
        .group(datetimeDimGroup)
        .x(d3.time.scale().domain([minDate, maxDate]))
        .renderArea(true)
        .elasticY(true)
        // .xAxisLabel("Time")
        .yAxis().ticks(4);

    heartbeatsChart
    	.width(300)
		.height(200)
		.dimension(datetimeDim_heartbeats)
		.group(datetimeDimGroup_heartbeats)
		.transitionDuration(500)
		.x(d3.time.scale().domain([minDate_heartbeats, maxDate_heartbeats]))
		.renderArea(false)
		.elasticY(true)
		// .xAxisLabel("Time")
		;
		// .xAxis.tickFormat("");
		// .xAxis().ticks(4);

	ramsChart
        .width(300)
        .height(200)
        .transitionDuration(500)
        .dimension(datetimeDim_rams)
        .group(datetimeDimGroup_rams)
        .x(d3.time.scale().domain([minDate_rams, maxDate_rams]))
        .renderArea(true)
        .elasticY(true)
        // .xAxisLabel("Time")
        .yAxis().ticks(4);

    dc.renderAll();

};