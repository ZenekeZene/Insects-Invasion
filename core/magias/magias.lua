local objMagias={};

local AutoStore=require("dmc_autostore");
local data;
--print("CARGO LAS MAGIAS");

local crearClon=function(xx,yy,tipo)
	local tnt=objMagias.tnt;
	if(tipo=="bomba")then
		--BOMBA:
		objMagias.tipos.bomba.newBomba(xx,yy,objMagias.capaGamePlay,tnt);
	elseif(tipo=="muro")then
		--MURO:
		objMagias.tipos.muro.newMuro(xx,yy);
	elseif(tipo=="lluvia")then
		--LLUVIA:
		objMagias.tipos.lluvia.newLluvia(objMagias.capaLluvia,tnt);
	elseif(tipo=="gallina")then
		--GALLINA:
		objMagias.tipos.gallina.newGallina(xx,yy,objMagias.capaGallina,objMagias.prop,tnt);
	elseif(tipo=="spray")then
		objMagias.tipos.spray.newSpray();
	end
end

--ARRASTRAR MAGIA:
local arrastrarMagia=function(event)
	
	local t = event.target;
	local phase = event.phase;
	local stage=display.getCurrentStage();

	if(estado=="NORMAL")then
		if "began" == phase then
			
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
				local tipo=t.tipo;
				timer.performWithDelay(100, function()crearClon(xx,yy,tipo);end, 1);

				if(t.padre.num>1)then
					t.padre.num=t.padre.num-1;
					local id=tonumber(t.padre.id);
					data.coleccion[id].cant=data.coleccion[t.padre.id].cant-1;
					t.padre.label.text="x"..t.padre.num;
				elseif(t.padre.num<=1)then
					t.padre.num=t.padre.num-1;
					local id=tonumber(t.padre.id);
					data.coleccion[id].cant=data.coleccion[t.padre.id].cant-1;
					t.padre.label.text="x"..t.padre.num;
					t.padre.fondo:setFillColor(100, 100, 100);
				end

				t:removeSelf();
				t=nil;
			end
		end
	elseif(estado=="PAUSA")then
		stage:setFocus( nil );
		t.isFocus = false;
		print("Deberiamos desavtivar las magias al salir los mensajes");
		return true;
	end
	return true
end

--DIBUJAR MAGIAS:
local drawMagias=function(objPanel)
	--print("2.-Pinto las magias y asocio arrastre");
	local objPanel=objPanel;
	local magias=objMagias.magias;
	local propMagias=objMagias.propMagias;

	local prop=objMagias.prop;

	for i=1,#magias do
		--capaGamePlay:
		magias[i].capaMagia=display.newGroup();
		magias[i].capaMagia.width,magias[i].height=propMagias.wwidth,propMagias.hheight;
		magias[i].capaMagia.x,magias[i].capaMagia.y=prop._WIDTH-(i*propMagias.margin),objPanel.fondoPanel.height/2-(propMagias.hheight/2);
		--fondo:
		magias[i].fondo=display.newRect(magias[i].capaMagia,0,0,propMagias.wwidth,propMagias.hheight);
		--label cantidad X magia:
		magias[i].label=display.newText(magias[i].capaMagia,"x"..magias[i].num,0,0,"Helvetica",11);
		--magias[i].label:rotate(90);
		magias[i].label.x,magias[i].label.y=-3,-1;

		if(magias[i].num>0)then
			magias[i].fondo:setFillColor(230, 10, 0);
			--Crear instancias de esas magias:
			for j=1,magias[i].num do
				local obj=display.newRect(magias[i].capaMagia,2,2,25,25);
				obj:setFillColor(30,30,30);
				obj.estado="sinPoner";
				obj.padre=magias[i];
				obj.tipo=obj.padre.tipo;
				obj:addEventListener("touch",arrastrarMagia);
			end
		elseif(magias[i].num<=0)then
			magias[i].fondo:setFillColor(100,100,100);
		end
		objMagias.capaUI:insert(magias[i].capaMagia);
	end
end
objMagias.drawMagias=drawMagias;

--INIT:
local initMagias=function(init,panel)
	
	AutoStore.data.info.fondos=3000;

	--Cargamos las cantidades por magia que tenemos en AutoStore:
	objMagias.magias={{num=0,id=1,tipo=0},{num=0,id=0,tipo=0},{num=0,id=3,tipo=0},{num=0,id=4,tipo=0},{num=0,id=5,tipo=0}};

	data=AutoStore.data;
	local coleccion=data.coleccion;
	if (coleccion ~= nil)then
	--local tam=#data.coleccion;
		for i=1,5 do
			--print()
			objMagias.magias[i].num=coleccion[i].cant;
			objMagias.magias[i].id=coleccion[i].id;
			objMagias.magias[i].tipo=coleccion[i].nombre;
		end
	end
	objMagias.propMagias={
							wwidth=31,
							hheight=30,
							margin=75
						};
	objMagias.prop=init.prop;
	objMagias.capaUI=init.capas.capaUI;
	objMagias.capaGamePlay=init.capas.capaGamePlay;
	objMagias.capaLluvia=init.capas.capaLluvia;
	objMagias.capaGallina=init.capas.capaGallina;
	objMagias.capaSpray=init.capas.capaSpray;

	objMagias.tnt=init.mod.tnt;

	objMagias.objetos={};--Almacena todos los objetos en pantalla

	objMagias.tipos={};
	objMagias.tipos.bomba=require("core.magias.bomba");
	objMagias.tipos.muro=require("core.magias.muro");
	objMagias.tipos.muro.initMuro(objMagias.capaGamePlay,objMagias.objetos,objMagias.tnt);
	objMagias.tipos.lluvia=require("core.magias.lluvia");
	objMagias.tipos.gallina=require("core.magias.gallina");
	objMagias.tipos.spray=require("core.magias.spray");
	objMagias.tipos.spray.initSpray(objMagias.capaSpray,objMagias.tnt);
	---

	drawMagias(panel);
end
objMagias.initMagias=initMagias;

return objMagias;