pstring="F"
rstring="F+F-F"
angle=90
cangle=0

xoff=300
yoff=200

ax=xoff
ay=yoff

nx=ax
ny=ay
length=10

iterations=5

local stack={};

function pushstack()
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
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

rules=newAutotable(2)





function GradToRad(g)
	return((g/360)*2*math.pi);
end

function replace_char(pos, str, r)
    return str:sub(1,pos-1)..r..str:sub(pos+1)
end

function replaceF(str)
i=0
l=0
strn=" "
rp=false;

while (i<#str) do
	i=i+1;
	s=str:sub(i,i)
	while(l<tablelength(rules))do
		if s==rules[l][0] then
			print(i)
			strn=strn..rules[l][1];
			rp=true;
		end
		l=l+1;
	end
	print(rp)
	if(rp==false)then
		strn=strn..s;
	end
	rp=false;
	l=0;

end
--print(l,i)

return strn
end


function turtle(str)
ax=xoff
ay=yoff
cangle=0
nx=ax
ny=ay
i=0
d=true
while(i<=#str)do
	s=str:sub(i,i)
	if(s=="F")then
		nx=ax+math.cos(cangle)*length
		ny=ay+math.sin(cangle)*length
		d=true
	elseif (s=="f")then
		nx=ax+math.cos(cangle)*length
		ny=ay+math.sin(cangle)*length
		d=false	
	elseif(s=="+")then
		cangle=cangle+GradToRad(angle);
		
	elseif(s=="-")then
		cangle=cangle-GradToRad(angle);
	elseif(s=="[")then
	elseif(s=="]")then
	end
	
	while(cangle>math.pi*2)do
		cangle=cangle-math.pi*2;
	end
	while(cangle<0)do
		cangle=cangle+math.pi*2;
	end	
	if(d==true)then
	sim.createLine(math.floor(ax),math.floor(ay),math.floor(nx),math.floor(ny),0,0,tpt.element("TTAN"))
	--sim.decoLine(math.floor(ax),math.floor(ay),math.floor(nx),math.floor(ny),0,0,math.random(255),math.random(255),math.random(255))
	end
	ax=nx
	ay=ny
	i=i+1
end
end

function drawFract()
	m=0
	istring=pstring;
	while(m<iterations)do
			istring=replaceF(istring)
		m=m+1
		--print(m)
	end
	turtle(istring)
end

