local cCaracol={};

local _PORC_AGUA=1;
local _VEL=0.5;
local _DANIO=10;
local _VIDA=2;-- 0 batible, 1 batible
local _VEL_SEC=800;--velocidad de secuencia

--CAMBIAR SECUENCIA:
local cambiarSecuencia=function(target,secuencia)
	target:setSequence(secuencia);
	target:play();
end

--MANEJADOR EVENTO SPRITE (al terminar una secuencia):
local sprCaracListener=function(event)
	local phase=event.phase;
	local target=event.target;

	if(phase=="ended")then
		if(target.sequence=="Atacar")then
			cambiarSecuencia(target,"Masticar");
			if(estado=="NORMAL")then
				if(cCaracol.planta.vida>0)then
					cCaracol.planta.vida=cCaracol.planta.vida-_DANIO;
					cCaracol.tnt:newTimer(100,cCaracol.planta.setRadioMenos,1);--Desengordamos la planta
					--timer.performWithDelay(100,cCaracol.planta.setRadioMenos,1);
					cCaracol.planta.txtVida.text=cCaracol.planta.vida;
				elseif(cCaracol.planta.vida<=0)then
					
					--print("PLANTA MUERTA, NIVEL FALLIDO");
					cCaracol.UI.objMsjFallido.sacar();
					if(cCaracol.prop.puntos>cCaracol.prop.maxRecord)then
						cCaracol.prop.maxRecord=cCaracol.prop.puntos;
						--txtMaxRecord.text=maxRecord;
					end
					estado="FINALIZADO";
				end
			end
		elseif(target.sequence=="Masticar")then
			cambiarSecuencia(target,"Atacar");
		elseif(target.sequence=="Esconderse")then
			target.enEstado="batible";
			cambiarSecuencia(target,"Escondido");
		elseif(target.sequence=="Escondido")then
			cambiarSecuencia(target,"Caminar");
			target.vel=cCaracol.velOrigin;
			target.enEstado="imbatible";
		end
	end
end
cCaracol.sprCaracListener=sprCaracListener;

--MANEJADOR EVENTO TOUCH:
local ataquePorTap=function(event)
	local phase=event.phase;
	local target=event.target;
	if(estado=="NORMAL")then
		if(phase=="began")then
			if(target.enEstado=="imbatible")then
				if(target.sequence~="Esconderse")then
					cambiarSecuencia(target,"Esconderse");
					target.vel=0.0000000001;
				end
			elseif(target.enEstado=="batible")then
				local xx,yy=target.x,target.y;

				cCaracol.prop.puntos=cCaracol.prop.puntos+1;
				cCaracol.UI.objPuntos.txtPuntos.text=cCaracol.prop.puntos;

				local sacarClorofila=math.random(1,_PORC_AGUA);--¿Sacamos clorofila, si o no?
				if(sacarClorofila==1)then
					cCaracol.agua.newAgua(xx,yy);
				end

				target.estado=2;

				cCaracol.combos.aumentarCombo();
		
			end
		end
	end
end

--CONSTRUCTOR:
local newCaracol=function(xx,yy)
	local caracol={};

	caracol=display.newSprite(cCaracol.capaGamePlay,cCaracol.sprCarac,cCaracol.secCarac);
	caracol.x,caracol.y=xx,yy;

	caracol.estado=0;
	caracol.enEstado="imbatible";
	caracol.vida=_VIDA;
	caracol.tipo="enemigo";
	caracol.clase="terrestre";
	caracol.puntos=100;
	caracol.velOrigin=cCaracol.velOrigin;
	caracol.vel=cCaracol.vel;

	caracol.moveX=0.1;
	caracol.moveY=0.1;

	caracol.xScale=0.5;
	caracol.yScale=0.5;

	--playSequence
	cambiarSecuencia(caracol,"Caminar");

	--cuerpo fisico:
	physics.addBody(caracol, {density = 4, friction = 1, bounce = 1, isSensor = false, radius=20})
	caracol.linearDamping = 3;
	caracol.angularDamping = 0.8;

	--Listener's:
	caracol:addEventListener("touch", ataquePorTap);
	caracol:addEventListener("sprite", sprCaracListener);

	return caracol;

end
cCaracol.newCaracol=newCaracol;

--INIT:
local initCaracol=function(prop,UI,capa,ruta,planta,agua,combos,tnt)
	local prop=prop;

	cCaracol.prop=prop;
	cCaracol.UI=UI;
	cCaracol.capaGamePlay=capa;
	cCaracol.planta=planta;
	cCaracol.agua=agua;
	cCaracol.combos=combos;
	cCaracol.tnt=tnt;

	cCaracol.velOrigin=_VEL;
	cCaracol.vel=_VEL;

	--sprite config:
	local sprOptCarac={
		width=102,
		height=102,
		numFrames=44,
		sheetContentWidth=512,
		sheetContentHeight=1024
	};
	--sprite:
	cCaracol.sprCarac= graphics.newImageSheet( ruta, sprOptCarac);

	--Secuencias:
	cCaracol.secCarac = {
		{
		name="Caminar",
		start=1,
		count=8,
		time=_VEL_SEC,
		loopCount=0,
		loopDirection = "forward"
		},
		{
		name="Atacar",
		start=10,
		count=10,
		time=_VEL_SEC,
		loopCount=1,
		loopDirection = "forward",
		},
		{
		name="Escondido",
		start=21,
		count=5,
		time=_VEL_SEC,
		loopCount=4,
		loopDirection = "forward"
		},
		{
		name="Masticar",
		start=27,
		count=10,
		time=_VEL_SEC,
		loopCount=2,
		loopDirection = "forward"
		},
		{
		name="Esconderse",
		start=38,
		count=7,
		time=_VEL_SEC,
		loopCount=1,
		loopDirection = "forward"
		}

	}

	return cCaracol;

end
cCaracol.initCaracol=initCaracol;

return cCaracol;