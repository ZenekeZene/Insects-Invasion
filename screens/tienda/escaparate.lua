local escaparate={};

local _WIDTH,_HEIGHT=display.contentWidth,display.contentHeight;
local AutoStore=require("dmc_autostore");
local data;

local capaPadre,capaArticulos,capaFondos,capaMensaje,capaSeleccionado,capaBtnComprar,lblBocadillo,timerMsj,capaMonedas,lblfondos;

local fondos;
local coleccion;

local ultimo_nivel_desb=6;
local seleccionado=0;
local lblUnidad=0;

local _DELAY_MSJ=10000;
local _DELAY_COMPRAR=5000;

local flagAnima=false;--HAY UN BUG [MEJORAR]

local mensajes=require("screens.tienda.mensajes");
local inventario=require("screens.tienda.inventario");
	
--AUMENTAR UNIDAD:
local aumentarUnidad=function(idTarget)
	local lblUnidad=lblUnidad;
	coleccion[idTarget].cant=coleccion[idTarget].cant+1;
	local seleccionado=seleccionado;
	lblUnidad.text=coleccion[idTarget].cant.."/"..coleccion[idTarget].max;
	transition.to(lblUnidad, {time = 500, xScale = 2, yScale = 2, onComplete = function()transition.to(lblUnidad, {time = 500, xScale=1, yScale=1});end});
end

--QUITAR FONDOS:
local quitarFondos=function(resta)

	--Efecto cant. de fondos:
	lblFondos.xScale,lblFondos.yScale=1,1;
	local selecId=seleccionado.id;
	transition.to(lblFondos,{time=500, xScale=2, yScale=2,onComplete=function()
		--Restamos de los fondos:
		if(fondos-resta>=0)then 
			fondos=fondos-resta;
			data.info.fondos=fondos;
			lblFondos.text=fondos;
			--Aumentamos en uno el articulo comprado:
			aumentarUnidad(selecId);
		end
		transition.to(lblFondos,{time=500, xScale=1,yScale=1,onComplete=function()flagAnima=false;end});
	end});

	--Efecto monedas:
	local xx,yy=seleccionado.xx,seleccionado.yy;
	transition.to(capaMonedas,{time=500, x=xx,y=yy,xScale=2,yScale=2,alpha=0,onComplete=function()capaMonedas.x,capaMonedas.y,capaMonedas.alpha,capaMonedas.xScale,capaMonedas.yScale=350,20,1,1,1;end});
end

--CAMBIAR MENSAJE:
local cambiarMensaje=function(categoria)
	local categoria=categoria;
	timer.cancel(timerMsj);
	timerMsj=timer.performWithDelay(1, function()lblBocadillo.text=mensajes.getMensaje(categoria);timerMsj=timer.performWithDelay(_DELAY_MSJ,function()lblBocadillo.text=mensajes.getMensaje("enun");end,0);end, 1);
end

--COMPRAR (manejador ev. touch del boton de compra):
local comprar=function(event)
	local phase=event.phase;
	local target=event.target;

	if("began"==phase)then
		if(seleccionado~=nil and flagAnima==false)then
			flagAnima=true;
			
			if(seleccionado.cant<seleccionado.max)then
				--Si nos queda pasta:
				if(fondos>=seleccionado.precio)then
					--Efecto boton de compra:
					transition.to(capaBtnComprar,{time=100,xScale=1.5,yScale=1.5,onComplete=function()transition.to(capaBtnComprar, {time=500,xScale=1,yScale=1});end});
					
					cambiarMensaje("afi");
					--quitarPasta:
					quitarFondos(seleccionado.precio);
				--Si no nos queda pasta:
				else
					cambiarMensaje("neg");
				end
			else
				cambiarMensaje("max");
			end
		end
	end
	return true;
end

--ELEGIR (manejador ev. touch en cada articulo):
local elegir=function(event)
	local phase=event.phase;
	local target=event.target;

	data=AutoStore.data;
	coleccion=data.coleccion;
	if("began"==phase)then
		flagAnima=false;

		if(target.desb)then

			local xx,yy=target:contentToLocal(0,0);
			xx,yy=math.abs(xx),math.abs(yy);
			print("COORD XX: "..xx..", YY: "..yy);

			if(seleccionado==0 or seleccionado.id~=target.id)then
				print(coleccion[target.id].nombre);
				seleccionado=coleccion[target.id];
				seleccionado.xx,seleccionado.yy=xx,yy;
				lblUnidad=target.lblUnidad;
				transition.to(capaSeleccionado, {time = 100, alpha = 0, onComplete=function()
					transition.to(capaSeleccionado, {time = 100, alpha = 1, x = xx-170-5, y = yy-60-5, onComplete=function()
						transition.to(capaBtnComprar, {time=100, alpha = 0, x = xx+30, y = yy+70, xScale = 0.5, yScale = 0.5, onComplete=function()
							transition.to(capaBtnComprar, {time=100, alpha = 1, x = xx+30, y = yy+70, xScale = 1, yScale = 1 ,onComplete=function()end});
						end});
					end});
				end});
			end
		else
			cambiarMensaje("desb");
		end

		if(target.prox)then
			cambiarMensaje("prox");
		end
	end
	return true;
end

--DIBUJAR TIENDA (Creamos todos los elementos en juego):
local dibujar=function( capaPadre )

	data=AutoStore.data;
	coleccion=data.coleccion;
	--print("OYE "..coleccion[1].nombre);

	--CAPA CONTENEDORA PADRE:
	capaPadre=capaPadre;
	capaPadre.width,capaPadre.height=_WIDTH,_HEIGHT;
	local capaPadreFondo=display.newRect(capaPadre,0,0,570,380);
	capaPadreFondo.x,capaPadreFondo.y=display.contentWidth/2,display.contentHeight/2;
	capaPadreFondo:setFillColor(100, 100, 100);

	--CAPA ARMARIO:
	capaArticulos=display.newGroup();
	capaPadre:insert(capaArticulos);
	capaArticulos.x,capaArticulos.y=170,60;
	local capaArticulosFondo=display.newRect(capaArticulos,0,0,300,250);
	capaArticulosFondo:setFillColor(23, 34, 34);

	--CAPA SELECCIONADO:
	capaSeleccionado=display.newGroup();
	capaSeleccionado.x,capaSeleccionado.y=0,0;capaSeleccionado.width,capaSeleccionado.height=80,80;
	capaArticulos:insert(capaSeleccionado);
	local capaSeleccionadoFondo=display.newRect(capaSeleccionado,0,0,90,80);
	capaSeleccionadoFondo:setFillColor(240,240,0);
	capaSeleccionado.alpha=0;
	capaSeleccionado:setReferencePoint(display.TopLeftReferencePoint);

	local k=0;
	--Estanterias:
	for i=1,3 do

		local capaEstante=display.newGroup();
		capaEstante.x,capaEstante.y=10,10;
		local capaEstanteFondo=display.newRect(capaEstante,0,-80+(i*80),280,10);
		capaEstanteFondo:setFillColor(50, 10, 50);
		capaArticulos:insert(capaEstante);
		
		for j=1,3 do

			local capaArticulo=display.newGroup();
			capaArticulo.id=k;

			capaArticulo.width,capaArticulo.height=80,50;capaArticulo.x,capaArticulo.y=-85+(85*j),-80+(i*80);

			local capaArticuloFondo=display.newRect(capaArticulo,0,0,80,70);
			capaArticuloFondo:setFillColor(200, 100, 100);

			--local capaImagen=dis...
			capaArticulo:toFront();
			
			capaEstante:insert(capaArticulo);
			--Si existe el articulo:
			if(coleccion[k])then
				capaArticulo.nombre=coleccion[k].nombre;

				if(coleccion[k].nivel_desb<=ultimo_nivel_desb)then
					capaArticulo.desb=true;
					local capaPrecio=display.newGroup();
					local capaPrecioFondo=display.newRect(capaPrecio,0,55,80,15);
					capaPrecioFondo:setFillColor(100, 0, 0,100);
					capaArticulo:insert(capaPrecio);

					local lblPrecio=display.newText(capaPrecio,coleccion[k].precio.." €",20,55,"Helvetica",15);

					local capaUnidad=display.newGroup();
					capaUnidad.x,capaUnidad.y=65,0;
					local capaUnidadFondo=display.newRect(capaUnidad,0,0,20,12);
					capaUnidadFondo:setFillColor(10, 10, 10, 30);
					capaArticulo.lblUnidad=display.newText(capaUnidad,coleccion[k].cant.."/"..coleccion[k].max,0,0,"Helvetica",10);
					capaArticulo:insert(capaUnidad);
				else
					local lblBlock=display.newText(capaArticulo,"Desb. en \nnivel "..coleccion[k].nivel_desb,0,0,"Helvetica",15);
				end
			else
				local lblNoStock=display.newText(capaArticulo,"Proximamente",0,0,"Helvetica",12);
				lblNoStock:rotate(30);
				lblNoStock.y=30;
				capaArticulo.prox=true;
			end		
			capaArticulo:addEventListener("touch", elegir);

			k=k+1;

		end
	end

	--CAPA FONDOS:
	capaFondos=display.newGroup();
	capaPadre:insert(capaFondos);
	capaFondos.x,capaFondos.y=350,0;
	local capaFondosFondo=display.newRect(capaFondos,0,0,100,50);
	lblFondos=display.newText(capaFondos,fondos, 30, 0, "Helvetica",25);
	lblFondos:setTextColor(34, 50, 60);

	--CAPA DESCRIPCION:
	local capaDescripcion=display.newGroup();
	capaPadre:insert(capaDescripcion);
	capaDescripcion.x,capaDescripcion.y=0,25;capaDescripcion.width,capaDescripcion.height=100,300;

	local capaDescripcionFondo=display.newRect(capaDescripcion,0,0,150,280);
	capaDescripcionFondo:setFillColor(120, 120, 120);

	--Capa bocadillo:
	local capaBocadillo=display.newGroup();
	capaDescripcion:insert(capaBocadillo);
	capaBocadillo.x,capaBocadillo.y=17,-10;capaBocadillo.width,capaBocadillo.height=150,150;

	local capaBocadilloFondo=display.newRect(capaBocadillo,0,0,150,100);
	local msjIni=mensajes.getMensaje("ini");
	lblBocadillo=display.newText(capaBocadillo,msjIni,40,40,"Helvetica",10);
	lblBocadillo:setTextColor(0, 0, 100);
	--Cmambiamos el mensaje cada X tiempo:
	timerMsj=timer.performWithDelay(_DELAY_MSJ, function()lblBocadillo.text=mensajes.getMensaje("enun");end, 0);

	--CAPA BOTON COMPRAR:
	capaBtnComprar=display.newGroup();
	capaBtnComprar.width,capaBtnComprar.height=100,100;
	
	capaBtnComprar.x,capaBtnComprar.y=50,150;
	local capaBtnComprarFondo=display.newRect(capaBtnComprar,0,0,100,20);
	capaBtnComprarFondo:setFillColor(0, 0, 100);
	capaBtnComprarFondo:setReferencePoint(display.CenterLeftReferencePoint);
	capaBtnComprarFondo.xOrigin,capaBtnComprarFondo.yOrigin=10,10;
	
	local lblBtnComprar=display.newText(capaBtnComprar,"Comprar",-20,0,"Helvetica",15);
	capaBtnComprar.alpha=0;
	capaPadre:insert(capaBtnComprar);

	capaBtnComprar:addEventListener("touch", comprar);

	--CAPA SALIR:
	--[[local capaSalir=display.newGroup();
	capaSalir.width,capaSalir.height=50,50;
	capaSalir.x,capaSalir.y=0,0;

	local capaSalirFondo=display.newRect(capaSalir,0,0,50,25);
	capaSalirFondo:setFillColor(0, 0, 10);]]

	--capaSalirFondo:addEventListener("touch", salir);--AL SALIR DEBEMOS GUARDAR LOS lblUnidad de los capaArticulos en su respectivo articulo en la coleccion:

	--MENSAJE DE CONFIRMACION:
	capaMensaje=display.newGroup();
	capaMensaje.width,capaMensaje.height=100,100;capaMensaje.x,capaMensaje.y=_WIDTH/2-150,-195;
	local capaMensajeFondo=display.newRect(capaMensaje,0,0,300,200);
	capaMensajeFondo:setFillColor(0, 140, 140);
	capaPadre:insert(capaMensaje);

	--MONEDAS:
	capaMonedas=display.newGroup();
	capaMonedas.width,capaMonedas.height=80,30;capaMonedas.x,capaMonedas.y=320,20;
	local capaMonedasFondo=display.newRect(capaMonedas,0,0,30,30);
	capaMonedasFondo:setFillColor(100, 150, 0);
	capaPadre:insert(capaMonedas);
end

--INIT:
local initEscaparate=function( capaPadre )

	inventario.cargarColeccion();
	data=AutoStore.data;
	fondos=data.info.fondos;

	dibujar( capaPadre );
end
escaparate.initEscaparate=initEscaparate;

return escaparate;