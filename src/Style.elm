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
        , margin2 (pct 15) auto
        , padding (px 20)
        , border3 (px 1) solid (hex "#888")
        , width (pct 80)
        ]


modalCloseButtonStyle : Style
modalCloseButtonStyle =
    batch
        [ color (hex "#aaa")
        , float right
        , fontSize (px 28)
        , fontWeight bold
        , hover
            [ color (rgb 0 0 0)
            , textDecoration none
            , cursor pointer
            ]
        ]
