local mensajes={

	ini={
		"¡Bienvenido!\ncompre lo que necesite",
		"Hola, sea derrochador",
		"Ciaaaaao",
		"¡Que pasa maquinon!"
	},
	enun={
		"¡Compre compre compre!",
		"¡Gastese la pasta\n en bichos!",
		"Nada como matar hormigas\n a bombazos",
		"Ojo con el escarabajo\n Hercules. Tiende a ponerse\n muy nervioso.",
		"Lo mejor en jardineria\n a un precio ridiculo"
	},
	neg={
		"¡No tiene suficiente pasta!",
		"No cash, no pary",
		"Va a ser que no, ¡pobreton!"
	},
	afi={
		"Encantado de hacer negocios\ncontigo.",
		"Sabe comprar, ¡si señor!",
		"¿Algo más, jefe?"
	},
	desb={
		"Es usted todavia demasiado\n novatillo para comprar ",
		"No tiene usted el nivel suficiente."
	},
	prox={
		"PRrrrrrrrroximamente",
		"Mmmmmm no me quedan \n pero te pediré, vale?",
		"Aun no me han \ntraido de esto, lo siento"
	},
	max={
		"Ha llegado al maximo de unidades",
		"Compre otra cosa. De esto tiene mucho."
	}

};

--GET MENSAJE (devuelve un mensaje aleatorio de cierta categoria):
local getMensaje=function(categoria,articulo)
	local categoria=categoria;
	local msjRandom=math.random(1,#mensajes[categoria]);
	
		if(articulo and categoria=="desb")then
			return mensajes[categoria][msjRandom]..articulo;
		end
	return mensajes[categoria][msjRandom];
end
mensajes.getMensaje=getMensaje;

return mensajes;