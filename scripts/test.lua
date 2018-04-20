xrun=0;
yrun=0;
ytest=0;
mtype="DMND" ;
xcent=310;--max 611
ycent=30;--max 382
thickness=5;
a=1/500;
b=0;
c=0;
function functiontodraw(t)

	return(t^2*a+t*b+c) 
end

function plot()
	n=0;
	m=0;
	tpt.create(xcent,(382-ycent-(1/(4*(a)))),"DMND");
	while(n<382)do
		while(m<611)do
			ytest=functiontodraw(m-xcent);
			ytest=ytest+ycent;
			if((ytest>n)and(ytest-thickness<n))then
				tpt.create(m,382-n,mtype);
			end
			m=m+1;
		end
		n=n+1;
		m=0;
	end
	n=0;
end
o=0;

	plot();
