Class = require 'class'
require 'Vec'
require 'ShadowLine'
require 'Shadow'
require 'Tile'
require 'Vec'
require 'Util'
require 'Item'
require 'Actor'

push = require 'push'
local luastar = require("lua-star")

MAP_WIDTH = 36
MAP_HEIGHT = 24
TILE_SIZE = 16
FONT_SIZE = 16
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 256

-- sprite constants
UPPER_WALL = 141
MID_WALL = 425
LOWER_WALL = 423
VERT_WALL = 204
WALL_NE = 174
WALL_NW = 173
WALL_SE = 206
WALL_SW = 205
WALL_JUNCTION = 140
PIT_GRADIENT = 557
SHADOW = 589

-- camera variables
camx = 0
camy = 0
camyn = 0
camxn = 0

map = {
    {1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,0,0,0,0,0,0,0,1, 1,0,0,0,0,0,0,0,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,0,0,0,0,0,0,0,1, 1,0,0,0,0,0,0,0,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,0,0,0,0,0,0,0,1, 1,0,0,0,0,0,0,0,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,0,0,0,0,0,0,0,1, 1,0,0,0,0,0,0,0,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,0,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,0,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,0,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,0,0,0,0,0,0,0,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,0,0,0,0,0,0,0,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,0,0,0,0,0,0,0,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
    {1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1},
}

function positionIsOpenFunc (x, y)
    -- should return true if the position is open to walk
    return map[y][x] == 0
end

function requestPath (start, goal, actor)
    local path = luastar:find(MAP_WIDTH, MAP_HEIGHT, start, goal, positionIsOpenFunc)
    if path then
        actor.pathIndex = 1
        actor.path = path
    else
        actor.pathIndex = 1
        actor.path = {}
    end
end

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')
    font = love.graphics.newFont('vv1989.ttf', FONT_SIZE)
    love.graphics.setFont(font)
    -- love.graphics.setFont(love.graphics.newFont('fonts/font.ttf', 8))

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    love.window.setTitle('Roguesque')

    player = Actor(64, 64, 1, 10, 2)
    monsters = {Actor(4 * TILE_SIZE, 8 * TILE_SIZE, 9, 5, 3), Actor(12 * TILE_SIZE, 12 * TILE_SIZE, 10, 2, 1), Actor(30 * TILE_SIZE, 20 * TILE_SIZE, 10, 2, 1)}
    items = {}
    inventory = {}

    table.insert(items, 1, Item(4, 6, 'Wrench', 'Equip', 'Weapon', 'A large wrench.', 'Basic'))
    table.insert(items, 1, Item(8, 16, 'Lucky Hammer', 'Equip', 'Weapon', 'An ordinary hammer.', 'Magic'))
    table.insert(items, 1, Item(15, 10, 'Cloak of Shadows', 'Equip', 'Armor', 'Reduces vision radius.', 'Rare'))
    table.insert(items, 1, Item(20, 20, 'Greaves of Grimdank', 'Equip', 'Armor', 'Increases speed', 'Legendary'))

    LANTERN_BRIGHTNESS = 0.009

    spritesheet = love.graphics.newImage('tiles_evil_corp2.png')
    sprites = generateQuads(spritesheet, TILE_SIZE, TILE_SIZE)

    playersheet = love.graphics.newImage('roguelikecreatures.png')
    psprites = generateQuads(playersheet, TILE_SIZE, TILE_SIZE)
    generateTiles()

    refreshVisibility(Vec(math.floor(player.grid_x / TILE_SIZE), math.floor(player.grid_y / TILE_SIZE)))
end

function testMap(x, y)
	if tiles[(player.grid_y / TILE_SIZE) + y][(player.grid_x / TILE_SIZE) + x].isWall then
		return false
	end
	return true
end

ticker = 0

function love.update(dt)

    player:update(dt)

    ticker = ticker + dt
    if ticker > 1 then
        for i = 1, #monsters do
            monster_coords = {x = math.floor(monsters[i].grid_x / TILE_SIZE), y = math.floor(monsters[i].grid_y / TILE_SIZE)}
            player_coords = {x = math.floor(player.grid_x / TILE_SIZE), y = math.floor(player.grid_y / TILE_SIZE)}
            if tiles[monster_coords.y][monster_coords.x].isVisible then
            requestPath(monster_coords, player_coords, monsters[i])
            end
        end
        ticker = 0
    end

    for i = 1, #monsters do
        monsters[i]:update(dt)
    end


    refreshVisibility(Vec(math.floor(player.grid_x / TILE_SIZE), math.floor(player.grid_y / TILE_SIZE)))

    -- update camera
    camyn = player.act_y - VIRTUAL_HEIGHT / 2
    camxn = player.act_x - VIRTUAL_WIDTH / 2
    camy = camy - (camy - camyn) * dt * 0.7
    camx = camx - (camx - camxn) * dt * 0.7

    -- debug to find mouse coords
    -- mouseX = math.floor(love.mouse.getX() * (VIRTUAL_WIDTH / WINDOW_WIDTH) / TILE_SIZE) * TILE_SIZE
    -- mouseY = math.floor((love.mouse.getY() * (VIRTUAL_WIDTH / WINDOW_WIDTH) / TILE_SIZE) - 1) * TILE_SIZE
end

function love.draw()
    push:apply('start')
    love.graphics.setColor(0, 1, 0, 1)
    --love.graphics.rectangle("line", mouseX, mouseY, TILE_SIZE, TILE_SIZE)
    love.graphics.translate(-camx, -camy)

    -- do vison stuff for map render
    for y = 1, MAP_HEIGHT do
        for x = 1, MAP_WIDTH do
            distancealpha = math.max(0, 1 - math.sqrt(math.pow(player.act_y - y * TILE_SIZE, 2) + math.pow(player.act_x - x * TILE_SIZE, 2)) * LANTERN_BRIGHTNESS)
                --distancealpha = 1
            if tiles[y][x].isWall then
                love.graphics.setColor(1, 1, 1, distancealpha)
                if y < MAP_HEIGHT then
                    if not tiles[y + 1][x].isVisible and not tiles[y + 1][x].isWall and tiles[y][x].isWall then
                        love.graphics.draw(spritesheet, sprites[PIT_GRADIENT], x * TILE_SIZE, y * TILE_SIZE)
                    else
                        love.graphics.draw(spritesheet, sprites[tiles[y][x].sprite], x * TILE_SIZE, y * TILE_SIZE)
                    end
                else
                    love.graphics.draw(spritesheet, sprites[tiles[y][x].sprite], x * TILE_SIZE, y * TILE_SIZE)
                end
            elseif tiles[y][x].isVisible then
                love.graphics.setColor(1, 1, 1, distancealpha)
                love.graphics.draw(spritesheet, sprites[tiles[y][x].sprite], (x) * TILE_SIZE, (y) * TILE_SIZE)
                 for i = 1, #monsters do
                     monster_coords = {x = math.floor(monsters[i].grid_x / TILE_SIZE), y = math.floor(monsters[i].grid_y / TILE_SIZE)}
                     player_coords = {x = math.floor(player.grid_x / TILE_SIZE), y = math.floor(player.grid_y / TILE_SIZE)}
                     if y == monster_coords.y and x == monster_coords.x then
                         monsters[i]:render()
                     end
                 end
            else
                love.graphics.setColor(1, 1, 1, distancealpha)
                love.graphics.draw(spritesheet, sprites[SHADOW], (x) * TILE_SIZE, (y) * TILE_SIZE)
        end
        love.graphics.setColor(0.3, 1, 0.5, 0.5)
        if tiles[y][x].isSelected then
            love.graphics.rectangle("fill", x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE, TILE_SIZE)
        end
    end
end

-- player interact dialog
for i = 1, #items do
    if tiles[items[i].y][items[i].x].isVisible then
        items[i]:draw()
        if items[i].x == math.floor(player.grid_x / TILE_SIZE) and items[i].y == math.floor(player.grid_y / TILE_SIZE) then
            items[i]:color()
            love.graphics.print(items[i].name, camx + VIRTUAL_WIDTH / 2 - string.len(items[i].name), camy + 16)
            message = 'Press F to ' .. items[i].interact
            love.graphics.print(message, camx + VIRTUAL_WIDTH / 2 - string.len(message), camy + 32)
        end
    end
end

for i = 1, #inventory do
    inventory[i]:color()
    love.graphics.print(inventory[i].type.. ': ' .. inventory[i].name, camx, camy + 16 * i)
end

love.graphics.setColor(1, 1, 1, 1)
-- love.graphics.rectangle("fill", player.act_x, player.act_y, TILE_SIZE, TILE_SIZE)

player:render()


push:apply('end')
end

function love.keypressed(key)

    -- wasd movement
    -- if key == "w" then
    --     if testMap(0, -1) then
    --         player.grid_y = monster1.grid_y - TILE_SIZE
    --     end
    -- elseif key == "s" then
    --     if testMap(0, 1) then
    --             player.grid_y = monster1.grid_y + TILE_SIZE
    --     end
    -- elseif key == "a" then
    --     if testMap(-1, 0) then
    --         player.grid_x = player.grid_x - TILE_SIZE
    --     end
    -- elseif key == "d" then
    --     if testMap(1, 0) then
    --         player.grid_x = player.grid_x + TILE_SIZE
        --  end


    if key == "f" then
        -- pickup interface
        pickup = false
        local dropIndex
        local drop
        for i = 1, #items do
            if math.floor(player.grid_x/TILE_SIZE) == items[i].x and math.floor(player.grid_y/TILE_SIZE) == items[i].y then
                item = i
                pickup = true
                for j = 1, #inventory do
                    if inventory[j].type == items[i].type then
                        print(inventory[j].type)
                        dropIndex = j
                        drop = inventory[j]
                        drop.x = items[i].x
                        drop.y = items[i].y
                    end
                end
            end
        end
        if pickup == true then
            if dropIndex ~= nil then
                table.remove(inventory, dropIndex)
            end
            table.insert(inventory, items[item])
            table.remove(items, item)
            if drop ~= nil then
                table.insert(items, drop)
            end
        end
    end
    
end

function love.mousepressed(x, y, button, istouch )
    mX = math.floor((camx + x * VIRTUAL_WIDTH / WINDOW_WIDTH) / TILE_SIZE)
    mY = math.floor((camy + y * VIRTUAL_WIDTH / WINDOW_WIDTH) / TILE_SIZE) - 1
    if mX > 0 and mX < MAP_WIDTH and mY > 0 and mY < MAP_HEIGHT then
        for y = 1, MAP_HEIGHT do
            for x = 1, MAP_WIDTH do
                tiles[y][x].isSelected = false
            end
        end
        tiles[mY][mX].isSelected = true
        requestPath({x = math.floor(player.grid_x / TILE_SIZE), y = math.floor(player.grid_y / TILE_SIZE)}, {x = mX, y = mY}, player)
    end
end