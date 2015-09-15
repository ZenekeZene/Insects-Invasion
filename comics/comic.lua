local cComic={};

local _WIDTH,_HEIGHT=display.contentWidth,display.contentHeight;
local _TAM=3;
local _ANCH;
local _MARGIN=30;
local _VEL=500;
local vinetas={};
local interruptor=false;
local paso=1;

--LIMPIAR PANTALLA:
local limpiarPantalla = function()
	print("LIMPIAMOS!");
	for i = 1, _TAM do
		transition.to(vinetas[i], {time = 100, y = -_HEIGHT/2+30, onComplete = function()end});
	end
end

--SACAR VIÑETA:
local sacarVineta = function(ind)
	print("SACAMOS VINETA "..paso);
	local ind = ind;
	transition.to(vinetas[ind], {time = _VEL, y = _HEIGHT/2, onComplete = function() interruptor=false; paso = paso+1; end});
end
cComic.sacarVineta = sacarVineta;

--DIBUJAR BOTON:
local dibujarBtn = function()
	local btn = display.newCircle(cComic.capa, _WIDTH-100, _HEIGHT-100, 30);
	btn:setFillColor(0, 0, 240, 210);
	btn:addEventListener("tap", 
		function()
			if(interruptor==false)then
				interruptor=true;
				if(paso<=_TAM)then 
					sacarVineta(paso);
				elseif(paso>_TAM)then
					limpiarPantalla();
				end
			end
		end
	);
end

--DIBUJAR VIÑETA:
local dibujarVineta = function(xx)
	local vineta = display.newRect(cComic.capa,xx,0,300,300);
	
	vineta:setFillColor(10,0,70);
	vineta.x, vineta.y = xx, -200;
	vineta.width, vineta.height =_ANCH, _HEIGHT;

	return vineta;
end

--CREAR VIÑETAS:
local crearVinetas=function()
	for i=1,_TAM do
		local xx = i*(_ANCH+_MARGIN)-(_ANCH/2);
		local vineta = dibujarVineta(xx);
		vineta.ind = i;
		vinetas[i] = vineta;
	end
	if(interruptor==false)then
		interruptor=true;
		sacarVineta(paso);
	end
end

--INIT:
local initComic=function( capaPadre , idComic)
	cComic.capa = capaPadre;
	cComic.idComic=idComic;
	if(cComic.idComic==1)then
		_TAM=6;
	end
	print("HAY QUE ENSEÑAR EL COMIC #"..idComic);
	_ANCH= _WIDTH/3.5;
	crearVinetas();
	dibujarBtn();
end
cComic.initComic=initComic;

return cComic;