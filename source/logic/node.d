module node;

import dlib.core.ownership;
import dlib.core.memory;

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

class Node : Owner
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
        super(brd);
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
        
    }

    void addRoad(Road road, uint index)
    {
        road.parents[0] = this;
        road.parents[1] = neighbour(index);
        switch (index)
        {
        case 0: _board.roads[_indices[0] * 2    ][_indices[1] * 2 + 1] = road; break;
        case 1: _board.roads[_indices[0] * 2 + 1][_indices[1]     + 1] = road; break;
        case 2: _board.roads[_indices[0] * 2 + 2][_indices[1] * 2 + 2] = road; break;
        case 3: _board.roads[_indices[0] * 2 + 2][_indices[1] * 2 + 1] = road; break;
        case 4: _board.roads[_indices[0] * 2 + 1][_indices[1]        ] = road; break;
        case 5: _board.roads[_indices[0] * 2    ][_indices[1] * 2    ] = road; break;
        default: break;
        }
    }
}

unittest
{
    auto board = New!Board(5, 5);
    assert(board.nodes[0][0].neighbour(0) is null);
    assert(board.nodes[0][0].neighbour(1) == board.nodes[0][1]);
}
unittest
{
    auto board = New!Board(5, 5);
    board.nodes[0][0].addRoad(Road(2), 1);
    assert(board.nodes[0][1]._roads[4].player == 2);
}
