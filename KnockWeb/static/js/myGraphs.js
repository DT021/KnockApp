function makeGraphs(error, projectsJson) {
	
	var color_array = [];
	//Clean projectsJson data
	var processes_array = projectsJson["processes"];
	// var dateFormat = d3.time.format("%Y-%m-%d %H:%M:%S");
	processes_array.forEach(function(d) {
		if (d["status"].valueOf()=="ACTIVE") {
			d["name"] = d["name"]+": ACTIVE";
			color_array.push("#00AAA0");
		} else if (d["status"].valueOf()=="FAULTY") {
			d["name"] = d["name"]+": FAULTY";
			color_array.push("#FF7A5A");
 		} else {
			d["name"] = d["name"]+": TO_BE_DEPLOYED";
			color_array.push("#FFB85F");
		}
	});

	//Create a Crossfilter instance
	var ndx = crossfilter(processes_array);

	//Define Dimensions
	var statusDim = ndx.dimension(function(d) { return d["name"]; });

	//Calculate metrics
	var statusDimGroup = statusDim.group(); 

	var all = ndx.groupAll();

    //Charts
	var processStatusChart = dc.rowChart("#process-status-row-chart");

	processStatusChart
        .width(600)
        .height(200)
        .colors(color_array)
        .transitionDuration(500)
        .dimension(statusDim)
        .group(statusDimGroup)
        .xAxis().tickFormat(function(v) { return ""; });

    dc.renderAll();

};
