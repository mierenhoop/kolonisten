import std.stdio;
import raylib;
import board;
import drawing;

void main()
{
    auto brd = new Board(9, 9);

    InitWindow(800, 480, "kolonisten");
    scope (exit)
        CloseWindow();

    auto camera = Camera(Vector3(28.0f, 28.0f, 28.0f), Vector3(0.0f, 0.0f,
            0.0f), Vector3(0.0f, 1.0f, 0.0f), 45.0f);

    SetCameraMode(camera, 1);

    SetTargetFPS(60);

    while (!WindowShouldClose())
    {
        brd.update();

        UpdateCamera(&camera);

        BeginDrawing();

        ClearBackground(Colors.RAYWHITE);

        BeginMode3D(camera);

        DrawCube(Vector3(0, 0, 0), 1000, 0.05, 1000, Colors.GOLD);

        brd.draw();

        EndMode3D();

        EndDrawing();
    }

}
