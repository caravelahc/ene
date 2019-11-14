module Chart exposing (renderGradesChart)

import Axis
import Data exposing (ChartTuple)
import Scale exposing ( BandScale, ContinuousScale, defaultBandConfig)
import TypedSvg exposing (g, rect, style, svg, text_)
import TypedSvg.Attributes exposing (class, textAnchor, transform, viewBox)
import TypedSvg.Attributes.InPx exposing (height, width, x, y)
import TypedSvg.Core exposing (Svg, text)
import TypedSvg.Types exposing (AnchorAlignment(..), Transform(..))


w : Float
w =
    900


h : Float
h =
    450


padding : Float
padding =
    30


xScale : List ChartTuple -> BandScale Int
xScale model =
    List.map Tuple.first model
        |> Scale.band
            { defaultBandConfig | paddingInner = 0.1, paddingOuter = 0.2 }
            ( 0, w - 2 * padding )


xAxisFormat : Int -> String
xAxisFormat n =
    String.fromInt n


yScale : ContinuousScale Float
yScale =
    Scale.linear ( h - 2 * padding, 0 ) ( 0, 10 )


xAxis : List ChartTuple -> Svg msg
xAxis model =
    Axis.bottom [] (Scale.toRenderable xAxisFormat (xScale model))


yAxis : Svg msg
yAxis =
    Axis.left [ Axis.tickCount 5 ] yScale


column : BandScale Int -> ChartTuple -> Svg msg
column scale ( gradeGroup, studentsInt ) =
    let
        students =
            toFloat studentsInt
    in
    g
        [ class [ "column" ] ]
        [ rect
            [ x <| Scale.convert scale gradeGroup
            , y <| Scale.convert yScale students
            , width <| Scale.bandwidth scale
            , height <| h - Scale.convert yScale students - 2 * padding
            ]
            []
        , text_
            [ x <| Scale.convert (Scale.toRenderable xAxisFormat scale) gradeGroup
            , y <| Scale.convert yScale students - 5
            , textAnchor AnchorMiddle
            ]
            [ text <| String.fromFloat students ]
        ]


renderGradesChart : List ChartTuple -> Svg msg
renderGradesChart model =
    svg [ viewBox 0 0 w h ]
        [ style [] [ text """
            .column rect { fill: rgba(118, 214, 78, 0.8); }
            .column text { display: none; }
            .column:hover rect { fill: rgb(118, 214, 78); }
            .column:hover text { display: inline; }
          """ ]
        , g [ transform [ Translate (padding - 1) (h - padding) ] ]
            [ xAxis model ]
        , g [ transform [ Translate (padding - 1) padding ] ]
            [ yAxis ]
        , g [ transform [ Translate padding padding ], class [ "series" ] ] <|
            List.map (column (xScale model)) model
        ]
