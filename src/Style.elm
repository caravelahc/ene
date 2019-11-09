module Style exposing (..)

import Css exposing (..)


modalStyle : Style
modalStyle =
    batch
        [ position fixed
        , zIndex (int 1)
        , top (px 0)
        , left (px 0)
        , width (pct 100)
        , height (pct 100)
        , overflow auto
        , backgroundColor (rgb 0 0 0)
        , backgroundColor (rgba 0 0 0 0.4)
        ]


modalContentStyle : Style
modalContentStyle =
    batch
        [ backgroundColor (hex "#fefefe")
        , margin (pct 15)
        , padding (px 20)
        , border (px 1)
        , width (pct 80)
        ]
