module drawing;

import raylib;
import board;
import node;

void draw(Board brd)
{
    with (brd)
    {
        import std.algorithm.iteration : each;
        import std.range : enumerate;

        nodes.each!(each!(node => node.draw()));
        foreach (y; 0 .. roads.length)
        {
            if (y & 1) {
                foreach (x; 0 .. roads[y].length)
                {
                    uint i = 4;
                    Vector2 vertex = vertexPosition(i);
                    Vector2 vertex2 = vertexPosition(cast(uint) (i + 1) % 6);
                    Vector2 pos = nodePosition(nodes[y][x]);
                    DrawLineV(Vector2(pos.x + vertex.x, pos.y + vertex.y),Vector2(pos.x + vertex2.x, pos.y + vertex2.y), Colors.BLUE);
                }
            }
        }
    }
}

void draw(Node n)
{
    with (n)
    {
        Vector2 pos = nodePosition(_board.width, _indices, _board.nodes[_indices[0]].length);
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
        DrawPoly(pos, 6, 0.5, 0.0, color);

        //import std.stdio : writeln;
        //foreach (i; 0 .. _roads.length)
        //{
        //    if (_roads[i].player == 0 && _roads[i].parents[0] == n)
        //    {
        //        Vector2 vertex = vertexPosition(cast(uint) i);
        //        Vector2 vertex2 = vertexPosition(cast(uint) (i + 1) % 6);
        //        //DrawLineEx(Vector2(pos.x + vertex.x, pos.y + vertex.y), Vector2(pos.x + vertex2.x, pos.y + vertex2.y), 0.2, Colors.BLUE);
        //        DrawLineV(Vector2(pos.x + vertex.x, pos.y + vertex.y),Vector2(pos.x + vertex2.x, pos.y + vertex2.y), Colors.BLUE);

        //        //DrawCircleV(roadMiddle(n, cast(uint) i), 0.1, Colors.MAROON);
        //    }
        //}
        //foreach (i; 0 .. _buildings.length)
        //{
        //    if (_buildings[i].player == 0 && _buildings[i].parents[0] == n)
        //    {
        //        Vector2 vertex = vertexPosition(cast(uint) i);
        //        DrawCircleV(Vector2(pos.x + vertex.x, pos.y + vertex.y), 0.2, Colors.BLUE);
        //    }
        //}
    }
}

Vector2 nodePosition(uint boardWidth, uint[2] indices, uint nodesLen)
{
    Vector2 pos;
    pos.y = -cast(float) boardWidth / 2 + cast(float) indices[0] + 0.5;
    float len = cast(float) nodesLen;
    pos.x = cast(float) indices[1] - len / 2 + 0.5;
    return pos;
}

Vector2 roadMiddle(Node n, uint index)
{
    Vector2 pos = nodePosition(n);
    Vector2 vertex1 = pos + vertexPosition(index);
    Vector2 vertex2 = pos + vertexPosition((index + 1) % 6);
    return Vector2((vertex1.x + vertex2.x) / 2, (vertex1.y + vertex2.y) / 2);
}

Vector2 vertexPosition(uint index)
{
    import std.math : PI, sin, cos;
    float rot = 2.0 * PI / 6.0 * (cast(float) index) - 2.0 * PI / 4.0;
    return Vector2(0.58 * cos(rot), 0.58 * sin(rot));
}
