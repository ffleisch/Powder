require "scripts/perlin"

t=perlinGenerator:new();
t:generateLookup();
t.res=0.5;
t.oct=10;
t.zoom=100;

n=0
m=0
tpt.set_pause(1);
function elemPick(x)
	elem=0
	if(x>0.67)then
		elem=tpt.element("SNOW")
	elseif(x>0.6)then
		elem=tpt.element("STNE")
	elseif(x>0.43)then
		elem=tpt.element("PLNT")
	elseif(x>0.4)then
		elem=tpt.element("SAND")
	else
		elem=tpt.element("WATR")
	end
	return(elem)
end

function river(x,y)
	posx=x;
	posy=y;
	for i=0,200 do
		val=t:perlinOctave(posx/zoom,posy/zoom,oct,res);
		print(val,posx,posy)
		repeat
			posxn=posx+math.floor(math.random(-1,2))
			posyn=posy+math.floor(math.random(-1,2))
			nval=0.0;
			nval=t:perlinOctave(posxn/zoom,posyn/zoom,oct,res)
		until(nval<=val)
		sim.createLine(posx,posy,posxn,posyn,0,0,tpt.element("WATR"),0,1,1);
		posx=posxn;
		posy=posyn;
	end
end

function shade(x,y)
	mx=t:perlinOctave(x-1,y)-t:perlinOctave(x,y);
	my=t:perlinOctave(x,y-1)-t:perlinOctave(x,y);
	if math.max(mx,my)==mx then
		col=0
	else
		col=20
	end
	if(math.max(math.abs(mx),math.max(math.abs(my)))==mx)then
		sf=math.abs(mx)*255*10
	else
		sf=math.abs(my)*255*10
	end	
	
	sim.decoBox(m,n,m,n,col,col,col,math.abs(sf));
end

function genMap()
	while(n<382)do
		while(m<611)do		
			num=(t:perlinOctave(m,n)+1)/2;
			if(num>0)then
				
				index=tpt.create(m,n,elemPick(num));
				if(num>0.4)then
					shade(m,n)
				end
				--sim.decoBox(m,n,m,n,num*255,num*255,num*255);
			end
			m=m+1;
		end
		n=n+1;
		m=0;
	end
	n=0;
end
