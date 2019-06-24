module Endgame.View exposing (view)

import Animation.Types exposing (Anim(..))
import Connected.Messages as Connected
import GameState.Messages as GameState
import GameType exposing (GameType(..))
import Html exposing (Html, a, button, div, text)
import Html.Attributes exposing (class, classList, disabled, href, style)
import Html.Events exposing (onClick)
import Main.Messages as Main
import PlayState.Messages exposing (Msg(..), PlayingOnly(..))
import Room.Messages as Room
import Stats exposing (Experience, StatChange, levelAt, levelFromExperience, nextLevelAt)
import WhichPlayer.Types exposing (WhichPlayer(..))


view : Float -> Anim -> Maybe String -> Maybe StatChange -> Maybe GameType -> Maybe String -> Html Main.Msg
view progress anim mReplayId mXp gameType mUsername =
    let
        ( show, endGameText, endGameClass ) =
            case anim of
                GameEnd (Just PlayerA) ->
                    ( True, "VICTORY", "victory" )

                GameEnd (Just PlayerB) ->
                    ( True, "DEFEAT", "defeat" )

                GameEnd Nothing ->
                    ( True, "DRAW", "draw" )

                _ ->
                    ( False, "", "no-win" )

        isDisabled =
            not show && (progress < 0.8)

        rematchButton =
            case ( gameType, anim ) of
                ( Just TutorialGame, GameEnd (Just PlayerA) ) ->
                    button
                        [ class "rematch"
                        , onClick <|
                            Main.RoomMsg <|
                                Room.ConnectedMsg <|
                                    Connected.GameStateMsg <|
                                        GameState.PlayStateMsg <|
                                            GotoComputerGame
                        , disabled isDisabled
                        ]
                        [ text "Play Again" ]

                ( Just DailyGame, GameEnd (Just PlayerA) ) ->
                    button
                        [ class "rematch"
                        , onClick <|
                            Main.RoomMsg <|
                                Room.ConnectedMsg <|
                                    Connected.GameStateMsg <|
                                        GameState.PlayStateMsg <|
                                            GotoComputerGame
                        , disabled isDisabled
                        ]
                        [ text "Play again" ]

                _ ->
                    button
                        [ class "rematch"
                        , onClick <|
                            Main.RoomMsg <|
                                Room.ConnectedMsg <|
                                    Connected.GameStateMsg <|
                                        GameState.PlayStateMsg <|
                                            PlayingOnly Rematch
                        , disabled isDisabled
                        ]
                        [ text "Play Again" ]

        watchReplayButton =
            case mReplayId of
                Just replayId ->
                    button
                        [ class "replay"
                        , onClick <|
                            Main.RoomMsg <|
                                Room.ConnectedMsg <|
                                    Connected.GameStateMsg <|
                                        GameState.PlayStateMsg <|
                                            GotoReplay replayId
                        , disabled isDisabled
                        ]
                        [ text "Watch Replay" ]

                Nothing ->
                    button
                        [ class "replay", disabled True ]
                        [ text "Watch Replay" ]

        experienceDisplay =
            case mXp of
                Just { initialXp, finalXp } ->
                    let
                        xp : Experience
                        xp =
                            initialXp + progress * (finalXp - initialXp)
                    in
                    div [ class "experience" ]
                        [ div [ class "experience-progress" ]
                            [ div
                                [ class "experience-level-badge" ]
                                [ text <| String.fromInt <| levelFromExperience xp ]
                            , div
                                [ class "experience-bar"
                                , style "width" <|
                                    String.fromFloat
                                        (100 * (xp - levelAt xp) / (nextLevelAt xp - levelAt xp))
                                        ++ "%"
                                ]
                                []
                            ]
                        ]

                Nothing ->
                    div [] []

        conversionLink =
            div [ class "endgame-conversion" ]
                [ case mUsername of
                    Just _ ->
                        a [ href "https://discord.gg/SVXXej4" ] [ text "Join the community on Discord" ]

                    Nothing ->
                        a [ href "/signup" ] [ text "Sign up to gain experience" ]
                ]

        styles =
            if show then
                style "opacity" <| String.fromFloat progress

            else
                style "" ""

        classes =
            classList
                [ ( "endgame-layer", True )
                , ( endGameClass, True )
                ]
    in
    div [ classes, styles ]
        [ div [ class "endgame-container" ]
            [ div
                [ class endGameClass ]
                [ text endGameText ]
            , experienceDisplay
            , div [ class "endgame-buttons" ]
                [ rematchButton
                , watchReplayButton
                ]
            , conversionLink
            ]
        ]
