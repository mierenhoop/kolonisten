module node;

import raylib;
import board;

class Node
{
    enum Type
    {
        Lumber,
        Ore,
    }

    Type type;

    this(Board brd, uint[2] indices)
    {
        _board = brd;
        _indices = indices;

        import std.random;
        type = uniform!Type;
    }

    void draw()
    {
        Vector2 pos = position;
        Color color;
        switch (type)
        {
        case Type.Lumber:
            color = Colors.GREEN;
            break;
        case Type.Ore:
            color = Colors.GRAY;
            break;
        default:
            throw new Error("Node type doesn't exist"); 
        }
        DrawCylinder(Vector3(pos.x, 0.0, pos.y), 0.5, 0.5, 0.1, 6, color);
    }

    @property Vector2 position()
    {
        Vector2 pos;
        pos.y = - cast(float) _board.width / 2 + cast(float) _indices[0] + 0.5;
        float len = cast(float) _board.nodes[_indices[0]].length;
        pos.x = cast(float) _indices[1] - len / 2 + 0.5;
        return pos;
    }

private:
    uint[2] _indices;
    Board _board;
}
