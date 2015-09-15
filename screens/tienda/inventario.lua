local inventario={};
local AutoStore=require("dmc_autostore");
local data;

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

--CARGAR COLECCION:
local cargarColeccion=function()
	print("INVENTARIOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO!!!!");
	--CARGAMOS LA COLECCION DEL INVENTARIO DESDE AUTOSTORE
	--SI NO EXISTE, LA CREAMOS Y GUARDAMOS EN AUTOSTORE
	--Arrancamos auto_store (sist. de guardado):
	local results = doesFileExist( "dmc_autostore.cfg", system.DocumentsDirectory )
	if(results)then


		data=AutoStore.data;
	    --Si ya existe el archivo:
        if (data.coleccion~=nil)then
        	
			 --DEBUG ESTRUCTURA DE DATOS:
                for k,v in data:pairs() do
                        
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
                end

			return;
		end
		--Sino, creamos estructura inicial:

		data=AutoStore.data;
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
			},
		};
		print("COLECCION CREADA.");
	end
end
inventario.cargarColeccion=cargarColeccion;

local getColeccion=function()
	data=AutoStore.data;
	local coleccion=data.coleccion;
	return coleccion;
end
inventario.getColeccion=getColeccion;

return inventario;