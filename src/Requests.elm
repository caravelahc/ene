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
    crossOrigin "https://ene.caravela.club/csv" endpoint


fetchCourseSemesterCSV : String -> String -> Cmd CsvResponse
fetchCourseSemesterCSV courseCode semester =
    Http.get
        { url = endpointUrl [ courseCode, semester ++ ".csv" ] []
        , expect = Http.expectString GotCSV
        }


stripCSVParameterString : String -> String
stripCSVParameterString str =
    -- Strip the first line of parameter data that is present in every CSV file
    let
        removeLength =
            List.head (String.indices "\n" str)

        removeString =
            String.slice 0 (Maybe.withDefault 105 removeLength) str

        removedFirstLine =
            String.replace removeString "" str
    in
    removedFirstLine
