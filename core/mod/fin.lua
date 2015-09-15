
local fin = {}
 
fin.distanceBetween = function ( pos1, pos2 )
    local sqrt = math.sqrt
    if not pos1 or not pos2 then
        return false;
    end
    if not pos1.x or not pos1.y or not pos2.x or not pos2.y then
        return false;
    end
    local factor = { x = pos2.x - pos1.x, y = pos2.y - pos1.y }
    return sqrt( ( factor.x * factor.x ) + ( factor.y * factor.y ) )
end
 
fin.doFollow = function (follower, targetObject, missileSpeed, turnRate)
 
    local missileSpeed = missileSpeed or 0
    local turnRate = turnRate or 0.8
  
    -- get distance between follower and target
    
    local target = targetObject

    
    local distanceX = target.x - follower.x;
    local distanceY = target.y - follower.y;
    
    -- get total distance as one number
    local distanceTotal = fin.distanceBetween (follower, target);
    
    -- calculate how much to move
     local moveDistanceX = turnRate * distanceX / distanceTotal;
     local moveDistanceY = turnRate * distanceY / distanceTotal;
    
    -- increase current speed
    follower.moveX = follower.moveX + moveDistanceX; 
    follower.moveY = follower.moveY + moveDistanceY;
            
    -- get total move distance
    local totalmove = math.sqrt(follower.moveX * follower.moveX + follower.moveY * follower.moveY);
    
    -- apply easing
    follower.moveX = missileSpeed*follower.moveX/totalmove;
    follower.moveY = missileSpeed*follower.moveY/totalmove;
    
    -- move follower
    follower.x = follower.x + follower.moveX;
    follower.y = follower.y + follower.moveY;
    
    -- rotate follower toward target
    follower.rotation =  (180 * math.atan2(follower.moveY, follower.moveX)/math.pi )  - 90 --+ 180 
    
    -- !!!!! you got to check if we hit the target - here or in main game logic !!!!!
 
end

fin.doRotateFollow = function(follower, targetObject)
    follower.rotation =  (180 * math.atan2(follower.moveY, follower.moveX)/math.pi )  - 90 
end

return fin;