module Clock.Types exposing (..)

import Math.Matrix4 exposing (Mat4)
import Math.Vector2 exposing (Vec2)
import Math.Vector3 exposing (Vec3)
import WebGL.Texture exposing (Texture)
import Resolvable.Types as Resolvable


type alias Model =
    { res : Resolvable.Model }


type alias Uniforms a =
    { a
        | resolution : Vec2
        , texture : Texture
        , rotation : Mat4
        , scale : Mat4
        , color : Vec3
        , worldPos : Vec3
        , worldRot : Mat4
        , perspective : Mat4
        , camera : Mat4
    }


type alias Vertex =
    { position : Vec3
    , coord : Vec2
    }


type alias ClockParams =
    { w : Float
    , h : Float
    , radius : Float
    }
