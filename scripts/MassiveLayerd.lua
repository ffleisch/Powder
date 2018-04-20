layers=5
element=tpt.element("PROT")
function update(i,x,y,s,nt)
	m=0
		sim.partKill(i)
	while(m<layers)do
	
		i=sim.partCreate(-3,x,y,element)
		sim.partProperty(i,"vx",0);
		sim.partProperty(i,"vy",0);
		m=m+1;
	end
end




local mixm = elements.allocate("elem", "MLAY")
elements.element(mixm, elements.element(elements.DEFAULT_PT_DMND))
elements.property(mixm, "Name", "MLAY")
elements.property(mixm, "Description", "Massively layered")
elements.property(mixm, "Update",update);