local cCuentaAtras={};

local _TAM=1;
local _SIZE=350;
local _SEG=1000;

local terminar=function()
	--empezamos:
	--cCuentaAtras.empezar();
end

--SACAR NUM:
local sacarNum=function(ind)
	local objNum=cCuentaAtras.nums[ind];
	transition.to(
		objNum,
		{
			time=_SEG,
			alpha=1,
			width=250,
			height=450,
			onComplete=function() 
				transition.to(objNum,{
								time=_SEG,
								alpha=0,
								onComplete=function()
									if(ind==_TAM)then 
										terminar();
										return 1;
									end
								end
								}
							);
						end
		}
	);
end

--INIT:
local initCuentaAtras=function(capa,prop,empezar)
	cCuentaAtras.capaPadre=capa;
	cCuentaAtras.prop=prop;
	cCuentaAtras.empezar=empezar;
	cCuentaAtras.capa=display.newGroup();
	cCuentaAtras.capa.width,cCuentaAtras.capa.height=50,50;
	cCuentaAtras.capa.x,cCuentaAtras.capa.y=cCuentaAtras.prop._CENTRO.xx,cCuentaAtras.prop._CENTRO.yy-200;
	cCuentaAtras.nums={};
	local aux=_TAM-1;
	for i=_TAM,1,-1 do
		cCuentaAtras.nums[i]=display.newText(cCuentaAtras.capa,i, -100,0, "Helvetica", _SIZE);
		cCuentaAtras.nums[i]:setReferencePoint(display.CenterReferencePoint);
		cCuentaAtras.nums[i]:setTextColor(255,218,0);
		cCuentaAtras.nums[i].alpha=0;
		timer.performWithDelay((_TAM-aux)*_SEG, function() sacarNum(i);end, 1);
		aux=aux-1;
	end
end
cCuentaAtras.initCuentaAtras=initCuentaAtras;

return cCuentaAtras;