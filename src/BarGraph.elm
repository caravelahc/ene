module BarGraph exposing (renderGradesChart)

import Axis
import Data exposing (ChartTuple)
import Scale exposing (BandScale, ContinuousScale, defaultBandConfig)
import TypedSvg exposing (g, rect, style, svg, text_)
import TypedSvg.Attributes exposing (class, textAnchor, transform, viewBox)
import TypedSvg.Attributes.InPx exposing (height, width, x, y)
import TypedSvg.Core exposing (Svg, text)
import TypedSvg.Types exposing (AnchorAlignment(..), Transform(..))


w : Float
w =
    500


h : Float
h =
    250


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
    if n == -1 then
        "FI"

    else
        String.fromInt n


xAxis : List ChartTuple -> Svg msg
xAxis data =
    Axis.bottom [] (Scale.toRenderable xAxisFormat (xScale data))


yScale : ContinuousScale Float
yScale =
    let
        maxY =
            30
    in
    Scale.linear ( h - 2 * padding, 0 ) ( 0, maxY )


yAxis : Svg msg
yAxis =
    Axis.left [ Axis.tickCount 7 ] yScale


column : BandScale Int -> ChartTuple -> Svg msg
column data tuple =
    let
        gradeGroup =
            Tuple.first tuple

        students =
            toFloat (Tuple.second tuple)
    in
    g [ class [ "column" ] ]
        [ rect
            [ x <| Scale.convert data gradeGroup
            , y <| Scale.convert yScale students
            , width <| Scale.bandwidth data
            , height <| h - Scale.convert yScale students - 2 * padding
            ]
            []
        , text_
            [ x <| Scale.convert (Scale.toRenderable xAxisFormat data) gradeGroup
            , y <| Scale.convert yScale students - 5
            , textAnchor AnchorMiddle
            ]
            [ text <| String.fromFloat students ]
        ]


renderGradesChart : List ChartTuple -> Svg msg
renderGradesChart data =
    svg [ viewBox 0 0 w h ]
        [ style [] [ text """
            .column rect { fill: rgba(0, 59, 111, 0.75); }
            .column text { display: none; }
            .column:hover rect { fill: rgba(0, 59, 111, 1); }
            .column:hover text { display: block; }
          """ ]
        , g [ transform [ Translate (padding - 1) (h - padding) ] ]
            [ xAxis data ]
        , g [ transform [ Translate (padding - 1) padding ] ]
            [ yAxis ]
        , g [ transform [ Translate padding padding ], class [ "series" ] ] <|
            List.map (column (xScale data)) data
        ]
