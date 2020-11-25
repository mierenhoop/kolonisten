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

        import std.stdio : writeln;
        foreach (i; 0 .. _roads.length)
        {
            if (_roads[i].player == 0 && _roads[i].parents[0] == n)
            {
                Vector2 vertex = vertexPosition(cast(uint) i);
                Vector2 vertex2 = vertexPosition(cast(uint) (i + 1) % 6);
                DrawLine3D(Vector3(pos.x + vertex.x, 0.1, pos.y + vertex.y), Vector3(pos.x + vertex2.x, 0.1, pos.y + vertex2.y), Colors.BLUE);
            }
        }
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

Vector2 vertexPosition(uint index)
{
    import std.math : PI, sin, cos;
    float rot = 2.0 * PI / 6.0 * (cast(float) index + 1) + 2.0 * PI / 12.0 + PI;
    return Vector2(0.5 * cos(rot), 0.5 * sin(rot));
}
