local AutoStore=require("dmc_autostore");
local storyboard = require( "storyboard" );
local scene = storyboard.newScene();
local core={};

local estado="INICIO";
----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------

--lblEstado=display.newText(display.getCurrentStage(),estado, 200, 330, "Helvetica", 30);
--lblEstado:setTextColor(230, 23, 23);

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	print("Se ha creado la escena del Gameplay");

	core=require("core.core");
	core.requireCore();
	core.initCore(group);
	--group.xScale,group.yScale=0.1,0.1;
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view;
	--group.xScale,group.yScale=0.5,0.5;
	--transition.to( group, { time=1500, xScale=1, yScale=1, onComplete=function()end } );

	print("Nos hemos metido dentro de la escena del Gameplay");

	local params=event.params;
	if(params~=nil)then
		print("vale llegan parametros");
		local ejercito=params.ejercito;
		mainInfo.ultimo_ejercito=ejercito;
		if(ejercito~=nil)then

			--Cacheamos:
			local id=params.id;
			mainInfo.ultimo_id=id;

			--Desbloqueo de nivel:
			local data=AutoStore.data;
			for i=1,data.niveles:len()do
				if(data.niveles[id]==nil)then--Si esta desbloqueado (no existe en data.niveles)
					data.niveles[id]={
						superado=0,--0: no , 1: si
                        puntuacion=0,
                        contJugado=0,
                        contReiniciar=0,
                        };
				end
			end
			local oldContJugado=data.niveles[id].contJugado;
			data.niveles[id].contJugado=oldContJugado+1;

			if(params.mensajes)then
				local mensajes=params.mensajes;
				mainInfo.ultimo_mensajes=mensajes;
				core.cGestorMsj.arrancarGestor(mensajes);
			end
			
			--EMPEZAMOS...
			core.gear.k=1;
			core.gear.setHorda(ejercito);--Cambiar este nombre...
			core.gear.setNivelPausa(id);
		end
	else
		print("CARGAMOS LO ANTERIOR");
		local id=mainInfo.ultimo_id;
		core.gear.k=1;
		print("ULTIMO EJERCITO ES "..#mainInfo.ultimo_ejercito);
		core.gear.setHorda(mainInfo.ultimo_ejercito);
		core.gear.setNivelPausa(mainInfo.ultimo_id);

		--Añadimos 1 al contReiniciar y contJugado del nivel:
		local data=AutoStore.data;
		local oldContJugado=data.niveles[id].contJugado;
		data.niveles[id].contJugado=oldContJugado+1;
		local oldContReiniciar=data.niveles[id].contReiniciar;
		data.niveles[id].contReiniciar=oldContReiniciar+1;
	end

	--Con este timer en el que nos vamos a "Eleccion" y nos purgamos lienzo, podremos comprobar si salimos bien de este (eliminar Disp.Obj, quitar listeners, resetear puntos, etc)
	--timer.performWithDelay(5000, function()storyboard.gotoScene("screens.eleccion");storyboard.purgeScene("screens.lienzo");end, 1);
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	print("Hemos salido de la escena Gameplay");
	
	--core.gear.eliminar();

	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
end

-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	print("Se ha destruido la escena Gameplay");
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
end

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene );

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene );

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene );

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene );

---------------------------------------------------------------------------------

return scene;