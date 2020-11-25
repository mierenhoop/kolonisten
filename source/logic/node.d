module node;

import raylib;
import board;

struct Road
{
    int player = -1;
    Node[2] parents;
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
    Node[3] parents;
}

class Node
{
    enum Type
    {
        Lumber,
        Ore,
    }

    Type type;

    bool blocked;

    debug bool selected;

    this(Board brd, uint[2] indices)
    {
        _board = brd;
        _indices = indices;

        import std.random;

        type = uniform!Type;
    }

    uint[2] _indices;
    Board _board;

    // Index starts at topright and turns clockwise
    Node neighbour(uint index)
    {
        Node tryGetNode(int i1, int i2)
        {
            if (i1 >= 0 && i1 < _board.nodes.length)
            {
                if (i2 >= 0 && i2 < _board.nodes[i1].length)
                    return _board.nodes[i1][i2];
            }
            return null;
        }
        switch (index)
        {
            case 0:
                return tryGetNode(_indices[0] - 1, _indices[1]);
            case 1:
                return tryGetNode(_indices[0],_indices[1] + 1);
            case 2:
                return tryGetNode(_indices[0] + 1, _indices[1] + 1);
            case 3:
                return tryGetNode(_indices[0] + 1, _indices[1]);
            case 4:
                return tryGetNode(_indices[0], _indices[1] - 1);
            case 5:
                return tryGetNode(_indices[0] - 1, _indices[1] - 1);
            default:
                throw new Error("Can't get neighbor at unknown index");
        }
    }

    // Houses get indexed starting from the top going clockwise.
    void addBuilding(Building bdg, uint index)
    {
        assert(bdg.player != -1);
        if (_buildings[index].player == -1) {
            bdg.parents[0] = this;
            _buildings[index] = bdg;
        }

        auto nb1 = neighbour((index + 5) % 6);
        auto nb2 = neighbour(index);
        if (nb1 !is null) {
            bdg.parents[1] = nb1;
            nb1._buildings[(index + 3) % 6] = bdg;
        }
        if (nb2 !is null) {
            bdg.parents[2] = nb2;
            nb2._buildings[(index + 3) % 6] = bdg;
        }
    }

    void addRoad(Road road, uint index)
    {
        assert(road.player != -1);
        if (_roads[index].player == -1) {
            road.parents[0] = this;
            _roads[index] = road;
        }

        // If a neighbour exists, add road to it too.
        // The road placed at the neighbour should be on the opposite side.
        auto nb = neighbour(index);
        if (nb !is null) {
            road.parents[1] = nb;
            nb._roads[(index + 3) % 6] = road;
        }
    }

    Road[6] _roads;
    Building[6] _buildings;
}

unittest
{
    auto board = new Board(5, 5);
    assert(board.nodes[0][0].neighbour(0) is null);
    assert(board.nodes[0][0].neighbour(1) == board.nodes[0][1]);
}
unittest
{
    auto board = new Board(5, 5);
    board.nodes[0][0].addRoad(Road(2), 1);
    assert(board.nodes[0][1]._roads[4].player == 2);
}
