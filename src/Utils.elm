module Utils exposing (semesterList)

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
