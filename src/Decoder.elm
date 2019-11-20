module Decoder exposing (decodeCsv)

import Csv
import Csv.Decode exposing (Decoder, andMap, field, map)
import Data exposing (Class)
import Utils exposing (stringTrimToInt)


toIntResult : String -> Result String Int
toIntResult str =
    -- Version of String.toInt but using 'Result' instead of 'Maybe'
    Result.fromMaybe ("Error using toIntResult with" ++ str) (stringTrimToInt str)


stringDecoder : String -> Result String String
stringDecoder str =
    Ok (String.trim str)


classDecoder : Decoder (Class -> a) a
classDecoder =
    -- Exact mapping of CSV headers (including wrong spaces)
    map Class
        (field "semestre" stringDecoder
            |> andMap (field "centroDoDepartamento" stringDecoder)
            |> andMap (field "nomeDoCentro" stringDecoder)
            |> andMap (field "departamento" stringDecoder)
            |> andMap (field "nomeDoDepartamento_Campus" stringDecoder)
            |> andMap (field "turmaDoCurso" stringDecoder)
            |> andMap (field "disciplina" stringDecoder)
            |> andMap (field "nomeDaDisciplina" stringDecoder)
            |> andMap (field "HorasAulas" toIntResult)
            |> andMap (field "qtdeNota10,0" toIntResult)
            |> andMap (field "qtdeNota9,5_9,0" toIntResult)
            |> andMap (field "qtdeNota8,5_8,0" toIntResult)
            |> andMap (field "qtdeNota7,5_7,0" toIntResult)
            |> andMap (field "qtdeNota6,5_6,0" toIntResult)
            |> andMap (field "qtdeNota5,5_5,0" toIntResult)
            |> andMap (field "qtdeNota4,5_4,0" toIntResult)
            |> andMap (field "qtdeNota3,5_3,0" toIntResult)
            |> andMap (field "qtdeNota2,5_2,0" toIntResult)
            |> andMap (field "qtdeNota1,5_0,5" toIntResult)
            |> andMap (field "nota0_FS" toIntResult)
            |> andMap (field "nota0_FI" toIntResult)
            |> andMap (field " qtdeDeAlunosDaTurmaComNotas" toIntResult)
            |> andMap (field "mencaoI" toIntResult)
            |> andMap (field " Aprovados" toIntResult)
            |> andMap (field "Reprovados_FS" toIntResult)
            |> andMap (field "Reprovados_FI" toIntResult)
        )


decodeCsv : String -> Result Csv.Decode.Errors (List Class)
decodeCsv data =
    Csv.parseWith ";" data |> Csv.Decode.decodeCsv classDecoder
