--HORMIGA:
local cHormiga={};

local _PORC_AGUA=1;
local _VEL=0.5;
local _DANIO=10;
local _VIDA=1;
local _VEL_SEC=800;--velocidad de secuencia

--CAMBIAR SECUENCIA:
local cambiarSecuencia=function(target,secuencia)
	target:setSequence(secuencia);
	target:play();
end

--MANEJADOR EVENTO SPRITE (al terminar una secuencia):
local sprHormListener=function(event)
	local phase=event.phase;
	local target=event.target;

	if(phase=="ended")then
		if(target.sequence=="Atacar")then
			cambiarSecuencia(target,"Masticar");
			if(estado=="NORMAL")then
				if(cHormiga.planta.vida>0)then
					cHormiga.planta.vida=cHormiga.planta.vida-_DANIO;
					cHormiga.tnt:newTimer(100,cHormiga.planta.setRadioMenos,1);--Desengordamos la planta
					--timer.performWithDelay(100,cHormiga.planta.setRadioMenos,1);
					cHormiga.planta.txtVida.text=cHormiga.planta.vida;
				elseif(cHormiga.planta.vida<=0)then
					
					--print("PLANTA MUERTA, NIVEL FALLIDO");
					cHormiga.UI.objMsjFallido.sacar();
			
					if(cHormiga.prop.puntos>cHormiga.prop.maxRecord)then
						cHormiga.prop.maxRecord=cHormiga.prop.puntos;
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
cHormiga.sprHormListener=sprHormListener;

--MANEJADOR EVENTO TOUCH:
local ataquePorTap=function(event)
	local phase=event.phase;
	local target=event.target;
	if(estado=="NORMAL")then
		if(phase=="began")then
			if(target.vida>1)then
				target.vida=target.vida-1;
			elseif(target.vida<=1)then
				local xx,yy=target.x,target.y;

				cHormiga.prop.puntos=cHormiga.prop.puntos+1;
				cHormiga.UI.objPuntos.txtPuntos.text=cHormiga.prop.puntos;

				local sacarClorofila=math.random(1,_PORC_AGUA);--¿Sacamos clorofila, si o no?
				if(sacarClorofila==1)then
					cHormiga.agua.newAgua(xx,yy);
				end

				target.estado=2;

				cHormiga.combos.aumentarCombo();
		
			end
		end
	end
end

--CONSTRUCTOR:
local newHormiga=function(xx,yy)
	local hormiga={};

	hormiga=display.newSprite(cHormiga.capaGamePlay,cHormiga.sprHorm,cHormiga.secHorm);
	hormiga.x,hormiga.y=xx,yy;

	hormiga.estado=0;
	hormiga.vida=_VIDA;
	hormiga.tipo="enemigo";
	hormiga.clase="terrestre";
	hormiga.puntos=100;
	hormiga.velOrigin=cHormiga.velOrigin;
	hormiga.vel=cHormiga.vel;

	hormiga.moveX=0.1;
	hormiga.moveY=0.1;

	hormiga.xScale=0.5;
	hormiga.yScale=0.5;
	
	--playSequence
	cambiarSecuencia(hormiga,"Caminar");

	--cuerpo fisico:
	physics.addBody(hormiga, {density = 0.1, friction = 1, bounce = 1, isSensor = false, radius=20})
	hormiga.linearDamping = 3;
	hormiga.angularDamping = 0.8;

	--Listener's:
	hormiga:addEventListener("touch", ataquePorTap);
	hormiga:addEventListener("sprite", sprHormListener);

	return hormiga;

end
cHormiga.newHormiga=newHormiga;

--INIT:
local initHormiga=function(prop,UI,capa,ruta,planta,agua,combos,tnt)
	local prop=prop;
	--print("Cargando hormiga");
	cHormiga.prop=prop;
	cHormiga.UI=UI;
	cHormiga.capaGamePlay=capa;
	cHormiga.planta=planta;
	cHormiga.agua=agua;
	cHormiga.combos=combos;
	cHormiga.tnt=tnt;

	cHormiga.velOrigin=_VEL;
	cHormiga.vel=_VEL;

	--sprite config:
	local sprOptHorm={
		width=96,
		height=96,
		numFrames=24,
		sheetContentWidth=512,
		sheetContentHeight=512
	};

	--sprite:
	cHormiga.sprHorm = graphics.newImageSheet( ruta, sprOptHorm);

	--Secuencias:
	cHormiga.secHorm = {
		{
		name="Caminar",
		start=17,
		count=7,
		time=_VEL_SEC,
		loopCount=0,
		loopDirection = "forward"
		},
		{
		name="Masticar",
		start=1,
		count=8,
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
		}
	}

	--return cHormiga;
	
end
cHormiga.initHormiga=initHormiga;

return cHormiga;