print("testing Point")

local Point = require("geom.point")

local function test_init()
    local p = Point(1, 2)
    assert(p.x == 1)
    assert(p.y == 2)
end

local function test_keys()
    local n_keys = 0
    local keys = {}
    for k, _ in pairs(Point(1, 2)) do
        keys[k] = true
        n_keys = n_keys + 1
    end
    assert(n_keys == 2)
    assert(keys["x"])
    assert(keys["y"])
end

local function test_eq_neq()
    assert(Point(1, 2) == Point(1, 2))
    assert(Point(1, 2) ~= Point(1, 3))
    assert(Point(1, 2) ~= Point(3, 2))
end

local function test_add_sub_unm()
    assert(Point(1, 2) + Point(3, 5) == Point(4, 7))
    assert(Point(1, 2) - Point(3, 5) == Point(-2, -3))
    assert(-Point(1, 2) == Point(-1, -2))
end

local function test_mul()
    assert(Point(1, 2) * 2 == Point(2, 4))
    assert(2 * Point(1, 2) == Point(2, 4))
end

test_init()
test_keys()
test_eq_neq()
test_add_sub_unm()
test_mul()
