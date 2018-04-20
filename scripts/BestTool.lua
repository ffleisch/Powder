
newElement={}
mainWindow={}


function newElement:new(o)
	o=o or {}
	setmetatable(o,self)
	self.__index=self

	return o
end

function mainWindow:close()	
	interface.closeWindow(self.w);
end


function mainWindow:new(o)
	o=o or {}
	setmetatable(o,self)
	self.__index=self
		
	self.w = Window:new( 16 , 28 , 111 , 221 )

	local exitButton = Button:new( 98 , 3 , 10 , 12 , "x" , nil )
	local function exitButton_action( sender )
	  interface.closeWindow(self.w)
	end
	exitButton:action( exitButton_action )
	
	local titleLabel = Label:new( 6 , 5 , 58 , 10 , "My Elements" )
	
	local addBtn = Button:new( 5 , 18 , 44 , 13 , "Add New" , "Add a new Element" )
	local function addBtn_action( sender )
	  --Put your code here. This gets called when addBtn is pressed.
	end
	addBtn:action( addBtn_action )
	
	--placeholders
	
	local ElemLabel1 = Label:new( 7 , 39 , 51 , 10 , "ElemLabel1" )
	
	local remBtn1 = Button:new( 73 , 36 , 35 , 13 , "Remove" , "Remove this Element" )
	local function remBtn1_action( sender )
	  --Put your code here. This gets called when remBtn1 is pressed.
	end
	remBtn1:action( remBtn1_action )
	
	--end placeholders
	
	self.w:addComponent( exitButton )
	self.w:addComponent( titleLabel )
	self.w:addComponent( addBtn )
	
	--
	self.w:addComponent( ElemLabel1 )
	self.w:addComponent( remBtn1 )
	
	--self.w:onTryExit(function() self:close() end);
	-- 
	print("test");

	return o
end


function mainWindow:open()
	interface.showWindow(self.w);
end



function key(key_char,keyNum,event)
	if key_char == "j" then
		mw:open();	
	end		
end


mw=mainWindow:new();


tpt.register_keypress(key);
