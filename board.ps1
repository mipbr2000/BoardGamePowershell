class Board {

    [int] $height
    [int] $wide
    [Tile[]]$tiles
    Board([int] $height, [int] $wide) {
        $this.height = $height
        $this.wide = $wide
        $this.createBoardTiles([TileFactory]::new())
    }

    [string] getRandomTerrain() {
        return [Terrain](Get-Random -Minimum 0 -Maximum $([Enum]::GetValues([Terrain]).Count))
    }

    [string] getRandomUnit() {
        return [Unit](Get-Random -Minimum 0 -Maximum $([Enum]::GetValues([Unit]).Count))
    }

    [string] getRandomPlayer() {
        return [Player](Get-Random -Minimum 0 -Maximum $([Enum]::GetValues([Player]).Count))
    }

    initializeTile([Tile] $tile) {
        $tile.setTerrain($this.getRandomTerrain())
        $tile.setPlayer($this.getRandomPlayer())
        $tile.addUnit($this.getRandomUnit())
    }

    createBoardTiles([AbstractFactory] $factory) {
        foreach ($xTile in (1..$this.wide)) {
            foreach ($yTile in (1..$this.height)) {
                $new_tile = $factory.createTile($xTile, $yTile)
                $this.initializeTile($new_tile)
                $this.tiles += $new_tile
            }
        }
    }

    [Tile] findTile([int] $x, [int] $y) {
        foreach ($singleTile in $this.tiles) {
            if (($singleTile.x -eq $x) -and ($singleTile.y -eq $y)) {
                return $singleTile
            }
        }
        return $null
    }

    [void] addUnitToTile([Tile] $tile, [Unit] $Unit) {
        $tile.addUnit($unit)
    }

    [void] removeUnitFromTile([Tile] $tile, [Unit] $Unit) {
        $tile.removeUnit($unit)
    }

}

[Flags()] enum Terrain {
    Dry
    Water
    Sand
    Mood
}

[Flags()] enum Unit {
    None
    Soldier
    Tank
}

[Flags()] enum Player {
    Player1
    Player2
}

class Tile {

    [int] $x
    [int] $y
    [string] $terrain
    [string] $player
    [System.Collections.Generic.List[object]]$_units = @()

    Tile([int] $x, [int] $y) {
        $this.x = $x
        $this.y = $y
    }

    [string] getTerrain() { return $this.terrain }
    setTerrain([string] $terrain) { $this.terrain = $terrain }

    [string] getPlayer() { return $this.player }
    setPlayer([string] $player) { $this.player = $player }

    addUnit([object] $unit) {
        $this._units.Add($unit)
    }

    removeUnit([object] $unit) {
        $this._units.Remove($unit)
    }

    getUnits() {
        foreach ($unit in $this._units) {
            write-host $unit.GetType().Name
        }
    }

    notify() {}
}

class Game {

}



"wait"

class AbstractFactory {
    createBoard() {}
    createTile() {}
}
class BoardFactory: AbstractFactory {
    [Board] createBoard([int] $height, [int] $wide) { return [Board]::new($height, $wide) }
}
class TileFactory: AbstractFactory {
    [Tile] createTile([int] $x, [int] $y) { return [Tile]::new($x, $y) }
}

$board = [Board]::new(10, 8)

$tile = $board.findTile(3, 5)

"wait"
