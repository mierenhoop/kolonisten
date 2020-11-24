import std.stdio;
import raylib;

class Road
{
}

class Node
{
    enum Type
    {
        Lumber,
        Ore,
    }

    Type type;

    this(Board board, uint[2] indices)
    {
        _board = board;
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
        pos.y = cast(float) _indices[0];
        float len = cast(float) _board.nodes[_indices[0]].length;
        pos.x = cast(float) _indices[1] - len / 2;
        return pos;
    }

private:
    uint[2] _indices;
    Board _board;
}

class Board
{
    this(uint width, uint height)
    {
        this.width = width;
        this.height = height;
        nodes.length = height;
        import std.range, std.algorithm, std.math;

        int mh = (- cast(int)height) / 2;
        nodes = iota(height)
            .map!(y => iota(width - abs(mh + cast(int) y))
                    .map!(x => new Node(this, [y, x]))
                    .array)
            .array;
    }


    void update()
    {
    }

    void draw()
    {
        DrawCube(Vector3()
        import std.algorithm.iteration : each;
        nodes.each!(each!(node => node.draw()));
    }

    invariant
    {
        assert(height & 1);
    }

private:
    uint nodeLength()
    {
        import std.algorithm.iteration : sum;
        import std.range : iota;
        return width + iota(width - height / 2, width).sum * 2;
    }

    uint height;
    uint width;
    Node[][] nodes;
}


void main()
{
    auto board = new Board(9, 9);

    InitWindow(800, 480, "kolonisten");
    scope (exit)
        CloseWindow();

    auto camera = Camera(Vector3(18.0f, 28.0f, 18.0f), Vector3(0.0f, 0.0f, 0.0f ), Vector3(0.0f, 1.0f, 0.0f), 45.0f);

    SetCameraMode(camera, 0);

    SetTargetFPS(60);

    while (!WindowShouldClose())
    {
        board.update();

        UpdateCamera(&camera);

        BeginDrawing();

        ClearBackground(Colors.RAYWHITE);

        BeginMode3D(camera);

        DrawCube(Vector3(0, 0, 0), 1000, 0.05, 1000, Colors.GOLD);

        board.draw();

        EndMode3D();

        EndDrawing();
    }

}
