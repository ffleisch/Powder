require "scripts/perlin"

tpt.set_pause(1);

function elemPick(x)
	elem=0
	if(x>0.71)then
		elem=tpt.element("SNOW")
	elseif(x>0.67)then
		elem=tpt.element("STNE")
	elseif(x>0.57)then
		elem=tpt.element("PLNT")
	elseif(x>0.55)then
		elem=tpt.element("SAND")
	else
		elem=tpt.element("WATR")
	end
	return(elem)
end

stone=perlinGenerator:new()
stone:generateLookup(1)
stone.zoom=70
stone.oct=30
stone.res=.5

sand=perlinGenerator:new()
sand:generateLookup(2)
sand.zoom=70
sand.oct=30
sand.res=.5

for n=0,611 do
	h=((stone:perlinOctave(0,n)+1)/2)*100+10
	sim.createLine(n,382-h,n,382,0,0,tpt.element("STNE"))
	
	h=h+(sand:perlinOctave(n,0))*30
	sim.createLine(n,382-h,n,382,0,0,tpt.element("SAND"))
end
