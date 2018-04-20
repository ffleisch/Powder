
x1=100;
y1=200;
x2=400;
y2=250;


function randp(prob)
	if (math.random(math.floor(1/prob))==1) then
		r=1
		return r
	else 
		return 0;
	end 
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

function selectMaterials()
	--materials=matrAdd(0.1,"QRTZ",materials);
	n=0;
	width=350;
	height=200;
	w=Window:new(150,100,width,height);
	
	local label=Label:new(30,10,20,15,"Materials")
	w:addComponent(label);
	
	while(n<anum)do
		local labels =Label:new(30,30+n*10,20,15,tpt.element(materials[n]));
		w:addComponent(labels);
		n=n+1;
	end
	n=0;
	

	
	textboxm= Textbox:new(200,30,50,15,"","Matr.");
	w:addComponent(textboxm);
	
	local buttonadd=Button:new(200,50,20,15,"Add");
	w:addComponent(buttonadd);
	
	buttonadd:action(function()
		materials=matrAdd(textboxm:text(),materials);
		--interface.showWindow(w);
		interface.closeWindow(w);
		selectMaterials();
	end)
	
	local buttonrem=Button:new(200,70,20,15,"Rem");
	w:addComponent(buttonrem);
	
	buttonrem:action(function()
		matrRem();
		--interface.showWindow(w);
		interface.closeWindow(w);
		selectMaterials();
	end)

	w:onTryExit(function() interface.closeWindow(w) end);
	interface.showWindow(w);

end

function matr()
	

	materials[0]=tpt.element("WOOD");
	materials[1]=tpt.element("PLNT");
	--array[4][0]=0.01;
	--array[4][1]=tpt.element("SOAP");


	anum=2;
	return(materials);
end

function matrAdd(str,array)
	array[anum]=tpt.element(str);
	anum=anum+1;
	return(array);	
end

function matrRem()
	if(anum>0)then
		anum=anum-1;
	end
end

materials=newAutotable(2);
materials=matr();

function draw()
	
	i=0;
	l=0;
	m=0;
	
	
	while(i<x2-x1)do
		while(l<y2-y1)do
			l=l+1;
			o=0;
			ran=math.random();
			tpt.delete(x1+i,y1+l);
			while(m<anum)do
					
					if(ran<materials[m][0]+o)then
						
						sim.partCreate(-2,x1+i,y1+l,materials[m][1]);
						
					end
					
					o=o+materials[m][0];
					m=m+1;	
			end	
			m=0;
		end
		l=0;
		i=i+1;
	end
	i=0;
	tpt.set_property("ctype","TNT","BCLN");
	
end



function key(key_char,keyNum,event)
	if key_char == "j" then
		selectMaterials();	
	end		
end

function update(i,x,y,ss,nt)
	sim.partKill(i);
	m=0
	o=0;
	ran=math.random();
	while(m<anum)do
			
			
				
			sim.partCreate(-3,x,y,materials[m]);
							
			o=o+materials[m];
			m=m+1;	
	end	
	m=0;
end

local mixm = elements.allocate("elem", "layr")
elements.element(mixm, elements.element(elements.DEFAULT_PT_DMND))
elements.property(mixm, "Name", "LAYR")
elements.property(mixm, "Description", "Layerd material")
elements.property(mixm, "Update",update);
tpt.register_keypress(key);
