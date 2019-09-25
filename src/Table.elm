module Table exposing
    ( classToCompactDataElement
    , compactData
    , compactDataHeader
    , placeholderClass
    )

import Decoder exposing (Class)
import Html exposing (Html, td, text, th, tr)


compactData : List String
compactData =
    [ "Centro"
    , "Departamento"
    , "Curso"
    , "Disciplina"
    , "Nome Disciplina"
    , "Alunos Total"
    , "Aprovados"
    , "Reprovados FS"
    , "Reprovados FI"
    ]


compactDataHeader : Html msg
compactDataHeader =
    tr []
        (List.map
            (\h -> th [] [ text h ])
            compactData
        )


classToCompactDataElement : Class -> Html msg
classToCompactDataElement class =
    tr []
        [ td [] [ text class.center ]
        , td [] [ text class.department ]
        , td [] [ text class.classCourse ]
        , td [] [ text class.courseCode ]
        , td [] [ text class.courseName ]
        , td [] [ text class.studentsWithGrades ]
        , td [] [ text class.approved ]
        , td [] [ text class.disapprovedSP ]
        , td [] [ text class.disapprovedIP ]
        ]


placeholderClass : Class
placeholderClass =
    let
        p =
            "---"
    in
    { semester = p
    , center = p
    , centerName = p
    , department = p
    , departmentName = p
    , classCourse = p
    , courseCode = p
    , courseName = p
    , credits = p
    , notes100 = p
    , notes95and90 = p
    , notes85and80 = p
    , notes75and70 = p
    , notes65and60 = p
    , notes55and50 = p
    , notes45and40 = p
    , notes35and30 = p
    , notes25and20 = p
    , notes15and05 = p
    , notes0SP = p
    , notes0IP = p
    , studentsWithGrades = p
    , mentionOne = p
    , approved = p
    , disapprovedSP = p
    , disapprovedIP = p
    }
