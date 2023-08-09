print("testing Vector2")

local Vector2 = require("geom.vector2")

local function test_basic_vector()
    local v1 = Vector2(5, 6)

    assert(v1[1] == 5)
    assert(v1[2] == 6)

    assert(v1 == v1)
    assert(v1 == Vector2(5, 6))
    assert(v1 ~= Vector2(7, 8))

    assert(v1 + Vector2(1, 2) == Vector2(6, 8))
    assert(v1 - Vector2(1, 3) == Vector2(4, 3))
    assert(v1 * 2 == Vector2(10, 12))
    assert(2 * v1 == Vector2(10, 12))
    assert(-v1 == Vector2(-5, -6))
end

local function test_vector_class_methods()
    assert(Vector2:x_axis() == Vector2(1, 0))
    assert(Vector2:y_axis() == Vector2(0, 1))
end

test_basic_vector()
test_vector_class_methods()
