module Decoder exposing (Class, Course, availableCourses, decodeCsv)

import Csv
import Csv.Decode exposing (Decoder, andMap, field, map)


type alias Course =
    ( String, String )


availableCourses : List Course
availableCourses =
    [ ( "208", "CIÊNCIAS DA COMPUTAÇÃO" )
    ]



-- type Center
--     = CTC
-- type Department
--     = INE
-- SP - Sufficient Presence
-- IP - Insufficient Presence


type alias Class =
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


classDecoder : Decoder (Class -> a) a
classDecoder =
    map Class
        (field "semestre" Ok
            |> andMap (field "centroDoDepartamento" Ok)
            |> andMap (field "nomeDoCentro" Ok)
            |> andMap (field "departamento" Ok)
            |> andMap (field "nomeDoDepartamento_Campus" Ok)
            |> andMap (field "turmaDoCurso" Ok)
            |> andMap (field "disciplina" Ok)
            |> andMap (field "nomeDaDisciplina" Ok)
            |> andMap (field "HorasAula" Ok)
            |> andMap (field "qtdeNota10,0" Ok)
            |> andMap (field "qtdeNota9,5_9,0" Ok)
            |> andMap (field "qtdeNota8,5_8,0" Ok)
            |> andMap (field "qtdeNota7,5_7,0" Ok)
            |> andMap (field "qtdeNota6,5_6,0" Ok)
            |> andMap (field "qtdeNota5,5_5,0" Ok)
            |> andMap (field "qtdeNota4,5_4,0" Ok)
            |> andMap (field "qtdeNota3,5_3,0" Ok)
            |> andMap (field "qtdeNota2,5_2,0" Ok)
            |> andMap (field "qtdeNota1,5_0,5" Ok)
            |> andMap (field "nota0_FS" Ok)
            |> andMap (field "nota0_FI" Ok)
            |> andMap (field "qtdeDeAlunosDaTurmaComNotas" Ok)
            |> andMap (field "mencaoI" Ok)
            |> andMap (field "Aprovados" Ok)
            |> andMap (field "Reprovados_FS" Ok)
            |> andMap (field "Reprovados_FI" Ok)
        )


decodeCsv : String -> Result Csv.Decode.Errors (List Class)
decodeCsv data =
    Csv.parse data |> Csv.Decode.decodeCsv classDecoder
