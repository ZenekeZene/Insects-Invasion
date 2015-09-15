local AutoStore=require("dmc_autostore");

local cCajasNiveles={};

local _CANT=18;--cantidad de cajas por paginas por defecto
local _TAM=40;--tamaño de la caja
local _MARGEN_RIGHT=20;--margen entre las cajas
local _MARGEN_TOP=50;
local _LIM_FILA=6;--numero de cajas por fila
local escenas={};
cCajasNiveles.acumulativo=1;
local _INI_TOPE_DESB=4;--solo estan desbloqueados los dos primeros niveles:

--Candado:
local _TAM_CAND=20;
local _DESF_CAND=15;

local quitarCandado=function(target)
		local target=target;
		target.estado="desbloqueado";
		print("Lo desbloqueamos "..target.nivel);
		--transition.to(target.candado,{alpha=0});
		if(target.candado~=nil)then
			transition.to(target.candado, {time = 500, alpha = 0,onComplete=function()end});
			--target.candado.alpha=0;
			target.candado:removeSelf();
			target.candado=nil;
		end
end
cCajasNiveles.quitarCandado=quitarCandado;

local crearCajas=function(pagina)
	print("CREAMOS CAJAS");
	local niveles={};
	local acumulativo=cCajasNiveles.acumulativo;
	local yy,xx=0,0;
	for i=1,cCajasNiveles._CANT do
		if(xx>=_LIM_FILA)then
			yy=yy+(_TAM+_MARGEN_TOP);
			xx=0;
		end
		--Capa padre para cajita:
		local capaNivel=display.newGroup();
		capaNivel.x,capaNivel.y=xx*(_TAM+_MARGEN_RIGHT),yy;
		--Id. para cada cajita:
		capaNivel.name="nivel";
		capaNivel.nivel=acumulativo;
		capaNivel.pagina=pagina;
		capaNivel.mundo=1;
		--Metemos la cajita en su capa padre:
		cCajasNiveles.capaEscena:insert(capaNivel);
		--Cuadrado:
		--local nivel=display.newRect(capaNivel,0,0,_TAM,_TAM);
		--nivel:setFillColor(100, 100, 100);
		local nivel=display.newImageRect( capaNivel,"media/caja.png", _TAM, _TAM );
		nivel:setReferencePoint(display.TopLeftReferencePoint);
		nivel.x,nivel.y=0,0;
		--Texto
		local num=display.newText(capaNivel,acumulativo, 5, 5, "Helvetica", 15);

		if(acumulativo<_INI_TOPE_DESB+1 and pagina==1)then
			capaNivel.estado="desbloqueado";
		else
			local data=AutoStore.data;
			for j=1,data.niveles:len()do
				if(j==acumulativo)then
					capaNivel.estado="desbloqueado";
					--print("CAJA NIVEL "..capaNivel.nivel.."="..j.." "..capaNivel.estado);
					
				elseif(j~=capaNivel.nivel)then
					--print("CAJA NIVEL "..capaNivel.nivel.." BLOCK");
					capaNivel.estado="bloqueado";
					
				end
			end
			local candado=display.newImageRect(capaNivel,"media/candado.png",_TAM_CAND,_TAM_CAND);
			candado.x,candado.y=_TAM,_TAM;
			candado:setReferencePoint(display.TopLeftReferencePoint);
			--local candado=display.newRect(capaNivel,_TAM-_DESF_CAND,_TAM-_DESF_CAND,_TAM_CAND,_TAM_CAND);
			--candado:setFillColor(250, 0, 0);
			capaNivel.candado=candado;			
		end

		acumulativo=acumulativo+1;
		cCajasNiveles.acumulativo=acumulativo;
		niveles[#niveles+1]=capaNivel;
		
		xx=xx+1;
	end
	return niveles;
end

cCajasNiveles.newCajasNiveles=function(_CANT,capa,pagina)
	cCajasNiveles._CANT=_CANT;
	--cCajasNiveles.acumulativo=1;
	cCajasNiveles.capaEscena=capa;
	local niveles=crearCajas(pagina);
	return niveles;
end

return cCajasNiveles;