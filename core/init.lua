local init={};
----print("CARGANDO INIT");

init.mod={};
init.prop={};
init.capas={};
init.fondo={};

--MODULOS
local initMod=function()
	display.setStatusBar( display.HiddenStatusBar );
	
	--print("1.-Cargamos modulos");
	local objMod={};
	
	objMod.fin = require("core.mod.fin");
	--objMod.ctrans = require("core.mod.ctrans");
	objMod.tnt = require("core.mod.tnt");
	objMod.utils = require("core.mod.utils");
	objMod.physics = require("physics");

	return objMod;
end
init.initMod=initMod;

--CONSTANTES:
local initProp=function()
	--print("3.-Cargamos propiedades principales");
	estado="INICIO";
	local objProp={};

	objProp._WIDTH, objProp._HEIGHT=display.contentWidth,display.contentHeight;
	objProp._CENTRO={xx=objProp._WIDTH/2,yy=objProp._HEIGHT/2};

	objProp.puntos=0;
	objProp.maxRecord=objProp.puntos;
	
	objProp.objMagias={};

	objProp.aguas=0;

	objProp.clorofilas=0;

	return objProp;
end
init.initProp=initProp;

--FISICAS:
local initPhysics=function()
	--print("2.-Cargamos fisicas");
	system.activate( "multitouch" );
	physics.setDrawMode( "normal" );
	physics.start();
	physics.setGravity( 0, 0 );
end
init.initPhysics=initPhysics;

--CAPAS:
local initCapas=function()
	--print("4.-Cargamos capas");
	local objCapas={};

	objCapas.capaFondo=display.newGroup();
	init.capaPrincipal:insert(objCapas.capaFondo);

	objCapas.capaManchas=display.newGroup();
	init.capaPrincipal:insert(objCapas.capaManchas);

	objCapas.capaSombras=display.newGroup();
	init.capaPrincipal:insert(objCapas.capaSombras);

	objCapas.capaAguas=display.newGroup();
	init.capaPrincipal:insert(objCapas.capaAguas);

	objCapas.capaGamePlay=display.newGroup();
	init.capaPrincipal:insert(objCapas.capaGamePlay);

	objCapas.capaVoladores=display.newGroup();
	init.capaPrincipal:insert(objCapas.capaVoladores);

	objCapas.capaFlores=display.newGroup();
	init.capaPrincipal:insert(objCapas.capaFlores);

	objCapas.capaClorofilas=display.newGroup();
	init.capaPrincipal:insert(objCapas.capaClorofilas);

	objCapas.capaSpray=display.newGroup();
	init.capaPrincipal:insert(objCapas.capaSpray);

	objCapas.capaGallina=display.newGroup();
	init.capaPrincipal:insert(objCapas.capaGallina);

	objCapas.capaLluvia=display.newGroup();
	init.capaPrincipal:insert(objCapas.capaLluvia);

	objCapas.capaPuntos=display.newGroup();
	init.capaPrincipal:insert(objCapas.capaPuntos);

	objCapas.capaUI=display.newGroup();
	init.capaPrincipal:insert(objCapas.capaUI);

	objCapas.capaMensajes=display.newGroup();
	init.capaPrincipal:insert(objCapas.capaMensajes);

	objCapas.capaCuentaAtras=display.newGroup();
	init.capaPrincipal:insert(objCapas.capaCuentaAtras);
	
	return objCapas;
end
init.initCapas=initCapas;

--FONDO:
local initFondo=function()
	--print("5.-Cargamos fondo");
	--local xx=math.random(1,300);
	--local yy=math.random(1,300);
	--local objFondo=display.newRect(init.capas.capaFondo,0,0,init.prop._WIDTH,init.prop._HEIGHT);
	local objFondo=display.newRect(init.capas.capaFondo,0,0,570,380);
	objFondo.x,objFondo.y=display.contentWidth/2,display.contentHeight/2;
	--local objFondo=display.newRect(init.capas.capaFondo,0,0,100,100);
	return objFondo;
end
init.initFondo=initFondo;

--INIT:
local initGo=function(capa)
	--print("Empezamos:");
	init.capaPrincipal=capa;
	init.mod=initMod();
	initPhysics();
	init.prop=initProp();
	init.capas=initCapas();
	init.fondo=initFondo();
end
init.initGo=initGo;

return init;