module Model.State exposing (..)

import Model.Types exposing (Model, WhichPlayer(..))


init : Model
init =
    { hand = []
    , otherHand = 0
    , stack = []
    , turn = PlayerA
    , life = 100
    , otherLife = 100
    , otherHover = Nothing
    }


maxHandLength : Int
maxHandLength =
    6
