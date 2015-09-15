local cManchaVol={};
--print("CARGAMOS LAS MANCHAS");

local _TIME_MANCHA_ALPHA=800;

--BORRAR:
local borrarMancha=function(mancha)
	mancha:removeSelf();
end
cManchaVol.borrarMancha=borrarMancha;

--NEW:
local newMancha=function(xx,yy,rot)
	--puntos=puntos+1;
	--txtPuntos.text=puntos;

	local mancha=display.newSprite(cManchaVol.capaManchas,cManchaVol.sprManchasVol,cManchaVol.secManchaVols);
	mancha:setReferencePoint(display.CenterReferencePoint);
	mancha:setSequence("Manchas");
	mancha:play();
	--local frame=math.random(1,6);
	--mancha:setFrame(frame);
	mancha.x=xx+50;
	mancha.y=yy;
	mancha.rotation=rot;
	--local rot=math.random(1,360);
	--local rot=90;
	mancha:rotate(rot);
	--local tam=math.random(0.1,0.5);
	--mancha.xScale=0.5+tam
	--mancha.yScale=0.5+tam;

	local trans1=cManchaVol.tnt:newTransition(mancha, {time = _TIME_MANCHA_ALPHA, alpha = 0, onComplete = function()borrarMancha(mancha);end});
	--transition.to(mancha, {time = _TIME_MANCHA_ALPHA, alpha = 0, onComplete = function()borrarMancha(mancha);end})

	return mancha;
end
cManchaVol.newMancha=newMancha;

--INIT:
local initMancha=function(capa,tnt)
	--cManchaVol.prop=prop;
	cManchaVol.capaManchas=capa;
	cManchaVol.tnt=tnt;

	local sprOptManchas={
		width=107,
		height=107,
		numFrames=8,
		sheetContentWidth=512,
		sheetContentHeight=256
	}

	cManchaVol.sprManchasVol = graphics.newImageSheet( "core/otros/sprManchaVol.png", sprOptManchas);

	cManchaVol.secManchaVols = {
		{
		name="Manchas",
		start=1,
		count=8,
		time=500,
		loopCount=1,
		loopDirection = "forward"
		}
	}
end
cManchaVol.initMancha=initMancha;

return cManchaVol;