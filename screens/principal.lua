local storyboard=require("storyboard");
local _WIDTH,_HEIGHT=display.contentWidth,display.contentHeight;

local scnPrincipal = storyboard.newScene();

--IR ELECCION:
local irEleccion=function(event)
	estado="ELECCION";
	storyboard.gotoScene("screens.eleccion");
    storyboard.purgeScene("screens.principal");
    storyboard.removeScene("screens.principal");
    collectgarbage();
    --return true;
end

--DIBUJAR:
local dibujar=function(capaPadre)
	local capaPadre=capaPadre;

	--FONDO:
	local capaFondo=display.newImageRect(capaPadre,"media/principal.png", 570, 380);
	--local capaFondo=display.newRect(capaPadre, 0, 0, 570, 380);
	capaFondo.x,capaFondo.y=display.contentWidth/2,display.contentHeight/2;
	--capaFondo:setFillColor(100,100,100);

	--[[local capaTitulo=display.newGroup();
	local titulo=display.newText(capaTitulo, "PLANT VS BUGS", 0, 0, "Helvetica", 30);
	capaTitulo.x,capaTitulo.y=_WIDTH/2-125,50;
	capaPadre:insert(capaTitulo);]]

	--BOTON PLAY:
	local capaPlay=display.newGroup();
	local btnPlay=display.newRect(capaPlay, 0, 0, 200, 80);
	capaPlay.x,capaPlay.y=_WIDTH/2-btnPlay.width/2,_HEIGHT/2-btnPlay.height/2 - 40;
	capaPadre:insert(capaPlay);
	capaPlay:addEventListener("tap", irEleccion);
	capaPlay.alpha = 0.1;

	--BOTON AJUSTES:
	local capaAjustes=display.newGroup();
	local btnAjustes=display.newCircle(capaAjustes, 0, 0, 20);
	btnAjustes:setFillColor(234,10,50);
	capaAjustes.x,capaAjustes.y=50,_HEIGHT-50;
	capaPadre:insert(capaAjustes);

	--BOTON OTROS:
	local capaOtros=display.newGroup();
	local btnOtros=display.newCircle(capaOtros, 0, 0, 20);
	btnOtros:setFillColor(200,100,50);
	capaOtros.x,capaOtros.y=_WIDTH-50,_HEIGHT-50;
	capaPadre:insert(capaOtros);
end

-- Llamada cuando la vista de scnPrincipal no exista:
function scnPrincipal:createScene( event )
	local group = self.view;
	print("CREATE SCENE Principal.");
	
	-- Crea Display Objects y añadelos al "grupo" principal.	
	-- Example use-case: Restore 'group' from previously saved state.
	
end

-- Llamada inmediatamente despues de que scnPrincipal haya sido movido a la pantalla:
function scnPrincipal:enterScene( event )
	local group = self.view;
	dibujar(group);

end

-- Llamada cuando scnPrincipal se haya movido fuera de pantalla:
function scnPrincipal:exitScene( event )
	local group = self.view;
	print("EXIT SCENE Principal.");

	-- (e.g. stop timers, remove listeners, unload sounds, etc.)	
end

-- Llamada antes de la eliminación de la "view" de scnPrincipal:
function scnPrincipal:destroyScene( event )
	local group = self.view;
	print("DESTROY SCENE Principal.");
	
	-- (e.g. remove listeners, widgets, save state, etc.)
end

-- Disparado si la vista de scnPrincipal no existe:
scnPrincipal:addEventListener( "createScene", scnPrincipal );

-- Disparado cuando la transicion de scnPrincipal ha finalizado:
scnPrincipal:addEventListener( "enterScene", scnPrincipal );

-- Disparado antes de que la transicion empiece:
scnPrincipal:addEventListener( "exitScene", scnPrincipal );

--Disparado antes de que la "view" sea descargada en memoria 
--(esto puede ser automaticamente en situaciones de poca memoria ó manualmente con purgeScene() y removeScene())
scnPrincipal:addEventListener( "destroyScene", scnPrincipal );

---------------------------------------------------------------------------------

return scnPrincipal;
