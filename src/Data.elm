module Data exposing
    ( ChartTuple
    , Class
    , ClassCourse
    , Course
    , CourseCode
    , CourseName
    , Semester
    , availableCourses
    , classToChartTupleArray
    , classToString
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


type alias CourseCode =
    String


type alias ClassCourse =
    String


type alias CourseName =
    String


type alias Class =
    -- SP - Sufficient Presence
    -- IP - Insufficient Presence
    { semester : String
    , center : String
    , centerName : String
    , department : String
    , departmentName : String
    , classCourse : ClassCourse
    , courseCode : CourseCode
    , courseName : CourseName
    , credits : Int
    , grades100 : Int
    , grades95to90 : Int
    , grades85to80 : Int
    , grades75to70 : Int
    , grades65to60 : Int
    , grades55to50 : Int
    , grades45to40 : Int
    , grades35to30 : Int
    , grades25to20 : Int
    , grades15to05 : Int
    , grades0SP : Int
    , grades0IP : Int
    , studentsWithGrades : Int
    , mentionOne : Int
    , approved : Int
    , disapprovedSP : Int
    , disapprovedIP : Int
    }


classToString : Class -> String
classToString c =
    c.courseName


findCourseByCode : String -> List Course -> Maybe Course
findCourseByCode courseCode list =
    find (\course -> course.code == courseCode) list


findClassByCode : ClassCourse -> CourseCode -> List Class -> Maybe Class
findClassByCode classCourse classCourseCode list =
    find (\class -> class.classCourse == classCourse && class.courseCode == classCourseCode) list


type alias ChartTuple =
    -- Tuple of grade group (0 to 10) and number of students in that group
    ( Int, Int )


classToChartTupleArray : Maybe Class -> List ChartTuple
classToChartTupleArray class =
    let
        c =
            Maybe.withDefault placeholderClass class
    in
    [ ( -1, c.grades0IP )
    , ( 0, c.grades0SP )
    , ( 1, c.grades15to05 )
    , ( 2, c.grades25to20 )
    , ( 3, c.grades35to30 )
    , ( 4, c.grades45to40 )
    , ( 5, c.grades55to50 )
    , ( 6, c.grades65to60 )
    , ( 7, c.grades75to70 )
    , ( 8, c.grades85to80 )
    , ( 9, c.grades95to90 )
    , ( 10, c.grades100 )
    ]


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
    , grades100 = pInt
    , grades95to90 = pInt
    , grades85to80 = pInt
    , grades75to70 = pInt
    , grades65to60 = pInt
    , grades55to50 = pInt
    , grades45to40 = pInt
    , grades35to30 = pInt
    , grades25to20 = pInt
    , grades15to05 = pInt
    , grades0SP = pInt
    , grades0IP = pInt
    , studentsWithGrades = pInt
    , mentionOne = pInt
    , approved = pInt
    , disapprovedSP = pInt
    , disapprovedIP = pInt
    }
