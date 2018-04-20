--Made by DoubleF
frame=1;
fd={};
replim=2;
mr=5;
mrp=5;
repp=0.01;
plife=100;
function ColToRGB(col)
b=col%256;
g=math.floor(col/256)%256;
r=math.floor(col/65536)%256;
return r,g,b;
end

function RGBToCol(r,g,b)
sum=b;
sum=sum+256*g;
sum=sum+65536*r;
return(sum+4278190080);
end

function ColDiff(r1,g1,b1,r2,b2,g2)
return(math.abs(r1-r2)+math.abs(g1-g2)+math.abs(b1-b2));
end

function mutate(val,range)
hw=math.random(2);
hw=hw-1;
if(hw==0)then
hw=-1;
end
val=val+math.random(range)*hw;
if(val<0)then	val=0;
end
if(val>255)then
val=255;
end
return(val);
end


function randp(prob)
if math.random(math.floor(1/prob))==1 then
return 1;
else 
return 0;
end 
end


function update(i,x,y,s,nt)
if(sim.partProperty(i,"tmp2")==0)then
sim.partProperty(i,"tmp2",1);
else
if(true)then
if(sim.partProperty(i,"tmp")>replim)then
m=math.random(8);
if(m==1)then
m=sim.partCreate(-1,x-1,y-1,tpt.element("lfe"));
sim.partProperty(i,"tmp2",0);
elseif(m==2)then
m=sim.partCreate(-1,x-1,y,tpt.element("lfe"));
sim.partProperty(i,"tmp2",0);
elseif(m==3)then
m=sim.partCreate(-1,x-1,y+1,tpt.element("lfe"));
sim.partProperty(i,"tmp2",0);
elseif(m==4)then
m=sim.partCreate(-1,x,y-1,tpt.element("lfe"));
sim.partProperty(i,"tmp2",0);
elseif(m==5)then
m=sim.partCreate(-1,x,y+1,tpt.element("lfe"));
sim.partProperty(i,"tmp2",0);
elseif(m==6)then
m=sim.partCreate(-1,x+1,y-1,tpt.element("lfe"));
sim.partProperty(i,"tmp2",0);
elseif(m==7)then
m=sim.partCreate(-1,x+1,y,tpt.element("lfe"));
sim.partProperty(i,"tmp2",0);
elseif(m==8)then
m=sim.partCreate(-1,x+1,y+1,tpt.element("lfe"));
sim.partProperty(i,"tmp2",0);
end
if(m>0)then
r,g,b =ColToRGB(sim.partProperty(i,"dcolour"));
--print(r,g,b);
r=mutate(r,mr);
g=mutate(g,mr);
b=mutate(b,mr);

sim.partProperty(m,"dcolour",RGBToCol(r,g,b)); 
sim.partProperty(m,"tmp",sim.partProperty(i,"tmp")/2);

sim.partProperty(i,"tmp",sim.partProperty(i,"tmp")/2);	
end
if(sim.partProperty(i,"tmp")>replim*5)then
sim.partProperty(i,"type",tpt.element("INSL"));
end
end
sim.partProperty(i,"tmp",sim.partProperty(i,"tmp")+1);
end
end
end

function updateP(i,x,y,s,nt)
if(sim.partProperty(i,"tmp2")==0)then
sim.partProperty(i,"tmp2",1);
else
itype=sim.partProperty(i,"type");
--print(itype);
ri,gi,bi =ColToRGB(sim.partProperty(i,"dcolour"));
for n in sim.neighbours(x,y,1,1) do
ntype=sim.partProperty(n,"type");
rn,gn,bn =ColToRGB(sim.partProperty(n,"dcolour"));
dc=ColDiff(ri,gi,bi,rn,gn,bn)/(255*3);
p=1-dc;
p=repp*p;
if(math.random(1/p)==1 and ntype==tpt.element("lfe"))then
sim.partProperty(n,"type",tpt.element("PRED"));
sim.partProperty(n,"life",plife);
r,g,b =ColToRGB(sim.partProperty(i,"dcolour"));
--print(r,g,b);
r=mutate(r,mrp);
g=mutate(g,mrp);
b=mutate(b,mrp);

sim.partProperty(n,"dcolour",RGBToCol(r,g,b)); 
end
end
end
end
local mixm = elements.allocate("elem", "lfe")
elements.element(mixm, elements.element(elements.DEFAULT_PT_INSL))
elements.property(mixm, "Name", "lfe")
elements.property(mixm, "Description", "Evolving")
elements.property(mixm, "Update",update);

local mixm = elements.allocate("elem", "pred")
elements.element(mixm, elements.element(elements.DEFAULT_PT_DMND))
elements.property(mixm, "Name", "pred")
elements.property(mixm, "Properties", elements.property(tpt.element("PLSM"), "Properties"));
elements.property(mixm, "Description", "Eating lfe")
elements.property(mixm, "Update",updateP);
