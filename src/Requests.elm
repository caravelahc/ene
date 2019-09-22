module Requests exposing
    ( CsvResponse(..)
    , endpointUrl
    , fetchCourseSemesterCSV
    , stripCSVParameterString
    )

import Http
import Url.Builder exposing (QueryParameter, crossOrigin)


type CsvResponse
    = GotCSV (Result Http.Error String)


endpointUrl : List String -> List QueryParameter -> String
endpointUrl endpoint =
    crossOrigin "https://caravelahc.github.io/ene/csv" endpoint


fetchCourseSemesterCSV : String -> String -> Cmd CsvResponse
fetchCourseSemesterCSV courseCode semester =
    Http.get
        { url = endpointUrl [ courseCode, semester ++ ".csv" ] []
        , expect = Http.expectString GotCSV
        }


stripCSVParameterString : String -> String
stripCSVParameterString str =
    -- Strip the first line of parameter data that is present in every CSV file (105 char length)
    let
        removeString =
            String.slice 0 105 str

        removedFirstLine =
            String.replace removeString "" str
    in
    removedFirstLine
