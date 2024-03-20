#pragma once

#include <QObject>


typedef struct MapTileSet_t {
    int tileX0 {0};
    int tileX1 {0};
    int tileY0 {0};
    int tileY1 {0};
    quint64 tileCount {0};
    quint64 tileSize {0};

    void clear() {
        tileX0 = 0;
        tileX1 = 0;
        tileY0 = 0;
        tileY1 = 0;
        tileCount = 0;
        tileSize = 0;
    }

    MapTileSet_t &operator+=(const MapTileSet_t &other) {
        tileX0 += other.tileX0;
        tileX1 += other.tileX1;
        tileY0 += other.tileY0;
        tileY1 += other.tileY1;
        tileCount += other.tileCount;
        tileSize += other.tileSize;
        return *this;
    }
}   MapTileSet_t;
