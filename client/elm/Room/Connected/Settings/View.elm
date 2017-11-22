module Settings.View exposing (view)

import Connected.Messages as Connected
import Html exposing (..)
import Html.Attributes as H exposing (..)
import Html.Events exposing (onClick, onInput)
import Room.Messages as Room
import Settings.Messages exposing (Msg(..))
import Settings.Types exposing (..)


view : Model -> Html Room.Msg
view { modalState, volume } =
    let
        settingsStyle =
            case modalState of
                Closed ->
                    style [ ( "display", "none" ) ]

                Open ->
                    style []
    in
        div [ class "settings-layer" ]
            [ img
                [ class "settings-icon"
                , src "/img/icon/settings.svg"
                , onClick <|
                    Room.ConnectedMsg <|
                        Connected.SettingsMsg <|
                            ToggleSettings
                ]
                []
            , div
                [ settingsStyle
                , class "settings-open"
                ]
                [ div
                    [ class "settings-body"
                    ]
                    [ div [ class "settings-inner" ]
                        [ h1 [] [ text "Settings" ]
                        , label [ class "settings-volume" ]
                            [ text "Master Volume"
                            , input
                                [ class "settings-slider"
                                , type_ "range"
                                , H.min "0"
                                , H.max "100"
                                , value <| toString volume
                                , onInput
                                    (\v ->
                                        Room.ConnectedMsg <|
                                            Connected.SetVolume <|
                                                Result.withDefault 0 (String.toInt v)
                                    )
                                ]
                                []
                            ]
                        , button
                            [ class "settings-button"
                            , onClick <|
                                Room.ConnectedMsg <|
                                    Connected.Concede
                            ]
                            [ text "Concede" ]
                        ]
                    ]
                ]
            ]