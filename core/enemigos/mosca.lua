--Arana:
local cMosca={};

local _PORC_AGUA=1;
local _VEL=1;
local _DANIO=50;
local _VIDA=5;
local _VEL_SEC=800;--velocidad de secuencia

local _VX,_VY=240,100;
local _ANG_DAMP_MOSCA=10;
local _FREC_MUERTE=30;--intervalo en ms. para comprobar si sale fuera de pantalla

local empezarOrbita,colision,dragBody,sprMoscaListener,comprobarMuerte;

--CAMBIAR SECUENCIA:
local cambiarSecuencia=function(target,secuencia)
	if(target~=nil)then
		target:setSequence(secuencia);
		target:play();
	end
end

--EMPEZAR ORBITA:
empezarOrbita=function(target)
	if(target)then
		local target=target;
		target.joint=physics.newJoint( "distance", target, cMosca.planta.inst, target.x, target.y, cMosca.planta.inst.x, cMosca.planta.inst.y );
		target.paso="orbitando";
		target.linearDamping=nil;
		target.angularDamping=nil;
		target:setLinearVelocity(_VX,_VY);

		target.timerCad:cancel();
		--Quitamos la comprobacion de muerte (orbitando no pueden morir, aunque esten fuera de la pantalla):
		if(target.timerMuerte~=nil)then
			target.timerMuerte:cancel();
			target.timerMuerte=nil;
		end
	end

end

--COLISION ENTRE MOSCAS:
colision=function(event)
	local phase=event.phase;
	local target=event.target;
	local other=event.other;

	if(other.clase=="volador")then

		if(target.paso=="agarrado" or target.paso=="resbalando")then

			target.paso="resbalando";
			other.paso="resbalando";

		elseif(target.paso=="orbitando")then

			if(other.paso~="orbitando")then

				target.paso="resbalando";
				other.paso="resbalando";
			end
		end

		if(target.paso=="resbalando")then

			--Empezamos a comprobar si sale fuera de pantalla:
			if(target.timerMuerte==nil)then
				target.timerMuerte=cMosca.tnt:newTimer(_FREC_MUERTE,function()comprobarMuerte(target);end,0);
			else
				target.timerMuerte:resume();
			end

			--Quitamos la union entre la mosca y la planta (para arrastrar completamente):
			if(target.joint)then
				target.joint:removeSelf();
				target.joint=nil;
			end
			--Cancelamos si se iva a poner en orbita en breves:
			if(target.timerCad~=nil)then
				target.timerCad:cancel();
			end
			--Lo ponemos en orbita despues de un tiempo:
			target.timerCad=cMosca.tnt:newTimer(
				1000,
				function()
					empezarOrbita(target);
				end, 
			1);
		end

		if(other.paso=="resbalando")then

			--Empezamos a comprobar si sale fuera de pantalla:
			if(other.timerMuerte==nil)then
				other.timerMuerte=cMosca.tnt:newTimer(_FREC_MUERTE,function()comprobarMuerte(other);end,0);
			else
				other.timerMuerte:resume();
			end

			--Quitamos la union entre la mosca y la planta (para arrastrar completamente):
			if(other.joint)then
				other.joint:removeSelf();
				other.joint=nil;
			end
			--Cancelamos si se iva a poner en orbita en breves:
			if(other.timerCad~=nil)then
				other.timerCad:cancel();
			end
			--Lo ponemos en orbita despues de un tiempo:
			other.timerCad=cMosca.tnt:newTimer(
				1000,
				function()
					empezarOrbita(other);
				end, 
			1);
		end
	end
	
	return true;
end

--MANEJADOR EVENTO SPRITE (al terminar una secuencia):
sprMoscaListener=function(event)
	local phase=event.phase;
	local target=event.target;

	if(phase=="ended")then
		if(target.sequence=="Atacar")then
			cambiarSecuencia(target,"Masticar");
			if(estado=="NORMAL")then
				if(cMosca.planta.vida>0)then
					cMosca.planta.vida=cMosca.planta.vida-_DANIO;
					cMosca.tnt:newTimer(100,cMosca.planta.setRadioMenos,1);--Desengordamos la planta
					cMosca.planta.txtVida.text=cMosca.planta.vida;
				elseif(cMosca.planta.vida<=0)then
					--print("PLANTA MUERTA, NIVEL FALLIDO");
					cMosca.UI.objMsjFallido.sacar();
					
					if(cMosca.prop.puntos>cMosca.prop.maxRecord)then
						cMosca.prop.maxRecord=cMosca.prop.puntos;
					end
					estado="FINALIZADO";
				end
			end
		elseif(target.sequence=="Masticar")then
			cambiarSecuencia(target,"Atacar");
		elseif(target.sequence=="Incorporar")then
			cambiarSecuencia(target,"Atacar");
		end
	end
end
cMosca.sprMoscaListener=sprMoscaListener;

--COMPROBAR MUERTE:
comprobarMuerte=function(target)
	print(target);
	local xx,yy=nil,nil;
	--Comprobamos si no esta orbitando 
	--Comprobamos si sale fuera de la pantalla:
	if(target.x>cMosca.prop._WIDTH+150)then
		xx=cMosca.prop._WIDTH-50;
		yy=target.y;
		rot=-45;
	elseif(target.x<-50)then
		xx=0;
		yy=target.y;
		rot=45;
	elseif(target.y>cMosca.prop._HEIGHT+50)then
		xx=target.x;
		yy=cMosca.prop._HEIGHT-50;
		rot=0;
	elseif(target.y<-50)then
		xx=target.x;
		yy=0;
		rot=-90;
	end

	if(xx~=nil)then
		physics.removeBody(target);
		if(target.timerCad~=nil)then
			target.timerCad:cancel();
		end
		target.timerSombra:cancel();
		if(target.timerMuerte~=nil)then
			target.timerMuerte:cancel();
		end
		target.xx=xx;
		target.yy=yy;
		target.rot=rot;
		target:removeEventListener("touch", dragBody);
		target:removeEventListener("sprite", sprMoscaListener);
		target:removeEventListener("collision", colision);

		--Quitamos conexion con planta:
		if(target.joint)then
			target.joint:removeSelf();
			target.joint=nil;
		end

		--Quitamos sombra y su timer:
        target.timerSombra:cancel();
        target.timerSombra=nil;
        target.sombra.joint:removeSelf();
        target.sombra:removeSelf();

		target.estado=2;
	end
end

--DRAG BODY:
dragBody=function(event)
	local target=event.target;
	local phase=event.phase;
	
	if(estado=="NORMAL")then
		target.estado=0;
		cambiarSecuencia(target,"Caminar");
		--Empezamos a comprobar si sale fuera de pantalla:
		if(target.timerMuerte==nil)then
			target.timerMuerte=cMosca.tnt:newTimer(_FREC_MUERTE,function()comprobarMuerte(target);end,0);
		else
			target.timerMuerte:resume();
		end

		--Empezamos a arrastrar:
		local params={ maxForce=20000, frequency=1000, dampingRatio=1.0}
		local finArrastrado=cMosca.utils.dragBody(event,params,cMosca.planta.inst);
		--Si hemos terminado de arrastar:
		if(finArrastrado=="terminado")then
			if(target.estado~=2)then
				target.paso="resbalando";

				--Lo ponemos en orbita despues de un tiempo:
				target.timerCad=cMosca.tnt:newTimer(1000,function()
					empezarOrbita(target);
				end, 1);
			end
		--Si nos hemos quedado a medias (nos hemos chocado mientras arrastrabamos):
		elseif(finArrastrado=="aMedias")then
			--if(target.tempJoint.length)then
				--target.tempJoint:removeSelf();
				
				target.angularDamping=100;
				target.linearDamping=5;
			--end
		end
	end
	return true;
end

--SEGUIR SOMBRA:
local seguirSombra=function(target,sombra)
	--print("LA SOMBRA SIGUE");
	local target,sombra=target,sombra;
	if(target.x and sombra.x)then
		sombra.x=target.x-85;
		sombra.y=target.y;
	end
end

--CONSTRUCTOR:
local newMosca=function(xx,yy)
	local mosca={};
	mosca=display.newSprite(cMosca.capaVoladores,cMosca.sprMosca,cMosca.secMosca);
	mosca.x,mosca.y=xx,yy;

	mosca.estado=0;
	mosca.vida=_VIDA;
	mosca.velOrigin=cMosca.velOrigin;
	mosca.vel=cMosca.vel;
	
	mosca.tipo="enemigo";
	mosca.clase="volador";
	mosca.idTipo="mosca";
	mosca.paso="orbitando";

	mosca.puntos=100;

	mosca.moveX=0.1;
	mosca.moveY=0.1;

	mosca.xScale=0.5;
	mosca.yScale=0.5;

	--playSequence
	cambiarSecuencia(mosca,"Caminar");

	--cuerpo fisico:
	physics.addBody(mosca, {density=1,friction=0.5, bounce=1,radius=30,isSensor=false, filter=cMosca.voladoresColFiltro});
	mosca.angularDamping=100;
	--Union fisica ("invisible") con la planta:
	mosca.joint = physics.newJoint( "distance", mosca, cMosca.planta.inst, mosca.x, mosca.y, cMosca.planta.inst.x, cMosca.planta.inst.y );
	mosca:setLinearVelocity(_VX,_VY);

	--Listener's:
	mosca:addEventListener("touch", dragBody );
	mosca:addEventListener("sprite", sprMoscaListener);
	mosca:addEventListener("collision", colision);

	--SOMBRA [PROVISIONAL]:
	mosca.sombra=display.newCircle(cMosca.capaSombras,xx-5,yy-5,30);
	mosca.sombra:setFillColor(10, 10, 10, 40);
	physics.addBody(mosca.sombra, {radius=30,isSensor=true, filter=cMosca.voladoresColFiltro});
	mosca.sombra.moveX=0.1;
	mosca.sombra.moveY=0.1;

	mosca.sombra.joint = physics.newJoint( "distance", mosca.sombra, cMosca.planta.inst, mosca.sombra.x, mosca.sombra.y, cMosca.planta.inst.x, cMosca.planta.inst.y );
	mosca.sombra:setLinearVelocity(_VX,_VY);
	mosca.timerSombra=cMosca.tnt:newTimer(1, function()seguirSombra(mosca,mosca.sombra);end, 0);

	return mosca;

end
cMosca.newMosca=newMosca;

--INIT:
local initMosca=function(prop,UI,capaSombras,capaVoladores,ruta,planta,agua,combos,tnt,utils)
	local prop=prop;
	--print("Cargando Arana");
	cMosca.prop=prop;
	cMosca.UI=UI;
	cMosca.capaSombras=capaSombras;
	cMosca.capaVoladores=capaVoladores;
	cMosca.planta=planta;
	cMosca.agua=agua;
	cMosca.combos=combos;
	cMosca.tnt=tnt;
	cMosca.utils=utils;

	cMosca.velOrigin=_VEL;
	cMosca.vel=_VEL;

	--Filtro de colision:
	cMosca.voladoresColFiltro = { categoryBits = 2, maskBits = 2 };

	--sprite config:
	local sprOptMosca={
		width=107,
		height=107,
		numFrames=36,
		sheetContentWidth=512,
		sheetContentHeight=1024
	};

	--sprite:
	cMosca.sprMosca = graphics.newImageSheet( ruta, sprOptMosca );

	--Secuencias:
	cMosca.secMosca = {
		{
		name="Caminar",
		start=28,
		count=9,
		time=_VEL_SEC,
		loopCount=0,
		loopDirection = "forward"
		},
		{
		name="Atacar",
		start=1,
		count=9,
		time=_VEL_SEC,
		loopCount=1,
		loopDirection = "forward"
		},
		{
		name="Incorporar",
		start=10,
		count=9,
		time=_VEL_SEC+100,
		loopCount=1,
		loopDirection = "forward",
		},
		{
		name="Masticar",
		start=19,
		count=9,
		time=_VEL_SEC,
		loopCount=1,
		loopDirection = "forward",
		}
	}

end
cMosca.initMosca=initMosca;

return cMosca;