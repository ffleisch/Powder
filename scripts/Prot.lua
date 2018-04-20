i=0;
ptype="ELEC"
num=10000;
index=0;
speed=1;
angle=0;
xc=0;
yc=0;
range=200;
function cp(x,y)
	--tpt.set_pause(1);
	while(i<num)do
		angle=math.random(36000)/100;
		xs=math.cos(angle)*speed;
		xy=math.sin(angle)*speed;
		index=sim.partCreate(-3,x,y,tpt.element(ptype));
		sim.partProperty(index,"temp",10000);
		sim.partProperty(index,"vx",xs);
		sim.partProperty(index,"vy",xy);
		sim.partProperty(index,"life",range/speed);
		tpt.log(index);
		i=i+1;
	
	end
	i=0;
end
--xc,yc=sim.adjustCoords(10,10);
--cp(xc,yc);

function click(mousex,mousey,button,event)
	--xc,yc=sim.adjustCoords(x,y);
	
    if(event==2 and button==1)then
    	tpt.log(button);

    	cp(mousex+1,mousey+1);
    end
end
function key(key_char,keyNum,event)
	
  if key_char == "j" then
  	--tpt.log(mousex);
  	tpt.register_mouseclick(click);
  end
  if key_char == "m" then
  --tpt.log("pressed m");
   tpt.unregister_mouseclick(click); 
  end	
end
tpt.register_keypress(key);
