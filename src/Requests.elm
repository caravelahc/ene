module Requests exposing (CsvResponse(..), endpointUrl, fetchCourseSemesterCSV)

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
