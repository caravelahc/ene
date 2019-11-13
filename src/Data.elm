module Data exposing
    ( Class
    , Course
    , Semester
    , availableCourses
    , courseToString
    , defaultCourse
    , findClassByCode
    , findCourseByCode
    , lastSemesterFromCourse
    , placeholderClass
    , semesterString
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
    , credits : Int
    , notes100 : Int
    , notes95and90 : Int
    , notes85and80 : Int
    , notes75and70 : Int
    , notes65and60 : Int
    , notes55and50 : Int
    , notes45and40 : Int
    , notes35and30 : Int
    , notes25and20 : Int
    , notes15and05 : Int
    , notes0SP : Int
    , notes0IP : Int
    , studentsWithGrades : Int
    , mentionOne : Int
    , approved : Int
    , disapprovedSP : Int
    , disapprovedIP : Int
    }


findCourseByCode : String -> List Course -> Maybe Course
findCourseByCode courseCode list =
    find (\course -> course.code == courseCode) list


findClassByCode : String -> List Class -> Maybe Class
findClassByCode classCourseCode list =
    find (\class -> class.courseCode == classCourseCode) list


placeholderClass : Class
placeholderClass =
    -- Used during loading
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
