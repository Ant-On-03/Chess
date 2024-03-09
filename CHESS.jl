


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

struct Game
    Win::Bool
    Team::Bool # 0 para las blancas, 1 para las negras
    Board::Matrix{Any}
    Game(Win,Team, Board) = !is_square_8(Board) ? error("Board not 8x8") : new(Win,Team,Board)
end

# -----------------------------------------------------------------------------------------------
# -------------------------------------- MÉTODOS CLASES -----------------------------------------
# -----------------------------------------------------------------------------------------------


function GetBoard(Game::Game)
    return Game.Board
end

function GetBoard(Game::Game, pos::Vector{Int64})
    return Game.Board[pos[1],pos[2]]
end

function GetWin(Game::Game)
    return Game.Win
end

function GetTeam(Game::Game)
    return Game.Team 
end

function GetTeam(Piece::Piece)
    return Piece.team
end

function ChangeBoard(Game::Game,NewBoard::AbstractArray{Any,2})
    Game.Board = NewBoard
end

function KillPiece(Piece::Piece)
    Piece.alive = false
end

# -----------------------------------------------------------------------------------------------
# ------------------------------------- CREACIÓN DE TABLEROS ------------------------------------
# -----------------------------------------------------------------------------------------------

function is_square_8(matrix::Array{T, 2}) where T
    return size(matrix,1) == size(matrix,2) == 8
end

function CreateEmptyBoard()
    Board = Array{Any,2}(undef,8,8) 
    return Game(false, false, Board)
end

function CreateFullBoard()
    Board::Matrix{Any} = fill(0,(8,8))
    Board[1,1] = Brook()
    Board[1,8] = Brook()
    Board[1,2] = Bbishop()
    Board[1,7] = Bbishop()

    return Game(false, false, Board)
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
    translate =  Dict('a'=>1,'b'=>2,'c'=>3,'d'=>4,'e'=>5,'f'=>6,'g'=>7,'h'=>8,
    '1'=>8,'2'=>7,'3'=>6,'4'=>5,'5'=>4,'6'=>3,'7'=>2,'8'=>1)

    RealCoords = []

    for coord in coords
        
        if haskey(translate, coord)
            push!(RealCoords, translate[coord])
        else
            println("No encontrada la coordinada", coords)
        end
        return RealCoords
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


function BePrinter(Game::Game)
    cnt::Int64 = 8
    abec = "abcdefgh"

    print("  ")
    for letter in abec
        print(letter, " ")
    end

    println("")

    for row in eachrow(GetBoard(Game))
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
# ----------------------------------- COMPROBACIÓN LEGAL ----------------------------------------
# -----------------------------------------------------------------------------------------------

# ----------------------------------------ISA FUNCTIONS------------------------------------------
function IsaRook(Game::Game, Pos::Vector{Int64} )
    return isa(GetBoard(Game, Pos), Rook)
end
function IsaBishop(Game::Game, Pos::Vector{Int64})
    return isa(GetBoard(Game,PosI), Bishop)
end


    



# --------------------------------- CHECKS FOR ROOK ----------------------------------------------


function LegalRook(Game::Game,PosI::Vector{Int64},PosF::Vector{Int64})

    if CanMoveRook(Game::Game,PosI::Vector{Int64},PosF::Vector{Int64})




    else
        return false
    end


end

function PlausiblePosRook(Vector::Vector{Any}, Team::Bool)
    if isa(Vector[1], Rook)

        for item in Vector[2:end]
            
            if isa(item, Piece)

            end
        end




    else
        error("Element 1 from PlausiblePosRook is not a rook")
    end


end
function PlausiblePosRook()


    PlausiblePosRook(Vector, Team)
end

function CanMoveRook(Game::Game, PosI::Vector{Int64}, PosF::Vector{Int64})
    # Checks wether PosF is in the same lane (column or row) than PosI
    return PosI[1]==PosF[1] || PosI[2]==PosF[2]
end


function InMiddleRook(Game::Game, PosI::Vector{Int64}, PosF::Vector{Int64})
    # Checks wether there is any pieces in the middle
    if PosI[1] == PosF[1]
        pos1 = PosI[1]
        for pos2 in PosI[2]:PosF[2]
            if isa(GetBoard(Game,[pos1,pos2]), Piece)

            end
        end
    end
end






# --------------------------------- CHECKS FOR BISHOP -------------------------------------------
function LegalBishop()
end
# -----------------------------------------------------------------------------------------------
# --------------------------------------- CHECKS INITIAL POS -----------------------------------
# -----------------------------------------------------------------------------------------------

function IsaPiece(Game::Game,Coords::Vector{Int64})
    return isa(GetBoard(Game,Coords),Piece)
end

function CorrectTeam(Game::Game,Coords::Vector{Int64})
    return GetTeam(GetBoard(Game, Coords)) == GetTeam(Game)
end

function CheckInitialPosition(Game::Game,Coords::Vector{Int64})
    if IsaPiece(Game,Coords)
        return CorrectTeam(Game, Coords)
    else 
        return false 
    end
end

# -----------------------------------------------------------------------------------------------
# --------------------------------------- CHECKS FINAL POS --------------------------------------
# -----------------------------------------------------------------------------------------------

function EspecificCheck(Game::Game,PosI::Vector{Int64},PosF::Vector{Int64})
    
    if IsaRook(Game, PosI)
        return LegalRook(Game, PosI, PosF)

    elseif IsaBishop(Game, PosI)
        return CheckBishop(Game, PosI, PosF)

    end
end

function CheckFinalPosition(Game::Game,PosI::Vector{Int64},PosF::Vector{Int64})
    
    EspecificCheck(Game,PosI,PosF)


end
# -----------------------------------------------------------------------------------------------
# --------------------------------------- GAME LOOP PRIMITIVO -----------------------------------
# -----------------------------------------------------------------------------------------------


function main()

    println("workinga")

    Game = CreateFullBoard()
    BePrinter(Game)

    while !GetWin(Game)

        BePrinter(Game)

        println("Put the next coordinates in this way [1,a] would be 1a")

        Fakecoordinates = readline()
        coordinates = GetCoords(Fakecoordinates)
        println("the coordinates you choose were $coordinates")





    end

end

main() 
