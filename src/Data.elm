module Data exposing
    ( Class
    , Course
    , Semester
    , availableCourses
    , courseToString
    , defaultCourse
    , lastSemesterFromCourse
    , semesterString
    , stringToCourse
    )

import List.Extra exposing (find)
import Utils exposing (semesterList)


type alias Course =
    { code : String
    , name : String
    , availableSemesters : List String
    }


courseToString : Course -> String
courseToString course =
    course.code ++ " - " ++ course.name


defaultCourse : Course
defaultCourse =
    { code = "208"
    , name = "CIÊNCIAS DA COMPUTAÇÃO"
    , availableSemesters = List.drop 1 (semesterList 2009 2019) -- drop inexistent 20192
    }


availableCourses : List Course
availableCourses =
    [ defaultCourse
    ]


stringToCourse : String -> List Course -> Maybe Course
stringToCourse courseCode list =
    find (\course -> course.code == courseCode) list


type alias Semester =
    ( Int, Int )


semesterString : Semester -> String
semesterString s =
    String.fromInt (Tuple.first s) ++ String.fromInt (Tuple.second s)


lastSemesterFromCourse : Course -> String
lastSemesterFromCourse course =
    Maybe.withDefault "error" (List.head course.availableSemesters)


type alias Class =
    -- SP - Sufficient Presence
    -- IP - Insufficient Presence
    { semester : String
    , center : String
    , centerName : String
    , department : String
    , departmentName : String
    , classCourse : String
    , courseCode : String
    , courseName : String
    , credits : String
    , notes100 : String
    , notes95and90 : String
    , notes85and80 : String
    , notes75and70 : String
    , notes65and60 : String
    , notes55and50 : String
    , notes45and40 : String
    , notes35and30 : String
    , notes25and20 : String
    , notes15and05 : String
    , notes0SP : String
    , notes0IP : String
    , studentsWithGrades : String
    , mentionOne : String
    , approved : String
    , disapprovedSP : String
    , disapprovedIP : String
    }
