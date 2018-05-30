module Clock.Stack exposing (..)

import Animation.Types exposing (Anim(..))
import Animation.State exposing (animToResTickMax)
import Clock.Primitives as Primitives
import Clock.Shaders
import Clock.State exposing (uniforms)
import Clock.Types exposing (ClockParams)
import Ease
import Math.Matrix4 exposing (Mat4, makeRotate, makeScale3)
import Math.Vector3 exposing (Vec3, vec3)
import Maybe.Extra as Maybe
import Stack.Types exposing (Stack)
import WebGL
import WebGL.Texture exposing (Texture)


view : ClockParams -> Stack -> Maybe ( Float, Maybe Anim ) -> Texture -> List WebGL.Entity
view { w, h, radius } stack resInfo texture =
    let
        resTick =
            Maybe.withDefault 0.0 <|
                Maybe.map Tuple.first resInfo

        anim =
            Maybe.join <|
                Maybe.map Tuple.second resInfo

        maxTick =
            animToResTickMax anim

        progress =
            case anim of
                Just (Rotate _) ->
                    Ease.inQuad <| resTick / maxTick

                Just (Play _ _ _) ->
                    1 - (Ease.outQuad <| resTick / maxTick)

                otherwise ->
                    0

        makeCard ( pos, rot ) =
            Primitives.quad Clock.Shaders.fragment <|
                uniforms 0
                    ( floor w, floor h )
                    texture
                    pos
                    rot
                    (makeScale3 (0.13 * radius) (0.13 * radius) 1)
                    (vec3 1 1 1)

        points =
            clockFace
                (List.length stack)
                (vec3 (w / 2) (h / 2) 0)
                (0.62 * radius)
                progress
    in
        case anim of
            otherwise ->
                List.map makeCard points


clockFace : Int -> Vec3 -> Float -> Float -> List ( Vec3, Mat4 )
clockFace n origin radius progress =
    let
        segments : Int
        segments =
            12

        indexes : List Int
        indexes =
            List.range 1 n

        genPoint : Int -> ( Vec3, Mat4 )
        genPoint i =
            ( Math.Vector3.add origin <| offset i, rotation i )

        segmentAngle : Float
        segmentAngle =
            -2.0 * pi / toFloat segments

        rot : Int -> Float
        rot i =
            (toFloat i * segmentAngle)
                - (progress * segmentAngle)

        offset : Int -> Vec3
        offset i =
            Math.Vector3.scale -radius <|
                vec3 (sin <| rot i) (cos <| rot i) 0

        rotation : Int -> Mat4
        rotation i =
            makeRotate (2 * pi - rot i) (vec3 0 0 1)
    in
        List.map genPoint indexes
