local storyboard=require("storyboard");
local _WIDTH,_HEIGHT=display.contentWidth,display.contentHeight;

local scnQuiosco = storyboard.newScene();

--IR ELECCION:
--[[local irEleccion=function(event)
	estado="ELECCION";
	storyboard.gotoScene("screens.eleccion");
    storyboard.purgeScene("screens.principal");
    storyboard.removeScene("screens.principal");
    collectgarbage();
    --return true;
end]]

-- Llamada cuando la vista de scnQuiosco no exista:
function scnQuiosco:createScene( event )
	local group = self.view;
	print("CREATE SCENE Quiosco.");
	
	-- Crea Display Objects y añadelos al "grupo" principal.	
	-- Example use-case: Restore 'group' from previously saved state.
	
end

-- Llamada inmediatamente despues de que scnQuiosco haya sido movido a la pantalla:
function scnQuiosco:enterScene( event )
	local group = self.view;
	local comic=require("comics.comic");

	local event=event;
	if(event.params~=nil)then
		if(event.params.idComic~=nil)then

			local idComic=event.params.idComic;
			print("GO COMIC #"..idComic)
			comic.initComic(group,idComic);
		end
	end
end

-- Llamada cuando scnQuiosco se haya movido fuera de pantalla:
function scnQuiosco:exitScene( event )
	local group = self.view;
	print("EXIT SCENE Quiosco.");

	-- (e.g. stop timers, remove listeners, unload sounds, etc.)	
end

-- Llamada antes de la eliminación de la "view" de scnQuiosco:
function scnQuiosco:destroyScene( event )
	local group = self.view;
	print("DESTROY SCENE Quiosco.");
	
	-- (e.g. remove listeners, widgets, save state, etc.)
end

-- Disparado si la vista de scnQuiosco no existe:
scnQuiosco:addEventListener( "createScene", scnQuiosco );

-- Disparado cuando la transicion de scnQuiosco ha finalizado:
scnQuiosco:addEventListener( "enterScene", scnQuiosco );

-- Disparado antes de que la transicion empiece:
scnQuiosco:addEventListener( "exitScene", scnQuiosco );

--Disparado antes de que la "view" sea descargada en memoria 
--(esto puede ser automaticamente en situaciones de poca memoria ó manualmente con purgeScene() y removeScene())
scnQuiosco:addEventListener( "destroyScene", scnQuiosco );

---------------------------------------------------------------------------------

return scnQuiosco;
