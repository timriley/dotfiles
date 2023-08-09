print("testing Segment")

local Segment = require("geom.segment")

local function test_init()
    local s = Segment(100, 20)
    assert(s.x == 100)
    assert(s.w == 20)
end

local function test_props()
    local s = Segment(100, 20)
    assert(s.x1 == 100)
    assert(s.x2 == 120)
end

local function test_eq_neq()
    assert(Segment(100, 20) == Segment(100, 20))
    assert(Segment(100, 20) ~= Segment( 90, 20))
    assert(Segment(100, 20) ~= Segment(100, 30))
end

local function test_add()
    assert(Segment(100, 20) + 5 == Segment(105, 20))
end

local function test_contains()
    local s = Segment(100, 20)

    assert(s:contains(100))
    assert(s:contains(120))
    assert(s:contains(110))
    assert(not s:contains(99))
    assert(not s:contains(121))

    assert(s:contains(Segment(100, 20)))
    assert(s:contains(Segment(100, 19)))
    assert(s:contains(Segment(101, 19)))
    assert(s:contains(Segment(101,  5)))

    assert(not s:contains(Segment( 50, 10)))
    assert(not s:contains(Segment(200, 10)))
    assert(not s:contains(Segment( 90, 40)))
    assert(not s:contains(Segment(100, 30)))
    assert(not s:contains(Segment( 90, 30)))
    assert(not s:contains(Segment( 95, 10)))
    assert(not s:contains(Segment(115, 10)))
end

local function test_intersects()
    local s = Segment(100, 20)

    assert(s:intersects(Segment(100, 20)))
    assert(s:intersects(Segment(100, 19)))
    assert(s:intersects(Segment(101, 19)))
    assert(s:intersects(Segment(101,  5)))

    assert(s:intersects(Segment( 90, 40)))
    assert(s:intersects(Segment(100, 30)))
    assert(s:intersects(Segment( 90, 30)))
    assert(s:intersects(Segment( 95, 10)))
    assert(s:intersects(Segment(115, 10)))

    assert(not s:intersects(Segment( 50, 10)))
    assert(not s:intersects(Segment(200, 10)))
end

test_init()
test_props()
test_eq_neq()
test_add()
test_contains()
test_intersects()
