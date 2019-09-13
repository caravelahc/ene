module Table exposing (simpleData, simpleDataHeader)

import Html exposing (Html, div, table, text, th, tr)


simpleData : List String
simpleData =
    [ "Centro"
    , "Departamento"
    , "Curso"
    , "Disciplina"
    , "Nome Disciplina"
    , "Aprovados"
    , "Reprovados FS"
    , "Reprovados FI"
    ]


simpleDataHeader : List (Html msg)
simpleDataHeader =
    List.map
        (\h ->
            th [] [ text h ]
        )
        simpleData
