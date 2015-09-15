local Bomba={};

local _CAD_ACCION=200;

local quitarVida=function(other)
	local other=other;
	if(other)then
		if(other.idTipo=="arana")then--Quitamos el impulso de la arana por querer tirar una telaraña, incluso cuando ha muerto
			other.timerTela:cancel();
		end
		if(other.vida>1)then--si tiene vida
			other.vida=other.vida-1;--le quitamos una vida
		elseif(other.vida<=1)then--si no
			other.estado=2;--lo matamos
		end
	end
end

local colision=function(event)
	local phase=event.phase;
	local self=event.target;
	local other=event.other;

	if("began"==phase)then
		if(other.tipo=="enemigo")then
			if(other.estado==0 or other.estado==3)then--si esta vivo (o atacando)
				timer.performWithDelay(_CAD_ACCION, function()quitarVida(other);end, 1);
			end
		end
	end
end

local quitarOndas=function(onda)
	onda:removeSelf();
	onda=nil;
end

--CONSTRUCTOR:
local newBomba=function(xx,yy,capa)
	Bomba.capa=capa;
	local coords={{0,15},{10,10},{15,0},{10,-10},{0,-15},{-10,-10},{-15,0},{-10,10}};

	for i=1,#coords do
		local xxx,yyy=unpack(coords[i]);	
		local onda=display.newCircle(capa, xx+xxx, yy+yyy, 30 );
		onda.tipo="onda";
		onda.vida=1;
		onda.alpha=0.2;
		onda:setFillColor(242, 161, 240 );
		physics.addBody(onda, {density = 1.0, friction = 0.3, radius=50});
		onda:applyLinearImpulse(xxx,yyy,xx,yy);
		onda.linearDamping = 10;
		onda.angularDamping = 0.8;

		timer.performWithDelay(100,function()quitarOndas(onda);end,1);
		onda:addEventListener("collision", colision);
	end
end
Bomba.newBomba=newBomba;

return Bomba;