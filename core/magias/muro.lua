local Muro={};

--print("Cargando muro");

local _VIDA=10;--10 segundos (luego se multiplica x 1000)
local _DIST_MIN_DESP=140;
local _VEL_ALPHA=1000;


--[[local eliminarMuro=function(target)
    if(target)then
        target:removeSelf();
    end
end]]

local colision;
local rotateObj;

local quitarMuro=function(target)
    local target=target;
    local tnt=Muro.tnt;
    if(target~=nil)then
        local trans1 = tnt:newTransition(
            target, 
                {
                time = _VEL_ALPHA, 
                alpha = 0,
                name = 'Slide Transition', 
                userData = 'User data', 
                cycle = 1, 
                backAndForth = false, 
                onEnd = function (object, event) 
                    if(object~=nil)then
                        target:removeEventListener("collision", colision);
                        target:removeEventListener("touch", rotateObj);
                        target:removeSelf();
                    end
                end
                }
            );
        --transition.to(target, {time = _VEL_ALPHA, alpha = 0, onComplete = function()if(target~=nil)then target:removeSelf();end;end})
    end
end

--MANEJADOR EVENTO COLLISION:
colision=function(event)
    local phase=event.phase;
    local target=event.target;
    local other=event.other;

    if(target.estado=="activo")then

        local distX=math.abs(target.x-target.x1);
        local distY=math.abs(target.y-target.y1);
        local totalDist=distX+distY;
        --print("DISTX: "..distX,"DISTY:  "..distY);
        if(totalDist>_DIST_MIN_DESP)then-- and distY>_DIST_MIN_DESP)then--Si lo han desplazado mucho en el eje X o Y
            --quitarMuro(target);--eliminamos
            target.estado="inactivo";
            return true;
        end
    end
end

rotateObj=function(event)
    local target = event.target
    local phase = event.phase
    if(target.girado==false)then
        if (phase == "began") then
            display.getCurrentStage():setFocus( target );
            target.isFocus = true;
            
            -- Store initial position of finger
            target.x1 = event.x;
            target.y1 = event.y;
                
        elseif target.isFocus then
            if (phase == "moved") then
                target.x2 = event.x;
                target.y2 = event.y;
                
                angle1 = 180/math.pi * math.atan2(target.y1 - target.y , target.x1 - target.x);
                angle2 = 180/math.pi * math.atan2(target.y2 - target.y , target.x2 - target.x);
                
                rotationAmt = angle1 - angle2;

                target.rotation = target.rotation - rotationAmt;
                ----print ("t.rotation = "..t.rotation)
                
                target.x1 = target.x2;
                target.y1 = target.y2;
                    
            elseif (phase == "ended") then
                    
                display.getCurrentStage():setFocus( nil );
                target.isFocus = false;
                target.girado=true;--Solo puede ser girado una vez
                
            end
        end
        
        -- Stop further propagation of touch event
        return true
    end
end

local newMuro=function(xx,yy)
    local capa=Muro.capa;
    local tnt=Muro.tnt;
	local clon=display.newRect(capa,xx,yy,100,30);
	physics.addBody(clon, {density = 1.0, friction = 0.3, bounce = 0.2, isSensor = false});

	clon:setFillColor( 0, 255, 0 );
    clon.vida=_VIDA;
	clon.estado="activo";
	clon.girado=false;
    clon.x1=xx;
    clon.y1=yy;
    clon:addEventListener("collision", colision);
	clon:addEventListener("touch", rotateObj);
    local vida=_VIDA*1000;
    local timer1=tnt:newTimer(vida, function()quitarMuro(clon);end, 1);
    --timer.performWithDelay(vida, function()quitarMuro(clon);end, 1);
    local objetos=Muro.objetos;
	objetos[#objetos+1]=clon;
	--print(#objetos);
end
Muro.newMuro=newMuro;

local initMuro=function(capa,objetos,tnt)
    Muro.capa=capa;
    Muro.objetos=objetos;
    Muro.tnt=tnt;
end
Muro.initMuro=initMuro;

return Muro;