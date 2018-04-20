d=2;
imax=10;
voff=0;
hoff=-1;
zoom=80;
cshift=0;
cstep=50;
saturation=255;
lightness=128;

mmax=382;
lmax=611;
rhoff=0;
rvoff=0;

function iterate(px,py)
	x=0;
	y=0;
	i=0;

	while(x^d+y^d<2^d and (i<imax))do
		xz=x^d-y^d+px;
		y=2*x*y+py;
		x=xz;
		i=i+1;
	end
	return(i)
end
 
colormax=255
colormin=0
function red(r)
	if(255-(r)>0)then
		return(255-r)
	else
		return(0)
	end
end

function green(g)
	if(g<255)then
		return(g)
	else
		if(g>255 and g-255 <255)then
			return((-1*g)+255*2)
		else
			return(0)
		end
	end
end

function blue(b)
	if(b>255)then
		return(b-255)
	else
		return(0)
	end
end

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

function shiftcolor(c,shift)
	c=c+shift;
	while(c>255)do
		c=c-255;
	end
	return(c);
	
end

function drawmandel()
	--width=400
	--height=100
	--w=Window:new(150,100,width-0.25,height);
	--pb=ProgressBar:new(10,10,300,20,0,"Working");
	--w:addComponent(pb);
	--w:onTryExit(function() interface.closeWindow(w) end);
	--interface.showWindow(w);
	l=0;

	m=0;
	color=0;

	cmax=0;

	progmax=lmax*mmax;
	tpt.set_pause(1);
	while(l<lmax)do
		while(m<mmax)do
			m=m+1;
			color=iterate(((l-lmax/2)/zoom)+hoff,((m-mmax/2)/zoom)+voff);
			sim.partCreate(-2,l,m,tpt.element("METL"));
			if(color==imax)then
				--sim.decoBox(l,m,l,m,0,0,0);
				sim.partKill(l,m);
			else
				r=0;
				g=0;
				b=0;
				color=math.sqrt(color)*cstep;
				color=shiftcolor(color,cshift)
				if(color>=255)then
					color=color-255;
				end
				r,g,b =HSL(255-color,saturation,lightness);		
				sim.decoBox(l,m,l,m,r,g,b);			
			end
			--pb:progress((l*m/progmax)*100)
		end
		l=l+1;
		m=0;

	end
	l=0;
	rhoff=hoff;
	rvoff=voff;
end

function gui()

	drawmandel();
	
end

function showcoordinates()
	tpt.drawtext(15,110,"Zoom",0);
	tpt.drawtext(50,110,zoom,0);
	tpt.drawtext(15,130,"x:",0);
	tpt.drawtext(50,130,hoff,0);
	tpt.drawtext(15,140,"y:",0);
	tpt.drawtext(50,140,voff,0);
end

function key(key_char,keyNum,event)
	if key_char == "j" then
		gui();	
	end		
end

function click(mousex,mousey,button,event)
	--xc,yc=sim.adjustCoords(x,y);
	
    if(event==2 and button==7)then
    	hoff=rhoff+((mousex-(lmax/2))/zoom)
    	voff=rvoff+((mousey-(mmax/2))/zoom)
		tpt.log(button);
    	
    end
end


tpt.register_keypress(key);
tpt.register_step(showcoordinates);
tpt.register_mouseclick(click);
