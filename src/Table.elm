module Table exposing (classToSimpleDataElement, simpleData, simpleDataHeader)

import Decoder exposing (Class)
import Html exposing (Html, td, text, th, tr)


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


simpleDataHeader : Html msg
simpleDataHeader =
    tr []
        (List.map
            (\h -> th [] [ text h ])
            simpleData
        )


classToSimpleDataElement : Class -> Html msg
classToSimpleDataElement class =
    tr []
        [ td [] [ text class.centerName ]
        , td [] [ text class.departmentName ]
        , td [] [ text class.classCourse ]
        , td [] [ text class.courseCode ]
        , td [] [ text class.courseName ]
        , td [] [ text class.approved ]
        , td [] [ text class.disapprovedSP ]
        , td [] [ text class.disapprovedIP ]
        ]
