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
    }

    override void onMouseButtonUp(int button)
    {
        if (button == MB_LEFT)
        {
        }
    }

    Ray mouseRay()
    {
        Vector3f deviceCoords;
        deviceCoords.x = (2.0f * eventManager.mouseX) / cast(float) game.width - 1.0f;
        deviceCoords.y = 1.0f - (2.0f * eventManager.mouseY) / cast(float) game.height;
        deviceCoords.z = 1.0f;

        auto matViewProj = game.renderer.view.viewMatrix * game.renderer.view.projectionMatrix;
        matViewProj.invert();

        Vector3f unproject(float z)
        {
            Quaternionf quat = Quaternionf(deviceCoords.x, deviceCoords.y, z, 1.0f) * matViewProj;
            return Vector3f(quat.x / quat.w, quat.y / quat.w, quat.z / quat.w);
        }

        return Ray(unproject(0.0), unproject(1.0));
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
