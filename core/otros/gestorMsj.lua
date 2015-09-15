local gestorMsj={};

local _ANCH=300;
local _ALT=200;
local _DESF_H=50;
local _VEL=100;
local _POSX_TIT=0;
local _POSY_TIT=150;
local _ANCH_TIT,_ALT_TIT=190,35;
local _MARGIN_LEFT,_MARGIN_BOTTOM=0,-50;
local _POSX_DESC,_POSY_DESC=80,190;
local _TAM_FONT_TIT,_TAM_FONT_DESC=35,20;
local index=1;

--Sacar:
local function sacar(descripcion)

	if(estado~="FINALIZADO")then
		print("SACAMOS MENSAJE AUNQUE ESTEMOS EN FALLIDO ("..estado..") CLARO QUE SI");
		gestorMsj.lblDescripcion.text=descripcion;
		transition.to(gestorMsj.capaPanelMensaje, {time = _VEL, y = gestorMsj.prop._HEIGHT/2-(_ALT/2), onComplete = function()end});
	end
end

--Meter:
local function meter()
	transition.to(
		gestorMsj.capaPanelMensaje,
		{
			time = _VEL,
			y = -_ALT-_DESF_H, 
			onComplete = function()
				if(index<#gestorMsj.mensajes)then 
					index=index+1;
					gestorMsj.tnt:newTimer(
						gestorMsj.mensajes[index].mom,
						function()
							sacar(gestorMsj.mensajes[index].desc);
							gestorMsj.pausar();
						end,
						1
					);
				end;
			end
		}
	);
end

--ARRANCAR GESTOR:
local arrancarGestor=function(mensajes)
	gestorMsj.mensajes=mensajes;
	index=1;
	
	if(#mensajes>0)then
		local timer1=gestorMsj.tnt:newTimer(mensajes[index].mom,function()sacar(mensajes[index].desc);gestorMsj.pausar();end,1)
	end
end
gestorMsj.arrancarGestor=arrancarGestor;

--Draw:
local drawPanelMsj=function()
	--Capa principal:
	local capaPanelMensaje=display.newGroup();
	capaPanelMensaje.width,capaPanelMensaje.height=_ANCH,_ALT;
	capaPanelMensaje.x,capaPanelMensaje.y=gestorMsj.prop._WIDTH/2-(_ANCH/2),-_ALT-_DESF_H;
	--Fondo capa principal:
	local fondo=display.newRect(capaPanelMensaje,0,0,_ANCH,_ALT);
	fondo:setFillColor(200, 100, 100);
	--capa para la imagen (hija):
	local capaImagen=display.newGroup();
	capaImagen.width,capaImagen.height=_ANCH,150;
	capaPanelMensaje:insert(capaImagen);

	--Capa para el titulo (hija):
	--[[local capaTitulo=display.newGroup();
	capaTitulo.width,capaTitulo.height=_ANCH,40;
	capaTitulo.x,capaTitulo.y=_POSX_TIT,_POSY_TIT;

	local fondoTitulo=display.newRect(capaTitulo,_MARGIN_LEFT,_MARGIN_BOTTOM,0,,-50_ANCH_TIT,_ALT_TIT);
	fondoTitulo:setFillColor(12, 134, 45);
	fondoTitulo.alpha=0.9;

	local lblTitulo=display.newText(capaTitulo,"TITULO", _MARGIN_LEFT,_MARGIN_BOTTOM, 0,-50, "Helvetica",_TAM_FONT_TIT);
	lblTitulo:setTextColor(0, 0, 0);

	capaPanelMensaje:insert(capaTitulo);]]

	--Capa para la descripcion (hija):
	local capaDescripcion=display.newGroup();
	capaDescripcion.width,capaDescripcion.height=_ANCH,60;
	capaDescripcion.x,capaDescripcion.y=_POSX_DESC,_POSY_DESC;

	local lblDescripcion=display.newText(capaDescripcion,"",_MARGIN_LEFT,_MARGIN_BOTTOM,"Helvetica", _TAM_FONT_DESC);
	lblDescripcion:setReferencePoint(display.BottomLeftReferencePoint);

	capaPanelMensaje:insert(capaDescripcion);

	--Capa para la X de cerrar (hija):
	local capaCerrar=display.newGroup();
	capaCerrar.width,capaCerrar.height=80,80;
	capaCerrar.x,capaCerrar.y=_ANCH,0;

	local fondoCerrar=display.newCircle(capaCerrar,0,0,30);
	fondoCerrar:setFillColor(0, 0, 124, 34);

	local btnCerrar=display.newCircle(capaCerrar,0,0,20);
	btnCerrar:setFillColor(240, 0, 0);
	--btnCerrar:addEventListener("tap", meter);
	btnCerrar:addEventListener("tap", function()meter();gestorMsj.reanudar();end);

	capaPanelMensaje:insert(capaCerrar);

	-------
	gestorMsj.capa:insert(capaPanelMensaje);
	gestorMsj.capaPanelMensaje=capaPanelMensaje;

	gestorMsj.lblDescripcion=lblDescripcion;--hacemos publico para acceder en "sacar".
	
end

--Init:
local initGestorMsj=function(prop,capa,reanudar,pausar,tnt)

	gestorMsj.prop=prop;
	gestorMsj.capa=capa;
	gestorMsj.reanudar=reanudar;
	gestorMsj.pausar=pausar;

	gestorMsj.tnt=tnt;

	gestorMsj.mensajes={};

	drawPanelMsj();
end
gestorMsj.initGestorMsj=initGestorMsj;

return gestorMsj;