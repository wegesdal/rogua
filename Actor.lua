Actor = Class{}

function Actor:init(grid_x, grid_y, sprite, hp, ap)

    self.grid_x = grid_x
    self.grid_y = grid_y
    self.act_x = grid_x
    self.act_y = grid_y
    self.path = {}
    self.pathIndex = 1
    self.sprite = sprite
    self.ticker = 0
    self.hp = hp
    self.maxhp = hp
    self.ap = ap
    self.alive = true
end


function Actor:update(dt)
    -- smooth update player position
	self.act_y = self.act_y - (self.act_y - self.grid_y) * dt * 10
    self.act_x = self.act_x - (self.act_x - self.grid_x) * dt * 10

    -- timer function
    -- carry out movement for player based on path
    if self.alive then
    self.ticker = self.ticker + dt
    if self.ticker > 0.2 then
        self.ticker = 0
        if self.path then
            if self.pathIndex <= #self.path then
                self.grid_x = self.path[self.pathIndex].x * TILE_SIZE
                self.grid_y = self.path[self.pathIndex].y * TILE_SIZE
                self.pathIndex = self.pathIndex + 1
            end
        end
        if player.grid_x == self.grid_x and player.grid_y == self.grid_y and self ~= player then
            player.hp = player.hp - self.ap
            self.hp = self.hp - player.ap
            if self.hp < 0 then
                self.alive = false
            end
        end
        end
    end
end

function Actor:render()
    if self.alive then
        love.graphics.draw(playersheet, psprites[self.sprite], self.act_x, self.act_y)
        love.graphics.setColor(0.3, 0.9, 0.5, 1.0)
        love.graphics.rectangle("line", self.act_x, self.act_y - 4, 16, 3)
        love.graphics.setColor(0.3, 0.9, 0.5, 0.7)
        love.graphics.rectangle("fill", self.act_x, self.act_y - 4, (self.hp * 16 / self.maxhp), 3)
    else
        love.graphics.draw(playersheet, psprites[57], self.act_x, self.act_y)
        love.graphics.setColor(0.9, 0.3, 0.5, 1.0)
        love.graphics.rectangle("line", self.act_x, self.act_y - 4, 16, 3)
    end
end