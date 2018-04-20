--Makes a fractal
local element1 = elements.allocate("FEYNMAN", "FRCT")
elements.element(elements.FEYNMAN_PT_FRCT, elements.element(elements.DEFAULT_PT_BCOL))
elements.property(elements.FEYNMAN_PT_FRCT, "Name", "FRCT")
elements.property(elements.FEYNMAN_PT_FRCT, "Description", "Fractalizer!")
elements.property(elements.FEYNMAN_PT_FRCT, "Colour", 0x9000FF)
elements.property(elements.FEYNMAN_PT_FRCT, "MenuSection", 11)
elements.property(elements.FEYNMAN_PT_FRCT, "Gravity", 0)
elements.property(elements.FEYNMAN_PT_FRCT, "Flammable", 0)
elements.property(elements.FEYNMAN_PT_FRCT, "Explosive", 0)
elements.property(elements.FEYNMAN_PT_FRCT, "Loss", 0)
elements.property(elements.FEYNMAN_PT_FRCT, "AirLoss", 1)
elements.property(elements.FEYNMAN_PT_FRCT, "AirDrag", 0)
elements.property(elements.FEYNMAN_PT_FRCT, "Advection", 1)
elements.property(elements.FEYNMAN_PT_FRCT, "Weight", 0)
elements.property(elements.FEYNMAN_PT_FRCT, "Diffusion", 0)
FRCTGraphics = function(i, r, g, b)
 local x = tpt.get_property('x', i)
 local y = tpt.get_property('y', i)
 return 1, 0x00000001,x % 255, y % 255, (x * y) % 255, 255, 0, 0, 0, 0
end
tpt.graphics_func(FRCTGraphics, tpt.element('FRCT'))
--Read the description
local element1 = elements.allocate("FEYNMAN", "VELM")
elements.element(elements.FEYNMAN_PT_VELM, elements.element(elements.DEFAULT_PT_BCOL))
elements.property(elements.FEYNMAN_PT_VELM, "Name", "VELM")
elements.property(elements.FEYNMAN_PT_VELM, "Description", "Velocity Meter")
elements.property(elements.FEYNMAN_PT_VELM, "Colour", 0xFF0000)
elements.property(elements.FEYNMAN_PT_VELM, "MenuSection", 11)
elements.property(elements.FEYNMAN_PT_VELM, "Gravity", 0)
elements.property(elements.FEYNMAN_PT_VELM, "Flammable", 0)
elements.property(elements.FEYNMAN_PT_VELM, "Explosive", 0)
elements.property(elements.FEYNMAN_PT_VELM, "Loss", 0)
elements.property(elements.FEYNMAN_PT_VELM, "AirLoss", 1)
elements.property(elements.FEYNMAN_PT_VELM, "AirDrag", 0)
elements.property(elements.FEYNMAN_PT_VELM, "Advection", 1)
elements.property(elements.FEYNMAN_PT_VELM, "Weight", 0)
elements.property(elements.FEYNMAN_PT_VELM, "Diffusion", 0)
VELMGraphics = function(i, r, g, b)
 local x = tpt.get_property('x', i)
 local y = tpt.get_property('y', i)
 graphics.drawLine(x - tpt.get_property('vx', i), y - tpt.get_property('vy', i), x + tpt.get_property('vx', i), y + tpt.get_property('vy', i), 255, 0, 0, 75)
 graphics.fillCircle(x, y, 2, 2, 255, 255, 255, tpt.get_property('vx', i) * tpt.get_property('vy', i))
end
tpt.graphics_func(VELMGraphics, tpt.element('VELM'))
local element1 = elements.allocate("FEYNMAN", "REP")
elements.element(elements.FEYNMAN_PT_REP, elements.element(elements.DEFAULT_PT_BCOL))
elements.property(elements.FEYNMAN_PT_REP, "Name", "REP")
elements.property(elements.FEYNMAN_PT_REP, "Description", "Replicating Powder!")
elements.property(elements.FEYNMAN_PT_REP, "Colour", 0xFF9000)
elements.property(elements.FEYNMAN_PT_REP, "MenuSection", 8)
elements.property(elements.FEYNMAN_PT_REP, "Gravity", .5)
elements.property(elements.FEYNMAN_PT_REP, "Flammable", 0)
elements.property(elements.FEYNMAN_PT_REP, "Explosive", 0)
elements.property(elements.FEYNMAN_PT_REP, "Loss", 1)
elements.property(elements.FEYNMAN_PT_REP, "AirLoss", .5)
elements.property(elements.FEYNMAN_PT_REP, "AirDrag", .01)
elements.property(elements.FEYNMAN_PT_REP, "Advection", .01)
elements.property(elements.FEYNMAN_PT_REP, "Weight", 0)
elements.property(elements.FEYNMAN_PT_REP, "Diffusion", 0)
--Replicating Powder
REPUpdate = function(i, x, y, s, n)
 if not(cx == 0 and cy == 0) and tpt.get_property('life', x, y) == 0 then
 local ctmp = tpt.get_property('tmp', x, y)
 for cx = -1, 1 do
 for cy = -1, 1 do
 tpt.create(x + cx, y + cy, 'rep')
 tpt.set_property('life', ctmp + 10, x+cx, y+cy)
 tpt.set_property('tmp', ctmp + 10, x+cx, y+cy)
 end
 end
 tpt.set_property('type', 0, x, y)
 elseif tpt.get_property('life', x, y) == 0 then
 tpt.set_property('tmp', 10, x, y) --Default tmp to 10
 else
 tpt.set_property('life', tpt.get_property('life', x, y) - 1, x, y)
 end
end
tpt.element_func(REPUpdate, tpt.element('REP'))
--Napalm!
local element1 = elements.allocate("FEYNMAN", "NPLM")
elements.element(elements.FEYNMAN_PT_NPLM, elements.element(elements.DEFAULT_PT_BCOL))
elements.property(elements.FEYNMAN_PT_NPLM, "Name", "NPLM")
elements.property(elements.FEYNMAN_PT_NPLM, "Description", "Napalm")
elements.property(elements.FEYNMAN_PT_NPLM, "Colour", 0x850000)
elements.property(elements.FEYNMAN_PT_NPLM, "MenuSection", 5)
elements.property(elements.FEYNMAN_PT_NPLM, "Gravity", .5)
elements.property(elements.FEYNMAN_PT_NPLM, "Flammable", 0)
elements.property(elements.FEYNMAN_PT_NPLM, "Explosive", 0)
elements.property(elements.FEYNMAN_PT_NPLM, "Loss", 1)
elements.property(elements.FEYNMAN_PT_NPLM, "AirLoss", .5)
elements.property(elements.FEYNMAN_PT_NPLM, "AirDrag", .01)
elements.property(elements.FEYNMAN_PT_NPLM, "Advection", .01)
elements.property(elements.FEYNMAN_PT_NPLM, "Weight", 50)
elements.property(elements.FEYNMAN_PT_NPLM, "Diffusion", 0)
NPLMUpdate = function(i, x, y, s, n)
 local clife = tpt.get_property('life', x, y)
 if clife > 1 then
 for cx = -1, 1, 2 do
 for cy = -1, 1, 2 do
 tpt.create(x + cx, y + cy, 'fire')
 end
 end
 tpt.set_property('life', clife - 1, x, y)
 elseif clife == 1 then
 tpt.set_property('type', 0, x, y)
 elseif s > 0 then
 for cx = -1, 1, 2 do
 for cy = -1, 1, 2 do
 if tpt.get_property('type', x + cx, y + cy) == 4 or tpt.get_property('type', x + cx, y + cy) == 49 then
 tpt.set_property('life', 500, x, y)
 return true
 end
 end
 end
 end
end
tpt.element_func(NPLMUpdate, tpt.element('nplm'))
NPLMgraphics = function(i, colr, colg, colb)
 return 1,0x00000011,255,125,0,0,255,125,0,0
end
tpt.graphics_func(NPLMgraphics, tpt.element('nplm'))
--Starter Fluid!
local element1 = elements.allocate("FLEL", "STFL")
elements.element(elements.FLEL_PT_STFL, elements.element(elements.DEFAULT_PT_BCOL))
elements.property(elements.FLEL_PT_STFL, "Name", "STFL")
elements.property(elements.FLEL_PT_STFL, "Description", "Starter Fluid - Long-burning liquid, good for starting fires.")
elements.property(elements.FLEL_PT_STFL, "Colour", 0xFFC090)
elements.property(elements.FLEL_PT_STFL, "MenuSection", 5)
elements.property(elements.FLEL_PT_STFL, "Gravity", .5)
elements.property(elements.FLEL_PT_STFL, "Flammable", 0)
elements.property(elements.FLEL_PT_STFL, "Explosive", 0)
elements.property(elements.FLEL_PT_STFL, "Loss", 1)
elements.property(elements.FLEL_PT_STFL, "AirLoss", .5)
elements.property(elements.FLEL_PT_STFL, "AirDrag", .01)
elements.property(elements.FLEL_PT_STFL, "Advection", .01)
elements.property(elements.FLEL_PT_STFL, "Weight", 30)
elements.property(elements.FLEL_PT_STFL, "Diffusion", 0)
elements.property(elements.FLEL_PT_STFL, "Falldown", 2)
STFLUpdate = function(i, x, y, s, n)
 local clife = tpt.get_property('life', x, y)
 if clife > 1 then
 for cx = -1, 1, 2 do
 for cy = -1, 1, 2 do
 tpt.create(x + cx, y + cy, 'plsm')
 end
 end
 tpt.set_property('life', clife - 1, x, y)
 elseif clife == 1 then
 tpt.set_property('type', 0, x, y)
 elseif tpt.get_property('temp', x, y) >= 1273.15 then
 tpt.set_property('life', 100, x, y)
 elseif s > 0 then
 for cx = -1, 1, 2 do
 for cy = -1, 1, 2 do
 if tpt.get_property('type', x + cx, y + cy) == 4 or tpt.get_property('type', x + cx, y + cy) == 49 then
 tpt.set_property('life', 100, x, y)
 return true
 end
 end
 end
 end
end
tpt.element_func(STFLUpdate, tpt.element('STFL'))
local element1 = elements.allocate("FEYNMAN", "FRCE")
elements.element(elements.FEYNMAN_PT_FRCE, elements.element(elements.DEFAULT_PT_BCOL))
elements.property(elements.FEYNMAN_PT_FRCE, "Name", "FRCE")
elements.property(elements.FEYNMAN_PT_FRCE, "Description", "Force Powder. It flings itself (and other stuff) willy-nilly.")
elements.property(elements.FEYNMAN_PT_FRCE, "Colour", 0xC3FF00)
elements.property(elements.FEYNMAN_PT_FRCE, "MenuSection", 11)
elements.property(elements.FEYNMAN_PT_FRCE, "Gravity", 0)
elements.property(elements.FEYNMAN_PT_FRCE, "Flammable", 0)
elements.property(elements.FEYNMAN_PT_FRCE, "Explosive", 0)
elements.property(elements.FEYNMAN_PT_FRCE, "Loss", 0)
elements.property(elements.FEYNMAN_PT_FRCE, "AirLoss", 0)
elements.property(elements.FEYNMAN_PT_FRCE, "AirDrag", 0)
elements.property(elements.FEYNMAN_PT_FRCE, "Advection", 0)
elements.property(elements.FEYNMAN_PT_FRCE, "Weight", 0)
elements.property(elements.FEYNMAN_PT_FRCE, "Diffusion", 0)
elements.property(elements.FEYNMAN_PT_FRCE, "HotAir", .01)
FRCEUpdate = function(i, x, y, arg, ARGGHH, argument, arrr)
 tpt.set_gravity(x / 4, y / 4, 1, 1, 30)
end
FRCEGraphics = function(i, colr, colg, colb)
 local x, y = tpt.get_property('x', i), tpt.get_property('y', i)
 graphics.drawLine(x - tpt.get_property('vx', i), y - tpt.get_property('vy', i), x + tpt.get_property('vx', i), y + tpt.get_property('vy', i),tpt.get_, 255, 0, 75)
end
tpt.element_func(FRCEUpdate, tpt.element('FRCE'))
tpt.graphics_func(FRCEGraphics, tpt.element('FRCE'))