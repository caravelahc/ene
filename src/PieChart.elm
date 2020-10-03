module PieChart exposing (renderPieGraph)

import Array exposing (Array)
import Color exposing (Color)
import Path
import Shape exposing (defaultPieConfig)
import TypedSvg exposing (g, rect, svg, text_)
import TypedSvg.Attributes exposing (dy, fill, fontFamily, fontSize, height, rx, stroke, textAnchor, transform, viewBox, width, x, y)
import TypedSvg.Core exposing (Svg, text)
import TypedSvg.Types exposing (AnchorAlignment(..), Paint(..), Transform(..), em, percent, pt, px)
import Utils exposing (darkBlue, lightBlue, lightGrey)


type alias ChartConfig =
    { outerRadius : Float
    , innerRadius : Float
    , padAngle : Float
    , cornerRadius : Float
    , labelPosition : Float
    }


defaultChartConfig : ChartConfig
defaultChartConfig =
    { outerRadius = 90
    , innerRadius = 35
    , padAngle = 0.01
    , cornerRadius = 10
    , labelPosition = 100
    }


w : Float
w =
    800


h : Float
h =
    290


colors : Array Color
colors =
    Array.fromList
        [ darkBlue
        , lightBlue
        , lightGrey
        ]


view : ChartConfig -> List Float -> Svg msg
view config model =
    let
        pieData =
            model
                |> Shape.pie
                    { defaultPieConfig
                        | innerRadius = config.innerRadius
                        , outerRadius = config.outerRadius
                        , padAngle = config.padAngle
                        , cornerRadius = config.cornerRadius
                        , sortingFn = \_ _ -> EQ
                    }

        makeSlice index datum =
            Path.element (Shape.arc datum)
                [ fill <|
                    Paint <|
                        Maybe.withDefault Color.black <|
                            Array.get index colors
                , stroke <| Paint Color.white
                ]

        makeLabel slice value =
            let
                label =
                    if value <= 0 then
                        ""

                    else
                        String.fromFloat value

                ( x, y ) =
                    Shape.centroid
                        { slice
                            | innerRadius = config.labelPosition
                            , outerRadius = config.labelPosition
                        }
            in
            text_
                [ transform [ Translate x y ]
                , dy (em 0.35)
                , textAnchor AnchorMiddle
                ]
                [ text label ]
    in
    svg [ viewBox 0 0 w h ]
        [ g [ transform [ Translate (w / 2) (h / 2) ] ]
            [ g [] <| List.indexedMap makeSlice pieData
            , g [] <| List.map2 makeLabel pieData model
            , chartColorLabelSvg
            ]
        ]


chartColorLabelSvg : Svg msg
chartColorLabelSvg =
    svg []
        [ rect
            [ x (percent 15)
            , y (px 5)
            , width (px 20)
            , height (px 20)
            , rx (px 3)
            , fill <| Paint darkBlue
            ]
            []
        , text_
            [ fontSize (pt 10)
            , x (percent 18)
            , y (px 20)
            ]
            [ text "Aprovados" ]
        , rect
            [ x (percent 15)
            , y (px 30)
            , width (px 20)
            , height (px 20)
            , rx (px 3)
            , fill <| Paint lightBlue
            ]
            []
        , text_
            [ fontSize (pt 10)
            , x (percent 18)
            , y (px 45)
            ]
            [ text "Reprovados frequência suficiente" ]
        , rect
            [ x (percent 15)
            , y (px 55)
            , width (px 20)
            , height (px 20)
            , rx (px 3)
            , fill <| Paint lightGrey
            ]
            []
        , text_
            [ fontSize (pt 10)
            , x (percent 18)
            , y (px 70)
            ]
            [ text "Reprovados frequência insuficiente" ]
        ]


renderPieGraph : List Int -> Svg msg
renderPieGraph dataInt =
    view defaultChartConfig
        (dataInt
            |> List.map (\el -> toFloat el)
        )
