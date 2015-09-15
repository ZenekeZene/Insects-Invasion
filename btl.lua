---------------------------------------------------
--[[
Project: Btl
Author: CMP
Version: 1.1

Btl (pronounced "beetle") is a general use helper library to debug projects.

List of Functions -
	btl.log(...) - 1.0
	btl.stack(...) - 1.0
	btl.cache(...) - 1.0
	btl.dump() - 1.0
	
	btl.updateTime() - 1.0
	btl.elapsedTime() - 1.0
	
	btl.systemMemory() - 1.0
	btl.textureMemory() - 1.0
	
	btl.extraGlobals() - 1.1
	btl.allGlobals() - 1.1
--]]
---------------------------------------------------
local btl={
	--Public
	DrawMode=1, -- DrawMode: 1 = Terminal, 2 = Visual, 3 = Programmatic, Anything Else = Nonexistent 
	stackDelay=10, -- Number of .stack() entries before logging
	timeRoute="stack", -- Stack, cache, or log time when .fps() is called
	memoryInMb=true, -- Show the memory in units of Mb
	memRoute="stack", -- Stack, cache, or log memory when .systemMemory() or .textureMemory() is called and DrawMode = 1

	gui=display.newGroup(), -- Btl GUI
	
	--Private
	_t={}, -- Table for generic use
	_stack={}, -- Stack of entries
	_cache={}, -- Cache of entries
	_time=0, -- Time
	_timeDiff=0, -- Value for time calculations
	_prevTime=0, -- Previous time
	_curTime=system.getTimer(), -- Current time
	_systemMemory=0, -- System memory used
	_textureMemory=0, -- Texture memory used
}

btl.gui.properties={bkgColor={255, 255, 0}, textColor={0, 0, 0}} -- GUI properties

--Build GUI
if btl.DrawMode==2 then
	btl.gui.hasMoved=false
	
	-- Background
	btl.gui.bkg=display.newRoundedRect(0, 0, display.contentWidth/3, display.contentHeight/6, display.contentWidth/72)
	btl.gui.bkg:setFillColor(unpack(btl.gui.properties.bkgColor))
	btl.gui:insert(btl.gui.bkg)
	
	-- Title text
	btl.gui.statusText=display.newText("Status", 0, 0, "Trebuchet MS", btl.gui.bkg.width/12)
	btl.gui.statusText:setTextColor(unpack(btl.gui.properties.textColor))
	btl.gui.statusText.x, btl.gui.statusText.y=btl.gui.bkg.x, btl.gui.statusText.size
	btl.gui:insert(btl.gui.statusText)
		
	-- Time text
	btl.gui.timeText=display.newText("Time: "..btl._time, 0, 0, "Trebuchet MS", btl.gui.bkg.width/20)
	btl.gui.timeText:setTextColor(unpack(btl.gui.properties.textColor))
	btl.gui.timeText.x, btl.gui.timeText.y=btl.gui.bkg.x, btl.gui.statusText.size*2
	btl.gui:insert(btl.gui.timeText)
	
	-- System memory text
	btl.gui.systemText=display.newText("System Memory: 0 Mb", 0, 0, "Trebuchet MS", btl.gui.bkg.width/20)
	btl.gui.systemText:setTextColor(unpack(btl.gui.properties.textColor))
	btl.gui.systemText.x, btl.gui.systemText.y=btl.gui.bkg.x, btl.gui.timeText.y+(btl.gui.bkg.width/20)
	btl.gui:insert(btl.gui.systemText)

	-- Texture memory text
	btl.gui.textureText=display.newText("Texture Memory: 0 Mb", 0, 0, "Trebuchet MS", btl.gui.bkg.width/20)
	btl.gui.textureText:setTextColor(unpack(btl.gui.properties.textColor))
	btl.gui.textureText.x, btl.gui.textureText.y=btl.gui.bkg.x, btl.gui.systemText.y+(btl.gui.bkg.width/20)
	btl.gui:insert(btl.gui.textureText)
	
	-- Touch listener
	function btl.gui:touch(event)
		if "began"==event.phase then
			display.getCurrentStage():setFocus(btl.gui)
			btl.gui.isFocus=true
			btl.gui:toFront()
			btl.gui.x1=event.x-btl.gui.x
			btl.gui.y1=event.y-btl.gui.y
			btl.gui.alpha=0.75
		elseif btl.gui.isFocus then
			if "moved"==event.phase then
				btl.gui.hasMoved=true
				btl.gui.alpha=1
				btl.gui.x=event.x-btl.gui.x1
				btl.gui.y=event.y-btl.gui.y1
			elseif "ended"==event.phase then
				if not btl.gui.hasMoved then
					btl.gui.alpha=1
					if btl.gui.xScale==1 then
						btl.gui.xScale, btl.gui.yScale=0.2, 0.2
					else
						btl.gui.xScale, btl.gui.yScale=1, 1
					end
				end
				btl.gui.hasMoved=false
				
				display.getCurrentStage():setFocus(nil)
				btl.gui.isFocus=false
			end
		end
		return true
	end
	btl.gui:addEventListener("touch", btl.gui)
end

------------------
--[[
Btl Log System
******
The Btl Log System does not support the visual DrawMode, and will do nothing if it is turned on.
******


btl.log(...)
 Collects an unlimited amount of entries and prints or returns them

btl.stack(...)
 Logs or returns entries that are multiples of Btl's stackDelay

btl.cache(...)
 Caches entries into Btl's cache

btl.dump()
 Logs every entry in Btl's cache
--]]
------------------
function btl.log(...)
	if btl.DrawMode==1 then
		for i=1, #arg do
			print(arg[i])
		end
	elseif btl.DrawMode==3 then
		for i=1, #arg do
			btl._t[#btl._t+1]=arg[i]
		end
		return unpack(btl._t)
	end
end

function btl.stack(...)
	if btl.DrawMode==1 then
		
		for i=1, #arg do
			btl._stack[#btl._stack+1]=arg[i]
			if #btl._stack>=btl.stackDelay then
				btl.log(arg[i])
				for l=1, #btl._stack do
					btl._stack[l]=nil
				end
			end
		end
		
	elseif btl.DrawMode==3 then
		
		for i=1, #arg do
			btl._stack[#btl._stack+1]=arg[i]
			if #btl._stack>=btl.stackDelay then
				for l=1, #btl._stack do
					btl._stack[l]=nil
				end
				return arg[i]
			end
		end
		
	end
end

function btl.cache(...)
	if btl.DrawMode==1 then
		for i=1, #arg do
			btl._cache[#btl._cache+1]=arg[i]
		end
	end
end

function btl.dump()
	if btl.DrawMode==1 then
		for i=1, #btl._cache do
			btl.log(btl._cache[i])
		end
	elseif btl.DrawMode==3 then
		return unpack(btl._cache)
	end
	for i=1, #btl._cache do
		btl._cache[i]=nil
	end
end

------------------
--[[
Btl Time System


btl.updateTime()
 Resets the Btl internal time

btl.elapsedTime()
 Collects the elapsed time between the last calling of .updateTime() or .elapsedTime()
--]]
------------------
function btl.updateTime()
	btl._prevTime=btl._curTime
	btl._curTime=system.getTimer()
end

function btl.elapsedTime()
	if btl.DrawMode==1 then
		
		btl._curTime=system.getTimer()
		btl._timeDiff=btl._curTime-btl._prevTime
		btl._prevTime=btl._curTime
		btl._time=clamp(math.floor(1000/btl._timeDiff), 0, 60)
		btl[btl.timeRoute](btl._time)
		
	elseif btl.DrawMode==2 then
		
		btl._curTime=system.getTimer()
		btl._timeDiff=btl._curTime-btl._prevTime
		btl._prevTime=btl._curTime
		btl._time=math.round(btl._timeDiff*1000)/1000
		btl.gui.timeText.text="Time: "..btl._time
		
	elseif btl.DrawMode==3 then
	
		btl._curTime=system.getTimer()
		btl._timeDiff=btl._curTime-btl._prevTime
		btl._prevTime=btl._curTime
		btl._time=math.round(btl._timeDiff*1000)/1000
		return btl._time
		
	end
end

------------------
--[[
Btl Memory System


btl.systemMemory()
 Collects the system memory used

btl.textureMemory()
 Collects the texture memory used
--]]
------------------
function btl.systemMemory()
	if btl.DrawMode==1 then
	
		collectgarbage("collect")
		btl._systemMemory=collectgarbage("count")
		if btl.memoryInMb then btl._systemMemory=btl._systemMemory/1000 end
		btl[btl.memRoute]("System Memory: "..(math.round(btl._systemMemory*1000)/1000)..(btl.memoryInMb and " Mb" or " Kb"))
	
	elseif btl.DrawMode==2 then
	
		collectgarbage("collect")
		btl._systemMemory=collectgarbage("count")
		if btl.memoryInMb then btl._systemMemory=btl._systemMemory/1000 end
		btl.gui.systemText.text="System Memory: "..(math.round(btl._systemMemory*1000)/1000)..(btl.memoryInMb and " Mb" or " Kb")
	
	elseif btl.DrawMode==3 then
		
		collectgarbage("collect")
		btl._systemMemory=collectgarbage("count")
		if btl.memoryInMb then btl._systemMemory=btl._systemMemory/1000 end
		return math.round(btl._systemMemory*1000)/1000
	
	end
end

function btl.textureMemory()
	if btl.DrawMode==1 then
		
		btl._textureMemory=system.getInfo("textureMemoryUsed")
		if btl.memoryInMb then btl._textureMemory=btl._textureMemory/1000000 end
		btl[btl.memRoute]("Texture Memory: "..(math.round(btl._textureMemory*1000)/1000)..(btl.memoryInMb and " Mb" or " Kb"))
	
	elseif btl.DrawMode==2 then
		btl._textureMemory=system.getInfo("textureMemoryUsed")
		if btl.memoryInMb then btl._textureMemory=btl._textureMemory/1000000 end
		btl.gui.textureText.text="Texture Memory: "..(math.round(btl._textureMemory*1000)/1000)..(btl.memoryInMb and " Mb" or " Kb")
	
	elseif btl.DrawMode==3 then
	
		btl._textureMemory=system.getInfo("textureMemoryUsed")
		if btl.memoryInMb then btl._textureMemory=btl._textureMemory/1000000 end
		return math.round(btl._textureMemory*1000)/1000
	
	end
end

------------------
--[[
Btl Global System


btl.extraGlobals()
 Collects all globals not in default global cache

btl.allGlobals()
 Collects all globals
--]]
------------------
btl._normalGlobals={
	["string"]=true,
	["xpcall"]=true,
	["package"]=true,
	["tostring"]=true,
	["print"]=true,
	["transition"]=true,
	["os"]=true,
	["unpack"]=true,
	["reachability"]=true,
	["require"]=true,
	["getfenv"]=true,
	["setmetatable"]=true,
	["next"]=true,
	["_credits_init"]=true,
	["assert"]=true,
	["tonumber"]=true,
	["io"]=true,
	["rawequal"]=true,
	["easing"]=true,
	["collectgarbage"]=true,
	["timer"]=true,
	["getmetatable"]=true,
	["Runtime"]=true,
	["module"]=true,
	["metatable"]=true,
	["al"]=true,
	["media"]=true,
	["network"]=true,
	["rawset"]=true,
	["graphics"]=true,
	["debug"]=true,
	["coroutine"]=true,
	["display"]=true,
	["system"]=true,
	["coronabaselib"]=true,
	["math"]=true,
	["native"]=true,
	["pcall"]=true,
	["table"]=true,
	["newproxy"]=true,
	["type"]=true,
	["audio"]=true,
	["_G"]=true,
	["select"]=true,
	["gcinfo"]=true,
	["pairs"]=true,
	["rawget"]=true,
	["loadstring"]=true,
	["ipairs"]=true,
	["_VERSION"]=true,
	["dofile"]=true,
	["setfenv"]=true,
	["load"]=true,
	["error"]=true,
	["loadfile"]=true,
}

function btl.extraGlobals()
	if btl.DrawMode==1 then
		
		for k, v in pairs(btl._t) do
			btl._t[k]=nil
		end
		
		btl._t[1]="Extra Globals - "
		
		for k, v in pairs(_G) do
			if not btl._normalGlobals[k] then
				btl._t[#btl._t+1]="\t"..k
			end
		end
		
		if #btl._t==1 then
			btl._t[1]="No Extra Globals"
		end
		
		btl.log(unpack(btl._t))
		
	elseif btl.DrawMode==3 then
		
		for k, v in pairs(btl._t) do
			btl._t[k]=nil
		end
	
		btl._t[1]="Extra Globals - "
	
		for k, v in pairs(_G) do
			if not btl._normalGlobals[k] then
				btl._t[#btl._t+1]="\t"..k
			end
		end

		if #btl._t==1 then
			btl._t[1]="No Extra Globals"
		end
		
		return unpack(btl._t)
		
	end
end

function btl.allGlobals()
	for k, v in pairs(_G) do
		btl.log(k)
	end
end

return btl