local Gallina={};

local gallinas={}

local i=0;
local _VEL_BAJ=100;
local _VEL_SUB=200;
local _RAD_BOMBA=60;
local _RAD_BOMBA_FISIC=100;
local _VEL_BOMBA=200;
local _SCALE_MIN,_SCALE_MAX=2,3;
local _CAD_SUBIR=500;

local _CAD_BOMBA=100;
local _NUM_BOMBAS=5;
local _MARGIN_BOMBA=120;

--BORRAR GALLINA:
local borrarGallina=function(target,ind)
	target:removeSelf();
	table.remove(gallinas,#gallinas);
end

--SUBIR:
local terminar=function(target,ind)
	local objGallina=target;
	local rotate=target.rotate*(-2);
	local trans1 = Gallina.tnt:newTransition(objGallina, {time = _VEL_SUB, rotation=rotate,alpha=0, cycle = 1, backAndForth = false, onEnd = function (object, event) borrarGallina(objGallina,ind); end});
end

--MANEJADOR EVENTO COLLISION (bomba-enemigo):
local colisionBomba=function(event)
	local phase=event.phase;
	local target=event.target;
	local other=event.other;

	if("began"==phase)then
		if(other.tipo=="enemigo")then
			if(other.idTipo=="arana")then--Quitamos el impulso de la arana por querer tirar una telaraña, incluso cuando ha muerto
				other.timerTela:cancel();
			end
			if(other.estado==0 or other.estado==3)then--si esta vivo
				if(other.vida>1)then--si tiene vida
					other.vida=other.vida-1;--le quitamos una vida
				elseif(other.vida<=1)then--si no
					other.estado=2;--lo matamos
				end
			end
		end
	end
end

local borrarBomba=function(target,ind)
	target:removeSelf();
end

--CONTRUCTOR DE BOMBA
local crearBomba=function(xx,yy)
	local coordX=math.random(xx-_MARGIN_BOMBA,xx+_MARGIN_BOMBA);
	local bomba=display.newCircle(Gallina.capa,coordX,yy+50,_RAD_BOMBA);
	bomba:setFillColor(0, 50, 50);
	physics.addBody(bomba, "dynamic", {density = 1.0, friction = 0.3, bounce = 10, isSensor = false, radius=_RAD_BOMBA_FISIC});
	local scale=math.random(_SCALE_MIN,_SCALE_MAX);
	local trans1=Gallina.tnt:newTransition(bomba, {time = _VEL_BOMBA, xScale = scale, yScale=scale,alpha=0.1, cycle = 1, backAndForth = false, onEnd = function (object, event) borrarBomba(bomba,i); end})
	bomba:addEventListener("collision", colisionBomba);
end

--EMPEZAR RAFAGA:
local empezarRafaga=function(xx,yy)
	local timer1 = Gallina.tnt:newTimer(_CAD_BOMBA, function () crearBomba(xx,yy); end, _NUM_BOMBAS);
end

--INICIAR ATAQUE:
local iniciarAtaque=function(yy,target,ind)
	local coordX;
	local tipo=target.tipo;
	if(tipo==0)then--izq
		coordX=300;
	else
		coordX=600;
	end

	empezarRafaga(coordX,yy);
	local timer1 = Gallina.tnt:newTimer(_CAD_SUBIR, function () terminar(target,ind); end, 1);
end

--CONSTRUCTOR:
local newGallina=function(xx,yy,capa,prop,tnt)
	Gallina.capa=capa;
	local objGallina=display.newImage( Gallina.capa,"core/magias/gallina.png", 500, 250, true );
	local tipo=0;--0 izq,1 der
	local rotate=0;
	i=i+1;
	if(xx<prop._CENTRO.xx)then
		objGallina.xReference,objGallina.yReference=100,100;
		objGallina.xScale,objGallina.yScale=-1,1;
		objGallina.x=0;
		objGallina.tipo=0;
		objGallina.rotate=30;
	else
		objGallina.xReference,objGallina.yReference=100,100;
		objGallina.xScale,objGallina.yScale=1,1;
		objGallina.x=prop._WIDTH;
		objGallina.tipo=1;
		objGallina.rotate=-30;
	end

	Gallina.tnt=tnt;

	objGallina.y=yy;
	local trans1 = Gallina.tnt:newTransition(objGallina, {time = _VEL_BAJ, rotation=objGallina.rotate, cycle = 1, backAndForth = false, onEnd = function (object, event) iniciarAtaque(yy,objGallina,i); end})
	--Metemos en array:
	gallinas[#gallinas+1]=objGallina;
end
Gallina.newGallina=newGallina;

return Gallina;