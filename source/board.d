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
        import std.range : iota, array;
        import std.algorithm.iteration : map;
        import std.math : abs;

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
        import std.algorithm.iteration : each;
        nodes.each!(each!(node => node.draw()));
    }

    invariant
    {
        assert(height & 1);
    }

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
