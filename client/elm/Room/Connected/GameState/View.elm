module GameState.View exposing (htmlView, paramsFromFlags, webglView)

import Animation.Types exposing (Anim(..))
import Assets.Types as Assets
import Background.View as Background
import DeckBuilding.View as DeckBuilding
import GameState.Messages exposing (Msg(..))
import GameState.Types exposing (GameState(..), WaitType(..))
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (class, id, readonly, type_, value)
import Html.Events exposing (onClick)
import Main.Messages as Main
import Main.Types exposing (Flags)
import PlayState.View as PlayState
import Render.Types as Render
import WebGL


htmlView : GameState -> String -> Flags -> Html Main.Msg
htmlView state roomID flags =
    case state of
        Waiting waitType ->
            div [] [ waitingView waitType flags roomID ]

        Selecting _ ->
            text ""

        Started _ ->
            text ""


waitingView : WaitType -> Flags -> String -> Html Main.Msg
waitingView waitType { httpPort, hostname } roomID =
    let
        portProtocol =
            if httpPort /= "" then
                ":" ++ httpPort

            else
                ""

        challengeLink =
            "https://" ++ hostname ++ portProtocol ++ "/play/custom/" ++ roomID

        myID =
            "challenge-link"

        waitingPrompt =
            case waitType of
                WaitCustom ->
                    "Give this link to your opponent"

                WaitQuickplay ->
                    "Finding Opponent"

        waitingInfo : Html Main.Msg
        waitingInfo =
            case waitType of
                WaitCustom ->
                    div [ class "input-group" ]
                        [ input
                            [ value challengeLink
                            , type_ "text"
                            , readonly True
                            , id myID
                            , onClick <| Main.SelectAllInput myID
                            ]
                            []
                        , button
                            [ onClick <| Main.CopyInput myID, class "menu-button" ]
                            [ text "COPY" ]
                        ]

                WaitQuickplay ->
                    text ""
    in
    div [ class "waiting" ]
        [ div [ class "waiting-prompt" ]
            [ text waitingPrompt ]
        , waitingInfo
        ]


webglView : GameState -> Render.Params -> Assets.Model -> List WebGL.Entity
webglView state params assets =
    case state of
        Waiting _ ->
            Background.webglView params assets Finding

        Selecting selecting ->
            DeckBuilding.webglView params selecting assets

        Started started ->
            PlayState.webglView started params assets


paramsFromFlags : Flags -> Render.Params
paramsFromFlags { dimensions, pixelRatio, time } =
    let
        ( w, h ) =
            dimensions
    in
    { w = w
    , h = h
    , pixelRatio = pixelRatio
    , time = time
    }
