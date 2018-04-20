x=100;--max 611
y=100;--max 382
n=0;
size=15;
tpt.set_pause(1)

sx1=10;
sy1=250;
sx2=600;
sy2=300;
yoff=200;
xoff=250;
xinit=50;
yinit=50;
bestofall=0;
gengren=500;
id=0;
lastbest=0;
m=0;
l=0;
an=0;
gen=0;
genav=0;
mutation=0.01;
crossover=1;
ttime=500;
fmode=1;
mmode=2;
maxp=144;
stype="TTAN";
function delete(times)
xd=0;
yd=0;
tpt.start_getPartIndex()
	while times>=0 do
     while tpt.next_getPartIndex() do
        local index = tpt.getPartIndex()
        tpt.delete(tpt.get_property("x",index),tpt.get_property("y",index));
     end
     --tpt.log(index);
     times=times-1;
     end

end

function frame(write,overwrite,value)
	if overwrite==true then
		time=value;
	end
	if time==nil then
		time=0;
	end
	if write==true then
		time=time+1;
	end
	--tpt.log(time);
	return(time);
end

function newAutotable(dim)
    local MT = {};
    for i=1, dim do
        MT[i] = {__index = function(t, k)
            if i < dim then
                t[k] = setmetatable({}, MT[i+1])
                return t[k];
            end
        end}
    end

    return setmetatable({}, MT[1]);
end

eval=newAutotable(1);

file = io.open("log.txt", "w")

function randp(prob)
	if math.random(math.floor(1/prob))==1 then
		r=math.random(maxp);
		return r
	else 
		return 0;
	end 
end

function init()
	array =newAutotable(3); 
	x=0;
	y=0;
	while n<size+1 do
	while x<xinit do 
		while y<yinit do
			array[n][x][y]=randp(0.5);
			
			
			y=y+1;
		end
		y=0;
		x=x+1;
	end
	x=0;
	n=n+1;
	--tpt.log(n);
	end
	return(array);
end

function drawArray(a,number) 
x=0;
y=0;
while x<xinit do 
	while y<yinit do
		if not(array[number][x][y]==nil) then
			tpt.create(x+xoff,y+yoff,array[number][x][y]);
		end
		y=y+1;
	end
	y=0;
	x=x+1;
end
x=0;

end






function createvoid(xa,ya,xb,yb)
	n1=0;
	m1=0;
	while (n1<xb-xa) do
		n1=n1+1;
		while (m1<yb-ya)do
			m1=m1+1;
			tpt.create(n1+xa,m1+ya,stype);
		end
		m1=0;
	end
	n1=0;
end

function fitnessfunc(xa,ya,xb,yb,mode)
	n1=0;
	m1=0;
	iheat=0;
	num=0;
	while (n1<xb-xa) do
		n1=n1+1;
		while (m1<yb-ya)do
			m1=m1+1;
			if mode==0 then
				if not(sim.partID(xa+n1,ya+m1)==nil) then
					iheat=iheat+tpt.get_property("temp",xa+n1,ya+m1);
					num=num+1;
				end
			end
			if mode==1 then
				if not(sim.partID(xa+n1,ya+m1)==nil) then
					num=num+1;
				end
			end
			--tpt.log(n1);
			--tpt.log(m1);
		end
		m1=0;
	end
	n1=0;
	if mode==0 then
		iheat=iheat/num;
	end
	if mode==1 then
		iheat=((xb-xa)*(yb-ya))-num;
	end
	return(iheat);
end

function mate(inputarray,crit)
	order=newAutotable(1);
	n2=0;
	m2=0;
	p1=0;
	p2=0;
	help=0;
	champ=-1;
	bestchamp=0;
	while n2<(size+1) do
		order[n2]=0;
		n2=n2+1;
	end
	n2=0;
	m2=0;
	while n2<size do
		while m2<size do
			if crit[n2]>crit[m2] then
				--help=order[n2];
				--order[n2]=order[m2];
				--order[m2]=help;
				order[n2]=order[n2]+1;
				file:write(crit[n2]," >= ",crit[m2],"   swap\n");
				


			end
			m2=m2+1;
		end
		m2=0;
		n2=n2+1; 
	end
	while m2<size do
		order[m2]=size-order[m2]-1;
		m2=m2+1;
	end
	m2=0;
	m2=0;
	while m2<size do
		file:write("Order : ",order[m2],"   Crit: ",crit[m2],"\n");
		file:flush();
		m2=m2+1;
	end
	m2=0;

		 
	n2=0;
	file:write("Generation: ",gen,"\n");
	file:flush();

	while n2<size do
		n2=n2+1;
		--tpt.log(order[n2]);
		if mmode==0 then
			if order[n2]<(size/2) then
			
				p1=math.random(math.floor(size/2))+size/2;
				p2=math.random(math.floor(size/2))+size/2;
				truemate(p1,p2,n2,array,crossover,mutation,false);
			end	
		end
		if mmode==1 then
			m2=0;
			p1=-1;
			p2=-1;
			r1=0;
			r1o=0;
			while(p1<0)do
				r1=math.random(size);
				r1=r1;
				r1o=order[r1]-1;

				if math.random(r1o+1)==1 then
					p1=r1;
					tpt.log("chosen p1");
					tpt.log(r1o);
				end
			end
		
			
			r1=0;
			while(p2<0)do
				r1=math.random(size);
				r1=r1;
				r1o=order[r1]-1;
				if math.random(r1o+1)==1 then
					p2=r1;
					tpt.log("chosen p2");
					tpt.log(r1o);
				end
			end
	
		
			a1=n2;
			r2=-1;
			r2=math.random(size-order[a1]+1);
			--tpt.log	(r2+1000);
			if(r2==1)then
				tpt.log("Aim");
				tpt.log(order[a1]);
				truemate(p1,p2,a1,array,crossover,mutation,false);
			end
		end
		champ=0;
		if mmode==2 then
			champ=999999;
			order[champ]=9999999;
			while m2<size do
				if order[m2]<order[champ] then
					champ=m2;
					--tpt.log(champ);
				end
				m2=m2+1;
			end
			m2=0;
			if not(order[n2]==champ) then
				p1=champ;
				p2=champ;
				truemate(p1,p2,n2,array,1,mutation,true);
				tpt.log("Champ");
				tpt.log(champ);
				tpt.log(crit[champ]);
			end	
		end
	end

	return order
end

function truemate(parent1,parent2,aim,source,crosspos,mutpos,copy)
	n3=0;
	m3=0;
	while n3<xinit do
		while m3<yinit do
			if (math.random(math.floor(1/crosspos))==1)or(copy==true) then
				if math.random(1)==1 then
					source[aim][n3][m3]=source[parent1][n3][m3];
				else
					source[aim][n3][m3]=source[parent2][n3][m3];
				end
			end
			if math.random(math.floor(1/mutpos))==1 then
				source[aim][n3][m3]=randp(0.5);
			end
			m3=m3+1;
		end
		m3=0;
		n3=n3+1;
	end
	n3=0;
	return source;
end

init();
createvoid(sx1,sy1,sx2,sy2);


lgenav=0;
fitness=0;
function always()

	if tpt.set_pause()==0 then
		frame(true,false,0);
	end
	tpt.drawtext(15,30,"Current frame:",0);
	tpt.drawtext(15,40,frame(false,false,0));
	tpt.drawtext(15,50,"Generation:",0);
	tpt.drawtext(15,60,gen);
	tpt.drawtext(15,70,"Current best:",0);
	tpt.drawtext(15,80,bestofall);
	tpt.drawtext(15,90,"Last gen avrg:",0);
	tpt.drawtext(15,100,lgenav);
	--tpt.drawtext(10,10,(sx1,sy1,sx2,sy2));
	if frame(false,false,0) == 1 then
		createvoid(sx1,sy1,sx2,sy2);
		drawArray(array,an);
		id=sim.saveStamp(xoff,yoff,xinit,yinit);
		--tpt.log(id);
		if gen > gengren then 
			tpt.set_pause(1);
		end 	
	end

	if frame(false,false,0)> ttime then
		if an < size then
			fitness=fitnessfunc(sx1,sy1,sx2,sy2,fmode);
			eval[an] = fitness;
			genav=fitness+genav;
			if fitness>bestofall then
				tpt.log("best");
				--tpt.log(bestofall);
				--tpt.log(fitness);
				sim.deleteStamp(lastbest);
				lastbest=id;
				bestofall=fitness;	
			else
				sim.deleteStamp(id);
			end
			--tpt.log("fitness=");
			--tpt.log(fitnessfunc(sx1,sy1,sx2,sy2,fmode));
			
			delete(10);
			--sim.loadSave(1848501,1,1);
			tpt.set_pressure();
			frame(false,true,0);
	

			tpt.log(an);
			an=an+1;
		else
			rank=newAutotable(1);
			rank=mate(array,eval);
			an=0;
			gen=gen+1;
			lgenav=genav/size;
			genav=0;
			n2=0;
			while n2<size do
				--tpt.log(rank[n2]);
				n2=n2+1;
			end
			
					n2=0;
			m2=0;
			
		--[[	while m2<size do
				file:write("Rank: ",rank[m2],"   Eval : ",eval[m2],"\n");
				file:flush();
				m2=m2+1;
			end
			m2=0;
			 
			n2=0;
			file:write("Generation: ",gen,"\n");
			file:flush();]]--
			
		end
	end
end

function alwaysalways()
	tpt.drawtext(15,110,"Current Fitness:",0);
	tpt.drawtext(15,120,math.floor(fitnessfunc(sx1,sy1,sx2,sy2,fmode)));
end
tpt.register_step(alwaysalways);
function keys(key_char,keyNum,event)
  if key_char == "j" then
   tpt.register_step(always);
  end
  if key_char == "m" then
   tpt.unregister_step(always);
 end
end
tpt.register_keypress(keys)
	

--tpt.register_step(always);
