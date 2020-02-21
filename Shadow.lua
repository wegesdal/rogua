Shadow = Class{}

function Shadow:init(start, finish)
    self.start = start
    self.finish = finish
end

function Shadow:toString()
    return tostring(self.start - self.finish)
end

function Shadow:contains(other)

    return self.start <= other.start and self.finish >= other.finish
end

