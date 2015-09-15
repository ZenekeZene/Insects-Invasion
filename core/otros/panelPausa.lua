local panelPausa={};
storyboard=require("storyboard");

local _ANCH=130;
local _DESF_W,_DESF_H=70,70;
local _XX_BTN=70;
local _WIDTH_FONDO_GRIS;
local _DESF_H_FONDO=100;
local _VEL_ANIM=100;
local _VEL_ANIM_FONDO=500;

--SACAR:
local sacar=function()
	local xx=panelPausa.capaPanelPausa.x+_ANCH+25;
	panelPausa.fondoGris.width=_WIDTH_FONDO_GRIS;
	transition.to(panelPausa.fondoGris, {time = _VEL_ANIM_FONDO, alpha=0.5, onComplete = function()end});
	transition.to(panelPausa.capaPanelPausa, {time = _VEL_ANIM, x = xx, onComplete = function()end})
	
end
panelPausa.sacar=sacar;

--METER:
local meter=function()
	panelPausa.fondoGris.width=_WIDTH_FONDO_GRIS+345;
	transition.to(panelPausa.fondoGris, {time = _VEL_ANIM_FONDO, alpha=0, onComplete = function()end});			--aqui falta la llamada a reanudar, pero, al dar al boto de ir a eleccion, tb pasa por reanudar...
	transition.to(panelPausa.capaPanelPausa,{time = _VEL_ANIM, x = -_ANCH-_DESF_W, onComplete = function()panelPausa.reanudar();end});
end

--MANEJAR REANUDAR:
local manejarReanudar=function(event)
	meter();
	return true;
end

--MANEJAR REINICIAR:
local manejarReiniciar=function(event)
	panelPausa.reiniciar();
	
	return true;
end

--MANEJAR IR A ELECCION:
local manejarEleccion=function(event)

	--panelPausa.eliminar();
	panelPausa.irEleccion();

	return true;
end

--MANEJAR IR TIENDA:
local manejarTienda=function(event)

	panelPausa.irTienda();
	return true;
end

--DIBUJAR PANEL:
local dibujarPanelPausa=function(prop,capaUI)
	local prop=prop;
	local capaUI=capaUI;
	--capa:
	local capaPanelPausa=display.newGroup();
	capaPanelPausa.width,capaPanelPausa.height=_ANCH,prop._HEIGHT;
	capaPanelPausa.x,capaPanelPausa.y=-_ANCH-_DESF_W,-20;
	capaUI:insert(capaPanelPausa);
	--fondo:
	local fondo=display.newRect(capaPanelPausa,0,0,_ANCH,prop._HEIGHT+_DESF_H);
	fondo:setFillColor(0, 0, 0);
	fondo.alpha=0.9;

	local lblNivel=display.newText(capaPanelPausa, " ", 50, 0, "Helvetica", 15);
	lblNivel:setTextColor(255, 255, 255);
	lblNivel:setReferencePoint(display.CenterLeftReferencePoint);

	local fondoGris=display.newRect(capaUI,_ANCH-50,0,prop._WIDTH,prop._HEIGHT+_DESF_H_FONDO);
	fondoGris:setFillColor(60, 60, 60);
	fondoGris.alpha=0;
	fondoGris:setReferencePoint(display.CenterLeftReferencePoint);
	panelPausa.fondoGris=fondoGris;
	
	--Crear hijos botones (reanudar,eleccion de niveles, tienda)

	local btnReanudar=display.newCircle(capaPanelPausa,55,40,20);
	btnReanudar:setFillColor(50, 60, 80);
	btnReanudar:addEventListener("tap", manejarReanudar);

	local btnReiniciar=display.newCircle(capaPanelPausa,_XX_BTN,150,20);
	btnReiniciar:setFillColor(50, 60, 80);
	btnReiniciar:addEventListener("tap", manejarReiniciar);

	local btnEleccion=display.newCircle(capaPanelPausa,_XX_BTN,210,20);
	btnEleccion:setFillColor(50,60,80);
	btnEleccion:addEventListener("tap", manejarEleccion);

	local btnTienda=display.newCircle(capaPanelPausa,_XX_BTN,270,20);
	btnTienda:setFillColor(10, 60, 80);
	btnTienda:addEventListener("tap", manejarTienda);

	--Hacer publico:
	panelPausa.capaPanelPausa=capaPanelPausa;
	panelPausa.lblNivel=lblNivel;
end

--SET NIVEL:
local setNivel=function(nivel,reanudar,reiniciar,eliminar,irEleccion,irTienda)
	
	panelPausa.nivel=nivel;
	panelPausa.lblNivel.text="1 - "..nivel;--  Ej: 1 - 1
	
	--Asociamos los metodos:
	panelPausa.reanudar=reanudar;
	panelPausa.reiniciar=reiniciar;
	panelPausa.eliminar=eliminar;
	panelPausa.irEleccion=irEleccion;
	panelPausa.irTienda=irTienda;
end
panelPausa.setNivel=setNivel;

--INIT:
local initPanelPausa=function(prop,capaUI)
	_WIDTH_FONDO_GRIS=prop._WIDTH;
	dibujarPanelPausa(prop,capaUI);
end
panelPausa.initPanelPausa=initPanelPausa;

return panelPausa;