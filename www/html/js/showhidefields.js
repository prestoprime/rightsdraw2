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

