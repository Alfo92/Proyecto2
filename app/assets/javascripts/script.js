function setVote()
{
	var result = document.getElementById('result')

	var uls = document.getElementsByTagName('ul')
	var ulsLnt = uls.length

	for(var i=0; i<ulsLnt; i++)
	{
		if(uls[i].className == 'voting')
		{
			var as = uls[i].getElementsByTagName('a')
			var asLnt = as.length

			for(var j=0; j<asLnt; j++)
			{
				as[j].rel = j+1				
				as[j].onclick = function()
				{
					var sb = this.parentNode.parentNode.getElementsByTagName('a')
					var sbLnt = sb.length
					
					for(var k=0; k<sbLnt; k++)
					{
						sb[k].className = ''
					}

					this.className = 'cur'
					

					return false
				}
			}

		}
	}
}

window.onload = setVote;