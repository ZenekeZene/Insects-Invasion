local cPlanta={};

---------------------------
local _VIDA=100;
local radioAsp=20;
local radioFis=20;
local _VEL=500;
local _INC=0.1;
local _TOPE_INC=3;
local _TOPE_INC_MAX=3;
local _TOPE_INC_MIN=1;
local _MAX_AGUA=100;

local pto_crec={5,10,15,20,25};

cPlanta._DISTANCIA_ATAQUE=60;
---------------------
local flores={};
------------------------
local _TAM_FLOR_MIN=25;
local _TAM_FLOR_MAX=35;
local _MARGIN_FLOR=30;

local _CAD_CLORO=6000;
------------------------------------------------------
local crearClorofila=function(xx,yy)
	cPlanta.cClorofila.newClorofila(xx,yy);
end
------------------------------------------------------
local borrarFlor=function(pos)
	if(flores[pos]~=nil)then
		print("BORRADA FLOR #"..pos);
		flores[pos].timerCloro:cancel();
		--timer.cancel(flores[pos].timerCloro);
		if(flores[pos]~=nil)then
			flores[pos]:removeSelf();
			flores[pos]=nil;
		end
		--table.remove(flores,pos);
	end
end

----------------------------------------------------
local crearFlor=function(pos)
	local flor={};
	local tnt=cPlanta.tnt;
	if(pos==1)then
		flor=display.newCircle(cPlanta.capas.capaFlores,cPlanta.inst.x,cPlanta.inst.y,_TAM_FLOR_MIN);
		flor:setFillColor(10,255,10);
	elseif(pos==2)then
		flor=display.newCircle(cPlanta.capas.capaFlores,cPlanta.inst.x+_MARGIN_FLOR,cPlanta.inst.y+_MARGIN_FLOR,_TAM_FLOR_MIN);
		flor:setFillColor(10,230,50);
		local trans1 = tnt:newTransition(flores[1], {time = _VEL, x=cPlanta.inst.x-_MARGIN_FLOR,y=cPlanta.inst.y-_MARGIN_FLOR, name = 'Slide Transition', userData = 'User data', cycle = 1, backAndForth = false, onEnd = function (object, event)end});
		--transition.to(flores[1], {time=_VEL, x=cPlanta.inst.x-_MARGIN_FLOR,y=cPlanta.inst.y-_MARGIN_FLOR});
	elseif(pos==3)then
		flor=display.newCircle(cPlanta.capas.capaFlores,cPlanta.inst.x,cPlanta.inst.y+_MARGIN_FLOR,_TAM_FLOR_MIN);
		flor:setFillColor(40,230,50);
		local trans1 = tnt:newTransition(flores[1], {time = _VEL, x=cPlanta.inst.x-_MARGIN_FLOR,y=cPlanta.inst.y-_MARGIN_FLOR, name = 'Slide Transition', userData = 'User data', cycle = 1, backAndForth = false, onEnd = function (object, event)end});
		local trans2 = tnt:newTransition(flores[2], {time = _VEL, x=cPlanta.inst.x+_MARGIN_FLOR,y=cPlanta.inst.y-_MARGIN_FLOR, name = 'Slide Transition', userData = 'User data', cycle = 1, backAndForth = false, onEnd = function (object, event)end});
		--transition.to(flores[1], {time=_VEL, x=cPlanta.inst.x-_MARGIN_FLOR,y=cPlanta.inst.y-_MARGIN_FLOR});
		--transition.to(flores[2], {time=_VEL, x=cPlanta.inst.x+_MARGIN_FLOR,y=cPlanta.inst.y-_MARGIN_FLOR});
	elseif(pos==4)then
		flor=display.newCircle(cPlanta.capas.capaFlores,cPlanta.inst.x+_MARGIN_FLOR,cPlanta.inst.y+_MARGIN_FLOR,_TAM_FLOR_MIN);
		flor:setFillColor(40,150,50);
		local trans1 = tnt:newTransition(flores[1], {time = _VEL, x=cPlanta.inst.x-_MARGIN_FLOR,y=cPlanta.inst.y-_MARGIN_FLOR, name = 'Slide Transition', userData = 'User data', cycle = 1, backAndForth = false, onEnd = function (object, event)end});
		local trans2 = tnt:newTransition(flores[2], {time = _VEL, x=cPlanta.inst.x+_MARGIN_FLOR,y=cPlanta.inst.y-_MARGIN_FLOR, name = 'Slide Transition', userData = 'User data', cycle = 1, backAndForth = false, onEnd = function (object, event)end});
		local trans3 = tnt:newTransition(flores[3], {time = _VEL, x=cPlanta.inst.x-_MARGIN_FLOR,y=cPlanta.inst.y+_MARGIN_FLOR, name = 'Slide Transition', userData = 'User data', cycle = 1, backAndForth = false, onEnd = function (object, event)end});

		--transition.to(flores[1], {time=_VEL, x=cPlanta.inst.x-_MARGIN_FLOR,y=cPlanta.inst.y-_MARGIN_FLOR});
		--transition.to(flores[2], {time=_VEL, x=cPlanta.inst.x+_MARGIN_FLOR,y=cPlanta.inst.y-_MARGIN_FLOR});
		--transition.to(flores[3], {time=_VEL, x=cPlanta.inst.x-_MARGIN_FLOR,y=cPlanta.inst.y+_MARGIN_FLOR});
	end
	--print("CREADA FLOR #"..pos);
	
	local xscale,yscale=flor.xScale,flor.yScale;
	local trans1=cPlanta.tnt:newTransition(flor, {time = _VEL, xScale = xscale+0.5, yScale = yscale+0.5, cycle = 1, backAndForth = false, onEnd = function (object, event) end});
	--transition.to(flor, {time = _VEL, xScale = xscale+0.5, yScale = yscale+0.5});

	--La flor crea clorofilas:
	flor.timerCloro=cPlanta.tnt:newTimer(_CAD_CLORO,function()crearClorofila(flor.x,flor.y);end,0);
	--flor.timerCloro=timer.performWithDelay(_CAD_CLORO,function()crearClorofila(flor.x,flor.y);end,0);

	--Metemos la flor en el array flores:
	local ind=#flores+1;
	flores[ind]=flor;
	flor.ind=ind;
end
----------------------------------------------------------------------------------------------------------------------------
local setRadioMenos=function()
	local aguas=cPlanta.prop.aguas;

	if(#flores<=0)then
		local xscale,yscale=cPlanta.inst.xScale,cPlanta.inst.yScale;
		if(xscale>_TOPE_INC_MIN)then
			cPlanta.inst.xScale=xscale-_INC;
			cPlanta.inst.yScale=yscale-_INC;
		end
	else
		if(aguas==pto_crec[1])then
			--print("HIERBAJO");
		elseif(aguas==pto_crec[2])then
			borrarFlor(1);
		elseif(aguas==pto_crec[3])then
			borrarFlor(2);
		elseif(aguas==pto_crec[4])then
			borrarFlor(3);
		elseif(aguas==pto_crec[5])then
			borrarFlor(4);
		end
	end
	----print("N. de agua (-): "..cPlanta.prop.aguas);
	if(cPlanta.prop.aguas>1)then
		cPlanta.prop.aguas=cPlanta.prop.aguas-1;
	end
	----print("Nivel de agua"..cPlanta.prop.aguas);
end
cPlanta.setRadioMenos=setRadioMenos;
--------------------------------------------------------------------------------------------------------------------------
local setRadioMas=function()
	local aguas=cPlanta.prop.aguas;

	local xscale,yscale=cPlanta.inst.xScale,cPlanta.inst.yScale;
	if(aguas<pto_crec[1])then
		--if(xscale)
		if(xscale<_TOPE_INC)then
			cPlanta.inst.xScale=xscale+_INC;
			cPlanta.inst.yScale=yscale+_INC;
		end
	else
		if(aguas==pto_crec[1])then
			--print("HIERBAJO");
		elseif(aguas==pto_crec[2] and #flores==0)then
			crearFlor(1);
		elseif(aguas==pto_crec[3] and #flores==1)then
			crearFlor(2);
		elseif(aguas==pto_crec[4] and #flores==2)then
			crearFlor(3);
		elseif(aguas==pto_crec[5] and #flores==3)then
			crearFlor(4);
		end
	end
	----print("N. de agua (+): "..cPlanta.prop.aguas);
	if(cPlanta.prop.aguas<_MAX_AGUA)then
		cPlanta.prop.aguas=cPlanta.prop.aguas+1;
	end
	----print("Nivel de agua"..cPlanta.prop.aguas);
end
cPlanta.setRadioMas=setRadioMas;
---------------------------------------------------------------------------------------------------------------------------
local drawVida=function(capaUI)
	----print(cPlanta.vida);
	cPlanta.txtVida=display.newText(cPlanta.capaUI,cPlanta.vida,cPlanta.prop._CENTRO.xx-10,cPlanta.prop._CENTRO.yy-15,"Helvetica",40);
	cPlanta.txtVida:setTextColor(255, 255, 255);
	cPlanta.txtVida:rotate(90);
	cPlanta.txtVida.alpha = 0; -- Only Debug

end
cPlanta.drawVida=drawVida;
----------------------------------------------------------------------------------------------------------------------------------
--INIT
local initPlanta=function(prop,capas,cClorofila,tnt)
	cPlanta.prop=prop;
	cPlanta.capas=capas;
	cPlanta.capaUI=capas.capaUI;

	--PLANTA
	cPlanta.inst=display.newCircle(cPlanta.capas.capaGamePlay, cPlanta.prop._WIDTH/2,cPlanta.prop._HEIGHT/2,radioAsp);
	cPlanta.inst:setFillColor(123,145,160);
	physics.addBody(cPlanta.inst, "static", {density = 1.0, friction = 0.3, bounce = 0.2, radius=radioFis});
	cPlanta.vidaOrigin=_VIDA;--para reiniciar de gear
	cPlanta.vida=_VIDA;
	
	cPlanta.cClorofila=cClorofila;
	cPlanta.tnt=tnt;

	--Dibujamos su UI(vida):
	drawVida();

	flores={};
	--return cPlanta;
end
cPlanta.initPlanta=initPlanta;
--------------------------------------------------------------------------------------------------------------------------------------
return cPlanta;