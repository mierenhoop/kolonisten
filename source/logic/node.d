module node;

import raylib;
import board;

struct Road
{
    int player = -1;
}

struct Building
{
    enum Type
    {
        House,
        Town
    }

    int player = -1;
    Type type;
}

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

    // Index starts at  
    Node neighbour(uint index)
    {
        switch (index)
        {
            default:
                throw new Error("Can't get neighbor at unknown index");
        }
    }

    void addRoad(Road road, uint index)
    {
        
    }

private:
    Road[6] _roads;
    Building[6] _buildings;
}
