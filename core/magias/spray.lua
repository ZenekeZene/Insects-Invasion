local Spray={};

local _CAD_INICIO=100;
local _CAD=100;
local _TAM_MIN,_TAM_MAX=50,100;
local i=0;
local _LIFE=5000;
local _ALPHA_MIN,_ALPHA_MAX=1,4;
local _DESX_MIN,_DESX_MAX,_DESY_MIN,_DESY_MAX=-100,100,-100,100;
local _ROT_MIN,_ROT_MAX=10,100;
local _CANT=200;
local _CANT_ORIGIN=_CANT;
local ON=false;
local estado_cad=false;

local _CAD_ACCION_MAX=2;--luego se multiplicara por 1000 (2x1000=2 seg)
local _CAD_ACCION_MIN=1;--igual.

local cursorX=0;
local cursorY=0;

local cont_bucles=0;
--local _VEL_RALENT=0.1; Lo aplicamos en gear.moto+r

local stage=display.getCurrentStage();
Spray.manchas={};

--ELIMINAR MANCHA:
local eliminarMancha=function(target)
	if(target)then
		target:removeSelf();
	end
	table.remove(Spray.manchas,#Spray.manchas);
end

--QUITAR VIDA A ENEMIGO:
local quitarVida=function(other)
	local other=other;
	if(other)then
		if(other.vida>1)then
			other.vida=other.vida-1;
			other.estado=0;
		elseif(other.vida<=1)then
			other.estado=2;
		end
	end
end

--MANEJADOR EVENTO COLLISION (mancha-enemigo)
local colisionMancha=function(event)
	local phase=event.phase;
	local target=event.target;
	local other=event.other;

	if("began"==phase)then
		if(other.tipo=="enemigo")then
			if(other.estado==0 or other.estado==3)then--si esta vivo (o atacando)
				--other.vel=other.vel-0.5;--NOTA: Si hacemos esto los ahuyentamos!
				--other.vel=_VEL_RALENT;--lo ralentizamos
				local random=math.random;
				local xx=random(0,display.contentWidth);
				local yy=random(0,display.contentHeight);
				other.objetivoMareo=display.newCircle(xx,yy,5);
				other.objetivoMareo.isVisible=false;
				other.estado=4;--estado envenenado
				--cGear.enemi.cambiarSecuencia(ene,"Caminar");
				local _CAD_ACCION=(random(_CAD_ACCION_MIN,_CAD_ACCION_MAX))*1000;
				local timer1 = Spray.tnt:newTimer(_CAD_ACCION, function()quitarVida(other);end, 1);
				--timer.performWithDelay(_CAD_ACCION,function()quitarVida(other);end);
				return true;
			end
		end
	end
end

--CONSTRUCTOR MANCHA:
local crearMancha=function(xx,yy)
	--print("LA CAPA ES ESTA"..tostring(Spray.capa));
	estado_cad=false;

	local tam=math.random(_TAM_MIN,_TAM_MAX);
	local desx=math.random(_DESX_MIN,_DESX_MAX);
	local desy=math.random(_DESY_MIN,_DESY_MAX);
	local sent=math.random(-1,1);
	local rot=math.random(_ROT_MIN,_ROT_MAX);
	local alfa=math.random(_ALPHA_MIN,_ALPHA_MAX);
	--Creamos mancha del spray:
	local mancha=display.newRect(Spray.capa,xx-(tam/2),yy-(tam/2),tam,tam);
	mancha:setReferencePoint(display.CenterReferencePoint);
	--mancha.xReference,mancha.yReference=-550,150;
	mancha:setFillColor(100, 50, 80);

	mancha.alpha=alfa/10;
	mancha.estado="activo";--una vez que toque a algun enemigo (y se aplique su efecto), se desactiva

	physics.addBody(mancha, "dynamic", {density = 1.0, friction = 0.3, bounce = 10, isSensor = true});

	local ind=#Spray.manchas+1;
	Spray.manchas[ind]=mancha;
	
	local trans1 = Spray.tnt:newTransition(mancha, {time = _LIFE, alpha = 0, x=mancha.x+desx,y=mancha.y+desy,rotation=rot*sent, cycle = 1, backAndForth = false, onEnd = function (object, event) eliminarMancha(mancha); end});
	--transition.to(mancha, {time = _LIFE, alpha = 0, x=mancha.x+desx,y=mancha.y+desy,rotation=rot*sent,onComplete = function()eliminarMancha(mancha);end})

	mancha:addEventListener("collision", colisionMancha);

	if(_CANT>0)then
		_CANT=_CANT-1;
	else
		ON=false;
		cont_bucles=cont_bucles-1;
		Runtime:removeEventListener("enterFrame", motor);
	end
end

--MOTOR SPRAY:
local function motor(event)
	--print("Ojo que hay "..cont_bucles.." en accion!");
	if(estado=="NORMAL")then
		if(ON==true and _CANT>0)then
			crearMancha(cursorX,cursorY);
			
		elseif(_CANT<=0)then
			cont_bucles=cont_bucles-1;
			Runtime:removeEventListener("enterFrame", motor);
		end
	end
end

--MANEJADOR EVENTO TOUCH (todo el escenario):
local manejadorSpray;
manejadorSpray=function(event)
	local phase=event.phase;
	local xx,yy=event.x,event.y;

	cursorX,cursorY=event.x,event.y;
	ON=true;

	if("began"==phase)then
		ON=true;
	elseif("ended"==phase)then
		ON=false;
	end

	return true;
end
Spray.manejadorSpray=manejadorSpray;

--ASOCIAR MANEJADOR EVENTO TOUCH
local empezarSpray=function()
	ON=false;
	_CANT=_CANT_ORIGIN;
	stage:removeEventListener("touch", manejadorSpray);
	stage:addEventListener("touch", manejadorSpray);
	cont_bucles=cont_bucles+1;
	Runtime:removeEventListener("enterFrame", motor);
	Runtime:addEventListener("enterFrame", motor);
end

--KILL (DESASOCIAR EVENTOS ENTERFRAME)
local killSpray=function()--Para matar todos los eventListener's cuando reiniciamos nivel:
	stage:removeEventListener("touch", manejadorSpray);
	Runtime:removeEventListener("enterFrame", motor);
end
Spray.killSpray=killSpray;

--CONSTRUCTOR SPRAY:
local newSpray=function()
	print("¡SPRAY!");
	_CANT=_CANT_ORIGIN;
	--Spray.capa=capa;--Esto no esta del todo bien.
	--Spray.tnt=tnt;--Ni esto, mejor hacer un metodo init que solo se llama una vez no?
	local timer1 = Spray.tnt:newTimer(_CAD_INICIO, empezarSpray, 1);
end
Spray.newSpray=newSpray;

--INIT:
local initSpray=function(capa,tnt)
	Spray.capa=capa;--Esto no esta del todo bien.
	Spray.tnt=tnt;--Ni esto, mejor hacer un metodo init que solo se llama una vez no?
end
Spray.initSpray=initSpray;

return Spray;