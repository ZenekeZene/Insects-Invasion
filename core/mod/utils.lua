local Utils={};

local _LIN_DAMP_MOSCA=3;
local _ANG_DAMP_MOSCA=10;


-- Simple example:
-- 		local dragBody = gameUI.dragBody
-- 		object:addEventListener( "touch", dragBody )
local dragBody = function( event , params, planta)
	local body = event.target
	local phase = event.phase
	local stage = display.getCurrentStage();
	--
	local planta=planta;

	if "began" == phase then
		stage:setFocus( body, event.id )
		body.isFocus = true

		body.paso="agarrado";
		--Quitamos la union entre la mosca y la planta, para poder arrastrar bien:
		if(body.joint)then
			body.joint:removeSelf();
			body.joint=nil;
		end
		--Si ivamos a ponernos en orbita en breves, lo cancelamos:
		if(body.timerCad~=nil)then
			body.timerCad:cancel();
		end
		
		-- Create a temporary touch joint and store it in the object for later reference
		if params and params.center then
			-- drag the body from its center point
			body.tempJoint = physics.newJoint( "touch", body, body.x, body.y )
		else
			-- drag the body from the point where it was touched
			body.tempJoint = physics.newJoint( "touch", body, event.x, event.y )
		end

		-- Apply optional joint parameters
		if params then
			local maxForce, frequency, dampingRatio

			if params.maxForce then
				-- Internal default is (1000 * mass), so set this fairly high if setting manually
				body.tempJoint.maxForce = params.maxForce
			end
			
			if params.frequency then
				-- This is the response speed of the elastic joint: higher numbers = less lag/bounce
				body.tempJoint.frequency = params.frequency
			end
			
			if params.dampingRatio then
				-- Possible values: 0 (no damping) to 1.0 (critical damping)
				body.tempJoint.dampingRatio = params.dampingRatio
			end
		end
	
	elseif body.isFocus then
		if "moved" == phase then
		
			-- Update the joint to track the touch
			if(body.paso=="agarrado")then
				body.tempJoint:setTarget( event.x, event.y );
			elseif(body.paso=="resbalando")then
				body.tempJoint:removeSelf();
				stage:setFocus( body, nil );
				body.isFocus = false;
				return "aMedias";
			end

			if(body.estado==3)then
				body.tempJoint:removeSelf();
				stage:setFocus( body, nil );
				body.isFocus = false;
				return "aMedias";
			end

		elseif "ended" == phase or "cancelled" == phase then
			stage:setFocus( body, nil )
			body.isFocus = false

			-- Remove the joint when the touch ends			
			body.tempJoint:removeSelf();
			body.angularDamping=_ANG_DAMP_MOSCA;
			body.linearDamping=_LIN_DAMP_MOSCA;
			return "terminado";
		end
	end

	-- Stop further propagation of touch event
	return true;
end
Utils.dragBody=dragBody;

return Utils;