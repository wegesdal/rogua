Tile = Class{}

function Tile:init(sprite, x, y)

    self.sprite = sprite
    self.x = x
    self.y = y

    isWall = false
    isSelected = false

    local isVisible = false
    local isExplored = false
end

function Tile:setVisibility(value)
    isVisible = value
    if(value) then
        isExplored = true
    end
end
