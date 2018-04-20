ccolor=0xFF00FF00;
cspeed=0.1;
cycle=0;

function HSL(h, s, l)
   if s == 0 then return l,l,l end
   h, s, l = h/256*6, s/255, l/255
   local c = (1-math.abs(2*l-1))*s
   local x = (1-math.abs(h%2-1))*c
   local m,r,g,b = (l-.5*c), 0,0,0
   if h < 1     then r,g,b = c,x,0
   elseif h < 2 then r,g,b = x,c,0
   elseif h < 3 then r,g,b = 0,c,x
   elseif h < 4 then r,g,b = 0,x,c
   elseif h < 5 then r,g,b = x,0,c
   else              r,g,b = c,0,x
   end
   return math.ceil((r+m)*256),math.ceil((g+m)*256),math.ceil((b+m)*256)
end

function RGBToCol(r,g,b)
sum=b;
sum=sum+256*g;
sum=sum+65536*r;
return(sum+4278190080);
end

function update(i,x,y,ss,nt)
m=0;
neigh=sim.neighbours(x,y,1,1)
	for m in neigh do
		sim.partProperty(m,sim.FIELD_DCOLOUR,ccolor)
	end
end

function cchange()
	cycle=cycle+cspeed;
	if(cycle>255)then
		cycle=0;
	end
	r,g,b=HSL(cycle,128,128);
	
	ccolor=RGBToCol(r,g,b);
end 

tpt.register_step(cchange);

local ccln = elements.allocate("elem", "ccln")
elements.element(ccln, elements.element(elements.DEFAULT_PT_DMND))
elements.property(ccln, "Name", "DYE")
elements.property(ccln, "Description", "Dyes with Color")
elements.property(ccln, "Update",update);