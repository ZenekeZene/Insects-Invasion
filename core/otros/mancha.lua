local cMancha={};
--print("CARGAMOS LAS MANCHAS");

local _TIME_MANCHA_ALPHA=10000;

--BORRAR:
local borrarMancha=function(mancha)
	mancha:removeSelf();
end
cMancha.borrarMancha=borrarMancha;

--NEW:
local newMancha=function(xx,yy)
	--puntos=puntos+1;
	--txtPuntos.text=puntos;

	local mancha=display.newSprite(cMancha.capaManchas,cMancha.sprManchas,cMancha.secManchas);
	mancha:setSequence("Manchas");
	local frame=math.random(1,6);
	mancha:setFrame(frame);
	mancha.x=xx;
	mancha.y=yy;
	local rot=math.random(1,360);
	mancha:rotate(rot);
	local tam=math.random(0.1,0.5);
	mancha.xScale=0.5+tam
	mancha.yScale=0.5+tam;

	local trans1=cMancha.tnt:newTransition(mancha, {time = _TIME_MANCHA_ALPHA, alpha = 0, onComplete = function()borrarMancha(mancha);end});
	--transition.to(mancha, {time = _TIME_MANCHA_ALPHA, alpha = 0, onComplete = function()borrarMancha(mancha);end})

	return mancha;
end
cMancha.newMancha=newMancha;

--INIT:
local initMancha=function(capa,tnt)
	--cMancha.prop=prop;
	cMancha.capaManchas=capa;
	cMancha.tnt=tnt;

	local sprOptManchas={
		width=256,
		height=256,
		numFrames=8,
		sheetContentWidth=512,
		sheetContentHeight=1024
	}

	cMancha.sprManchas = graphics.newImageSheet( "core/otros/sprManchas.png", sprOptManchas);

	cMancha.secManchas = {
		{
		name="Manchas",
		frames={1,2,3,4,5,6,7},
		time=0,
		loopCount=0,
		loopDirection = "forward"
		}
	}
end
cMancha.initMancha=initMancha;

return cMancha;