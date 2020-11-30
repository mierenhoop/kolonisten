module main;

import board;
import node;

import dagon;
import rotationview;

import std.stdio;

class MainScene : Scene
{
    Game game;
    OBJAsset aNode;
    OBJAsset aRoad;

    Board currentBoard;

    this(Game game)
    {
        super(game);
        this.game = game;
    }

    override void beforeLoad()
    {
        aNode = addOBJAsset("data/node.obj");
        aRoad = addOBJAsset("data/road.obj");
    }

    override void afterLoad()
    {
        game.deferredRenderer.ssaoEnabled = true;
        game.deferredRenderer.ssaoPower = 6.0;
        game.postProcessingRenderer.tonemapper = Tonemapper.Filmic;
        game.postProcessingRenderer.fxaaEnabled = true;

        Camera camera = addCamera();

        RotationViewComponent rotview = New!RotationViewComponent(eventManager, camera);

        rotview.zoom(5);
        //rotview.pitch(-30.0f);
        //rotview.turn(10.0f);
        game.renderer.activeCamera = camera;

        // auto sun = addLight(LightType.Sun);
        // sun.shadowEnabled = true;
        // sun.energy = 10.0f;
        // sun.pitch(-45.0f);

        generateBoard();
    }

    void generateBoard()
    {
        currentBoard = New!Board(5, 5);

        Material matLumber = addMaterial();
        matLumber.diffuse = Color4f(0.0, 1.0, 0.0, 1.0);
        Material matOre = addMaterial();
        matOre.diffuse = Color4f(0.5, 0.5, 0.5, 1.0);

        foreach (nodesRow; currentBoard.nodes)
        {
            foreach (node; nodesRow)
            {
                Entity eNode = addEntity();
                eNode.drawable = aNode.mesh;
                final switch (node.type)
                {
                case Node.Type.Lumber:
                    eNode.material = matLumber;
                    break;
                case Node.Type.Ore:
                    eNode.material = matOre;
                    break;
                }
                eNode.position.x = 2 * (
                        cast(float) node._indices[1] - cast(float) nodesRow.length / 2 + 0.5);
                eNode.position.y = 0;
                eNode.position.z = 1.78 * (cast(float) node._indices[0] - cast(
                        float) currentBoard.nodes.length / 2 + 0.5);
            }
        }
        Material matRoad = addMaterial();
        matRoad.diffuse = Color4f(0.0, 0.0, 1.0, 1.0);
        writeln(currentBoard.nodes.length, " ", currentBoard.roads.length);
        for (uint y = 0; y < currentBoard.roads.length; y++)
        {
            for (uint x = 0; x < currentBoard.roads[y].length; x++)
            {
                Road road = currentBoard.roads[y][x];
                if (road.player == 0) continue;
                Entity eRoad = addEntity();
                eRoad.drawable = aRoad.mesh;
                eRoad.material = matRoad;
                if (y & 1)
                {
                    eRoad.position.x = 2 * (cast(float) x - cast(float) currentBoard.roads[y].length / 2 + 0.5);
                    eRoad.position.z = 1.78 / 2 * (cast(float) y - cast(float) currentBoard.roads.length / 2 + 0.5);
                }
                else
                {
                    eRoad.position.x =  (cast(float) x - cast(float) currentBoard.roads[y].length / 2 + 0.5);
                    eRoad.position.z = 1.78 / 2 * (cast(float) y - cast(float) currentBoard.roads.length / 2 + 0.5);
                    if (y > currentBoard.nodes.length)
                    {
                        if (x & 1)
                            eRoad.rotate(Vector3f(0.0, 120.0, 0.0));
                        else
                            eRoad.rotate(Vector3f(0.0, 60, 0));
                    } else {
                        if (x & 1)
                            eRoad.rotate(Vector3f(0.0, -120.0, 0.0));
                        else
                            eRoad.rotate(Vector3f(0.0, -60, 0));
                    }
                }

                eRoad.position.y = 0.0;
            }
        }
    }

    override void onMouseButtonUp(int button)
    {
        if (button == MB_LEFT)
        {
            Vector3f intersect;
            if(mouseRay().intersectSphere(Vector3f(0.0, 0.0, 0.0), 1.0, intersect))
                writeln(intersect);
            else writeln("no intersect");
        }
    }

    Ray mouseRay()
    {
        Vector3f rayNds;
        rayNds.x = (2.0 * eventManager.mouseX) / cast(float) game.width - 1.0;
        rayNds.y = 1.0 - (2.0 * eventManager.mouseY) / cast(float) game.height;
        rayNds.z = 1.0;
        Vector4f rayClip = Vector4f(rayNds.x, rayNds.y, -1.0, 1.0);

        Vector4f rayEye = rayClip * game.renderer.view.projectionMatrix.inverse;
        rayEye = Vector4f(rayEye.x, rayEye.y, -1.0, 0.0);

        Vector3f rayWor = Vector3f(rayEye * game.renderer.view.invViewMatrix);
        rayWor.normalize();
        writeln(rayWor);
        return Ray();
    }

}

class MyGame : Game
{
    this(uint w, uint h, bool fullscreen, string title, string[] args)
    {
        super(w, h, fullscreen, title, args);
        currentScene = New!MainScene(this);
    }
}

void main(string[] args)
{
    MyGame game = New!MyGame(1280, 720, false, "Kolonisten 3D", args);
    game.run();
    Delete(game);
}
