class Board {

    [int] $height
    [int] $wide
    [Square[]] $squares

    Board([int] $height, [int] $wide) {
        $this.height = $height
        $this.wide = $wide
        $this.loadBoard([SquareFactory]::new())
        $this.addLabel()
    }

    loadBoard([AbstractFactory] $factory) {
        $counter = 0
        foreach ($xSquare in (1..$this.wide)) {
            foreach ($ySquare in (1..$this.height)) {
                $this.squares += $factory.createSquare($xSquare, $ySquare)

                # write-host $counter
                $counter ++
            }
        }
    }

    addLabel() {
        $counter = 0
        $charIni = 64
        foreach ($singleSquare in $this.squares) {
            $label = $([char]$($singleSquare.x + $charIni)) + $([char]$($singleSquare.y + $charIni))
            $this.squares[$counter].label = $label
            write-host $this.squares[$counter].label "->" $this.squares[$counter].x ", " $this.squares[$counter].y
            $counter ++
        }
    }

    findSquare([int] $x, [int] $y) {
        foreach ($singleSquare in $this.squares) {
            if (($singleSquare.x -eq $x) -and ($singleSquare.y -eq $y)) {
                write-host $singleSquare.label
            }
        }
    }

}

class Square {
    [int] $x
    [int] $y
    [string] $label
    [string] $description



    Square([int] $x, [int] $y) {
        $this.x = $x
        $this.y = $y
    }

    setLable([string] $label) {
        $this.label = $label
    }

    [string] getDescription() {
        return $this.description
    }
}

class DryLand: Square {
    DryLand() {
        $this.description = "DryLand"
    }
}
class Water: Square {
    Water() {
        $this.description = "Water"
    }
}


class SquareDecorator: Square {
    [Square] $square
    Unit([Square] $square) {
        $this.square = $square
    }
    [string] getDescription() {
        return $this.description
    }
}

class Unit: SquareDecorator {

    [string] getDescription() {
        return $this.square.getDescription() + "Unit"
    }

}
class Soldier:Unit {
    [string] getDescription() {
        return $this.square.getDescription() + "Soldier"
    }
}
class Tank:Unit {
    [string] getDescription() {
        return $this.square.getDescription() + "Tank"
    }
}


class AbstractFactory {
    createBoard() {}
    createSquare() {}
    createUnit() {}
    createTerrain() {}
}
class BoardFactory: AbstractFactory {
    [Board] createBoard([int] $height, [int] $wide) {
        return [Board]::new($height, $wide)
    }
}
class SquareFactory: AbstractFactory {
    [Square] createSquare([int] $x, [int] $y) {
        return [Square]::new($x, $y)
    }
}
class UnitFactory: AbstractFactory {
    [Unit] createUnit([string] $type) {
        return New-Object -TypeName $type
    }
}
class TerrainFactory: AbstractFactory {
    [Terrain] createUnit([string] $type) {
        return New-Object -TypeName $type
    }
}

$board = [Board]::new(8, 8)
$board.findSquare(1, 2)
