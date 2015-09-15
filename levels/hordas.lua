local cHordas={};

-- 0: HORMIGA, 1: CARACOL, 2: ORUGA, 3: ARANA, 4: ESCARABAJO, 5: MOSCA
--DICCIONARIO DE NIVELES:
local hordas=
{
    {
        id=1,
        mensajes={
            --{mom=4000,desc="¡Hola, Julio!"},
            --{mom=16000,desc="¿Molestan estos mensajes?"},
            --{mom=18000,desc="Sigo aquí!"}
        },
        ejercito={
            {mom=1000,ene={0}},
            {mom=2000,ene={0,0}},
            {mom=1000,ene={0,0,0}},
            --]]
        }
    },
    {
        id=2,
        ejercito={
            {mom=2000,ene={1,1,1,1}},
            {mom=2000,ene={1,0,1,1,1,0,1}},
            {mom=2000,ene={1,0,1,1,1,0,1}},
            {mom=2000,ene={0,1,0,1,0,1,0}},
            {mom=2000,ene={1,0,1,4,1,0,1}},
            {mom=2000,ene={0,2,0,1,0,1,0}},
            {mom=2000,ene={1,1,1,0,2,0,1}},
            {mom=2000,ene={0,0,4,0,0,2,0}},
            {mom=2000,ene={2,0,1,0,1,0,1}},
            {mom=2000,ene={2,0,2,0,2,0,0}},
            {mom=2000,ene={1,0,1,0,1,0,1}},
            {mom=2000,ene={0,2,0,2,0,2,0}},
            {mom=2000,ene={1,0,2,0,1,0,1}},
            {mom=2000,ene={0,2,0,2,0,2,0}},
            {mom=2000,ene={1,0,1,0,1,0,1}},
            {mom=2000,ene={0,2,0,0,2,1,0}},
        }
    },
    {
        id=3,
        ejercito={
            {mom=2000,ene={3,1,3,1}},
            {mom=2000,ene={0,1,2,1,3,2,1,3,1,0}},
            {mom=4000,ene={0,3}},
            {mom=100,ene={0,3}},
            {mom=100,ene={0,3,3,1,0,0,1}},
            {mom=4000,ene={0,1,3,0,1,2,3}},
            {mom=2000,ene={3,2,0,1,3,2,0}},
            {mom=100,ene={0,3,1,0,3,2,0}},
            {mom=100,ene={0,0}},
            {mom=100,ene={0,2,1,0,3,0,3}},
            {mom=2000,ene={0,0}},
            {mom=2000,ene={1,0,1,0,1,0,3}},
            {mom=2000,ene={0,1,0,2,1,3,0}},
            {mom=2000,ene={0,0,1,0,1,2,0}},
            {mom=2000,ene={0,0}},
            {mom=2000,ene={0,1,2,1,0,1,2}},
            {mom=2000,ene={0}},
            {mom=2000,ene={0,1,0,0,0,1,0}},
            {mom=2000,ene={2,0,1,0,1,2,0}},
            {mom=2000,ene={0}},
            {mom=2000,ene={0,2,1,0,1,2,1}},
        }
    },
    {
        id=4,
        mensajes={
            --{mom=4000,desc="Bienvenido al cuarto nivel!"}
        },
        ejercito={
            {mom=2000,ene={4,1,4,1,4,2,4}},
            {mom=6000,ene={4,3,4,5,4,2,4}},
            {mom=6000,ene={1,5,4,3,4,2,4}},
            {mom=6000,ene={2,4,3,4,2,5,4}},
            {mom=6000,ene={1,2,4,3,5,2,1}},
            {mom=6000,ene={4,4,4,4,4,4,4}},
            {mom=6000,ene={4,4,4,4,4,4,4}},
            {mom=6000,ene={4,4,4,4,4,4,4}},
            {mom=6000,ene={4,2,4,2,2,2,2}},
            {mom=6000,ene={4,5,4,2,4,2,2}},
            {mom=6000,ene={2,2,2,2,2,4,2}},
            {mom=6000,ene={2,2,2,2,2,2,2}},
            {mom=6000,ene={2,4,2,2,4,2,2}},
            {mom=6000,ene={2,2,2,2,2,2,2}},
            {mom=6000,ene={2,2,2,2,2,2,2}},
            {mom=6000,ene={2,2,2,2,2,2,2}},
            {mom=6000,ene={2,2,2,2,2,2,2}},
            {mom=6000,ene={2,2,2,2,2,2,2}},
            {mom=6000,ene={2,2,2,2,2,2,2}},

        }
    },
    {
        id=5,
        ejercito={
            {mom=1000,ene={5}},
            {mom=1000,ene={5}},
            {mom=6000,ene={5,5,5,3,4,2,2}},
            --{mom=2000,ene={3,2,0,1,3,2,0}},
            --{mom=1000,ene={5}},
            --{mom=1000,ene={5}},
            --{mom=6000,ene={2,5,2,2,5,2,2}},
        }
    },
    {
        id=6,
        --mensajes={
            --{mom=2000,desc="Esto es el nivel SEIS!!"}
        --},
        ejercito={
            {mom=2000,ene={5}},
            {mom=2000,ene={5,5}},
            {mom=2000,ene={5,5}},
            {mom=2000,ene={5}},
            {mom=2000,ene={5}},
            {mom=2000,ene={5}},
            {mom=2000,ene={1,0,3}},
            {mom=2000,ene={4}},
            {mom=2000,ene={1,2,3,4,5}},
        }
    },
    {
        id=7,
         mensajes={
            --{mom=2000,desc="Esto es el nivel SIETE!!"}
        },
        ejercito={
            {mom=1000,ene={0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
        }
    },
    {
        id=8,
        ejercito={
            {mom=1000,ene={0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,}},
            {mom=1000,ene={0,0,0,0,0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}},
            {mom=1000,ene={0,0,0,0,0,0,0}},
        }
    },
    {
        id=9,
        mensajes={
            --{mom=2000,desc="A partir de aqui todos \nlos niveles son cortos"}
        },
        ejercito={
            {mom=2000,ene={0,0,0,0,0,0}}
        }
    },
    {
        id=10,
        ejercito={
            {mom=2000,ene={0,0,0,0,0,0}}
        }
    },
    {
        id=11,
        ejercito={
            {mom=2000,ene={0,0,0,0,0,0}}
        }
    },
    {
        id=12,
        ejercito={
            {mom=2000,ene={0,0,0,0,0,0}}
        }
    },
    {
        id=13,
        ejercito={
            {mom=2000,ene={0,0,0,0,0,0}}
        }
    },
    {
        id=14,
        ejercito={
            {mom=2000,ene={0,0,0,0,0,0}}
        }
    },
    {
        id=15,
        ejercito={
            {mom=2000,ene={0,0,0,0,0,0}}
        }
    },
     {
        id=16,
        ejercito={
            {mom=2000,ene={0,0,0,0,0,0}}
        }
    }
};

--BUSCAR NIVEL:
local buscarNivel=function(id)
    for i=1,#hordas do
        if(hordas[i]["id"]==id)then
            return hordas[i];--devolvemos la tabla de todo el id (id, mensajes, ejercito)
        end
    end
    local tablaVacia={};
    return tablaVacia;
end
cHordas.buscarNivel=buscarNivel;

return cHordas;