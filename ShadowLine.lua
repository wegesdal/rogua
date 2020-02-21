ShadowLine = Class{}



function ShadowLine:init()
    shadows = {}
end

function ShadowLine:isInShadow(projection)
    for i = 1, #shadows do
        if shadows[i]:contains(projection) then
            return true
        end
    end
    return false
end

function ShadowLine:add(shadow)
    index = 1
    for i = 1, #shadows do
        index = i
        if (shadows[i].start >= shadow.start) then
            break
        end
    end

    local overlappingPrevious
    if index > 1 and shadows[index - 1].finish > shadow.start then
        overlappingPrevious = shadows[index - 1]
    end

    local overlappingNext
    if index < #shadows and shadows[index].start < shadow.finish then
        overlappingNext = shadows[index]
    end

    if overlappingNext ~= nil then
        if overlappingPrevious ~= nil then
            overlappingPrevious.finish = overlappingNext.finish
            table.remove(shadows, index)
        else
            overlappingNext.start = shadow.start                
        end
    else
        if overlappingPrevious ~= nil then
            overlappingPrevious.finish = shadow.finish
        else
            table.insert(shadows, index, shadow)
        end
    end
end

function ShadowLine:isFullShadow()
    -- print(#shadows)
    return #shadows == 1 and shadows[1].start == 0 and shadows[1].finish == 1
end