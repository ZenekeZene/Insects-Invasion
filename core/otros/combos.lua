local cCombos={};

local _TAM_W=15;
local _TAM_H=50;

local _MARGIN_W=20;
local _MARGIN_H=28;

local _AUM=0.2;
local _TOPE=5;
local _VEL=500;

local _DURATION=3000;

local estado="apagado";

--CREAR PREVIEW:
local crearPreview=function(prop)

	--Capa (a medida en pos. y tam.):
	local capaMagiaCombo=display.newGroup();
	capaMagiaCombo.x,capaMagiaCombo.y=cCombos.prop._WIDTH-50,cCombos.prop._HEIGHT/2;
	capaMagiaCombo.width,capaMagiaCombo.height=100,100;
	cCombos.capaUI:insert(capaMagiaCombo);
	
	--Preview objeto Magia de combo:
	local previewMagiaCombo=display.newRect(capaMagiaCombo,0,0,50,50);
	previewMagiaCombo:setFillColor(240, 0, 0);
	previewMagiaCombo.isVisible=false;

	cCombos.previewMagiaCombo=previewMagiaCombo;
end

--QUITAR EFECTO:
local quitarEfecto=function(enemigo)
	enemigo.vel=enemigo.velOrigin;
end

--COLISION MAGIA:
local function colisionMagia(event)
	local phase=event.phase;
	local target=event.target;
	local other=event.other;

	if("began"==phase)then
		if(other)then
			if(other.tipo=="enemigo")then
				local vel=other.vel-1.9;
				if(other.vel~=vel)then
					other.vel=vel;
					timer.performWithDelay(_DURATION,function()quitarEfecto(other);end);
				end
			end
		end
	end
end

--QUTIAR MAGIA:
local quitarMagia=function(magia)
	local magia=magia;
	magia:removeEventListener("collision", colisionMagia);
	magia:removeSelf();
	estado="apagado";

	crearPreview();

end

--CREAR EFECTO:
local crearEfecto=function()
	local magia=display.newRect(cCombos.capaUI,0,0,cCombos.prop._WIDTH,cCombos.prop._HEIGHT);
	magia:setFillColor(100, 100, 100);
	magia.alpha=1;
	physics.addBody(magia, {density = 1.0, friction = 0.3, bounce = 0.2, isSensor = true});
	magia:addEventListener("collision", colisionMagia);
	transition.to(magia, {time = _DURATION, alpha = 0, onComplete = function() print("terminado");end});
	timer.performWithDelay(_DURATION, function()quitarMagia(magia);end, 1);
end

--ARRASTRAR PREVIEW:
local function arrastrarPreview(event)
	local phase=event.phase;
	local t=event.target;
	local stage=display.getCurrentStage();

	if("began"==phase)then

		stage:setFocus( event.target );
		t.isFocus = true;
		t.x0 = event.x - t.x;
		t.y0 = event.y - t.y;
		t.xScale=2;
		t.yScale=1;
	elseif t.isFocus then
		if "moved" == phase then
			t.x = event.x - t.x0;
			t.y = event.y - t.y0;
		elseif "ended" == phase or "cancelled" == phase then
			stage:setFocus( nil );
			t.isFocus = false;
			local xx,yy=event.x-t.width/2,event.y-t.height/2;

			timer.performWithDelay(100, crearEfecto, 1);

			t:removeEventListener("touch", arrastrarPreview);
			t:removeSelf();
		end
	end
	return true;
end

--REINICIAR COMBOS(manejador de ev. touch del fondo del escenario):
local reiniciarCombo=function(event)
	if ( event.phase == "began" ) then
		----print("old:"..oldCombos,"comb:"..combos);
		if(cCombos.oldCombos==cCombos.combos)then
			--Reiniciamos el contador de combos:
	        cCombos.combos=0;
	        --print("Reiniciamos combos  :"..cCombos.combos);
			transition.to(cCombos.fondo, {time = 300, yScale =1});
		end
    end
    cCombos.oldCombos=cCombos.combos;
	--return true;
end

--AUMENTAR COMBO (se dispara al eliminar a un enemigo):
local aumentarCombo=function()
	local combos=cCombos.combos;
	local oldCombos=cCombos.oldCombos;
	local fondo=cCombos.fondo;

	if(estado=="apagado")then
		if(fondo.yScale<_TOPE)then
			cCombos.combos=cCombos.combos+1;

			local yScaleAum=fondo.yScale+_AUM;
			transition.to(fondo, {time = _VEL, yScale = yScaleAum, onComplete = function() end});
		else
			--ACTIVAMOS LA MAGIA DE COMBO:
			--print("MAGIA DE COMBO ACTIVADA");
			cCombos.previewMagiaCombo.isVisible=true;
			cCombos.previewMagiaCombo:addEventListener("touch", arrastrarPreview);
			estado="encendido";
		end
	end
end
cCombos.aumentarCombo=aumentarCombo;

--DIBUJAR:
local dibujarCombos=function(capa,prop)
	local capa=capa;
	local prop=prop;

	local fondo=display.newRect(capa,prop._WIDTH-_TAM_W-_MARGIN_W,prop._HEIGHT-_TAM_H-_MARGIN_H,_TAM_W,_TAM_H);
	fondo:setReferencePoint(display.BottomCenterReferencePoint);
	--Faltaria todo el tema de cambiar el color...
	--fondo:setFillColor(125,125,124);
	fondo.alpha=0.9;

	cCombos.fondo=fondo;

	crearPreview(cCombos.prop);
end

--INIT:
local initCombos=function(capaUI,fondoEscenario,prop)
	local capa=capaUI;
	local fondo=fondoEscenario;
	local prop=prop;

	cCombos.capaUI=capa;
	cCombos.prop=prop;

	--Contador de combos:
	cCombos.combos=0;
	--Hack para comprobar que has pulsado una hormiga (no lleva return true en su manejador de eveto) y no el fondo:
	cCombos.oldCombos=cCombos.combos;
	--Dibujamos la UI de los combos (barra):
	dibujarCombos(capa,prop);
	--ASociamos al fondo del escenario un touch para reiniciar los combos 

	local stage=display.getCurrentStage();
	stage:addEventListener("touch", reiniciarCombo);
end
cCombos.initCombos=initCombos;

return cCombos;