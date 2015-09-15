local cAgua={};

local _TIME_LIFE=8000;
local _VEL=1000;
local _ROT=15;
local _DIST=40;

local setIr=function(event)
	local target=event.target;
	local phase=event.phase;
	if("began"==phase and target.estado=="parado")then
		target.estado="activo";
	
		local trans1 = cAgua.tnt:newTransition(target, {time = _VEL, x = cAgua.planta.inst.x, y = cAgua.planta.inst.y, name = 'Slide Transition', userData = 'User data', cycle = 1, backAndForth = false, onEnd = function (object, event)end})
		local timer1 = cAgua.tnt:newTimer(100,cAgua.planta.setRadioMas,1);--Engordamos la planta
		
	end
	return true;
end

local pararAguas=function(event)
	print("Paramos todas las aguas");
	cAgua.tnt:pauseAllTransitions();

end

--NEW:
local newAgua=function(xx,yy)
	
	local objAgua=display.newCircle(cAgua.capa,xx,yy,5);
	objAgua:setFillColor(0,0,240);
	objAgua.estado="parado";
	objAgua.moveX=0.1;
	objAgua.moveY=0.1;
	
	objAgua:addEventListener("touch", setIr);

	local trans1 = cAgua.tnt:newTransition(objAgua, 
											{
											time = _TIME_LIFE, 
											alpha = 0, 
											name = 'Slide Transition', 
											userData = 'User data', 
											cycle = 1, 
											backAndForth = true, 
											onEnd = function (object, event) 
												if(object)then
													object:removeSelf();
												end
											end
											})
end
cAgua.newAgua=newAgua;

--INIT:
local initAgua=function(planta,capa,tnt,aguas)
	cAgua.planta=planta;
	cAgua.capa=capa;
	cAgua.tnt=tnt;
	cAgua.aguas=aguas;--cuanto agua tenemos
end
cAgua.initAgua=initAgua;

return cAgua;