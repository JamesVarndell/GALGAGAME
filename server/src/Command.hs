module Command where

import Data.Monoid ((<>))
import Data.String.Conversions (cs)

import qualified Data.Text as Text
import Data.Text (Text)

import GameState (Username)
import Safe (readMay)
import Util (breakAt)


data Command =
    ChatCommand Username Text
  | PlayCommand Username
  | SpectateCommand Username
  | LeaveCommand Username
  | EndTurnCommand
  | PlayCardCommand Int
  | HoverCardCommand (Maybe Int)
  | RematchCommand
  | ConcedeCommand
  | SelectCharacterCommand Text
  | ErrorCommand Text
  deriving (Show)


parse :: Username -> Text -> Command
parse name msg =
  let
    (command, content) = breakAt ":" msg :: (Text, Text)
  in
    case command of
      "end" ->
        EndTurnCommand
      "play" ->
        case readMay . cs $ content of
          Just index ->
            PlayCardCommand index
          Nothing ->
            ErrorCommand (content <> " not a hand card index")
      "hover" ->
        case content of
          "null" ->
            HoverCardCommand Nothing
          _ ->
            case readMay . cs $ content of
              Just index ->
                HoverCardCommand (Just index)
              Nothing ->
                ErrorCommand (content <> " not a hand card index")
      "chat" ->
        ChatCommand name content
      "rematch" ->
        RematchCommand
      "concede" ->
        ConcedeCommand
      "selectCharacter" ->
        SelectCharacterCommand content
      _ ->
        ErrorCommand $ "Unknown Command " <> (cs $ show command)