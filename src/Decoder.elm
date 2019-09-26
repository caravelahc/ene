module Decoder exposing (decodeCsv)

import Csv
import Csv.Decode exposing (Decoder, andMap, field, map)
import Data exposing (Class)


classDecoder : Decoder (Class -> a) a
classDecoder =
    -- Exact mapping of CSV headers (including wrong spaces)
    map Class
        (field "semestre" Ok
            |> andMap (field "centroDoDepartamento" Ok)
            |> andMap (field "nomeDoCentro" Ok)
            |> andMap (field "departamento" Ok)
            |> andMap (field "nomeDoDepartamento_Campus" Ok)
            |> andMap (field "turmaDoCurso" Ok)
            |> andMap (field "disciplina" Ok)
            |> andMap (field "nomeDaDisciplina" Ok)
            |> andMap (field "HorasAulas" Ok)
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
            |> andMap (field " qtdeDeAlunosDaTurmaComNotas" Ok)
            |> andMap (field "mencaoI" Ok)
            |> andMap (field " Aprovados" Ok)
            |> andMap (field "Reprovados_FS" Ok)
            |> andMap (field "Reprovados_FI" Ok)
        )


decodeCsv : String -> Result Csv.Decode.Errors (List Class)
decodeCsv data =
    Csv.parseWith ";" data |> Csv.Decode.decodeCsv classDecoder
