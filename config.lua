application =
{

	content =
	{
		graphicsCompatibility = 1,
		width = 320,
		height = 480,
		scale = "letterbox",
		xAlign = "center",
        yAlign = "center",
		fps = 30,
		
		--[[
		imageSuffix =
		{
			    ["@2x"] = 2,
		},
		--]]
	},

	--[[
	-- Push notifications
	notification =
	{
		iphone =
		{
			types =
			{
				"badge", "sound", "alert", "newsstand"
			}
		}
	},
	--]]    
}
