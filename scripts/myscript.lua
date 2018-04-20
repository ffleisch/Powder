x=0;--max 611
y=0;--max 382
while x<50 do 
	while y<50 do
		tpt.create(x+100,y+100,math.random(50));
		y=y+1;
	end
	y=0;
	x=x+1;
end