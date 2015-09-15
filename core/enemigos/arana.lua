--Arana:
local cArana={};

local _PORC_AGUA=1;
local _VEL=0.5;
local _DANIO=10;
local _VIDA=1;
local _VEL_SEC=800;--velocidad de secuencia

local _LIFE_TELA_MIN,_LIFE_TELA_MAX=5000,9000;
local _CAD_TELA_MIN,_CAD_TELA_MAX=2000,4000;

local crearMancha=function(xx,yy)
	
	local xx,yy=xx,yy;
	local mancha=display.newImage(cArana.capaGamePlay,"core/enemigos/telaArana.png",0,0);
	mancha.x,mancha.y=xx,yy;
	local life=math.random(_LIFE_TELA_MIN,_LIFE_TELA_MAX);
	cArana.tnt:newTransition(mancha,{time=life, alpha=0, onComplete=function()mancha:removeSelf();mancha=nil;end});
	--mancha:setFillColor(10, 10, 10);
end

--CAMBIAR SECUENCIA:
local cambiarSecuencia=function(target,secuencia)
	if(target~=nil)then--DA BUG CON LA BOMBA
		target:setSequence(secuencia);
		target:play();
	end
end

--MANEJADOR EVENTO SPRITE (al terminar una secuencia):
local sprAranaListener=function(event)
	local phase=event.phase;
	local target=event.target;

	if(phase=="ended")then
		if(target.sequence=="Atacar")then
			cambiarSecuencia(target,"Masticar");
			if(estado=="NORMAL")then
				if(cArana.planta.vida>0)then
					cArana.planta.vida=cArana.planta.vida-_DANIO;
					cArana.tnt:newTimer(100,cArana.planta.setRadioMenos,1);--Desengordamos la planta
					--timer.performWithDelay(100,cArana.planta.setRadioMenos,1);
					cArana.planta.txtVida.text=cArana.planta.vida;
				elseif(cArana.planta.vida<=0)then
					
					--print("PLANTA MUERTA, NIVEL FALLIDO");
					cArana.UI.objMsjFallido.sacar();
					
					if(cArana.prop.puntos>cArana.prop.maxRecord)then
						cArana.prop.maxRecord=cArana.prop.puntos;
						--txtMaxRecord.text=maxRecord;
					end
					estado="FINALIZADO";
				end
			end
		elseif(target.sequence=="Masticar")then
			cambiarSecuencia(target,"Atacar");
		elseif(target.sequence=="Explotar")then
			cambiarSecuencia(target,"Caminar");
			target.flagBomba=false;
			local xx,yy=target.x,target.y;
			crearMancha(xx,yy);
			target.timerTela:cancel();
			local cad=math.random(_CAD_TELA_MIN,_CAD_TELA_MAX);
			target.timerTela=cArana.tnt:newTimer(cad,function()cambiarSecuencia(target,"Explotar");end,1);

			--target.estado=2;
		end
	end
end
cArana.sprAranaListener=sprAranaListener;

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

				cArana.prop.puntos=cArana.prop.puntos+1;
				cArana.UI.objPuntos.txtPuntos.text=cArana.prop.puntos;

				local sacarClorofila=math.random(1,_PORC_AGUA);--¿Sacamos clorofila, si o no?
				if(sacarClorofila==1)then
					cArana.agua.newAgua(xx,yy);
				end

				target.timerTela:pause();
				target.timerTela:cancel();
				target.timerTela=nil;
				target.estado=2;
				--cambiarSecuencia(target,"Explotar");
				--target.flagBomba=true;
				--cArana.combos.aumentarCombo();
		
			end
		end
	end
end

--CONSTRUCTOR:
local newArana=function(xx,yy)
	local arana={};
	arana=display.newSprite(cArana.capaGamePlay,cArana.sprArana,cArana.secArana);
	arana.x,arana.y=xx,yy;

	arana.estado=0;
	arana.vida=_VIDA;
	arana.flagBomba=false;
	arana.tipo="enemigo";
	arana.clase="terrestre";
	arana.idTipo="arana";
	arana.puntos=100;
	arana.velOrigin=cArana.velOrigin;
	arana.vel=cArana.vel;

	arana.moveX=0.1;
	arana.moveY=0.1;

	arana.xScale=0.5;
	arana.yScale=0.5;

	--playSequence
	cambiarSecuencia(arana,"Caminar");

	local xx,yy=arana.x,arana.y;
	local cadIni=math.random(_CAD_TELA_MIN,_CAD_TELA_MAX);
	arana.timerTela = cArana.tnt:newTimer(cadIni,function()cambiarSecuencia(arana,"Explotar");end,1);

	--cuerpo fisico:
	physics.addBody(arana, {density = 0.1, friction = 1, bounce = 1, isSensor = false, radius=20})
	arana.linearDamping = 3;
	arana.angularDamping = 0.8;

	--Listener's:
	arana:addEventListener("touch", ataquePorTap);
	arana:addEventListener("sprite", sprAranaListener);

	return arana;

end
cArana.newArana=newArana;

--INIT:
local initArana=function(prop,UI,capa,ruta,planta,agua,combos,tnt)
	local prop=prop;
	--print("Cargando Arana");
	cArana.prop=prop;
	cArana.UI=UI;
	cArana.capaGamePlay=capa;
	cArana.planta=planta;
	cArana.agua=agua;
	cArana.combos=combos;
	cArana.tnt=tnt;

	cArana.velOrigin=_VEL;
	cArana.vel=_VEL;

	--sprite config:
	local sprOptArana={
		width=102,
		height=102,
		numFrames=36,
		sheetContentWidth=512,
		sheetContentHeight=1024
	};

	--sprite:
	cArana.sprArana = graphics.newImageSheet( ruta, sprOptArana);

	--Secuencias:
	cArana.secArana = {
		{
		name="Caminar",
		start=1,
		count=9,
		time=_VEL_SEC,
		loopCount=0,
		loopDirection = "forward"
		},
		{
		name="Atacar",
		start=10,
		count=9,
		time=_VEL_SEC,
		loopCount=2,
		loopDirection = "forward"
		},
		{
		name="Explotar",
		start=19,
		count=9,
		time=_VEL_SEC,
		loopCount=1,
		loopDirection = "forward",
		}
		,
		{
		name="Masticar",
		start=28,
		count=9,
		time=_VEL_SEC,
		loopCount=1,
		loopDirection = "forward",
		}
	}

	--return cArana;

end
cArana.initArana=initArana;

return cArana;