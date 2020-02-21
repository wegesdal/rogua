function generateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local quads = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            quads[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return quads
end

function projectTile(row, col)
    topLeft = col - 1 / (row + 2)
    bottomRight = (col + 1) / (row + 1)
    return Shadow(topLeft, bottomRight)
end

function refreshVisibility(center)
    for octant = 0, 7 do
        refreshOctant(center, octant)
    end
end

function transformOctant(row, col, octant)
    if octant == 0 then
        -- col, -row
        return Vec(col, -row)
    elseif octant == 1 then
        -- row, -col
        return Vec(row, -col)
    elseif octant == 2 then
        -- row, col
        return Vec(row, col)
    elseif octant == 3 then
        -- col, row
        return Vec(col, row)
    elseif octant == 4 then
        -- -col, row
        return Vec(-col, row)
    elseif octant == 5 then
        -- -row, col
        return Vec(-row, col)
    elseif octant == 6 then
        -- -row, -col
        return Vec(-row, -col)
    elseif octant == 7 then
        -- -col, -row
        return Vec(-col, -row)
    end
end

function refreshOctant(start, octant)
    tiles[start.y][start.x].isVisible = true
    line = ShadowLine()
    local fullShadow = false
    for row = 1, 6 do
        t = transformOctant(row, 0, octant)
        pos = Vec(start.x + t.x, start.y + t.y)
        inBounds = pos.x > 0 and pos.x <= MAP_WIDTH and pos.y > 0 and pos.y <= MAP_HEIGHT
        if inBounds then
            for col = 0, row do
                t = transformOctant(row, col, octant)
                pos = Vec(start.x + t.x, start.y + t.y)
                if (pos.x > 0 and pos.x <= MAP_WIDTH and pos.y > 0 and pos.y <= MAP_HEIGHT) then
                if fullShadow then
                    tiles[pos.y][pos.x].isVisible = false
                else
                    projection = projectTile(row, col)
                    visible = not line:isInShadow(projection)
                    tiles[pos.y][pos.x].isVisible = visible
                    if visible and tiles[pos.y][pos.x].isWall then
                        line:add(projection)
                        fullShadow = line:isFullShadow()
                    end
                end
            end
        end
    end
end
return line.shadows
end

function generateTiles()
    tiles = {}
    for y = 1, MAP_HEIGHT do
        currentRow = {}
        for x = 1, MAP_WIDTH do
            if map[y][x] == 1 then
                if y % 3 == 1 then
                    sprite = UPPER_WALL
                elseif y % 3 == 2 then
                    sprite = MID_WALL
                elseif y % 3 == 0 then
                    sprite = LOWER_WALL
                end
                if x == 1 or x == MAP_WIDTH then
                    sprite = VERT_WALL
                    if y == 1 and x == 1 then
                        sprite = WALL_NW
                    elseif y == 1 and x == MAP_WIDTH then
                        sprite = WALL_NE
                    elseif y == MAP_HEIGHT and x == 1 then
                        sprite = WALL_SW
                    elseif y == MAP_HEIGHT and x == MAP_WIDTH then
                        sprite = WALL_SE
                    end
                end
                table.insert(currentRow, x, Tile(sprite, x, y))
                currentRow[x].isWall = true
            else
                table.insert(currentRow, x, Tile(489, x, y))
            end
        end
        table.insert(tiles, y, currentRow)
    end

    for x = 1, MAP_WIDTH do
        for y = 1, MAP_HEIGHT do
            if y > 1 and x > 1 and x < MAP_WIDTH and y < MAP_HEIGHT then
                if tiles[y - 1][x].isWall and tiles[y + 1][x].isWall and not tiles[y][x - 1].isWall and not tiles[y][x + 1].isWall and tiles[y][x].isWall then
                    tiles[y][x].sprite = VERT_WALL
                end
                if tiles[y][x].isWall and not tiles[y + 1][x].isWall and tiles[y + 1][x + 1].isWall then
                    for p = y, MAP_HEIGHT do
                        if tiles[p][x + 1].isWall then
                            tiles[p][x + 1].sprite = VERT_WALL
                            if tiles[p + 1][x].isWall and not tiles[p][x] or tiles[p + 1][x + 1].isWall then
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end
