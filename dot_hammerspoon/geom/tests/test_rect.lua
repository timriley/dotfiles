print("testing Rect")

local Point = require("geom.point")
local Size = require("geom.size")
local Segment = require("geom.segment")
local Rect = require("geom.rect")

local function test_init()
    local r = Rect(Point(10, 20), Size(30, 40))
    assert(r.x == 10)
    assert(r.y == 20)
    assert(r.w == 30)
    assert(r.h == 40)
end

local function test_keys()
    local n_keys = 0
    local keys = {}
    for k, _ in pairs(Rect(Point(10, 20), Size(30, 40))) do
        keys[k] = true
        n_keys = n_keys + 1
    end
    assert(n_keys == 4)
    assert(keys["x"])
    assert(keys["y"])
    assert(keys["w"])
    assert(keys["h"])
end

local function test_props()
    local r = Rect(Point(10, 20), Size(30, 40))
    assert(r.x1 == 10)
    assert(r.y1 == 20)
    assert(r.x2 == 40)
    assert(r.y2 == 60)
    assert(r.size == Size(30, 40))

    assert(r.top_left      == Point(10, 20))
    assert(r.mid_left      == Point(10, 40))
    assert(r.bottom_left   == Point(10, 60))

    assert(r.top_center    == Point(25, 20))
    assert(r.center        == Point(25, 40))
    assert(r.bottom_center == Point(25, 60))

    assert(r.top_right     == Point(40, 20))
    assert(r.mid_right     == Point(40, 40))
    assert(r.bottom_right  == Point(40, 60))

    assert(r.h_segment     == Segment(10, 30))
    assert(r.v_segment     == Segment(20, 40))
end

local function test_eq_neq()
    assert(Rect(Point(10, 20), Size(30, 40)) == Rect(Point(10, 20), Size(30, 40)))
    assert(Rect(Point(10, 20), Size(30, 40)) ~= Rect(Point(99, 99), Size(30, 40)))
    assert(Rect(Point(10, 20), Size(30, 40)) ~= Rect(Point(10, 20), Size(99, 99)))
end

local function test_add()
    local r1 = Rect(Point(10, 20), Size(30, 40))
    local r2 = Rect(Point(15, 26), Size(30, 40))
    local offset = Point(5, 6)
    assert(r1 + offset == r2)
end

local function test_contains()
    local r = Rect(Point(10, 20), Size(30, 40))

    assert(r:contains(Point(10, 20)))
    assert(r:contains(Point(40, 60)))

    assert(r:contains(Point(10, 40)))
    assert(r:contains(Point(40, 40)))
    assert(r:contains(Point(25, 20)))
    assert(r:contains(Point(25, 60)))
    assert(r:contains(Point(25, 40)))

    assert(not r:contains(Point(  0,   0)))
    assert(not r:contains(Point(999, 999)))
    assert(not r:contains(Point(  0,  40)))
    assert(not r:contains(Point(999,  40)))
    assert(not r:contains(Point( 25,   0)))
    assert(not r:contains(Point( 25, 999)))

    assert(r:contains(Rect(r.top_left,   r.size)))

    assert(r:contains(Rect(r.top_left,   r.size * 0.5)))
    assert(r:contains(Rect(r.mid_left,   r.size * 0.5)))
    assert(r:contains(Rect(r.top_center, r.size * 0.5)))
    assert(r:contains(Rect(r.center,     r.size * 0.5)))

    assert(not r:contains(Rect(r.top_left,   2 * r.size)))
    assert(not r:contains(Rect(r.mid_left,   2 * r.size)))
    assert(not r:contains(Rect(r.top_center, 2 * r.size)))
    assert(not r:contains(Rect(r.center,     2 * r.size)))
end

local function test_intersects()
    local r = Rect(Point(10, 20), Size(30, 40))

    assert(r:intersects(Rect(r.top_left,      r.size)))

    assert(r:intersects(Rect(r.top_left,      r.size * 0.5)))
    assert(r:intersects(Rect(r.mid_left,      r.size * 0.5)))
    assert(r:intersects(Rect(r.bottom_left,   r.size * 0.5)))

    assert(r:intersects(Rect(r.top_center,    r.size * 0.5)))
    assert(r:intersects(Rect(r.center,        r.size * 0.5)))
    assert(r:intersects(Rect(r.bottom_center, r.size * 0.5)))

    assert(r:intersects(Rect(r.top_right,    r.size * 0.5)))
    assert(r:intersects(Rect(r.mid_right,    r.size * 0.5)))
    assert(r:intersects(Rect(r.bottom_right, r.size * 0.5)))

    assert(r:intersects(Rect(r.top_left,      r.size * 2)))
    assert(r:intersects(Rect(r.mid_left,      r.size * 2)))
    assert(r:intersects(Rect(r.bottom_left,   r.size * 2)))

    assert(r:intersects(Rect(r.top_center,    r.size * 2)))
    assert(r:intersects(Rect(r.center,        r.size * 2)))
    assert(r:intersects(Rect(r.bottom_center, r.size * 2)))

    assert(r:intersects(Rect(r.top_right,    r.size * 2)))
    assert(r:intersects(Rect(r.mid_right,    r.size * 2)))
    assert(r:intersects(Rect(r.bottom_right, r.size * 2)))

    assert(r:intersects(Rect(
        r.top_left - Point(10, 10),
        r.size + Size(20, 20)
    )))
end

test_init()
test_keys()
test_props()
test_eq_neq()
test_add()
test_contains()
test_intersects()
