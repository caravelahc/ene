module Table exposing
    ( classToCompactDataElement
    , placeholderClass
    )

import Data exposing (Class)
import Html exposing (Html, td, text, tr)


classToCompactDataElement : Class -> Html msg
classToCompactDataElement class =
    tr []
        [ td [] [ text class.center ]
        , td [] [ text class.department ]
        , td [] [ text class.classCourse ]
        , td [] [ text class.courseCode ]
        , td [] [ text class.courseName ]
        , td [] [ text (String.fromInt class.studentsWithGrades) ]
        , td [] [ text (String.fromInt class.approved) ]
        , td [] [ text (String.fromInt class.disapprovedSP) ]
        , td [] [ text (String.fromInt class.disapprovedIP) ]
        ]


placeholderClass : Class
placeholderClass =
    let
        pStr =
            "---"

        pInt =
            0
    in
    { semester = pStr
    , center = pStr
    , centerName = pStr
    , department = pStr
    , departmentName = pStr
    , classCourse = pStr
    , courseCode = pStr
    , courseName = pStr
    , credits = pInt
    , notes100 = pInt
    , notes95and90 = pInt
    , notes85and80 = pInt
    , notes75and70 = pInt
    , notes65and60 = pInt
    , notes55and50 = pInt
    , notes45and40 = pInt
    , notes35and30 = pInt
    , notes25and20 = pInt
    , notes15and05 = pInt
    , notes0SP = pInt
    , notes0IP = pInt
    , studentsWithGrades = pInt
    , mentionOne = pInt
    , approved = pInt
    , disapprovedSP = pInt
    , disapprovedIP = pInt
    }
