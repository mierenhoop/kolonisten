module drawing;

import raylib;
import board;
import node;

void draw(Board brd)
{
    with (brd)
    {
        import std.algorithm.iteration : each;

        nodes.each!(each!(node => node.draw()));
    }
}

void draw(Node n)
{
    with (n)
    {
        Vector2 pos = nodePosition(n);
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
        debug if (selected) color = Colors.BLACK;
        DrawCylinder(Vector3(pos.x, 0.0, pos.y), 0.5, 0.5, 0.1, 6, color);
    }
}

Vector2 nodePosition(Node n)
{
    with (n)
    {
        Vector2 pos;
        pos.y = -cast(float) _board.width / 2 + cast(float) _indices[0] + 0.5;
        float len = cast(float) _board.nodes[_indices[0]].length;
        pos.x = cast(float) _indices[1] - len / 2 + 0.5;
        return pos;
    }
}
