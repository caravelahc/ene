module Utils exposing (d, errorToString, semesterList, stringTrimToInt)

import Html exposing (Html, div)
import Http exposing (Error(..))
import List.Extra exposing (cartesianProduct, getAt)


concatLists : List Int -> String
concatLists list =
    let
        first =
            Maybe.withDefault 0 (getAt 0 list)

        second =
            Maybe.withDefault 0 (getAt 1 list)
    in
    String.fromInt first ++ String.fromInt second


semesterList : Int -> Int -> List String
semesterList start end =
    let
        years =
            List.range start end

        semesters =
            [ 1, 2 ]

        cartesian =
            cartesianProduct [ years, semesters ]
    in
    List.map concatLists cartesian
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


d : Html msg
d =
    -- This function is placed here so elm-analyse doesn't freak out with an unused package.
    -- Configuring unused imports is impossible and Elm freaks out when you try removing elm/html
    div [] []
