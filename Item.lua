Item = Class{}

function Item:init(x, y, name, interact, type, description, rarity, stats)
    self.x = x
    self.y = y
    self.name = name
    self.type = type
    self.interact = interact
    self.description = description
    self.rarity = rarity
end

function Item:draw()
        self:color()
        love.graphics.rectangle('line', self.x * TILE_SIZE, self.y * TILE_SIZE, TILE_SIZE, TILE_SIZE)
end

function Item:color()
    if self.rarity == 'Basic' then
        love.graphics.setColor(0.8, 0.8, 0.8, 1)
    elseif self.rarity == 'Magic' then
        love.graphics.setColor(0.2, 0.2, 1, 1)
    elseif self.rarity == 'Rare' then
        love.graphics.setColor(0.8, 0.8, 0.2, 1)
    elseif self.rarity == 'Legendary' then
        love.graphics.setColor(0.7, 0.6, 0.4, 1)
    end        
end
