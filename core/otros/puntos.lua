local cPuntos={};

local _TIME_LIFE=500;
local _DIST=-80;

local newPuntos;
local colisionPuntos;

colisionPuntos=function(event)
	local phase=event.phase;
	local target=event.target;
	local other=event.other;
	local cont=target.cont;
	if("began"==phase)then
		local xx,yy=target.x,target.y;
		if(target.clase=="puntos" and other.clase=="puntos")then
			if(cont==1)then
				target.text="200";
				target.size=50;
				target:setTextColor(255, 0, 0);
			elseif(cont==2)then
				target.text="600";
				target.size=70;
				target:setTextColor(0, 0, 255);
			elseif(cont==3)then
				target.text="2000";
				target.size=90;
				target:setTextColor(0, 255, 0);
			elseif(cont==4)then
				target.text="5000";
				target.size=110;
				target:setTextColor(100, 100, 100);
			end
			target.cont=cont+1;
			target.transAlpha:cancel();
			target.alpha=1;
			local yyFinal=target.y+_DIST;
			target.transAlpha=cPuntos.tnt:newTransition(target, 
					{
					time = _TIME_LIFE, 
					alpha = 0,
					y = yyFinal,
					name = 'Slide Transition', 
					userData = 'User data', 
					cycle = 1, 
					backAndForth = false, 
					onEnd = function (object, event)end
					});
			target.transLife:cancel();
			target.transLife=cPuntos.tnt:newTimer(_TIME_LIFE,function ()
					target:removeEventListener("collision", colisionPuntos);
					target:removeSelf(); end,
					1);
			other.clase="descartado";
			other.transAlpha:cancel();
			other.alpha=0;
		end
	end
end

newPuntos=function(xx,yy,punt,tipo)
	--print("CREAMOS PUNTOS");
	local xx,yy=xx,yy;
	local punt=punt;
	local tipo=tipo or 1;
	local tamFuente=30;
	
	local lblPuntos=display.newText(cPuntos.capa, punt, xx, yy, "Helvetica", tamFuente);
	lblPuntos:setTextColor( 0,255,0 );
	
	lblPuntos.clase="puntos";
	--lblPuntos.tipo=tipo;
	lblPuntos.cont=1;
	
	timer.performWithDelay(
		1, 
		function()
			physics.addBody(lblPuntos, {density = 1.0, friction = 0.3, bounce = 0.2, shape={-100,-100,100,-100,100,100,-100,100},isSensor = true});	
		end, 
		1);
	
	lblPuntos:addEventListener("collision", colisionPuntos);

	local yyFinal=yy+_DIST;
	lblPuntos.transAlpha=cPuntos.tnt:newTransition(
		lblPuntos, 
		{
			time = _TIME_LIFE, 
			alpha = 0,
			y = yyFinal,
			name = 'Slide Transition', 
			userData = 'User data', 
			cycle = 1, 
			backAndForth = false, 
			onEnd = function (object, event)end
		});
	lblPuntos.transLife=cPuntos.tnt:newTimer(
		_TIME_LIFE,
		function ()
			lblPuntos:removeEventListener("collision", colisionPuntos);
			lblPuntos:removeSelf(); 
		end,
		1);
end

local sacarPuntos=function(xx,yy,punt)
	local xx,yy=xx,yy;
	local punt=punt;
	local puntos=newPuntos(xx,yy,punt);
end
cPuntos.sacarPuntos=sacarPuntos;

local initPuntos=function(capaPuntos,tnt)
	cPuntos.capa=capaPuntos;
	cPuntos.tnt=tnt;
end
cPuntos.initPuntos=initPuntos;

return cPuntos;