$(document).ready(function(){
	var a=$(".button").text();
        $(".button").text('Open '+a);
        $(".nascosto").hide();
        $(".button").toggle(function(){
        $(this).next().slideDown();
        $(this).text('Close '+a)
        $(".button").addClass('button_open');
},
function(){
	var a=$(".button").text().substring(6);
        $(this).next().slideUp();
        $(this).text('Open '+a);
})
});

//
//$(document).ready(function(){
//	$(".button").text('fill constraints');	
//	$(".nascosto").hide();
//	//$(".button")
//	$(".button").toggle(function(){
//	$(this).next().slideDown();
//	$(this).text('close constraints')
//	$(".button").addClass('button_open');
//},
//function(){
//	$(this).next().slideUp();
//	$(this).text('fill constraints');
//})
//});
//
$(document).ready(function(){
	var a=$(".button_percentages").text();
        $(".button_percentages").text('Open '+a);
        $(".hidden_percentages").hide();
        $(".button_percentages").toggle(function(){
        	$(this).next().slideDown();
        	$(this).text('Close '+a)
        	$(".button_percentages").addClass('button_open');
	},function(){
		var a=$(".button_percentages").text().substring(6);
        	$(this).next().slideUp();
        	$(this).text('Open '+a);
	})
});

$(document).ready(function(){
	$(".actedon").text('acted on:');	
	$(".ipdetails").hide();
	//$(".button")
	$(".actedon").toggle(function(){
	$(this).next().slideDown();
	$(this).text('acted on:')
	$(".actedon").addClass('button_open');
},
function(){
	$(this).next().slideUp();
	$(this).text('acted on:');
})
});
