port module Ports exposing (..)


port selectAllInput : String -> Cmd msg


port copyInput : String -> Cmd msg


port playAudio : ( String, Bool, Bool, Float ) -> Cmd msg


port volume : Int -> Cmd msg


port analytics : String -> Cmd msg
