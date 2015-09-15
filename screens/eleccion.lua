local AutoStore=require("dmc_autostore");
local storyboard = require( "storyboard" );
local paginado = require("screens.eleccion.paginado");
local cHordas=require("levels.hordas");

local scnEleccion = storyboard.newScene();

local paginas={};
local _CAD_GOTO_LIENZO=100;--pequeña cadencia o tiempo que tardamos en irnos a lienzo. Ojo, que no sea mayor que el _VEL usado en paginado para las transiciones visuales de las paginas

--	NOTE:
--	El codigo ejecutado fuera de los listeners solo será ejecutado una vez, a no ser que llamemos a removeScene().

--SALIR A PRINCIPAL:
local irPrincipal=function( event )

	storyboard.gotoScene("screens.principal");--Vamos a tienda
	storyboard.purgeScene("screens.eleccion");--purgamos esta pantalla
	storyboard.removeScene("screens.eleccion");

	return true;
end

--IR TIENDA:
local irTienda=function( event )
	
	storyboard.removeScene("screens.tienda");
	storyboard.gotoScene("screens.tienda");--Vamos a tienda
	storyboard.purgeScene("screens.eleccion");--purgamos esta pantalla
	storyboard.removeScene("screens.eleccion");

	return true;
end

--EMPEZAR GAMEPLAY:
local empezarGameplay=function(event)

	local phase=event.phase;
	local target=event.target;

	if(target.estado=="desbloqueado")then--Si el nivel tocado esta desbloqueado...

		local nivel=cHordas.buscarNivel(target.nivel);

		local id=nivel.id;
		local ejercito=nivel.ejercito;
		local mensajes=nivel.mensajes;

		print("NIVEL DE "..id);
		print("TAMANIAO HORDA:"..#ejercito);
		local params={};

		if(#nivel~=nil)then--Si tiene nivel asociado...
			
			if(mensajes~=nil)then
				params= { id = id, ejercito = ejercito, mensajes = mensajes }
			else
				print("No hay mensajes para este nivel");
				params= { id = id, ejercito = ejercito }
			end
			local options =
				{
				    effect = "slideLeft",
				    time = 200,
				    params = params
				}
			timer.performWithDelay(
				_CAD_GOTO_LIENZO, 
				function()
					storyboard.gotoScene("screens.lienzo",options);--purgamos esta pantalla
					storyboard.purgeScene("screens.eleccion");--Vamos a lienzo (pasamos la horda como parametro)
					storyboard.removeScene("screens.eleccion");
				end,
			1);
		end
	else
		print("Nivel "..target.nivel.." bloqueado.");
	end
end
 
-- Llamada cuando la vista de scnEleccion no exista:
function scnEleccion:createScene( event )
	local group = self.view
	print("CREATE SCENE Eleccion.");
	
	-- Crea Display Objects y añadelos al "grupo" principal.	
	-- Example use-case: Restore 'group' from previously saved state.
	
end

-- Llamada inmediatamente despues de que scnEleccion haya sido movido a la pantalla:
function scnEleccion:enterScene( event )

	local group = self.view;
	print("ENTER SCENE Eleccion.");
	--estado="ELECCION";
	
	paginado.initPaginado(group);
	--Reseteamos:
	for i=0,#paginas do
		paginas[i]=nil;
	end

	--Pedimos:
	paginas=paginado.getPaginas();
	--collectgarbage();

	--ASociamos Listeners:
	for i=1,#paginas do
		for j=1,#paginas[i].niveles do
			paginas[i].niveles[j]:addEventListener("tap", empezarGameplay);
		end
	end

	--Boton para ir a la Tienda en Eleccion:
	local btnTienda=display.newImageRect(group, "media/btnTiendaEleccion.png",30,30);
	btnTienda.x,btnTienda.y=460,270;
	btnTienda.xScale,btnTienda.yScale=1.5,1.5;
	--local btnTienda=display.newRect(group, 430,250,40,40);
	--btnTienda:setFillColor(60,60,60);
	btnTienda:addEventListener("tap", irTienda);

	--Boton para salir a Principal:
	local btnPrincipal=display.newImageRect(group, "media/btnSalirEleccion.png",30,30);
	btnPrincipal.x,btnPrincipal.y=20,270;
	btnPrincipal:addEventListener("tap", irPrincipal);
	btnPrincipal.xScale,btnPrincipal.yScale=1.5,1.5;
	--local btnPrincipal=display.newCircle(group, 20, 270, 20);
	

	--Si nos llegan parametros:
	if(event.params)then
		--Parametro de reiniciar:
		if(event.params.reiniciar==true)then
			if(event.params.desdeMsjFinal)then
				--Llegamos a Eleccion desde msjFInal. Es decir, nos hemos pasaado el nivel de lienzo,
				--hemos decidido volver a Eleccion pero hay que desbloquear el nivel siguiente:
				--Desbloqueo de nivel:
				local data=AutoStore.data;
				local nivelOld=event.params.nivelOld;
				local idSig=nivelOld+1;
				for i=1,data.niveles:len()do
					if(data.niveles[idSig]==nil)then--Si esta desbloqueado (no existe en data.niveles)
						print("HAY QUE DESBLOQUEAR EL SIGUIENTE "..idSig);
						data.niveles[idSig]={
							superado=0,--0: no , 1: si
	                        puntuacion=0,
	                        contJugado=0,
	                        contReiniciar=0,
	                        };
					end
				end
			end
				
			print("si params en eleccion enterScene");
			if(event.params.reiniciar)then
				print("Reiniciar == true");
				local options =
					{
					    effect = "slideUp",
					    time = 200,
					}
				storyboard.gotoScene("screens.lienzo",options);
			else
				print("Reiniciar == false ");
				local options =
					{
					    effect = "slideUp",
					    time = 200,
					}
				storyboard.gotoScene("screens.lienzo",options);
			end
		elseif(event.params.reiniciar==false)then
			if(event.params.irSiguiente)then
				
				local nivelOld=event.params.nivelOld;
				print("OK, vamos pa alla. Estmos en "..nivelOld.." y vamos hacia "..(nivelOld+1));
				--Habria que comprobar que lo tenemos. Si estaba bloqueado lo desbloqueamos:
				local nivel=cHordas.buscarNivel(nivelOld+1);

				--if(nivel~=0)then
					local id=nivel.id;
					local ejercito=nivel.ejercito;--devuelve ejercito del diccionario hordas.lua segun su nivel
					local mensajes=nivel.mensajes;

					local params={};
					if(mensajes~=nil)then
						params= { id = id, ejercito = ejercito, mensajes = mensajes }
					else
						print("No hay mensajes para este nivel");
						params= { id = id, ejercito = ejercito }
					end

					local options =
						{
						    effect = "slideUp",
						    time = 200,
						    params = params
						}
					storyboard.gotoScene("screens.lienzo",options);
				--end
			else
				if(event.params.desdeMsjFinal)then
					--Llegamos a Eleccion desde msjFInal. Es decir, nos hemos pasaado el nivel de lienzo,
					--hemos decidido volver a Eleccion pero hay que desbloquear el nivel siguiente:
					--Desbloqueo de nivel:
					local data=AutoStore.data;
					local nivelOld=event.params.nivelOld;
					local idSig=nivelOld+1;
					for i=1,data.niveles:len()do
						if(data.niveles[idSig]==nil)then--Si esta desbloqueado (no existe en data.niveles)
							print("HAY QUE DESBLOQUEAR EL SIGUIENTE "..idSig);
							data.niveles[idSig]={
								superado=0,--0: no , 1: si
		                        puntuacion=0,
		                        contJugado=0,
		                        contReiniciar=0,
		                        };
						end
					end
				end
			end
		end
	end
	--Desbloqueamos los niveles que se han pasado/jugado a traves de lienzo:
		print("DESBLOQUEAMOS");
		local data=AutoStore.data;
		for i=1,#paginas do
			for j=1,#paginas[i].niveles do
				local id=paginas[i].niveles[j].nivel;
				if(data.niveles[id]~=nil)then--si lo hemos desbloqueado desde lienzo (añadido a data.niveles)
					paginado.cCajasNiveles.quitarCandado(paginas[i].niveles[j]);
				end
			end
		end
end

-- Llamada cuando scnEleccion se haya movido fuera de pantalla:
function scnEleccion:exitScene( event )
	local group = self.view
	print("EXIT SCENE Eleccion.");

	for i=0,#paginas do
		paginas[i]=nil;
	end
	
	paginas=paginado.getPaginas();

	for i=1,#paginas do
		for j=1,#paginas[i].niveles do
			paginas[i].niveles[j]:removeEventListener("tap", empezarGameplay);
		end
	end
	-- (e.g. stop timers, remove listeners, unload sounds, etc.)	
end

-- Llamada antes de la eliminación de la "view" de scnEleccion:
function scnEleccion:destroyScene( event )
	local group = self.view;
	print("DESTROY SCENE Eleccion.");
	
	-- (e.g. remove listeners, widgets, save state, etc.)
end

-- Disparado si la vista de scnEleccion no existe:
scnEleccion:addEventListener( "createScene", scnEleccion );

-- Disparado cuando la transicion de scnEleccion ha finalizado:
scnEleccion:addEventListener( "enterScene", scnEleccion );

-- Disparado antes de que la transicion empiece:
scnEleccion:addEventListener( "exitScene", scnEleccion );

--Disparado antes de que la "view" sea descargada en memoria 
--(esto puede ser automaticamente en situaciones de poca memoria ó manualmente con purgeScene() y removeScene())
scnEleccion:addEventListener( "destroyScene", scnEleccion );

---------------------------------------------------------------------------------

return scnEleccion;
