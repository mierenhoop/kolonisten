module board;

import dlib.container;
import dlib.core.memory;
import dlib.core.ownership;

import node;


class Board : Owner
{
    this(uint width, uint height, Owner o = null)
    {
        super(o);
        this.width = width;
        this.height = height;
        import std.math : abs;
        foreach (y; 0 .. height)
        {
            Array!Node xArray;
            int mh = (-cast(int) height) / 2;
            foreach (x; 0 .. width - abs(mh + cast(int) y))
            {
                uint[2] indices = [y, x];
                xArray.append(New!Node(this, indices));
            }
            nodes.append(xArray);
        }

        roads.resize(nodes.length * 2 + 1, Array!Road());
        foreach (index; 0 .. nodes.length)
        {
            // roads[index * 2    ].resize(nodes[index].length * 2, Road());
            Array!Road r1, r2;
            r1.resize(nodes[index].length * 2, Road());
            r2.resize(nodes[index].length + 1, Road());

            roads[index * 2    ] = r1;
            roads[index * 2 + 1] = r2;
        }
        roads[nodes.length * 2].resize(nodes[0].length * 2, Road());
        // import std.range;// : iota, array;
        // import std.algorithm;//.iteration : map;

        // int mh = (-cast(int) height) / 2;
        // nodes = iota(height).map!(y => iota(width - abs(mh + cast(int) y)).map!(x => new Node(this,
        //         [y, x])).array).array;

        // // Optimize
        // foreach (nds; nodes)
        // {
        //     roads ~= iota(nds.length * 2).map!(_ => Road()).array;
        //     roads ~= iota(nds.length + 1).map!(_ => Road()).array;
        // }
        // roads ~= iota(nodes[0].length * 2).map!(_ => Road()).array;
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

    Array!(Array!Road) roads;
    Array!(Array!Building) buildings;

    Array!(Array!Node) nodes;
    uint height;
    uint width;
// private:
//     uint nodeLength()
//     {
//         import std.algorithm.iteration : sum;
//         import std.range : iota;

//         return width + iota(width - height / 2, width).sum * 2;
//     }

}
