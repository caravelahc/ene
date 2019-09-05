module Decoder exposing (Course, availableCourses)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as D exposing (required)


type alias Course =
    ( String, String )


availableCourses : List Course
availableCourses =
    [ ( "208", "CIÊNCIAS DA COMPUTAÇÃO" )
    ]


type Center
    = CTC


type Department
    = INE
