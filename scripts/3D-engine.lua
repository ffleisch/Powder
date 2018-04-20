zoom=30;
xoff=300;
yoff=200;
swidth=611;
sheight=383;
rx=0;
ry=2;
rz=0;

hlife=0;
hlifebool=0;
element="TNT"

stepmode=true

ks=0.2
kd=0.5
ka=1
alpha=1

ia={}
ia[0]=128
ia[1]=128
ia[2]=128

id={}
id[0]=128
id[1]=128
id[2]=128

is={}
is[0]=128
is[1]=128
is[2]=128


light={}
light[0]=0;
light[1]=1;
light[2]=0;


viewer={}
viewer[0]=0
viewer[1]=0
viewer[2]=1

dmode=0;


filename="Cow.obj"

t2=0;
	
function GradToRad(g)
	return((g/360)*2*math.pi);
end

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

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function toScreen(v1)
	--print(v1[0],v1[1],v1[2])
	v1[0]=v1[0]*zoom+xoff--math.floor(v1[0]*zoom+xoff)
	v1[1]=v1[1]*-zoom+yoff--math.floor(v1[1]*-zoom+yoff)	
	v1[2]=v1[2]*zoom
end

function clearZbuffer()
	m=0
	n=0
	while m<611 do
		while n<383 do
			zbuffer[m][n]=nil
			n=n+1
		end
		n=0
		m=m+1
	end
	m=0
end
function readmodel(model)
	vz={};	
	v=newAutotable(2);
	fz={};
	f=newAutotable(2);
	local file=io.open(model)
	str="empty"
	local mv=0;
	local mf=0;
	while str~=nil do
		str=file:read("*line")
		if(str~=nil)then 
			--print(str)
			
			if(string.find(str,"^v "))then
				--print(str);
				k=0;
				for s in string.gmatch(str,"[%d.+-]+")do		
					vz[k]=tonumber(s);	
					k=k+1;
					--print(s,k)	
				end
				v[mv][0]=vz[0]
				v[mv][1]=vz[1]
				v[mv][2]=vz[2]
				
				--print(v[mv][2])
				mv=mv+1
				
			end
			if(string.find(str,"^f "))then
				k=0;
				for s in string.gmatch(str,"%d+")do
					fz[k]=tonumber(s)
					k=k+1
					--print(s)
					
				end
				if(string.find(str,"(%d+)//(%d+)( +)(%d+)//(%d+)( +)(%d+)//(%d+)"))then
					f[mf][0]=fz[0]
					f[mf][1]=fz[2]
					f[mf][2]=fz[4]
	
				elseif(string.find(str,"(%d+)( +)(%d+)( +)(%d+)"))then
					f[mf][0]=fz[0]
					f[mf][1]=fz[1]
					f[mf][2]=fz[2]
				elseif(string.find(str,"(%d+)(/)(%d+)(/)(%d+)( +)(%d+)(/)(%d+)(/)(%d+)( +)(%d+)(/)(%d+)(/)(%d+)"))then
					f[mf][0]=fz[0]
					f[mf][1]=fz[3]
					f[mf][2]=fz[6]
				end
				mf=mf+1;
			end
		end
	end
	return v,f
end

function rotate(x,y,z)
	vx=x*1+y*0+z*0
	vy=x*0+y*math.cos(rx)-z*math.sin(rx)
	vz=x*0+y*math.sin(rx)+z*math.cos(rx)
	
	vx2=vx*math.cos(ry)+vy*0+vz*math.sin(ry)
	vy2=vx*0+vy*1+vz*0
	vz2=-vx*math.sin(ry)+vy*0+vz*math.cos(ry)	
	
	vx3=vx2*math.cos(rz)-vy2*math.sin(rz)+vz2*0
	vy3=vx2*math.sin(rz)+vy2*math.cos(rz)+vz2*0
	vz3=vx2*0+vy2*0+vz2*1
		
	xe=vx3;
	ye=vy3;
	ze=vz3;
	return xe,ye,ze;
end



function triangleBottomFlat(x1,y1,x2,y2,x3,y3,e,r,g,b)

	slope1=(x2-x1)/(y2-y1)
	slope2=(x3-x1)/(y3-y1)
	curx1=x1
	curx2=x1
	m=0;
	--print(y1,y2,y3)
	m=y1
	while m>=y2 do
		--print(curx1)
	
		sim.createLine(curx1,m,curx2,m,0,0,e)
		sim.decoLine(curx1,m,curx2,m,0,0,r,g,b)
		curx1=curx1-slope1;
		curx2=curx2-slope2;
		m=m-1
	end
end

function triangleTopFlat(x1,y1,x2,y2,x3,y3,e,r,g,b)
	slope1=(x3-x1)/(y3-y1)
	slope2=(x3-x2)/(y3-y2)
	curx1=x3
	curx2=x3
	m=0;
	--print(y1,y2,y3)
	m=y3
	while m<=y1 do
		--print(curx1)
	
		sim.createLine(curx1,m,curx2,m,0,0,e)
		sim.decoLine(curx1,m,curx2,m,0,0,r,g,b)
		curx1=curx1+slope1;
		curx2=curx2+slope2;
		m=m+1
	end
end

function fasttriangle(x1,y1,x2,y2,x3,y3)
--	print(x1,y1,x2,y2,x3,y3)
--	r=math.random(255);
	--g=math.random(255);
	--b=100--math.random(255);
	elem=tpt.element("IRON")--math.random(100);	
	if (y1<=y2 and y1<=y3) and (y3>y1 and y3>y2) then vy1=y3 vx1=x3 vy2=y2 vx2=x2 vy3=y1 vx3=x1 end
	if (y1<=y2 and y1<=y3) and (y2>y1 and y2>y3) then vy1=y2 vx1=x2 vy2=y3 vx2=x3 vy3=y1 vx3=x1 end
	if (y2<=y1 and y2<=y3) and (y3>y1 and y3>y2) then vy1=y3 vx1=x3 vy2=y1 vx2=x1 vy3=y2 vx3=x2 end
	if (y2<=y1 and y2<=y3) and (y1>y2 and y1>y3) then vy1=y1 vx1=x1 vy2=y3 vx2=x3 vy3=y2 vx3=x2 end
	if (y3<=y1 and y3<=y2) and (y1>y2 and y1>y3) then vy1=y1 vx1=x1 vy2=y2 vx2=x2 vy3=y3 vx3=x3 end
	if (y3<=y1 and y3<=y2) and (y2>y1 and y2>y3) then vy1=y2 vx1=x2 vy2=y1 vx2=x1 vy3=y3 vx3=x3 end	
	--print(vy1,vy2,vy3)
	vy4=vy2;
	--print(vx1,vy1,vx2,vy2,vx3,vy3)
	vx4=vx1+((vy2-vy1)/(vy3-vy1))*(vx3-vx1)
	
	triangleBottomFlat(vx1,vy1,vx2,vy2,vx4,vy4,elem,r,g,b)
	triangleTopFlat(vx2,vy2,vx4,vy4,vx3,vy3,elem,r,g,b)

	
	--sim.createLine(vx1,vy1,vx2,vy2,0,0,elem)
	--sim.createLine(vx3,vy3,vx2,vy2,0,0,elem)
	--sim.createLine(vx1,vy1,vx3,vy3,0,0,elem)
--	--sim.floodParts(x1,y1,10);--tpt.element("IRON
end

function vector2p(p1,p2)
	v={}
	v[0]=p2[0]-p1[0]
	v[1]=p2[1]-p1[1]
	v[2]=p2[2]-p1[2]
	--print(v[0],v[1],v[2])
	return v;
end

function crossProduct(v1,v2)
	ve={}
	ve[0]=v1[1]*v2[2]-v1[2]*v2[1]
	ve[1]=v1[2]*v2[0]-v1[0]*v2[2]
	ve[2]=v1[0]*v2[1]-v1[1]*v2[0]
	return(ve)
end

function dotProduct(v1,v2)
	return v1[0]*v2[0]+v1[1]*v2[1]+v1[2]*v2[2]
end

function sameSide(p1,p2,a,b)
	--print(p1[0],p1[1])
	vz1={}
	vz1=vector2p(b,a)
	vz2={}
	vz2=vector2p(p1,a)
	vz3={}
	vz3=vector2p(p2,a)
	--vz1[2]=0;
	--vz2[2]=0;
	--vz3[2]=0;
	cp1={}
	cp2={}
	cp1=crossProduct(vz1,vz2)
	cp2=crossProduct(vz1,vz3)
	w=dotProduct(cp1,cp2)
	--print(w)
	if(w>=0)then
		return(true)
	else
		return(false)
	end	
end

function vectorLength(v1)	
	return math.sqrt(math.pow(v1[0],2)+math.pow(v1[1],2)+math.pow(v1[2],2))
end

function vectorNormalize(v1)
	l1=vectorLength(v1)
	v1[0]=v1[0]/l1
	v1[1]=v1[1]/l1
	v1[2]=v1[2]/l1
end

function vectorScalar(n,v1)
	ve={}
	ve[0]=v1[0]*n
	ve[1]=v1[1]*n
	ve[2]=v1[2]*n
	return(ve)
end

function vectorAdd(v1,v2)
	ve={}
	ve[0]=v1[0]+v2[0]
	ve[1]=v1[1]+v2[1]
	ve[2]=v1[2]+v2[2]
	return (ve)
end

function vectorSubstract(v1,v2)
	ve={}
	ve[0]=v1[0]-v2[0]
	ve[1]=v1[1]-v2[1]
	ve[2]=v1[2]-v2[2]
	return(ve)
end

function capColorDown(i)
	if i[0]>255 then
		i[0]=255
	end
	if i[1]>255 then
		i[1]=255
	end
	if i[2]>255 then
		i[2]=255
	end
	i[0]=math.floor(i[0])
	i[1]=math.floor(i[1])
	i[2]=math.floor(i[2])
end

function capColorUp(i)
	if i[0]<0 then
		i[0]=0
	end
	if i[1]<0 then
		i[1]=0
	end
	if i[2]<0 then
		i[2]=0
	end
	i[0]=math.floor(i[0])
	i[1]=math.floor(i[1])
	i[2]=math.floor(i[2])
end

function trianglezbuffer(pf1,pf2,pf3)
	r=math.random(255);
	g=math.random(255);
	b=100--math.random(255);
	xmax=math.max(pf1[0],pf2[0],pf3[0])
	ymax=math.max(pf1[1],pf2[1],pf3[1])
	zmax=math.max(pf1[2],pf2[2],pf3[2])
	xmin=math.min(pf1[0],pf2[0],pf3[0])
	ymin=math.min(pf1[1],pf2[1],pf3[1])
	zmin=math.min(pf1[2],pf2[2],pf3[2])
--	print(xmax,xmin,ymax,ymin)

	--sim.partCreate(-3,xmax,ymax,tpt.element("PLNT"))
	--sim.partCreate(-3,xmin,ymin,tpt.element("PLNT"))
	--sim.partCreate(-3,pf1[0],pf1[1],tpt.element("TNT"))
	--sim.partCreate(-3,pf2[0],pf2[1],tpt.element("TNT"))
	--sim.partCreate(-3,pf3[0],pf3[1],tpt.element("TNT"))
	--c=pf1[2]+0xFF000000--math.random(0xFFFFFF)+0xFF000000
	--v1=vector2p(pf1,pf2)
	--v1[2]=0
	--print(v1[2])
	norm={}
	refl={}
	norm=crossProduct(vector2p(pf1,pf2),vector2p(pf1,pf3))
	vectorNormalize(norm)
	vectorNormalize(viewer)
	zw=2*dotProduct(light,norm)
	refl=vectorScalar(zw,norm)
	refl=vectorSubstract(refl,light)
	intensity={}
	intensity[0]=ka*ia[0]+kd*id[0]*dotProduct(light,norm)+ks*is[0]*math.pow(dotProduct(refl,norm),alpha)
	intensity[1]=ka*ia[1]+kd*id[1]*dotProduct(light,norm)+ks*is[1]*math.pow(dotProduct(refl,norm),alpha)
	intensity[2]=ka*ia[2]+kd*id[2]*dotProduct(light,norm)+ks*is[2]*math.pow(dotProduct(refl,norm),alpha)
	
	capColorDown(intensity)
	capColorUp(intensity)
	--print(intensity[0])
	
	c=RGBToCol(intensity[0],intensity[1],intensity[2]);
	
	t=0;
	z=zmax
	m=math.floor(xmin)
	n=math.floor(ymin)
	while math.floor(m)<=math.ceil(xmax) do
		while  math.floor(n)<=math.ceil(ymax) do
			pt={}			
			--vz1=vector2p()
			x=math.floor(m)--+xmin
			y=math.floor(n)--+ymin	
			pt[0]=x
			pt[1]=y
			pt[2]=0
			pa={}
			pb={}
			pc={}
			pa=pf1
			pb=pf2
			pc=pf3
			pa[2]=0;
			pb[2]=0;
			pc[2]=0;
			--elements=tablelength(zbuffer[x][y])
			--print(elements)
			
			if(sameSide(pt,pa,pb,pc)==true)and(sameSide(pt,pb,pa,pc)==true)and(sameSide(pt,pc,pa,pb)==true) then
				zalt=zbuffer[x][y]
				--c=RGBToCol(0,0,math.floor(z)+128)
				--print(zalt,z)
				if(zalt==nil)then
					zbuffer[x][y]=z
					t=t+1
					i=sim.partCreate(-3,math.floor(m),math.floor(n),tpt.element(element))
					sim.partProperty(i,"dcolour",c)
					if(hlifebool)then
						sim.partProperty(i,"life",hlife+1);
						sim.partProperty(i,"vx",0);
						sim.partProperty(i,"vy",0);
					end
				elseif(zalt>z)then
					--print(zalt)
					zbuffer[x][y]=z
					t=t+1
					--sim.partKill(math.floor(m),math.floor(n))
					i=sim.partCreate(-3,math.floor(m),math.floor(n),tpt.element(element))
					sim.partProperty(i,"dcolour",c)
					if(hlifebool)then
						sim.partProperty(i,"life",hlife+1);
						sim.partProperty(i,"vx",0);
						sim.partProperty(i,"vy",0);
					end
				end
				--print(zalt)
			end
			n=n+1
		end
		n=math.floor(ymin)
		m=m+1
	end
	m=math.floor(xmin);
	if(t==(xmax-xmin)*(ymax-ymin))then
		print("fail")
		t2=t2+1;
	end
end



--function sortFaces()
--	for m=0,m<tablelength(faces),1 do
--			for n=0,m<tablelength(faces),1 do
--				z1=vertices[faces[m][0]-1][2]+vertices[faces[m][1]-1][2]+vertices[faces[m][2]-1][2]
--				z2=vertices[faces[n][0]-1][2]+vertices[faces[n][1]-1][2]+vertices[faces[n][2]-1][2]
--				print(z1);
--			end	
--	end	
--end
function rg()

	zbuffer=newAutotable(2)
	vectorNormalize(light)
	clearZbuffer()
	

	vertices,faces=readmodel(filename)
	m=0;
	while m<tablelength(vertices) do
		--print(vertices[m][0],vertices[m][1],vertices[m][2]);
		xz,yz,zz=rotate(vertices[m][0],vertices[m][1],vertices[m][2]); 
		vertices[m][0]=xz
		vertices[m][1]=yz
		vertices[m][2]=zz
		m=m+1;
	end			
	n=0;
	
	
	
	for n=0,(tablelength(faces)-1) do
		x1,x2,x3,y1,y2,y3,z1,z2,z3=0;
		v1=faces[n][0]-1
		v2=faces[n][1]-1
		v3=faces[n][2]-1
		--print(v1,v2,v3)
		p1={}
		p2={}
		p3={}
		p1[0]=vertices[v1][0]
		p1[1]=vertices[v1][1]
		p1[2]=vertices[v1][2]
		p2[0]=vertices[v2][0]
		p2[1]=vertices[v2][1]
		p2[2]=vertices[v2][2]
		p3[0]=vertices[v3][0]
		p3[1]=vertices[v3][1]
		p3[2]=vertices[v3][2]
		--print(vertices[v1][0],vertices[v1][1],vertices[v1][2])
		--print(p1[0],p1[1],p1[2])
		toScreen(p1);
		toScreen(p2);
		toScreen(p3);
		--print(p1[0],p1[1],p1[2])
		if dmode==0 then		
			trianglezbuffer(p1,p2,p3)
		else
			sim.partCreate(-2,p1[0],p1[1],tpt.element(element))
			sim.partCreate(-2,p2[0],p2[1],tpt.element(element))
			sim.partCreate(-2,p3[0],p3[1],tpt.element(element))
		end
		--triangle(xb1,yb1,xb2,yb2,xb3,yb3)
		--sim.partCreate(-2,x1*zoom+xoff,y1*(-zoom)+yoff,tpt.element("IRON"))
			
		n=n+1;
	end	
end

function key(key_char,keyNum,event)
	if key_char == "m" then
		rg();	
	end
			
end


function animate(frames)
	element="Prot";
	hlife=frames;
	hlifebool=true;
	for i=0,frames do
		hlife=hlife-1;
		rg();
		ry=ry+0.2;
	
	end
end
		vertices=newAutotable(2)
		faces=newAutotable(2)

tpt.register_keypress(key);