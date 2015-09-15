local AutoStore=require("dmc_autostore");
local storyboard = require( "storyboard" );
local cHordas=require("levels.hordas");

--display.setStatusBar( display.HiddenStatusBar );

--BORRADO:

--[[for k,v in AutoStore.data:pairs() do
        AutoStore.data[k]=nil;
end
AutoStore.data=nil;]]

local setContJugado=function()
	local data=AutoStore.data;
	local oldContJugado=data.info.contJugado;
	data.info.contJugado=oldContJugado+1;
end

--INITAUTOSTORE:
local initAutoStore=function()
        print("CARGAMOS AUTO STORE");
        --Si ya existe el archivo:
        if not AutoStore.is_new_file then

    		local data=AutoStore.data;
            --DEBUG ESTRUCTURA DE DATOS:
            --[[for k,v in data:pairs() do
                    
                    if(type(v)=="table") then
                            print("\n"..tostring(k):upper()..":\n");
                            for kk,vv in data[k]:pairs() do
                                    if(type(vv)=="table") then
                                            print("\n"..tostring(kk):upper()..":\n");
                                            for kkk,vvv in data[k][kk]:pairs() do
                                                    print(kkk,vvv);
                                            end
                                    else
                                            print(kk,vv);
                                    end
                            end
                            print("\n------------------------------------------\n");
                    else
                            print("\n"..tostring(k):upper().." : "..v.."\n------------------------------------------\n");
                    end
            end]]
            return false;
        end
        --No existe el archivo asi que creamos uno:
        print("No existe el archivo asi que creamos uno");

        local data = AutoStore.data;
        
        data.app={
            version="1.3b",
            autor="Héctor Villar Mozo"
        };

        data.info={
            id=1,
            nombre="Hector",
            tiempoTotal=0,
            contJugado=0,
            fondos=2000,
        };

        data.niveles={};
        for i=1,5 do
            data.niveles[i]=
                {
                superado=0,--0: no , 1: si
                puntuacion=0,
                contJugado=0,
                contReiniciar=0,
                };
        end
        data.coleccion={
            {
                id=1,
                nombre="bomba",
                precio=100,--precio de cada unidad
                nivel_desb=3,--nivel a partir del cual se desbloquea el producto
                cant=5,--cuantas unidades tiene el usuario
                max=20,--maximo de unidades que puede tener el usuario
            },
            {
                id=2,
                nombre="muro",
                precio=200,--precio de cada unidad
                nivel_desb=4,--nivel a partir del cual se desbloquea el producto
                cant=0,--cuantas unidades tiene el usuario
                max=20,--maximo de unidades que puede tener el usuario
            },
            {
                id=3,
                nombre="lluvia",
                precio=300,--precio de cada unidad
                nivel_desb=5,--nivel a partir del cual se desbloquea el producto
                cant=5,--cuantas unidades tiene el usuario
                max=20,--maximo de unidades que puede tener el usuario
            },
            {
                id=4,
                nombre="gallina",
                precio=400,--precio de cada unidad
                nivel_desb=6,--nivel a partir del cual se desbloquea el producto
                cant=5,--cuantas unidades tiene el usuario
                max=20,--maximo de unidades que puede tener el usuario
            },
            {
                id=5,
                nombre="spray",
                precio=500,--precio de cada unidad
                nivel_desb=7,--nivel a partir del cual se desbloquea el producto
                cant=5,--cuantas unidades tiene el usuario
                max=20,--maximo de unidades que puede tener el usuario
            }
        };
        return true;   
end

--DOESFILEEXISTS:
function doesFileExist( fname, path )

    local results = false
    local filePath = system.pathForFile( fname, path );
    --filePath will be 'nil' if file doesn't exist and the path is 'system.ResourceDirectory'
    if ( filePath ) then
        filePath = io.open( filePath, "w" );
    end

    if ( filePath ) then
        print( "File found: " .. fname )
        --clean up file handles
        filePath:close()
        results = true
    else
        print( "File does not exist: " .. fname )
    end
    return results
end

mainInfo={
	ultimo_nivel=0,
	ultimo_ejercito=0,--Para almacenar la ultima horda que hemos ejecutado (reinicio de nivel desde GM)
	ultimo_mensajes={}	
};

estado="PRINCIPAL";

--PROVISIONAL, para mandar a lienzo unicamente sin pasar por eleccion
local nivel=cHordas.buscarNivel(1);
local id=nivel.id;
local ejercito=nivel.ejercito;--devuelve ejercito del diccionario hordas.lua segun su nivel
local mensajes=nivel.mensajes;--devuelve mensajes del diccionario hordas.lua segun su nivel (UNIFICAR LOS DOS METODOS???)

local params = {};
if(mensajes ~= nil)then
	params = 
    { 
        id = id, 
        ejercito = ejercito, 
        mensajes = mensajes 
    }
else
	print( "No hay mensajes para este nivel" );
	params = { 
        id = id,
        ejercito = ejercito 
    }
end
local options =
{
    effect = "slideRight",
    time = 1000,
    params = params
}

--Ahora no queremos que nos aparezca la pantalla de "Eleccion de niveles" siempre
--storyboard.gotoScene("screens.eleccion",options);
--Vamos al lienzo directamente:

--Arrancamos auto_store (sist. de guardado):
local results = doesFileExist( "dmc_autostore.cfg", system.DocumentsDirectory )
local inicio=true;
if(results)then
    inicio=initAutoStore();
    setContJugado(1);--Sumamos 1 al contador de veces abierta la aplicacion
end

--storyboard.gotoScene("screens.lienzo",options);
--storyboard.gotoScene("screens.tienda");
--if(inicio==false)then
    storyboard.gotoScene("screens.principal");
--end
--[[else
    --Enseñamos comic inicial:
    local options={
        effect = "slideRight",
        time = 1000,
        params = {
            idComic=1
        }
    };
    storyboard.gotoScene("comics.quiosco",options);
end]]


