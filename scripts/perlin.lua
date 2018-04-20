
--simple perlin noise script for 2d and 1d
--made by DoubleF
--create a generator like: 

--generator=perlinGenerator:new();

--!important! initialize lookup table once with 

--generator:generateLookup(seed)
--or
--generator:generateLookup()

--use fields  zoom, oct and per to change properties

--call either perlin(x,y) or perlinOctave(x,y) or perlinOctave(x,y,octaves,persistence) on the generator object for values

--generator:perlin(10,20)


perlinGenerator={}

perlinGenerator.permutation={};
perlinGenerator.zoom=1
perlinGenerator.oct=15
perlinGenerator.per=.5


function perlinGenerator:new(o)
	o=o or {}
	setmetatable(o,self)
	self.zoom=1
	self.__index=self
	return o
end


function perlinGenerator:generateLookup(seed)
	seed=seed or os.time();
	math.randomseed(seed);
	self.permutation={}
	num=255;
	for i=0,num do
		self.permutation[i]=i
	end
	
	for i=0,num-1 do
		j=math.floor(math.random(0,num-i))
		
		zw=self.permutation[i]
		self.permutation[i]=self.permutation[i+j]
		self.permutation[i+j]=zw
	end	
end

function fade(x)
	return(x*x*x*(x*(x*6-15)+10))
end

function wrapVal(x)
	while x>255 do
		x=x-255;
	end
	return x
end

function grad(hash,x,y)
	h=hash%4;
	if(h==0)then return x+y
	elseif(h==1)then return -x+y;
	elseif(h==2)then return  x-y;
	elseif(h==3)then return -x-y;
	end
end

function lerp(a,b,w)
	return(a+(b-a)*w)
end

function perlinGenerator:perlin(x,y)
	x=x
	y=y
		
	xf=x%1;
	yf=y%1;

	xi=math.floor(x)%255;
	yi=math.floor(y)%255;
	
	--u=xf
	--v=yf
	u=fade(xf)
	v=fade(yf)
	
	aa=self.permutation[wrapVal(self.permutation[wrapVal(xi  )]+yi  )]
	ab=self.permutation[wrapVal(self.permutation[wrapVal(xi+1)]+yi  )]
	ba=self.permutation[wrapVal(self.permutation[wrapVal(xi  )]+yi+1)]
	bb=self.permutation[wrapVal(self.permutation[wrapVal(xi+1)]+yi+1)]
	--print(aa,ab,ba,bb)
	
	v1=grad(aa,xf  ,yf  );
	v2=grad(ab,xf-1  ,yf);
	v3=grad(ba,xf,yf-1  );
	v4=grad(bb,xf-1,yf-1);
	return(lerp(lerp(v1,v2,u),lerp(v3,v4,u),v))
	
end

function perlinGenerator:perlinOctave(x,y,octaves,persistence)
	x=x/self.zoom
	y=y/self.zoom
	total=0
	frequency=1
	amplitude=1
	maxVal=0
	octaves=octaves or self.oct;
	persistence=persistence or self.per;
	for i=0,octaves do
		total=total+self:perlin(x*frequency,y*frequency)*amplitude;
		maxVal=maxVal+amplitude;
		amplitude=amplitude*persistence
		frequency=frequency*2
	end
	return(total/maxVal)
end


