--HORMIGA:
local cEscarabajo={};

local _PORC_AGUA=1;
local _VEL=0.5;
local _AUM_VEL=2;
local _DANIO=10;
local _VIDA=4;
local _VEL_SEC=800;--velocidad de secuencia

--CAMBIAR SECUENCIA:
local cambiarSecuencia=function(target,secuencia)
	target:setSequence(secuencia);
	target:play();
end

--MANEJADOR EVENTO SPRITE (al terminar una secuencia):
local sprEscaraListener=function(event)
	local phase=event.phase;
	local target=event.target;

	if(phase=="ended")then
		if(target.sequence=="Atacar")then
			cambiarSecuencia(target,"Masticar");
			if(estado=="NORMAL")then
				if(cEscarabajo.planta.vida>0)then
					cEscarabajo.planta.vida=cEscarabajo.planta.vida-_DANIO;
					cEscarabajo.tnt:newTimer(100,cEscarabajo.planta.setRadioMenos,1);--Desengordamos la planta
					--timer.performWithDelay(100,cEscarabajo.planta.setRadioMenos,1);
					cEscarabajo.planta.txtVida.text=cEscarabajo.planta.vida;
				elseif(cEscarabajo.planta.vida<=0)then
					
					--print("PLANTA MUERTA, NIVEL FALLIDO");
					cEscarabajo.UI.objMsjFallido.sacar();
					--[[transition.to(cEscarabajo.UI.objMsjF.capaMensaje,{
																	time=1000,
																	alpha=1,
																	onComplete=function()
																		timer.performWithDelay(2000,function()
																			estado="FINALIZADO_OK";
																			--print(estado);
																			cEscarabajo.UI.setReiniciar();end,1);
																	end});]]
					if(cEscarabajo.prop.puntos>cEscarabajo.prop.maxRecord)then
						cEscarabajo.prop.maxRecord=cEscarabajo.prop.puntos;
						--txtMaxRecord.text=maxRecord;
					end
					estado="FINALIZADO";
				end
			end
		elseif(target.sequence=="Masticar")then
			cambiarSecuencia(target,"Atacar");
		elseif(target.sequence=="Golpeado")then
			cambiarSecuencia(target,"Tocado");
			print("CAMBIAMOS A TOCADO");
		elseif(target.sequence=="Tocado")then
			--Le añadimos mas velocidad al escarabajo por cada golpe que le dan:
			target.vel=target.vel+_AUM_VEL;
			cambiarSecuencia(target,"Caminar");
		end
	end
end
cEscarabajo.sprEscaraListener=sprEscaraListener;

--MANEJADOR EVENTO TOUCH:
local ataquePorTap=function(event)
	local phase=event.phase;
	local target=event.target;
	if(estado=="NORMAL")then
		if(phase=="began")then
			local xx,yy=target.x,target.y;
			if(target.vida>1)then
				target.vida=target.vida-1;
				local xP,yP=cEscarabajo.planta.inst.x,cEscarabajo.planta.inst.y;
				local xxx,yyy;
				if(xx>xP and yy>yP)then--(-,-)
					xxx,yyy=4,4;
				elseif(xx<=xP and yy>yP)then--(-,+)
					xxx,yyy=-4,4;
				elseif(xx<=xP and yy<=yP)then--(-,-)
					xxx,yyy=-4,-4;
				elseif(xx>xP and yy<=yP)then--(+,-)
					xxx,yyy=4,-4;
				end
				target:applyLinearImpulse(xxx,yyy,xx,yy);
				cambiarSecuencia(target,"Golpeado");
			elseif(target.vida<=1)then
				

				cEscarabajo.prop.puntos=cEscarabajo.prop.puntos+1;
				cEscarabajo.UI.objPuntos.txtPuntos.text=cEscarabajo.prop.puntos;

				local sacarClorofila=math.random(1,_PORC_AGUA);--¿Sacamos clorofila, si o no?
				if(sacarClorofila==1)then
					cEscarabajo.agua.newAgua(xx,yy);
				end

				target.estado=2;
				--print("COS "..math.cos());
				--print(" X DE PLANTA:"..cEscarabajo.planta.inst.x);
				
				cEscarabajo.combos.aumentarCombo();
		
			end
		end
	end
end

--CONSTRUCTOR:
local newEscarabajo=function(xx,yy)
	local escarabajo={};

	escarabajo=display.newSprite(cEscarabajo.capaGamePlay,cEscarabajo.sprEscara,cEscarabajo.secEscara);
	escarabajo.x,escarabajo.y=xx,yy;

	escarabajo.estado=0;
	escarabajo.vida=_VIDA;
	escarabajo.tipo="enemigo";
	escarabajo.clase="terrestre";
	escarabajo.puntos=100;
	escarabajo.velOrigin=cEscarabajo.velOrigin;
	escarabajo.vel=cEscarabajo.vel;

	escarabajo.moveX=0.1;
	escarabajo.moveY=0.1;

	escarabajo.xScale=0.5;
	escarabajo.yScale=0.5;

	--playSequence
	cambiarSecuencia(escarabajo,"Caminar");

	--cuerpo fisico:
	physics.addBody(escarabajo, {density = 0.1, friction = 1, bounce = 1, isSensor = false, radius=20})
	escarabajo.linearDamping = 3;
	escarabajo.angularDamping = 0.8;

	--Listener's:
	escarabajo:addEventListener("touch", ataquePorTap);
	escarabajo:addEventListener("sprite", sprEscaraListener);

	return escarabajo;

end
cEscarabajo.newEscarabajo=newEscarabajo;

--INIT:
local initEscarabajo=function(prop,UI,capa,ruta,planta,agua,combos,tnt)
	local prop=prop;
	--print("Cargando hormiga");
	cEscarabajo.prop=prop;
	cEscarabajo.UI=UI;
	cEscarabajo.capaGamePlay=capa;
	cEscarabajo.planta=planta;
	cEscarabajo.agua=agua;
	cEscarabajo.combos=combos;
	cEscarabajo.tnt=tnt;

	cEscarabajo.velOrigin=_VEL;
	cEscarabajo.vel=_VEL;

	--sprite config:
	local sprOptEscara={
		width=102,
		height=102,
		numFrames=30,
		sheetContentWidth=512,
		sheetContentHeight=1024
	};

	--sprite:
	cEscarabajo.sprEscara = graphics.newImageSheet( ruta, sprOptEscara);

	--Secuencias:
	cEscarabajo.secEscara = {
		{
		name="Caminar",
		start=1,
		count=8,
		time=_VEL_SEC,
		loopCount=0,
		loopDirection = "forward"
		},
		{
		name="Masticar",
		start=25,
		count=6,
		time=_VEL_SEC,
		loopCount=2,
		loopDirection = "forward"
		},
		{
		name="Atacar",
		start=9,
		count=8,
		time=_VEL_SEC,
		loopCount=1,
		loopDirection = "forward",
		},
		{
		name="Golpeado",
		start=18,
		count=6,
		time=_VEL_SEC,
		loopCount=1,
		loopDirection = "forward"
		},
		{
		name="Tocado",
		start=22,
		count=2,
		time=_VEL_SEC,
		loopCount=1,
		loopDirection = "forward"
		}
	}
	--return cEscarabajo;
end
cEscarabajo.initEscarabajo=initEscarabajo;

return cEscarabajo;