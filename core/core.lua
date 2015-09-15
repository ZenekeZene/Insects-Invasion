local core={};

--REQUIRE CORE:
core.requireCore=function()
	core.init=require("core.init");
	core.UI=require("core.UI");
	core.cMagia=require("core.magias.magias");
	core.cMancha=require("core.otros.mancha");
	core.cManchaVol=require("core.otros.manchaVol");
	core.cPuntos=require("core.otros.puntos");
	core.cClorofila=require("core.planta.clorofila");
	core.cPlanta=require("core.planta.planta");
	core.cAgua=require("core.planta.agua");
	core.cEnemigo=require("core.enemigos.enemigos");
	core.cCombos=require("core.otros.combos");
	core.gear=require("core.gear");
	core.cGestorMsj=require("core.otros.gestorMsj");
	core.cCuentaAtras=require("core.otros.cuentaAtras");
end

--INIT CORE:
core.initCore=function(capaPrincipal)
	
	local init,UI,cMagia,cMancha,cManchaVol,cClorofila,cPlanta,cAgua,cCombos,cPuntos,cEnemigo,gear,cGestorMsj,cCuentaAtras=core.init,core.UI,core.cMagia,core.cMancha,core.cManchaVol,core.cClorofila,core.cPlanta,core.cAgua,core.cCombos,core.cPuntos,core.cEnemigo,core.gear,core.cGestorMsj,core.cCuentaAtras;

	--init INIT
	init.initGo(capaPrincipal);

	--init UI:
	UI.initUI(init.prop,init.capas.capaUI);

	--init MAGIAS:
	cMagia.initMagias(init,UI.objPanel);

	--init MANCHAS:
	cMancha.initMancha(init.capas.capaManchas,init.mod.tnt);

	--init MANCHAS VOL:
	cManchaVol.initMancha(init.capas.capaManchas,init.mod.tnt);

	--init CLOROFILA:
	cClorofila.initClorofila(UI.objSaco,init.capas.capaClorofilas,init.mod.tnt,init.prop.clorofilas);

	--init PLANTA:
	cPlanta.initPlanta(init.prop,init.capas,cClorofila,init.mod.tnt);

	--init AGUA:
	cAgua.initAgua(cPlanta,init.capas.capaAguas,init.mod.tnt,init.prop.aguas);

	--init COMBOS:
	--print("FONDO:"..tostring(init.fondo));
	cCombos.initCombos(init.capas.capaUI,init.fondo,init.prop);

	--init PUNTOS:
	cPuntos.initPuntos(init.capas.capaPuntos,init.mod.tnt);

	--init ENEMIGOS:
	cEnemigo.initEnemigos(init.prop,UI,init.capas.capaSombras,init.capas.capaGamePlay,init.capas.capaVoladores,cPlanta,cAgua,cCombos,init.mod.tnt,init.mod.utils);

	--init GEAR:
	gear.initGear(init,UI,cMagia.objetos,cEnemigo,cPlanta,cMancha,cManchaVol,cAgua,init.mod.tnt,cMagia.tipos.spray.killSpray,cPuntos.sacarPuntos);

	--init GESTOR MENSAJES:
	cGestorMsj.initGestorMsj(init.prop,init.capas.capaMensajes,gear.reanudar,gear.pausar,init.mod.tnt);

	--init CUENTA ATRAS:
	--cCuentaAtras.initCuentaAtras(init.capas.capaCuentaAtras,init.prop,gear.empezar);

	--hack para reiniciar desde UI con un metodo de gear
	UI.setGear(gear);

end

return core;
