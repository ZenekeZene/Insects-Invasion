--local AutoStore=require("dmc_autostore");
local escaparate = require("screens.tienda.escaparate");
local storyboard = require( "storyboard" );

local scnTienda = storyboard.newScene();

local salir=function(event)
	local phase=event.phase;

	if("began"==phase)then
		estado="ELECCION";
        storyboard.removeScene("screens.eleccion");
        storyboard.gotoScene("screens.eleccion");
        storyboard.purgeScene("screens.tienda");
        storyboard.removeScene("screens.tienda");
        collectgarbage();
	end
	return true;
end

-- Llamada cuando la vista de scnEleccion no exista:
function scnTienda:createScene( event )
	local group = self.view;
	print("CREATE SCENE Tienda.");
	
	-- Crea Display Objects y añadelos al "grupo" principal.	
	-- Example use-case: Restore 'group' from previously saved state.
	
end

-- Llamada inmediatamente despues de que scnEleccion haya sido movido a la pantalla:
function scnTienda:enterScene( event )
	local group = self.view;
	escaparate.initEscaparate( group );
	--CAPA SALIR:
	local capaSalir=display.newGroup();
	capaSalir.width,capaSalir.height=50,50;
	capaSalir.x,capaSalir.y=0,0;

	local capaSalirFondo=display.newRect(capaSalir,0,0,50,25);
	capaSalirFondo:setFillColor(0, 0, 10);

	group:insert(capaSalir);

	capaSalir:addEventListener("touch", salir);
end

-- Llamada cuando scnEleccion se haya movido fuera de pantalla:
function scnTienda:exitScene( event )

end

-- Llamada antes de la eliminación de la "view" de scnEleccion:
function scnTienda:destroyScene( event )

end

-- Disparado si la vista de scnEleccion no existe:
scnTienda:addEventListener("createScene", scnTienda );

-- Disparado cuando la transicion de scnEleccion ha finalizado:
scnTienda:addEventListener("enterScene", scnTienda );

-- Disparado antes de que la transicion empiece:
scnTienda:addEventListener("exitScene", scnTienda );

--Disparado antes de que la "view" sea descargada en memoria 
--(esto puede ser automaticamente en situaciones de poca memoria ó manualmente con purgeScene() y removeScene())
scnTienda:addEventListener("destroyScene", scnTienda );

return scnTienda;