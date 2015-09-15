--HORMIGA:
local cOruga={};

local _PORC_AGUA=1;
local _VEL=0.5;
local _DANIO=10;
local _VIDA=1;
local _VEL_SEC=800;--velocidad de secuencia

local explotar;
local colision;

--CAMBIAR SECUENCIA:
local cambiarSecuencia=function(target,secuencia)
	target:setSequence(secuencia);
	target:play();
end

--MANEJADOR EVENTO SPRITE (al terminar una secuencia):
local sprOrugaListener=function(event)
	local phase=event.phase;
	local target=event.target;

	if(phase=="ended")then
		if(target.sequence=="Atacar")then
			cambiarSecuencia(target,"Masticar");
			if(estado=="NORMAL")then
				if(cOruga.planta.vida>0)then
					cOruga.planta.vida=cOruga.planta.vida-_DANIO;
					cOruga.tnt:newTimer(100,cOruga.planta.setRadioMenos,1);--Desengordamos la planta
					--timer.performWithDelay(100,cOruga.planta.setRadioMenos,1);
					cOruga.planta.txtVida.text=cOruga.planta.vida;
				elseif(cOruga.planta.vida<=0)then
					
					--print("PLANTA MUERTA, NIVEL FALLIDO");
					cOruga.UI.objMsjFallido.sacar();
					
					if(cOruga.prop.puntos>cOruga.prop.maxRecord)then
						cOruga.prop.maxRecord=cOruga.prop.puntos;
						--txtMaxRecord.text=maxRecord;
					end
					estado="FINALIZADO";
				end
			end
		elseif(target.sequence=="Masticar")then
			cambiarSecuencia(target,"Atacar");
		end
	end
end
cOruga.sprOrugaListener=sprOrugaListener;

local quitarOndas=function(onda)
	onda:removeEventListener("collision", colision);
	onda:removeSelf();
	onda=nil;
end

local _CAD_ACCION=400;

local quitarVida=function(other)
	local other=other;
	if(other)then
		if(other.vida>1)then--si tiene vida
			other.vida=other.vida-1;--le quitamos una vida
		elseif(other.vida<=1)then--si no
			if(other.timerTela)then--en el caso de la arana
				other.timerTela:cancel();
			end
			other.estado=2;--lo matamos
		end
	end
end

colision=function(event)
	local phase=event.phase;
	local self=event.target;
	local other=event.other;

	if("began"==phase)then
		if(other.tipo=="enemigo")then
			if(other.estado==0 or other.estado==3)then--si esta vivo (o atacando)
				if(other.idTipo=="oruga" and other.flagBomba==false)then--COMBOS DE ORUGAS
					local xx,yy=other.x,other.y;
					cOruga.tnt:newTimer(300,function()other.flagBomba=true;explotar(other,xx,yy);end,1);
				else
					cOruga.tnt:newTimer(_CAD_ACCION,function()quitarVida(other);end,1);
				end
				--timer.performWithDelay(_CAD_ACCION, function()quitarVida(other);end, 1);
			end
		end
	end
end

local expansion=function(xx,yy)

	local coords={{-15,15},{15,15},{15,-15},{15,-15}};

	for i=1,#coords do
		local xxx,yyy=coords[i][1],coords[i][2];	
		local onda=display.newCircle(cOruga.capaGamePlay, xx+xxx, yy+yyy, 30 );
		onda.tipo="onda";
		onda.vida=1;
		onda.alpha=0.2;
		onda:setFillColor(242, 161, 240 );
		physics.addBody(onda, {density = 1.0, friction = 0.3, radius=50});
		onda:applyLinearImpulse(xxx,yyy,xx,yy);
		onda.linearDamping = 10;
		onda.angularDamping = 0.8;

		cOruga.tnt:newTimer(100,function()quitarOndas(onda);end,1);
		--timer.performWithDelay(100,function()quitarOndas(onda);end,1);
		onda:addEventListener("collision", colision);
	end
end

explotar=function(target,xx,yy)
	local target=target;
	local xx,yy=xx,yy;

	cambiarSecuencia(target,"Explotar");

	local trans1=cOruga.tnt:newTransition(
		target, 
		{
			time = 500, 
			xScale = 1.4, 
			yScale=1.4,
			alpha=1, 
			cycle = 1, 
			backAndForth = false, 
			onEnd = function (object, event) 
						object.estado=2;
						expansion(xx,yy); 
					end
		}
	);
end

--MANEJADOR EVENTO TOUCH:
local ataquePorTap=function(event)
	local phase=event.phase;
	local target=event.target;
	if(estado=="NORMAL")then
		if(phase=="began")then
			if(target.vida>1)then
				target.vida=target.vida-1;
			elseif(target.vida==1 and target.flagBomba==false)then
				local xx,yy=target.x,target.y;

				cOruga.prop.puntos=cOruga.prop.puntos+1;
				cOruga.UI.objPuntos.txtPuntos.text=cOruga.prop.puntos;

				local sacarClorofila=math.random(1,_PORC_AGUA);--¿Sacamos clorofila, si o no?
				if(sacarClorofila==1)then
					cOruga.agua.newAgua(xx,yy);
				end

				explotar(target,xx,yy);
				cOruga.combos.aumentarCombo();
				--target.estado=2;
				target.flagBomba=true;
			end
		end
	end
end

--CONSTRUCTOR:
local newOruga=function(xx,yy)
	local oruga={};

	oruga=display.newSprite(cOruga.capaGamePlay,cOruga.sprOrug,cOruga.secOrug);
	oruga.x,oruga.y=xx,yy;

	oruga.estado=0;
	oruga.vida=_VIDA;
	oruga.tipo="enemigo";
	oruga.idTipo="oruga";
	oruga.clase="terrestre";
	oruga.flagBomba=false;
	oruga.puntos=100;
	oruga.velOrigin=cOruga.velOrigin;
	oruga.vel=cOruga.vel;

	oruga.moveX=0.1;
	oruga.moveY=0.1;

	oruga.xScale=0.5;
	oruga.yScale=0.5;

	--playSequence
	cambiarSecuencia(oruga,"Caminar");

	--cuerpo fisico:
	physics.addBody(oruga, {density = 0.1, friction = 1, bounce = 1, isSensor = false, radius=20})
	oruga.linearDamping = 3;
	oruga.angularDamping = 0.8;

	--Listener's:
	oruga:addEventListener("touch", ataquePorTap);
	oruga:addEventListener("sprite", sprOrugaListener);

	return oruga;

end
cOruga.newOruga=newOruga;

--INIT:
local initOruga=function(prop,UI,capa,ruta,planta,agua,combos,tnt)
	local prop=prop;
	--print("Cargando hormiga");
	cOruga.prop=prop;
	cOruga.UI=UI;
	cOruga.capaGamePlay=capa;
	cOruga.planta=planta;
	cOruga.agua=agua;
	cOruga.combos=combos;
	cOruga.tnt=tnt;

	cOruga.velOrigin=_VEL;
	cOruga.vel=_VEL;

	--sprite config:
	local sprOptOrug={
		width=102,
		height=102,
		numFrames=39,
		sheetContentWidth=512,
		sheetContentHeight=1024
	};

	--sprite:
	cOruga.sprOrug = graphics.newImageSheet( ruta, sprOptOrug);

	--Secuencias:
	cOruga.secOrug = {
		{
		name="Caminar",
		start=1,
		count=9,
		time=_VEL_SEC,
		loopCount=0,
		loopDirection = "forward"
		},
		{
		name="Masticar",
		start=31,
		count=8,
		time=_VEL_SEC,
		loopCount=2,
		loopDirection = "forward"
		},
		{
		name="Atacar",
		start=10,
		count=8,
		time=_VEL_SEC,
		loopCount=1,
		loopDirection = "forward",
		},
		{
		name="Explotar",
		start=19,
		count=11,
		time=_VEL_SEC,
		loopCount=1,
		loopDirection = "forward",
		},
	}

	--return cOruga;

end
cOruga.initOruga=initOruga;

return cOruga;