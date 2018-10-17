module Stack.Decoders exposing (..)

import Json.Decode as Json exposing (Decoder, field)
import Card.Decoders as Card
import Stack.Types exposing (StackCard)
import WhichPlayer.Decoders as WhichPlayer


stackCardDecoder : Decoder StackCard
stackCardDecoder =
    Json.map2 StackCard
        (field "owner" WhichPlayer.decoder)
        (field "card" Card.decoder)