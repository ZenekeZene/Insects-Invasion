local Lluvia={};
--print("Cargando Lluvia");

local meteoritos={};

local _CAD_INI=100;
local _CAD_GRUPOS=300;
local _TAM_LLUVIA=10;
local _RAD_MIN,_RAD_MAX=10,30;
local _RAD_FIS=30;
local _VEL_MIN,_VEL_MAX=100,200;
local _VEL_EXP_MIN,_VEL_EXP_MAX=100,300;
local _AUM_EXP_MIN,_AUM_EXP_MAX=2,3;


local puntosOrigen={{100,10},{200,10},{300,10},{400,10},{500,10},{600,10},{700,10},{800,10},{900,10},{1000,10}};
local puntosImpacto={{10,150},{200,300},{50,400},{400,200},{400,50},{500,400},{350,350},{550,250},{700,300},{700,100}};

--BORRAR:
local borrar=function(target,i)
	target:removeSelf();
	table.remove(meteoritos,i);
end

--EXPLOTAR:
local explotar=function(target,i)
	local target=target;
	local ind=i;
	local vel=math.random(_VEL_EXP_MIN,_VEL_EXP_MAX);
	local aum=math.random(_AUM_EXP_MIN,_AUM_EXP_MAX);
	local trans1 = Lluvia.tnt:newTransition(target, {time = vel, xScale = aum, yScale = aum, cycle = 1, backAndForth = false, onEnd = function (object, event) borrar(target,i); end});
end

--MANEJADOR EVENTO COLLISION (meteorito-enemigo):
local colision=function(event)
	local phase=event.phase;
	local target=event.target;
	local other=event.other;

	if("began"==phase)then
		if(other.tipo=="enemigo")then
			if(other.estado==0 or other.estado==3)then--si esta vivo (o atacando)
				if(other.idTipo=="arana")then--Quitamos el impulso de la arana por querer tirar una telaraña, incluso cuando ha muerto
					other.timerTela:cancel();
				end
				if(other.vida>1)then--si tiene vida
					other.vida=other.vida-1;--le quitamos una vida
				elseif(other.vida<=1)then--si no
					other.estado=2;--lo matamos
				end
			end
		end
	end
end

--CREARGRUPOMETEORITOS:
local crearGrupoMeteoritos=function(xx,yy,j)

	local _TAM_GRUPO=math.random(3,6);
	local j=j;

	local xCenter = puntosOrigen[j][1];
	local yCenter = puntosOrigen[j][2];
	local radius = 15;

	local angleStep = 2 * math.pi / _TAM_GRUPO;

	--print("J:"..j);
	for i=1,_TAM_GRUPO do

		xxx=xCenter + radius*math.cos(i*angleStep);
		yyy=yCenter + radius*math.sin(i*angleStep);

		local radio=math.random(_RAD_MIN,_RAD_MAX);
		local vel=math.random(_VEL_MIN,_VEL_MAX);
		local meteoro=display.newCircle(Lluvia.capa,xxx,yyy,radio);
		meteoro:setFillColor(0, 0, 255);
		physics.addBody(meteoro, "dynamic", {density = 1.0, friction = 0.3, bounce = 10, radius=_RAD_FIS,isSensor = false});
		meteoro.linearDamping = 0.1;
		meteoro.angularDamping =30;

		local xTargetCenter = puntosImpacto[j][1];
		local yTargetCenter = puntosImpacto[j][2];

		local xTarget=xTargetCenter + radius*math.cos(i*angleStep);
		local yTarget=yTargetCenter + radius*math.sin(i*angleStep);

		local trans1 = Lluvia.tnt:newTransition(meteoro, {time = vel,  x = xTarget, y = yTarget, cycle = 1, backAndForth = false, onEnd = function()explotar(meteoro,i);end})

		meteoro:addEventListener("collision", colision);

		meteoritos[i]=meteoro;
	end
end

--EMPEZAR LLUVIA:
local empezarLluvia=function()
		local j=1;
		local xx,yy=puntosOrigen[j][1],puntosOrigen[1][2];
		local timer1=Lluvia.tnt:newTimer(_CAD_GRUPOS, function()crearGrupoMeteoritos(xx,yy,j);j=j+1;end,_TAM_LLUVIA);
end

--NEW:
local newLluvia=function(capa,tnt)
	Lluvia.capa=capa;
	Lluvia.tnt=tnt;
	local timer1=Lluvia.tnt:newTimer(_CAD_INI, empezarLluvia,1);
end
Lluvia.newLluvia=newLluvia;

return Lluvia;