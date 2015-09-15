local AutoStore=require("dmc_autostore");

local msjFinal={};

local _ANCH,_ALT=250,290;
local _CAD_SALIR=1000;
local _VEL=100;

local _TAM_BTN=20;
local _MARGIN_TOP=50;

local nivelSuperado=function(idNivel)
	local idNivel=idNivel;
	local data=AutoStore.data;
	data.niveles[idNivel].superado=1;
end

--EFECTO SACAR:
local sacar=function(idNivel)
	local idNivel=idNivel;
	print("Sacamos mensaje final!!!!");
	msjFinal.xScale,msjFinal.yScale=0.5,0.5;
	timer.performWithDelay(
		_CAD_SALIR, 
		function() 
			transition.to(msjFinal.capaMsjFinal,{time=_VEL,y=0,alpha=1,xScale=1,yScale=1,onComplete=function()nivelSuperado(idNivel);end});
		end, 
		1);
end
msjFinal.sacar=sacar;

--MANEJADORES DE LOS 3 BOTONES:
local manejarReiniciar=function(event)
	msjFinal.reiniciar(true);
	msjFinal.capaMsjFinal.alpha=0;
end

local manejarEleccion=function(event)
	msjFinal.irEleccion(true);
	msjFinal.capaMsjFinal.alpha=0;
end

local manejarSiguiente=function(event)
	msjFinal.irSiguiente();
	msjFinal.capaMsjFinal.alpha=0;
end

--DIBUJAR:
local dibujarMsjFinal=function()
	local prop=msjFinal.prop;

	local capaMsjFinal=display.newGroup();
	capaMsjFinal.width,capaMsjFinal.height=_ANCH,_ALT;
	capaMsjFinal.x,capaMsjFinal.y=(prop._WIDTH/2)-(_ANCH/2),0;

	local fondoGris=display.newRect(capaMsjFinal,-(prop._WIDTH/2),-100,prop._WIDTH*2,prop._HEIGHT*2);
	fondoGris:setFillColor(60, 160, 60, 150);
	--fondoGris.alpha=0;

	local fondo=display.newRect(capaMsjFinal,0,0,_ANCH,_ALT+100);
	fondo:setFillColor(100, 100, 100);

	local capaMsj=display.newGroup();
	local fondoMsj=display.newRect(capaMsj,0,0,_ANCH,40);
	fondoMsj:setFillColor(130,100, 100);
	local msj=display.newText(capaMsj,"¡NIVEL GANADO!",0,0,"Helvetica",20);
	capaMsjFinal:insert(capaMsj);

	--Crear hijos botones (reanudar,eleccion de niveles, tienda)
	local yInicial=150;

	local btnReiniciar=display.newCircle(capaMsjFinal,80,yInicial,_TAM_BTN);
	btnReiniciar:setFillColor(50, 60, 80);
	btnReiniciar:addEventListener("tap", manejarReiniciar);

	local btnEleccion=display.newCircle(capaMsjFinal,80,yInicial+_MARGIN_TOP,_TAM_BTN);
	btnEleccion:setFillColor(50,60,80);
	btnEleccion:addEventListener("tap", manejarEleccion);

	local btnSiguiente=display.newCircle(capaMsjFinal,80,yInicial+(_MARGIN_TOP*2),_TAM_BTN);
	btnSiguiente:addEventListener("tap", manejarSiguiente);


	capaMsjFinal.alpha=0;
	msjFinal.capaMsjFinal=capaMsjFinal;

end
msjFinal.dibujarMsjFinal=dibujarMsjFinal;

local setMetodosGear=function(reiniciar, irEleccion, irSiguiente)
	msjFinal.reiniciar=reiniciar;
	msjFinal.irEleccion=irEleccion;
	msjFinal.irSiguiente=irSiguiente;
end
msjFinal.setMetodosGear=setMetodosGear;

--INIT:
local initMsjFinal=function(prop)
	msjFinal.prop=prop;
	dibujarMsjFinal();
end
msjFinal.initMsjFinal=initMsjFinal;

return msjFinal;