module Data exposing
    ( Class
    , Course
    , Semester
    , availableCourses
    , courseToString
    , semesterString
    )


type alias CourseCode =
    String


type alias CourseName =
    String


type alias Course =
    ( CourseCode, CourseName )


courseToString : Course -> String
courseToString course =
    Tuple.first course ++ " - " ++ Tuple.second course


availableCourses : List Course
availableCourses =
    [ ( "208", "CIÊNCIAS DA COMPUTAÇÃO" )
    ]


type alias Semester =
    ( Int, Int )


semesterString : Semester -> String
semesterString s =
    String.fromInt (Tuple.first s) ++ String.fromInt (Tuple.second s)


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
