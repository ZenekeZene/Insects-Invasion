local cEnemigos={};
local _RATIO=520;

local cambiarSecuencia=function(target,secuencia)
	target:setSequence(secuencia);
	target:play();
end
cEnemigos.cambiarSecuencia=cambiarSecuencia;

--CARGAR ENEMIGOS:
local cargarEnemigos=function(prop,UI,capaSombras,capaTerrestres,capaVoladores)
	local capaSombras=capaSombras;
	local capaTerrestres=capaTerrestres;
	local capaVoladores=capaVoladores;
	--Hormiga:
	cEnemigos.hormiga=require("core.enemigos.hormiga");
	cEnemigos.hormiga.initHormiga(prop,UI,capaTerrestres,"core/enemigos/sprHormiga.png",cEnemigos.planta,cEnemigos.agua,cEnemigos.combos,cEnemigos.tnt);
	--Caracol:
	cEnemigos.caracol=require("core.enemigos.caracol");
	cEnemigos.caracol.initCaracol(prop,UI,capaTerrestres,"core/enemigos/sprCaracol.png",cEnemigos.planta,cEnemigos.agua,cEnemigos.combos,cEnemigos.tnt);
	--
	--Oruga:
	cEnemigos.oruga=require("core.enemigos.oruga");
	cEnemigos.oruga.initOruga(prop,UI,capaTerrestres,"core/enemigos/sprOruga.png",cEnemigos.planta,cEnemigos.agua,cEnemigos.combos,cEnemigos.tnt);
	--
	--Araña:
	cEnemigos.arana=require("core.enemigos.arana");
	cEnemigos.arana.initArana(prop,UI,capaTerrestres,"core/enemigos/sprArana.png",cEnemigos.planta,cEnemigos.agua,cEnemigos.combos,cEnemigos.tnt);
	--
	--Escarabajo:
	cEnemigos.escarabajo=require("core.enemigos.escarabajo");
	cEnemigos.escarabajo.initEscarabajo(prop,UI,capaTerrestres,"core/enemigos/sprEscarabajo.png",cEnemigos.planta,cEnemigos.agua,cEnemigos.combos,cEnemigos.tnt);
	--
	--Mosca:
	cEnemigos.mosca=require("core.enemigos.mosca");
	cEnemigos.mosca.initMosca(prop,UI,capaSombras,capaVoladores,"core/enemigos/sprMosca.png",cEnemigos.planta,cEnemigos.agua,cEnemigos.combos,cEnemigos.tnt,cEnemigos.utils);
end
cEnemigos.cargarEnemigos=cargarEnemigos;

--INIT
local initEnemigos=function(prop,UI,capaSombras,capaTerrestres,capaVoladores,planta,agua,combos,tnt,utils)
	--print("Iniciamos enemigos");
	local prop=prop;
	local capaSombras=capaSombras;
	local capaTerrestres=capaTerrestres;
	local capaVoladores=capaVoladores;
	local UI=UI;
	local tnt=tnt;
	local utils=utils;

	cEnemigos.tnt=tnt;
	cEnemigos.utils=utils;

	cEnemigos.enemigos={};

	cEnemigos.planta=planta;

	cEnemigos.agua=agua;

	cEnemigos.combos=combos;

	--PUNTOS DE ORIGEN DE LAS HORDAS:
	cEnemigos.pOrigen={{}};

	local numPoints = 10;
	local xCenter = prop._CENTRO.xx;
	local yCenter = prop._CENTRO.yy;
	local radius = _RATIO;
	 
	local angleStep = 2 * math.pi / numPoints;

	for i = 1, numPoints-1 do
		cEnemigos.pOrigen[i]={0,0};
	end
	    
	for i = 1, numPoints-1 do
	    cEnemigos.pOrigen[i][1] = xCenter + radius*math.cos(i*angleStep)
	    cEnemigos.pOrigen[i][2] = yCenter + radius*math.sin(i*angleStep)
	end

	cEnemigos.cargarEnemigos(prop,UI,capaSombras,capaTerrestres,capaVoladores);
end
cEnemigos.initEnemigos=initEnemigos;

return cEnemigos;