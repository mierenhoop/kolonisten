module node;

import raylib;
import board;

class Node
{
    enum Type
    {
        Lumber,
        Ore,
    }

    Type type;

    this(Board brd, uint[2] indices)
    {
        _board = brd;
        _indices = indices;

        import std.random;

        type = uniform!Type;
    }

    uint[2] _indices;
    Board _board;
}
