import std.stdio;
import raylib;
import board;
import node;
import drawing;

void main()
{
    auto brd = new Board(9, 9);

    brd.nodes[2][3].addRoad(Road(0), 0);
    brd.nodes[2][3].addRoad(Road(0), 1);
    brd.nodes[2][3].addRoad(Road(0), 2);
    brd.nodes[2][3].addRoad(Road(0), 3);
    brd.nodes[2][3].addRoad(Road(0), 4);
    brd.nodes[2][3].addRoad(Road(0), 5);
    //brd.nodes[2][3].addRoad(Road(0), 3);
    brd.nodes[3][4].addBuilding(Building(0, Building.Type.House), 3);
    brd.nodes[2][3].selected = true;

    uint screenHeight = 720;
    uint screenWidth = 1280;
    InitWindow(screenWidth, screenHeight, "kolonisten");
    scope (exit)
        CloseWindow();

    auto camera = Camera2D();
    camera.target = Vector2(0, 0);
    camera.offset = Vector2(screenWidth / 2, screenHeight / 2);
    camera.rotation = 0;
    camera.zoom = 60;

    //SetCameraMode(camera, 1);

    SetTargetFPS(60);

    while (!WindowShouldClose())
    {
        
        if (IsMouseButtonPressed(MouseButton.MOUSE_LEFT_BUTTON))
        {
            Vector2 mousePos = GetScreenToWorld2D(GetMousePosition(), camera);
            import std.algorithm.iteration : joiner;
            outer: foreach (node; brd.nodes.joiner)
            {
                foreach (i; 0 .. node._roads.length)
                {
                    if (CheckCollisionPointCircle(mousePos, roadMiddle(node, cast(uint) i), 0.1))
                    {
                        writeln("click", i);
                        break outer;
                    }
                }
            }
        }
        brd.update();

        //UpdateCamera(&camera);

        BeginDrawing();

        ClearBackground(Colors.RAYWHITE);

        BeginMode2D(camera);

        //DrawCube(Vector3(0, 0, 0), 1000, 0.05, 1000, Colors.GOLD);

        brd.draw();

        EndMode2D();

        EndDrawing();
    }

}
