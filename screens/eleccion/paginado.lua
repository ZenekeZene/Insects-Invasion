local cPaginado={};

local _VEL=50;--usado en las transiciones visuales de las paginas. Ojo: que no sea mayor que el tiempo _CAD_GOTO_LIENZO que se usa en "eleccion.lua" para pasar a "lienzo.lua".
local _PAD=50;
local _TAM_CP=700;--anchura capa padre
local _LEFT_CP=-50;
local _TOP_CP=50;

local _TAM=500;--anchura de las paginas
local _WIDTH_FONDO,HEIGHT_FONDO=360,250;
local _MARGIN_LEFT_FONDO,_MARGIN_TOP_FONDO=-10,-10;
local _MARGIN_LEFT=60;

local xCentral=display.contentWidth/2;
local activo=-1;

local paginas={};
local bolas={};
local nums={};
local _ALPHA_MIN=0.3;

local capaLibro;

local cCajasNiveles=require("screens.eleccion.cajas");--requerirlo en cada scene??

local transicion;
local _DESF_MIN=30;

--EFECTOS VISUALES DE TRANSICION ENTRE paginas:
local irPrimero=function()
	transition.to(capaLibro, {time = _VEL, x = xCentral-((_TAM+_PAD)*0.5), onComplete = function()end});
	transition.to(paginas[1], {time = _VEL, alpha = 1, onComplete = function()bolas[1]:setFillColor(0,240,0);nums[1].alpha=1; end});
	transition.to(paginas[2], {time = _VEL, alpha = _ALPHA_MIN, onComplete = function()bolas[2]:setFillColor(255,255,255);nums[2].alpha=0;end});
	transition.to(paginas[3], {time = _VEL, alpha = _ALPHA_MIN, onComplete = function()bolas[3]:setFillColor(255,255,255);nums[3].alpha=0;end});
	activo=1;
end
cPaginado.irPrimero=irPrimero;

local irSegundo=function()
	transition.to(capaLibro, {time = _VEL, x = xCentral-((_TAM+_PAD)*1.5), onComplete = function()end});
	transition.to(paginas[1], {time = _VEL, alpha = _ALPHA_MIN, onComplete = function()bolas[1]:setFillColor(255,255,255);nums[1].alpha=0;end});
	transition.to(paginas[2], {time = _VEL, alpha = 1, onComplete = function()bolas[2]:setFillColor(0,240,0);nums[2].alpha=1;end});
	transition.to(paginas[3], {time = _VEL, alpha = _ALPHA_MIN, onComplete = function()bolas[3]:setFillColor(255,255,255);nums[3].alpha=0;end});
	activo=2;
end
cPaginado.irSegundo=irSegundo;

local irTercero=function()
	transition.to(capaLibro, {time = _VEL, x = xCentral-((_TAM+_PAD)*2.5), onComplete = function()end});
	transition.to(paginas[1], {time = _VEL, alpha = _ALPHA_MIN, onComplete = function()bolas[1]:setFillColor(255,255,255);nums[1].alpha=0;end});
	transition.to(paginas[2], {time = _VEL, alpha = _ALPHA_MIN, onComplete = function()bolas[2]:setFillColor(255,255,255);nums[2].alpha=0;end});
	transition.to(paginas[3], {time = _VEL, alpha = 1, onComplete = function()bolas[3]:setFillColor(0,240,0);nums[3].alpha=1;end});
	activo=3;
end
cPaginado.irTercero=irTercero;

--MANEJADORES:
--Para boton izquierdo:
local function pasarIzq(event)

	local target=event.target;
	local phase=event.phase;
	local stage=display.getCurrentStage();

	if("began"==phase)then
		stage:setFocus( target );
		target.isFocus = true;

		if(activo==1)then
			--print("LIMITE IZQ"..activo)
		elseif(activo==2)then
			irPrimero();
		elseif(activo==3)then
			irSegundo();
		end
	elseif("ended"==phase or "cancelled"==phase)then
		stage:setFocus( nil );
		target.isFocus = false;
	end
	return true;
end

--Para boton derecho:
local function pasarDer(event)
	
	local target=event.target;
	local phase=event.phase;
	local stage=display.getCurrentStage();

	if("began"==phase)then
		stage:setFocus( target );
		target.isFocus = true;

		if(activo==1)then
			timer.performWithDelay(100, irSegundo, 1);
		elseif(activo==2)then
			timer.performWithDelay(100, irTercero, 1);
		elseif(activo==3)then
		end
	elseif("ended"==phase or "cancelled"==phase)then
		stage:setFocus( nil );
		target.isFocus = false;
	end
	return true;
end

--Comprobar distancia (codnicion para ir a una pagina u otra):
local comprobarDistancia=function()
	return (capaLibro.x-xCentral);
end

--manejador de evento, para arrastre:
local function mover(event)
	local phase=event.phase;
	local target=event.target;
	local stage=display.getCurrentStage();
	local xx;
	if("began"==phase)then--Arrastramos toda la capa contenedora principal (por lo que arrastramos las capas hijas(paginas))
		stage:setFocus( target );
		target.isFocus = true;
		markX = target.x;
	elseif(target.isFocus==true)then
		if("moved"==phase)then--Seguimos arrastrando...
			local x = (event.x - event.xStart) + markX;
	        target.x = x;
		elseif("ended"==phase or "cancelled"==phase)then
			stage:setFocus( nil );
			target.isFocus = false;
			local dist=comprobarDistancia();--COmprobamos la distancia entre el punto central de la capa contenedora principal y el punto central de la pantalla:
			--Conforme a esa distancia movemos la capa contenedora principal horizontalmente de forma que pongamos de frente a la capa hija (pagina) correspondiente:
			if(dist>0 or dist>-_TAM)then--CAJA 1 AL MEDIO:
				irPrimero();
			elseif(dist<-_TAM and dist>-(_TAM*2))then--CAJA 2 AL MEDIO:
				irSegundo();
			elseif(dist<-(_TAM*2))then--CAJA 3 AL MEDIO:
				irTercero();
			end
		end
	end
end

--Getter de paginas:
local getPaginas=function()
	return paginas;
end
cPaginado.getPaginas=getPaginas;

------------------------------------------------------------------------------------
--DIBUJAR:
local dibujar=function(vista)
	--print("Dibujo paginado");
	local vista=vista;

	--Capa contenedora:
	capaLibro=display.newGroup();
	vista:insert(capaLibro);
	capaLibro.width,capaLibro.height=_TAM_CP,200;
	capaLibro.x,capaLibro.y=_LEFT_CP,_TOP_CP;

	--Fondo de la escena:
	local capaLibroFondo=display.newImageRect( vista, "media/pagina1.png", 570,380 );
	capaLibroFondo:setReferencePoint(display.TopLeftReferencePoint);
	capaLibroFondo.x,capaLibroFondo.y=-45,0;
	capaLibroFondo:toBack();

	--Fondo capa contenedora:
	local fondo=display.newRect( capaLibro,0, 0, _TAM_CP, 200 );
	fondo.alpha=0.1;

	--Paginado:
	local capaPaginado=display.newGroup();
	capaPaginado.x,capaPaginado.y=display.contentWidth/2-60,450;

	for i=1,3 do
		local bola=display.newCircle(capaPaginado,i*30,0,5);
		bola:setFillColor(255,255,255);
		bolas[i]=bola;
		local num=display.newText(capaPaginado,i,-4+i*30,-20,"Helvetica",10);
		num:setTextColor(0, 255, 0);
		num.alpha=0;
		nums[#nums+1]=num;
	end
	capaPaginado:toFront();
	vista:insert(capaPaginado);

	--Paginas:
	local labels={"Baaah...","Mmmmm...","Bufffff..."}
	for i=1,3 do
		--Capa contenedora de cada pagina:
		local capaPagina=display.newGroup();
		capaPagina.x,capaPagina.y=_MARGIN_LEFT-_TAM+(i*(_TAM+_PAD)),0;
		capaPagina.alpha=_ALPHA_MIN;
		--Fondo capa contenedora:
		local fondo=display.newRect(capaPagina,_MARGIN_LEFT_FONDO,_MARGIN_TOP_FONDO,_WIDTH_FONDO,HEIGHT_FONDO);
		fondo:setFillColor(i*20, i*5, i*20);
		fondo.alpha=0.01;
		--Texto:
		local texto=display.newText(capaPagina,labels[i],_TAM/2-50,-50,"Helvetica",20);
		--La metemos en la capa contenedora principal:
		capaLibro:insert(capaPagina);
		
		--Creamos las cajas de los niveles:
		paginas[#paginas+1]=capaPagina;
		paginas[#paginas].niveles=cCajasNiveles.newCajasNiveles(18,capaPagina,i);
	end
	
	--Botones:
	--[[cPaginado.btnIzq=display.newRect(vista,0,display.contentHeight/2,20,20);
	cPaginado.btnDer=display.newRect(vista,display.contentWidth-20,display.contentHeight/2,20,20);
	cPaginado.btnIzq:setFillColor(240, 0, 0);
	cPaginado.btnDer:setFillColor(240, 0, 0);]]
	cPaginado.btnIzq=display.newImageRect(vista,"media/btnIzq.png",20,20);
	cPaginado.btnIzq.x,cPaginado.btnIzq.y=0,display.contentHeight/2;
	cPaginado.btnDer=display.newImageRect(vista,"media/btnDer.png",20,20);
	cPaginado.btnDer.x,cPaginado.btnDer.y=display.contentWidth-20,display.contentHeight/2;

	--Efecto visual inicial:
	transition.to(paginas[1], {time = _VEL, alpha = 1, onComplete = function()bolas[1]:setFillColor(0,240,0);nums[1].alpha=1;end});
	transition.to(paginas[2], {time = _VEL, alpha = _ALPHA_MIN, onComplete = function()bolas[2]:setFillColor(255,255,255);nums[2].alpha=0;end});
	transition.to(paginas[3], {time = _VEL, alpha = _ALPHA_MIN, onComplete = function()bolas[3]:setFillColor(255,255,255);nums[3].alpha=0;end});
	activo=1;

	cPaginado.capaLibro=capaLibro;

	--Asociamos evento y manejador:
	capaLibro:addEventListener("touch", mover);
	cPaginado.btnIzq:addEventListener("touch", pasarIzq);
	cPaginado.btnDer:addEventListener("touch", pasarDer);
end
cPaginado.dibujar=dibujar;

--INIT:
local initPaginado=function(vista)
	dibujar(vista);
	cCajasNiveles._CANT=38;
	cCajasNiveles.acumulativo=1;
	cPaginado.cCajasNiveles=cCajasNiveles;
end
cPaginado.initPaginado=initPaginado;

return cPaginado;