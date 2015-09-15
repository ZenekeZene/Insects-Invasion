local cClorofila={};

local AutoStore=require("dmc_autostore");
local data;

local _TIME_LIFE=8000;
local _VEL=2000;
local _ROT=15;
local _DIST=40;

local _INC=100; --incremento en fondos por "clorofila" (esta en un futuro sera un grupo de ellas)

local setIr=function(event)
	local target=event.target;
	local phase=event.phase;
	if("began"==phase and target.estado=="parado")then
		target.estado="activo";
		
		local trans1 = cClorofila.tnt:newTransition(
			target, 
				{
				time = _VEL, 
				x = cClorofila.saco.fondo.x, 
				y = cClorofila.saco.fondo.y, 
				name = 'Slide Transition', 
				userData = 'User data', 
				cycle = 1, 
				backAndForth = false, 
				onEnd = function (object, event)
					cClorofila.clorofilas=cClorofila.clorofilas+_INC;
					--Actualizamos los fondos:
					local fondos=data.info.fondos;
					data.info.fondos=fondos+_INC;
					cClorofila.saco.texto.text=data.info.fondos; 
					end
				}
			);
	end
end

--NEW:
local newClorofila=function(xx,yy)
	
	local objClorofila=display.newCircle(cClorofila.capa,xx,yy,15);
	objClorofila:setFillColor(10,230,10);
	objClorofila.estado="parado";
	objClorofila.moveX=0.1;
	objClorofila.moveY=0.1;

	objClorofila:addEventListener("touch", setIr);

	local trans1 = cClorofila.tnt:newTransition(objClorofila, 
											{
											time = _TIME_LIFE, 
											alpha = 0, 
											name = 'Slide Transition', 
											userData = 'User data', 
											cycle = 1, 
											backAndForth = false, 
											onEnd = function (object, event) 
												object:removeSelf(); end
											})
	return objClorofila;
end
cClorofila.newClorofila=newClorofila;

--INIT:
local initClorofila=function(saco,capa,tnt,clorofilas)

	cClorofila.saco=saco;
	cClorofila.capa=capa;
	cClorofila.tnt=tnt;
	cClorofila.clorofilas=clorofilas;--cuantas monedas tenemos

	data=AutoStore.data;
end
cClorofila.initClorofila=initClorofila;

return cClorofila;