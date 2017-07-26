module Settings.State exposing (init, update)

import Settings.Messages exposing (Msg(..))
import Settings.Types exposing (..)


init : Model
init =
    { modalState = Closed
    , volume = 100
    }


update : Msg -> Model -> Model
update msg ({ modalState, volume } as m) =
    case msg of
        ToggleSettings ->
            case modalState of
                Closed ->
                    { m | modalState = Open }

                Open ->
                    { m | modalState = Closed }

        OpenSettings ->
            { m | modalState = Open }

        CloseSettings ->
            { m | modalState = Closed }