


## CHESS PROJECT.
## Las classes creadas por nosotros no guardan relaciones entre ellas. de contenerse.


# -----------------------------------------------------------------------------------------------
# ------------------------------------------- CLASES --------------------------------------------
# -----------------------------------------------------------------------------------------------
abstract type Piece end

struct Rook <: Piece
    alive::Bool
    team::Bool
end

struct Bishop <: Piece
    alive::Bool
    team::Bool
end

struct ChessBoard
    Win::Bool
    Board::Matrix{Any}
    ChessBoard(Win, Board) = !is_square_8(Board) ? error("Board not 8x8") : new(Win,Board)
end

# -----------------------------------------------------------------------------------------------
# -------------------------------------- MÉTODOS CLASES -----------------------------------------
# -----------------------------------------------------------------------------------------------


function GetBoard(ChessBoard::ChessBoard)
    return ChessBoard.Board
end

function GetBoard(ChessBoard::ChessBoard, pos::Vector{Int64})
    return ChessBoard.Board[pos[1],pos[2]]
end

function GetWin(ChessBoard::ChessBoard)
    return ChessBoard.Win
end

function ChangeBoard(ChessBoard::ChessBoard,NewBoard::AbstractArray{Any,2})
    ChessBoard.Board = NewBoard
end

function KillPiece(Piece::Piece)
    Piece.alive = false
end



# -----------------------------------------------------------------------------------------------
# ----------------------------------- COMPROBACIÓN LEGAL ----------------------------------------
# -----------------------------------------------------------------------------------------------

function CheckRook(ChessBoard::ChessBoard, Pos::Vector{Int64} )
    return isa(GetBoard(ChessBoard, Pos), Rook)
end

function CheckRook(ChessBoard::ChessBoard, Pos::Vector{Int64})
    return typeof(ChessBoard[Pos[1], Pos[2]])
end

function CanMove(ChessBoard, PosI, PosF)
    
end

function CanMoveRook(ChessBoard::ChessBoard, PosI::Vector{Int64}, PosF::Vector{Int64})
    # Checks wether PosF is in the same lane (column or row) than PosI
    return PosI[1]==PosF[1] || PosI[2]==PosF[2]
end



function InMiddleRook(ChessBoard::ChessBoard, PosI::Vector{Int64}, PosF::Vector{Int64})
    # Checks wether there is any pieces in the middle
    if PosI[1] == PosF[1]
        pos1 = PosI[1]
        for pos2 in PosI[2]:PosF[2]
            if isa(GetBoard(ChessBoard,[pos1,pos2]), Piece)

            end
        end
    end
end

# -----------------------------------------------------------------------------------------------
# ------------------------------------- CREACIÓN DE TABLEROS ------------------------------------
# -----------------------------------------------------------------------------------------------

function is_square_8(matrix::Array{T, 2}) where T
    return size(matrix,1) == size(matrix,2) == 8
end

function CreateEmptyBoard()
    Board = Array{Any,2}(undef,8,8) 
    return ChessBoard(false, Board)
end

function CreateFullBoard()
    Board::Matrix{Any} = fill(0,(8,8))
    Board[1,1] = Brook()
    Board[1,8] = Brook()
    Board[1,2] = Bbishop()
    Board[1,7] = Bbishop()

    return ChessBoard(false, Board)
end

# -----------------------------------------------------------------------------------------------
# ------------------------------------- CREACIÓN DE PIEZAS --------------------------------------
# -----------------------------------------------------------------------------------------------
# WHITE IS false, BLACK IS true

function Wrook()
    return Rook(true,false)
end
function Brook()
    return Rook(true,true)
end
function Wbishop()
    return Bishop(true,false)
end
function Bbishop()
    return Bishop(true,true)
end



# -----------------------------------------------------------------------------------------------
# --------------------------------------- ESCOGER CASILLA ---------------------------------------
# -----------------------------------------------------------------------------------------------


function GetCoords(coords)
    translate = Dict("a"=>1,"b"=>2,"c"=>3,"d"=>4,"e"=>5,"f"=>6,"g"=>7,"h"=>8,
    "1"=>8,"2"=>7,"3"=>6,"4"=>5,"5"=>4,"6"=>3,"7"=>2,"8"=>1)

    for coord in coords
        #ranslate[coord]
    end
end


# -----------------------------------------------------------------------------------------------
# --------------------------------------------- VISUAL ------------------------------------------
# -----------------------------------------------------------------------------------------------

function Visual(item::Any)
    if isa(item, Piece)

        if isa(item,Rook)
            return "R"
        elseif isa(item,Bishop)
            return "B"
        else
            return "P"
        end
    else
        return "-"
    end
end


function BePrinter(ChessBoard::ChessBoard)
    cnt::Int64 = 8
    abec = "abcdefgh"

    print("  ")
    for letter in abec
        print(letter, " ")
    end

    println("")

    for row in eachrow(GetBoard(ChessBoard))
        print(cnt, " ")
        cnt -= 1
        for item in row
            print(Visual(item) * " ")

            #print(Visual(item), " ")
        end
        println("")
    end
end

# -----------------------------------------------------------------------------------------------
# --------------------------------------- GAME LOOP PRIMITIVO -----------------------------------
# -----------------------------------------------------------------------------------------------



function main()

    println("workinga")

    ChessBoard = CreateFullBoard()
    BePrinter(ChessBoard)

    while !GetWin(ChessBoard)

        BePrinter(ChessBoard)

        println("Put the next coordinates in this way [1,4] would be 14")
        coordinates = readline()
        println(coordinates)
        coordinates = GetCoords(coordinates)
        println("the coordinates you choose were $coordinates")

    end

end

main() 











Game = CreateFullBoard()
BePrinter(Game)


for row in eachrow(GetBoard(Game))
    for item in row
        print(item)
    end
    println(row)
end
