module Utils exposing
    ( darkBlue
    , errorToString
    , lightBlue
    , lightGrey
    , semesterRangeList
    , stringTrimToInt
    )

import Color exposing (Color)
import Http exposing (Error(..))
import List.Extra exposing (cartesianProduct, getAt)


darkBlue : Color
darkBlue =
    Color.rgb255 0 59 111


lightBlue : Color
lightBlue =
    Color.rgb255 51 153 255


lightGrey : Color
lightGrey =
    Color.rgb255 192 192 192


concatFirstTwoElements : List Int -> String
concatFirstTwoElements list =
    let
        first =
            Maybe.withDefault 0 (getAt 0 list)

        second =
            Maybe.withDefault 0 (getAt 1 list)
    in
    String.fromInt first ++ String.fromInt second


semesterRangeList : Int -> Int -> List String
semesterRangeList start end =
    let
        years =
            List.range start end

        semesters =
            [ 1, 2 ]

        cartesian =
            cartesianProduct [ years, semesters ]
    in
    List.map concatFirstTwoElements cartesian
        |> List.reverse


stringTrimToInt : String -> Maybe Int
stringTrimToInt str =
    str
        |> String.trim
        |> String.toInt


errorToString : Http.Error -> String
errorToString err =
    case err of
        Timeout ->
            "Timeout exceeded"

        NetworkError ->
            "Network error"

        BadStatus _ ->
            "BadStatus"

        BadBody _ ->
            "Bad Body"

        BadUrl url ->
            "Malformed url: " ++ url
