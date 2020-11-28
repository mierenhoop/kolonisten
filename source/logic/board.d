module board;

import raylib;
import node;

class Board
{
    this(uint width, uint height)
    {
        this.width = width;
        this.height = height;
        nodes.length = height;
        import std.range;// : iota, array;
        import std.algorithm;//.iteration : map;
        import std.math : abs;

        int mh = (-cast(int) height) / 2;
        nodes = iota(height).map!(y => iota(width - abs(mh + cast(int) y)).map!(x => new Node(this,
                [y, x])).array).array;

        // Optimize
        foreach (nds; nodes)
        {
            roads ~= iota(nds.length * 2).map!(_ => Road()).array;
            roads ~= iota(nds.length + 1).map!(_ => Road()).array;
        }
        roads ~= iota(nodes[0].length * 2).map!(_ => Road()).array;
    }

    void update()
    {
    }

    void getAvailabeRoads(int player)
    {
        foreach (node; nodes)
        {

        }
    }

    invariant
    {
        assert(height & 1);
    }

    Road[][] roads;

    Node[][] nodes;
    uint height;
    uint width;
private:
    uint nodeLength()
    {
        import std.algorithm.iteration : sum;
        import std.range : iota;

        return width + iota(width - height / 2, width).sum * 2;
    }

}
