local cUI={};
--print("CARGAMOS UI");

local AutoStore=require("dmc_autostore");
local data;

local inter_mensajes=false;--Interruptor de mensajes (UI se encarga de gestionarlos). Para no enseñar 2 dos a la vez o que se solapen.
local index_mensajes=1;

--PUNTOS:
local initPuntos=function()
	--print("1.-Cargamos puntos");
	local capaUI=cUI.capaUI;--Para todo el objeto?
	local prop=cUI.prop;

	local objPuntos={};

	--fondo:
	objPuntos.fondoPuntos=display.newRect(capaUI,prop._WIDTH-50,prop._HEIGHT-30,30,30);
	objPuntos.fondoPuntos:setFillColor(50,0, 255);
	objPuntos.fondoPuntos.alpha=0.7;
	--texto:
	objPuntos.txtPuntos=display.newText(capaUI,prop.puntos,prop._WIDTH-40,prop._HEIGHT-30,"Helvetica",20);
	objPuntos.txtPuntos:setTextColor(100,255,255);
	--objPuntos.txtPuntos:rotate(90);

	return objPuntos;
end
cUI.initPuntos=initPuntos;

--COMBOS: AHORA TIENE SU PROPIO MODULO CON SU INIT, SU DRAW Y SUS METODOS PUBLICOS PARA AUMENTAR/REINICIAR
--[[local initCombos=function()...]]

--PANEL:
local initPanel=function()
	--print("3.-Cargamos panel");
	local capaUI=cUI.capaUI;
	local prop=cUI.prop;

	local objPanel={};
	objPanel.capaPanel=display.newGroup();
	capaUI:insert(objPanel.capaPanel);

	objPanel.fondoPanel=display.newRect(objPanel.capaPanel,-45,0,570,15);
	objPanel.fondoPanel:setFillColor(123,123,123);
	objPanel.fondoPanel.alpha=0.5;

	--FALTA

	return objPanel;

end
cUI.initPanel=initPanel;

--SACO:
local initSacoClorofila=function()
	--print("4.-Cargamos saco clorofilas");
	local capaUI=cUI.capaUI;
	local prop=cUI.prop;

	local objSaco={};
	objSaco.capa=display.newGroup();
	objSaco.fondo=display.newRect(objSaco.capa,0,0,40,20);
	objSaco.fondo:setFillColor(10, 240, 10);

	--Sacamos los fondos del usuario y los cargamos en su elemento de UI:
	data=AutoStore.data;
	local fondos=data.info.fondos;

	objSaco.texto=display.newText(objSaco.capa,fondos,30,0,"Helvetica",15);
	objSaco.capa.x,objSaco.capa.y=30,0;
	capaUI:insert(objSaco.capa);
	--objSaco.texto:rotate(90);
	return objSaco;
end

--MANEJAR PAUSA:
local function manejarPausa(event)
	if(event.phase=="ended")then
		if(estado=="NORMAL")then
			cUI.gear.pausar();
			cUI.objPanelPausa.sacar();
			event.target:removeEventListener("touch", manejarPausa);
		--elseif(estado=="PAUSA")then
			--cUI.gear.reanudar();
		end
	end
end
cUI.manejarPausa=manejarPausa;

--MANEJAR REINICIAR:
local manejarReiniciar=function(event)
	if(estado=="FINALIZADO_OK")then
		if("began"==event.phase)then
			cUI.objMsjF.capaMensaje.alpha=0;
			cUI.gear.reiniciar();
		end
	end
end	

--SET GEAR:
local setGear=function(gear)
	if(gear~=nil)then
		cUI.gear=gear;
	end
end
cUI.setGear=setGear;

--SET REINICIAR:
local setReiniciar=function()
	cUI.objMsjF.capaMensaje:addEventListener("touch", manejarReiniciar);
end
cUI.setReiniciar=setReiniciar;

--MENSAJE FALLIDO:
local initMsjFallido=function()
	
	local objMsjFallido=require("core.otros.msjFallido");
	objMsjFallido.initMsjFallido(cUI.prop);
	objMsjFallido.capaMsjFallido.alpha=0;
	return objMsjFallido;

end
cUI.initMsjFallido=initMsjFallido;

--BOTON PAUSA:
local initBtnPausa=function()
	--print("5.-Cargamos boton de pausa");
	--display.newRect( [parentGroup], left, top, width, height )
	local objBtnPausa=display.newRect(cUI.capaUI,0,0,25,25);
	objBtnPausa:setFillColor(164, 62, 62);
	objBtnPausa:addEventListener("touch", manejarPausa);
	return objBtnPausa;
end
cUI.initBtnPausa=initBtnPausa;

--SET NIVEL PAUSA (enlace entre GEAR y UI [ y este con panelPausa ]):
local setNivelPausa=function(nivel,reanudar,reiniciar,eliminar,irEleccion,irSiguiente,irTienda)
	--print("LLEGA A UI EL NIVEL "..nivel);
	local nivel=nivel;
	cUI.objPanelPausa.setNivel(nivel,reanudar,reiniciar,eliminar,irEleccion,irTienda);
	cUI.objMsjFinal.setMetodosGear(reiniciar,irEleccion,irSiguiente);--DAR IRTIENDA A ESTOS DOS PANELES TAMBIEN?
	cUI.objMsjFallido.setMetodosGear(nivel,reiniciar,irEleccion,irSiguiente);
end
cUI.setNivelPausa=setNivelPausa;

--PANEL PAUSA:
local initPanelPausa=function()
	local objPanelPausa=require("core.otros.panelPausa");
	objPanelPausa.initPanelPausa(cUI.prop,cUI.capaUI);
	return objPanelPausa;
end

local initPanelMensaje=function()
	local objPanelMensaje=require("core.otros.panelMensaje");
	objPanelMensaje.initPanelMensaje(cUI.prop,cUI.capaUI);
	objPanelMensaje.btnCerrar:addEventListener("tap", function()objPanelMensaje.meter();cUI.gear.reanudar();end);
	return objPanelMensaje;
end

--MENSAJE FINAL (ganado/perdido):
local initMsjFinal=function()
	local objMsjFinal=require("core.otros.msjFinal");
	objMsjFinal.initMsjFinal(cUI.prop);
	objMsjFinal.capaMsjFinal.alpha=0;
	return objMsjFinal;
end
cUI.initMsjFinal=initMsjFinal;

--INIT:
local initUI=function(prop,capa)
	cUI.prop=prop;
	cUI.capaUI=capa;

	cUI.objPuntos=initPuntos();
	cUI.objPanel=initPanel();
	cUI.objSaco=initSacoClorofila();
	cUI.objMsjFallido=initMsjFallido();
	cUI.objBtnPausa=initBtnPausa();
	cUI.objPanelPausa=initPanelPausa();
	cUI.objMsjFinal=initMsjFinal();
	--cUI.objPanelMensaje=initPanelMensaje();
end
cUI.initUI=initUI;

return cUI;