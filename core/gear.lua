
--------------------------------------------------------------------------------------
local cGear={};
--------------------------------------------------------------------------------------
local storyboard=require("storyboard");

local hordas={};
local k=1;
local timerin;
local timerin2;
local j=1;
local timerCreacion;
local _MINI_CAD=10;

local _VEL_MAREO=0.5;--velociadad a la que van los enemigos al estar envenenados

local finalizadoHordas=false;

--COMPROBAR SI ES ULTIMO:
local comprobarSiEsUltimo=function()
    if(finalizadoHordas==true)then
        if(#cGear.enemigos<=1 and k>=#cGear.hordas)then
            print("ya no quedan");
            return true;
        end
    end
    print("Quedan");
    return false;
end
cGear.comprobarSiEsUltimo=comprobarSiEsUltimo;
--[[----------------------------------------------------------------------------------
-
-   A.-MOTOR ( enterframe ):
-
------------------------------------------------------------------------------------]]
local motor=function()
    --debug de hijos de las principales capas (init.objCapas):
    --print("------------------------");
    --for k,v in pairs(cGear.init.capas) do
        --print(k,v.numChildren);
    --end
    --print("RRrrmmmmmm...");

    --lblEstado.text=estado;

    ------------------------------------------------------------------------------------------

    for i=#cGear.enemigos,0,-1 do
        local ene=cGear.enemigos[i];
        if(ene~=nil)then
            if(ene.estado==0)then--enemigo VIVO:
                if(ene.clase=="terrestre")then
                    cGear.fin.doFollow (ene, cGear.planta.inst,ene.vel,100);
                elseif(ene.clase=="volador" and ene.paso=="orbitando")then
                    cGear.fin.doFollow (ene, cGear.planta.inst,0.00001,100);
                    ene.joint.length=ene.joint.length-ene.vel;
                end
                
                local distancia=cGear.fin.distanceBetween(ene,cGear.planta.inst);
                if(distancia<cGear.planta._DISTANCIA_ATAQUE and distancia~=nil)then
                    
                    if(ene.clase=="volador" and ene.paso=="orbitando")then
                        ene.estado=3;--si estamos cerca de la planta, pasamos a estado 3.-Atacar
                        cGear.enemi.cambiarSecuencia(ene,"Incorporar");
                         --cGear.fin.doFollow (ene, cGear.planta.inst,0.00001,100);
                        --cGear.enemi.angularDamping=10000;
                    elseif(ene.clase~="volador")then
                        ene.estado=3;--si estamos cerca de la planta, pasamos a estado 3.-Atacar
                        cGear.enemi.cambiarSecuencia(ene,"Atacar");
                    end
                end
            elseif(ene.estado==1)then--ENEMIGO PAUSADO:
                if(ene.clase=="terrestre")then
                    cGear.fin.doFollow (ene, cGear.planta.inst,0.00001,100);--hack 0.000001
                elseif(ene.clase=="volador")then
                    --ene:setLinearVelocity(0,0);

                end
                
            elseif(ene.estado==2)then--ENEMIGO MUERTO:
                
                local final=comprobarSiEsUltimo();
                if(final==true)then
                    --Pausamos:
                    cGear.pausar();
                    --Enseñamos mensaje final:
                    cGear.UI.objMsjFinal.sacar(cGear.nivel);

                end

                --Sacamos puntos:
                local xx,yy=ene.x,ene.y;
                local punt=ene.puntos;
                cGear.sacarPuntos(xx,yy,punt);

                
                if(ene.clase=="volador")then

                    --Creamos mancha de voladores:
                    if(ene.xx~=nil and ene.rot~=nil)then
                        local xx,yy,rot=ene.xx,ene.yy,ene.rot;
                        cGear.manchaVol.newMancha(xx,yy,rot);
                    else
                        local xx,yy=ene.x,ene.y;
                        cGear.tnt:newTimer(1, function()cGear.mancha.newMancha(xx,yy);end, 1);
                    end
                else
                    --Creamos mancha de terrestres:
                    local xx,yy=ene.x,ene.y;
                    cGear.tnt:newTimer(1, function()cGear.mancha.newMancha(xx,yy);end, 1);
                end

                --Borramos enemigo:
                ene:removeSelf();
                table.remove(cGear.enemigos, i );
                ene=nil;
                
            elseif(ene.estado==3)then--enemigo ATACANDO:
                if(ene.clase=="terrestre")then
                    cGear.fin.doFollow (ene, cGear.planta.inst,0.1,100);
                elseif(ene.clase=="volador")then --and ene.paso=="orbitando")then
                    cGear.fin.doFollow( ene, cGear.planta.inst,0.00001,100);
                    ene:setLinearVelocity(0,0);
                end
                local distancia=cGear.fin.distanceBetween(ene,cGear.planta.inst);
                if(distancia>=cGear.planta._DISTANCIA_ATAQUE and distancia~=nil)then
                    ene.estado=0;--Si estamos atacando y nos alejamos, pasamos a estado 0.-Normal
                    cGear.enemi.cambiarSecuencia(ene,"Caminar");
                end
            elseif(ene.estado==4)then--enemigo ENVENENADO

                cGear.fin.doFollow(ene, ene.objetivoMareo,_VEL_MAREO,1);
            end
        end
    end
end
cGear.motor=motor;

--[[----------------------------------------------------------------------------------
-
-   B.-PUNTOS:
-    
------------------------------------------------------------------------------------]]

--  B.1.- Calcular punto aleatorio :
local calcularPuntoCentral=function()
    local rand=math.random(1,#cGear.pOrigen);
    local pto=cGear.pOrigen[rand];
    
    local xx=pto[1];
    local yy=pto[2];
    
    return xx,yy;
end
cGear.calcularPuntoCentral=calcularPuntoCentral;

--  B2.- Calcular puntos alreredor del punto central :
local crearPuntoAlrededor=function(tam,xx,yy)
    local numPoints = tam;
    local xCenter = xx;
    local yCenter = yy;
    local radius = 10;
    
    local angleStep = 2 * math.pi / numPoints
    
    xx=xCenter + radius*math.cos(j*angleStep);
    yy=yCenter + radius*math.sin(j*angleStep);
    
    return xx,yy;
end
cGear.crearPuntoAlrededor=crearPuntoAlrededor;

--[[----------------------------------------------------------------------------------
-
-   C.-HORDAS/ENEMIGOS:
-
------------------------------------------------------------------------------------]]
--  C.1.-Crear enemigo:
local crearEnemigo=function(xx,yy,tipo)
    
    ----print("Creamos bicho #"..j.." de tipo"..tipo);
    
    local enemigo={};
    
    --Dependiendo de su tipo instanciamos un bicho u otro:
    if(tipo==0)then
        --HORMIGA
        enemigo=cGear.enemi.hormiga.newHormiga(xx,yy);
    elseif(tipo==1)then
        --CARACOL:
        enemigo=cGear.enemi.caracol.newCaracol(xx,yy);
    elseif(tipo==2)then
        --ORUGA:
        enemigo=cGear.enemi.oruga.newOruga(xx,yy);
    elseif(tipo==3)then
        --ARANA:
        enemigo=cGear.enemi.arana.newArana(xx,yy);
    elseif(tipo==4)then
        --ESCARABAJO:
        enemigo=cGear.enemi.escarabajo.newEscarabajo(xx,yy);
    elseif(tipo==5)then
        --MOSCA:
        enemigo=cGear.enemi.mosca.newMosca(xx,yy);
    end
    
    if(estado=="PAUSA")then
        enemigo.estado=1;
    end
    --Lo añadimos al array de enemigos:
    cGear.enemigos[#cGear.enemigos+1]=enemigo;
    enemigo.index=#cGear.enemigos;
    
    j=j+1;
    
    if(estado=="NORMAL")then
        --Si hemos acabado de instanciar todos los bichos de esta horda...
        if(j>#cGear.hordas[k].ene)then
            --comprobamos si quedan mas hordas, de ser asi la iniciamos:
            if(k<#cGear.hordas)then
                k=k+1;
                timerin2=cGear.tnt:newTimer(cGear.hordas[k].mom,cGear.crearHorda,cGear.moms);  
            else
                print("K:"..k.."#cGear.hordas:"..#cGear.hordas[k].ene);
                print("Finalizadas todas las hordas");
                finalizadoHordas=true;
            end
        end
    else
        print("Esta en pausa y por eso no podemos pasar a la siguiente horda.");
    end
end

--  C.2.-Crear horda de enemigos:
local crearHorda=function()
    
    if(estado=="NORMAL")then
        print("HORDA "..k);
        local _TAM_HORDA=#cGear.hordas[k].ene;
        
        j=1;
        if(timerCreacion~=nil)then
            timer.cancel(timerCreacion);
        end

        --Punto de nacimiento del enemigo:
        local xx,yy;
        if(cGear.hordas[k].pto==nil)then
            xx,yy=calcularPuntoCentral();
        else
            --print("Esta horda tiene punto de nacimiento fijo.");
            xx,yy=cGear.hordas[k].pto[1],cGear.hordas[k].pto[2];
        end
        
        --Llamamos a la creacion de los enemigos de esta horda:
        local timerCreacion=cGear.tnt:newTimer(
            _MINI_CAD,--cadencia entre enemigo y enemigo de la misma horda  
             function()--creamos enemigo
                xx,yy=crearPuntoAlrededor(_TAM_HORDA,xx,yy);
                crearEnemigo(xx,yy,cGear.hordas[k].ene[j]);
            end,
              _TAM_HORDA);--tantas veces como enemigos haya en la horda                     
            
        if(timerin~=nil)then
            timerin:cancel();
        end
        if(timerin2~=nil)then
            timerin2:cancel();
        end
    end
end
cGear.crearHorda=crearHorda;

--[[----------------------------------------------------------------------------------
-
-   D.TIMING:
-
------------------------------------------------------------------------------------]]
--REANUDAR:
local reanudar=function()
    print("REANUDAR");

    physics.start();

    --Cambiamos de estado:
    if(estado=="PAUSA")then
        estado="NORMAL";
    end

    --Reanudamos a todos los enemigos (estado=0 [ motor->vivo ] y play [sec. animacion]):
    for i=#cGear.enemigos,1,-1 do
        local ene=cGear.enemigos[i];
        ene.estado=0;
        ene:play();

        if(ene.clase=="volador")then
            print(ene:getLinearVelocity());
            --ene:setLinearVelocity(100,100);
            --ene.sombra:setLinearVelocity(100,100);
        end
    end

    --Volvemos a asociar el evento de tap al boton de pausa:
    cGear.UI.objBtnPausa:addEventListener("touch", cGear.UI.manejarPausa);

    --Reanudamos transiciones/timers (efectos magias, cloros, aguas, crearHordas, etc):
    cGear.tnt:resumeAllTransitions();
    cGear.tnt:resumeAllTimers();

    --Re-arrancamos motor:º
    Runtime:addEventListener("enterFrame", motor);
end
cGear.reanudar=reanudar;

--PAUSAR:
local pausar=function()
    estado="PAUSA";
    --lblEstado.text=estado;
    for i=#cGear.enemigos,1,-1 do
        local ene=cGear.enemigos[i];
        ene.estado=1;
        ene:pause();
        if(ene.clase=="volador")then
           -- ene:setLinearVelocity(0,0);
           physics.pause();
            --ene.sombra:setLinearVelocity(0,0);
            --print(ene:getLinearVelocity());
        end
        
    end
    
    cGear.tnt:pauseAllTransitions();
    cGear.tnt:pauseAllTimers();

    --Quitamos motor:
    Runtime:removeEventListener("enterFrame", motor);
end
cGear.pausar=pausar;

--ELIMINAR (llamamos desde lienzo):
local eliminar=function()
    print("SALIMOS!!!");
    estado="SALIR";
   --Matamos a todos los enemigos:
    for i=#cGear.enemigos,1,-1 do
        local ene=cGear.enemigos[i];
        if(ene.clase=="volador")then
            --Quitamos conexion con planta:
            --FALTA

            --Quitamos sombra y su timer:
            ene.timerSombra:cancel();
            ene.timerSombra=nil;
            ene.sombra.joint:removeSelf();
            ene.sombra:removeSelf();
        end
        ene.estado=2;
    end
    --Borramos capa objetos:


    --Borramos capa clorofilas:
    for i=#cGear.init.capas.capaClorofilas,1,-1 do
        local cloro=cGear.init.capas.capaClorofilas[i];
        cloro:removeSelf();
    end

    --Quitamos los enterFrame del spray:
    cGear.killSpray();
    --Quitamos el motor:
    Runtime:removeEventListener("enterFrame", motor);
    --Cancelamos todos las transiciones/timers:
    cGear.tnt:cancelAllTransitions();
    cGear.tnt:cancelAllTimers();

    collectgarbage();

end
cGear.eliminar=eliminar;

local irTienda=function()
    print("VAMOS A LA TIENDA");
    estado="TIENDA";
    storyboard.removeScene("screens.tienda");
    storyboard.gotoScene("screens.tienda");
    storyboard.purgeScene("screens.lienzo");
    storyboard.removeScene("screens.lienzo");
    collectgarbage();

end
cGear.irTienda=irTienda;

local irEleccion=function(desdeMsjFinal)
    local desdeMsjFinal = desdeMsjFinal or false;
    if(desdeMsjFinal)then
        eliminar();
        estado="ELECCION";
        storyboard.removeScene("screens.eleccion");
        local options =
            {
                effect = "slideUp",
                time = 100,
                params= { desdeMsjFinal=true, reiniciar = false , nivelOld = cGear.nivel}
            }
        storyboard.gotoScene("screens.eleccion",options);
        storyboard.purgeScene("screens.lienzo");
        storyboard.removeScene("screens.lienzo");
        collectgarbage();
    else
        eliminar();
        estado="ELECCION";
        storyboard.removeScene("screens.eleccion");
        local options =
            {
                effect = "slideUp",
                time = 100,
                params= { reiniciar = false , nivelOld = cGear.nivel}
            }
        storyboard.gotoScene("screens.eleccion",options);
        storyboard.purgeScene("screens.lienzo");
        storyboard.removeScene("screens.lienzo");
        collectgarbage();
    end
end
cGear.irEleccion=irEleccion;

local irSiguiente=function()
    print("VAMOS AL SIGUIENTE.");

    eliminar();

    storyboard.removeScene("screens.eleccion");
    local options =
        {
            effect = "slideUp",
            time = 1,
            params= { reiniciar = false , irSiguiente = true , nivelOld=cGear.nivel}
        }
    storyboard.gotoScene("screens.eleccion",options);
    storyboard.purgeScene("screens.lienzo");
    storyboard.removeScene("screens.lienzo");
end
cGear.irSiguiente=irSiguiente;

--REINICIAR:
local reiniciar=function(desdeMsjFinal)
    local desdeMsjFinal = desdeMsjFinal or false;
    if(desdeMsjFinal)then
         eliminar();
        --Reiniciamos vida de la planta, puntos
        timer.performWithDelay(1000,function()
            --Reseteamos las la vida de la planta, puntos, etc:
            cGear.planta.vida=cGear.planta.vidaOrigin;
            cGear.init.prop.puntos=0;
            cGear.planta.txtVida.text=cGear.planta.vidaOrigin;
            cGear.UI.objPuntos.txtPuntos.text=0;
            --Falta clorofilas, aguas, flores, etc:
        end,1);
        timer.performWithDelay(1, function() collectgarbage(); end,1);

        estado="REINICIAR";
        storyboard.removeScene("screens.eleccion");
        local options =
                {
                    effect = "slideUp",
                    time = 1,
                    params= { desdeMsjFinal=true, nivelOld=cGear.nivel,reiniciar = true }
                }
        storyboard.gotoScene("screens.eleccion",options);
        storyboard.purgeScene("screens.lienzo");
        storyboard.removeScene("screens.lienzo");
        collectgarbage();
    else
        eliminar();
        --Reiniciamos vida de la planta, puntos
        timer.performWithDelay(1000,function()
            --Reseteamos las la vida de la planta, puntos, etc:
            cGear.planta.vida=cGear.planta.vidaOrigin;
            cGear.init.prop.puntos=0;
            cGear.planta.txtVida.text=cGear.planta.vidaOrigin;
            cGear.UI.objPuntos.txtPuntos.text=0;
            --Falta clorofilas, aguas, flores, etc:
        end,1);
        timer.performWithDelay(1, function() collectgarbage(); end,1);

        estado="REINICIAR";
        storyboard.removeScene("screens.eleccion");
        local options =
                {
                    effect = "slideUp",
                    time = 1,
                    params= { reiniciar = true }
                }
        storyboard.gotoScene("screens.eleccion",options);
        storyboard.purgeScene("screens.lienzo");
        storyboard.removeScene("screens.lienzo");
        collectgarbage();
    end
   
    
end
cGear.reiniciar=reiniciar;

--EMPEZAR:
local empezar=function()
    estado="NORMAL";
    --print("EMPEZAMOS!!!!!");
    collectgarbage();
    finalizadoHordas=false;
    --Arrancamos motor y creacion de hordas:
    Runtime:addEventListener("enterFrame", motor);
    timerin=cGear.tnt:newTimer(cGear.hordas[1].mom, crearHorda, 1);

    --cGear.imprimirMem(100);
end
cGear.empezar=empezar;

--[[----------------------------------------------------------------------------------
-
-   E.-SETTERS:
-
------------------------------------------------------------------------------------]]

--  E.1.-Set nivel de la pausa:
local setNivelPausa=function(nivel,mensajes)
    cGear.nivel=nivel;
    cGear.UI.setNivelPausa(cGear.nivel,cGear.reanudar,cGear.reiniciar,cGear.eliminar,cGear.irEleccion,cGear.irSiguiente,cGear.irTienda);
end
cGear.setNivelPausa=setNivelPausa;

--  E.2.-Set Horda:
local setHorda=function(horda)
    print("METEMOS EL EJERCITO "..#horda);
    k=1;
    local horda=horda;
    if(#horda~=0)then
        cGear.hordas=horda;
        --Empezamos a crear las hordas
        cGear.empezar();--Empezamos en cuentaAtras??
    end
end
cGear.setHorda=setHorda;

--[[----------------------------------------------------------------------------------
-
-   F.-DEBUG:
-
------------------------------------------------------------------------------------]]
--  F.1.- Debug memoria sistema (LUA) :
local imprimirMem=function(cad)
    --Tamaño Del Garbage Collector (para ver un log del rendimiento)
    --print("G.C: "..math.round(collectgarbage("count")).." kb");
    --collectgarbage();--Invoca al collectgarbage (es idoneo estar invocandolo todo el rato, consumira mucha CPU?)
    --timer.performWithDelay(1, function() collectgarbage(); end);
    local memUsage_str = string.format( "MEMORY = %.3f KB", collectgarbage( "count" ) );
    print(memUsage_str);
    timer.performWithDelay(cad, function()cGear.imprimirMem(cad);end, 1);
end
cGear.imprimirMem=imprimirMem;

--  F.2.- Debug variables globales :
local imprimirGlobal=function()
    for key,value in pairs(_G) do
        print(key, ":", value)
    end
end
cGear.imprimirGlobal=imprimirGlobal;

--[[----------------------------------------------------------------------------------
-
-  G.-INIT:
-
------------------------------------------------------------------------------------]]
local initGear=function(init,UI,objetos,ene,planta,mancha,manchaVol,agua,tnt,killSpray,sacarPuntos)
    
    cGear.moms=#hordas;
    
    cGear.init=init;
    cGear.UI=UI;
    cGear.objetos=objetos;
    
    --Cargamos la libreria de movimiento de los enemigos:
    cGear.fin=cGear.init.mod.fin;
    
    cGear.enemi=ene;
    cGear.enemigos=ene.enemigos;
    cGear.pOrigen=ene.pOrigen;
    cGear.pOrigenName=ene.pOrigenName;
    
    cGear.planta=planta;
    cGear.mancha=mancha;
    cGear.manchaVol=manchaVol;
    cGear.aguas=agua.aguas;

    --Cargamos la libreria para pausar transiciones/timers:
    cGear.tnt=cGear.init.mod.tnt;

    cGear.killSpray=killSpray;

    cGear.sacarPuntos=sacarPuntos;
    
end
cGear.initGear=initGear;
---------------------------------------------------------------------------------------
return cGear;