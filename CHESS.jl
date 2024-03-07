


## CHESS PROJECT.


#
abstract type Piece end

struct Rook <: Piece
    alive::Bool
    team::Bool
    row::Int64
    col::Int64
    Rook() = Rook(false,false,1,1)
end

struct Bishop <: Piece
    alive::Bool
    team::Bool
    row::Int64
    col::Int64
    Bishop() = Bishop(false,false,1,3)
end

struct Chessboard
    Win::Bool
    Board::Matrix{Any}

    Chessboard() = Chessboard(0, CreateChessboard())
end



function CreateChessboard()
    return Array{Any}(undef,8,8)


end


Bishop()

Chessboard().Board






















struct Point{T}
    x::T
    y::T
end



Point{Float64} # es un punto cuyas coordenadas son Float64
Point{Int64} # es un punto cuyas coordenadas son Int64