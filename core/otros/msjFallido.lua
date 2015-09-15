local msjFallido={};

local _ANCH,_ALT=250,290;
local _CAD_SALIR=1000;
local _VEL=100;

local _TAM_BTN=20;

--EFECTO SACAR:
local sacar=function()
	estado="FALLIDO";
	local idNivel=msjFallido.nivel;
	print("Sacamos mensaje final FALLIDO !!!!");
	msjFallido.xScale,msjFallido.yScale=0.5,0.5;
	timer.performWithDelay(
		_CAD_SALIR, 
		function() 
			transition.to(msjFallido.capaMsjFallido,{time=_VEL,y=0,alpha=1,xScale=1,yScale=1,onComplete=function()end});
		end, 
		1);
end
msjFallido.sacar=sacar;

--MANEJADORES DE LOS 2 BOTONES:
local manejarReiniciar=function(event)
	msjFallido.reiniciar();
	msjFallido.capaMsjFallido.alpha=0;
end

local manejarEleccion=function(event)
	msjFallido.irEleccion();
	msjFallido.capaMsjFallido.alpha=0;
end

--DIBUJAR MSJ FINAL:
local dibujarMsjFallido=function()
	local prop=msjFallido.prop;

	local capaMsjFallido=display.newGroup();
	capaMsjFallido.width,capaMsjFallido.height=_ANCH,_ALT;
	capaMsjFallido.x,capaMsjFallido.y=(prop._WIDTH/2)-(_ANCH/2),0;

	local fondoGris=display.newRect(capaMsjFallido,-(prop._WIDTH/2),-100,prop._WIDTH*2,prop._HEIGHT*2);
	fondoGris:setFillColor(240, 0, 0, 150);
	--fondoGris.alpha=0;

	local fondo=display.newRect(capaMsjFallido,0,0,_ANCH,_ALT+100);
	fondo:setFillColor(100, 100, 100);

	local capaMsj=display.newGroup();
	local fondoMsj=display.newRect(capaMsj,0,0,_ANCH,40);
	fondoMsj:setFillColor(130,100, 100);
	local msj=display.newText(capaMsj,"¡NIVEL FRACASADO!",0,0,"Helvetica",20);
	capaMsjFallido:insert(capaMsj);

	--Crear hijos botones (reanudar,eleccion de niveles, tienda)

	local btnReiniciar=display.newCircle(capaMsjFallido,80,120,_TAM_BTN);
	btnReiniciar:setFillColor(50, 60, 80);
	btnReiniciar:addEventListener("tap", manejarReiniciar);

	local btnEleccion=display.newCircle(capaMsjFallido,80,180,_TAM_BTN);
	btnEleccion:setFillColor(50,60,80);
	btnEleccion:addEventListener("tap", manejarEleccion);

	capaMsjFallido.alpha=0;
	msjFallido.capaMsjFallido=capaMsjFallido;
end
msjFallido.dibujarMsjFallido=dibujarMsjFallido;

--SET METODOS GEAR:
local setMetodosGear=function(nivel,reiniciar,irEleccion)
	msjFallido.nivel=nivel;
	msjFallido.reiniciar=reiniciar;
	msjFallido.irEleccion=irEleccion;
end
msjFallido.setMetodosGear=setMetodosGear;

--INIT:
local initMsjFallido=function(prop)
	msjFallido.prop=prop;
	dibujarMsjFallido();
end
msjFallido.initMsjFallido=initMsjFallido;

return msjFallido;