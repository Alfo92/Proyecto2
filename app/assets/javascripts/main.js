 function gocicle(percent,ident,text){
	i=6;
	setInterval(function() {
	if(percent > i){
		$('div#'+ident).html(
			'<div class="percent"></div><div id="slice"'+
			(i > 50?' class="gt50"':'')+
			'><div class="pie"></div>'+
			(i > 50?'<div class="pie fill"></div>':'')+'</div>');
		var deg = 360/100*i;
		$('#'+ident+' #slice .pie').css({
			'-moz-transform':'rotate('+deg+'deg)',
			'-webkit-transform':'rotate('+deg+'deg)',
			'-o-transform':'rotate('+deg+'deg)',
			'transform':'rotate('+deg+'deg)'
		});
		$('#'+ident+' .percent').html('<span class="big">'+Math.round(i)+'<span class="small">%</span></span>');
		i++;
		}
	}, 70);
 }
 $(document).ready(function(){  
	/* gocicle(Количество процентов,id блока,текст под процентами); */
	gocicle(26,'timer','');
 });
 