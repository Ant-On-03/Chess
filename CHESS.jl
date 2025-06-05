


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



mutable struct Game
    Win::Bool
    Team::Bool # 0 para las blancas, 1 para las negras
    Board::Matrix{Any}
    Game(Win,Team, Board) = !is_square_8(Board) ? error("Board not 8x8") : new(Win,Team,Board)
end

# -----------------------------------------------------------------------------------------------
# -------------------------------------- MÉTODOS CLASES -----------------------------------------
# -----------------------------------------------------------------------------------------------

# --------------------------------------- GETTERS Y SETTERS --------------------------------------

# Getters and Setters for Game and Piece
function GetBoard(Game::Game)
    return Game.Board
end

function SetBoard(Game::Game, NewBoard::AbstractArray{Any,2})
    if is_square_8(NewBoard)
        Game.Board = NewBoard
    else
        error("New board is not 8x8")
    end
end

function MovePiece(Game::Game, PosI::Vector{Int64}, PosF::Vector{Int64})
    """
    Changes the position of a piece in the board.
    """
    if isa(GetBoard(Game, PosI), Piece)
        Game.Board[PosF[1], PosF[2]] = GetBoard(Game, PosI)
        Game.Board[PosI[1], PosI[2]] = 0
    else
        error("No piece in position $PosI")
    end
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

function ChangeTeam(Game::Game)
    Game.Team = !Game.Team
end

function ChangeTeam(Game::Game, NewTeam::Bool)
    Game.Team = NewTeam
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

    Board[6,1] = Wrook()
    Board[6,8] = Wrook()

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

    translate = Dict{Char, Int64}(
    'a' => 1, 'b' => 2, 'c' => 3, 'd' => 4, 'e' => 5, 'f' => 6, 'g' => 7, 'h' => 8,
    '1' => 8, '2' => 7, '3' => 6, '4' => 5, '5' => 4, '6' => 3, '7' => 2, '8' => 1
    )
    RealCoords::Vector{Int64} = Int64[]

    for coord in coords        
        if haskey(translate, coord)
            push!(RealCoords, translate[coord])
        else
            println("No encontrada la coordinada", coords)
        end
    end

    return RealCoords

end

# -----------------------------------------------------------------------------------------------
# --------------------------------------------- VISUAL ------------------------------------------
# -----------------------------------------------------------------------------------------------

function Visual(item::Any)
    if isa(item, Piece)

        if isa(item,Rook) && GetTeam(item)
            return "R"
        elseif isa(item,Rook) && !GetTeam(item)
            return "r"
        elseif isa(item,Bishop) && GetTeam(item)
            return "B"
        elseif isa(item,Bishop) && !GetTeam(item)
            return "b"
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

function BePrinter(Game::Game, PlausibleMoves::Vector{Vector{Int64}})
    cnt::Int64 = 8
    abec = "abcdefgh"

    print("  ")
    for letter in abec
        print(letter, " ")
    end

    println("")

    for row in 1:8
        print(cnt, " ")
        cnt -= 1
        for col in 1:8
            if any(isequal([row, col]), PlausibleMoves)
                print("X", " ")
            else
                print(Visual(GetBoard(Game, [row, col])) * " ")
            end
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
"""
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



"""

function AllPlausiblePosRook(Game::Game, PosI::Vector{Int64})
    """
    Returns all plausible positions for a rook given its initial position.
    """
    # PlausiblePositions will be a vector of Integer vectors

    plausible_positions::Vector{Vector{Int64}} = Vector{Vector{Int64}}()

    # Check horizontal movement
    # We add plausible if not piece. We break if ally piece. We add and break if enemy piece
    for col in (PosI[2]+1):8
        # We check wether POSITION is occupied by PIECE of SAMETEAM or NOT.
        Tile = GetBoard(Game, [PosI[1], col])

        if isa(Tile, Piece) && SameTeam(Tile, Game)
            break
        elseif isa(Tile, Piece) && !SameTeam(Tile, Game)
            push!(plausible_positions, [PosI[1], col])
            break
        end
        push!(plausible_positions, [PosI[1], col])
    end

    for col in (PosI[2]-1):-1:1
        Tile = GetBoard(Game, [PosI[1], col])
        if isa(Tile, Piece) && SameTeam(Tile, Game)
            break
        elseif isa(Tile, Piece) && !SameTeam(Tile, Game)
            push!(plausible_positions, [PosI[1], col])
            break
        end
        push!(plausible_positions, [PosI[1], col])
    end

    # Check vertical movement

    for row in (PosI[1]+1):8
        Tile = GetBoard(Game, [row, PosI[2]])
        if isa(Tile, Piece) == true && SameTeam(Tile, Game)
            break
        elseif isa(Tile, Piece) == true && !SameTeam(Tile, Game)
            push!(plausible_positions, [row, PosI[2]])
            break
        end
        push!(plausible_positions, [row, PosI[2]])
    end

    for row in (PosI[1]-1):-1:1
        Tile = GetBoard(Game, [row, PosI[2]])
        if isa(Tile, Piece) == true && SameTeam(Tile, Game)
            break
        elseif isa(Tile, Piece) == true && SameTeam(Tile, Game)
            push!(plausible_positions, [row, PosI[2]])
            break
        end
        push!(plausible_positions, [row, PosI[2]])
    end

    return plausible_positions
end


function AllPlausiblePos(Game::Game, PosI::Vector{Int64})
    """
    Returns all plausible positions for a piece given its initial position.
    """
    if IsaRook(Game, PosI)
        return AllPlausiblePosRook(Game, PosI)
    elseif IsaBishop(Game, PosI)
        return []
        # return AllPlausiblePosBishop(Game, PosI)
    else
        return []  # No plausible positions for other pieces
    end
end



# --------------------------------- CHECKS FOR BISHOP -------------------------------------------
function LegalBishop()
end
# -----------------------------------------------------------------------------------------------
# ----------------------------------------- CHECKS TEAMS ----------------------------------------
# -----------------------------------------------------------------------------------------------
# The idea fot this was to make it so we check wether the move requested is legal or not.


function SameTeam(Piece1::Piece, Piece2::Piece)
    """
    Checks wether Piece1 and Piece2 belong to the same team.
    Returns true if they do, false otherwise.
        input:
            Piece1: Piece object
            Piece2: Piece object
    """
    return GetTeam(Piece1) == GetTeam(Piece2)
end

function SameTeam(Piece::Piece, Game::Game)
    """
    Checks wether Piece belongs to the same team as the Game.
    Returns true if it does, false otherwise.
        input:
            Piece: Piece object
            Game: Game object
    """
    return GetTeam(Piece) == GetTeam(Game)
end

function IsaPiece(Game::Game,Coords::Vector{Int64})
    # Used by CheckInitialPosition
    """
    Checks wether COORDS selected are a Piece.
    Returns true if it is, false otherwise.
        input:
            Game: Game object
            Coords: Vector of Int64 with coordinates of the piece
    """
    return isa(GetBoard(Game,Coords),Piece)
end

function CorrectTeam(Game::Game,Coords::Vector{Int64})
    """
    Checks wether Piece selected BELONGS to same team as PLAYER.
    Returns true if it does, false if it doesn't.
        input:
            Game: Game object
            Coords: Vector of Int64 with coordinates of the piece
    """
    # Used by CheckInitialPosition
    return GetTeam(GetBoard(Game, Coords)) == GetTeam(Game)
end


function CheckInitialPosition(Game::Game,Coords::Vector{Int64})
    """
    Checks wether COORDS selected are PIECE, and wether BELONGS to PLAYER TURN.
    Returns true if both conditions are met, false otherwise.
        input:
            Game: Game object
            Coords: Vector of Int64 with coordinates of the piece
    """
    if IsaPiece(Game,Coords)
        return CorrectTeam(Game, Coords)
    else 
        return false 
    end
end

# -----------------------------------------------------------------------------------------------
# --------------------------------------- CHECKS FINAL POS --------------------------------------
# -----------------------------------------------------------------------------------------------
# The idea for this is to check wether the move requested is legal or not.

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

    println("working")

    Game = CreateFullBoard()
    
    while !GetWin(Game)
        BePrinter(Game)
        println("Put the next coordinates in this way 1a would be [1,a]")
        println("Current team is: ", GetTeam(Game) ? "Black" : "White")

        # We get the coordinates for PosI
        Fakecoordinates = readline()
        PosI = GetCoords(Fakecoordinates)
        println("the coordinates you choose were $PosI")


        # Now coordinates were chosen, we must only follow up if a piece gets selected.
        if CheckInitialPosition(Game, PosI)
            println("PIECE FROM YOUR TEAM!")
            # Once a piece gets selected:
            # We want to print all tiles that are plausible tiles for the piece.
            PosibleTiles = AllPlausiblePos(Game, PosI)

            println("The possible tiles for this piece are: $PosibleTiles")
            BePrinter(Game, PosibleTiles)
            println("Put the next coordinates in this way 1a would be [1,a]")

            # Now its time to choose the final position.
            Fakecoordinates = readline()
            PosF = GetCoords(Fakecoordinates)
            println("the coordinates you choose were $PosF")

            # Now we check if the final position is plausible for the piece.
            
            if PosF in PosibleTiles
                println("The move is plausible")
                # We move the piece.
                MovePiece(Game, PosI, PosF)
            else
                println("The move is not plausible")
                continue
            end








            



            # Where do we move the piece?





        else
            println("PIECE NOT FROM YOUR TEAM OR NOT A PIECE")
            continue
        end





        # Where do we move the piece?





        ChangeTeam(Game)
    end

end

main() 
