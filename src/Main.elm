module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Decoder exposing (Course, availableCourses)
import Html exposing (Html, div, table, text)
import Table exposing (simpleDataHeader)


type alias Model =
    { selectedCourse : Maybe Course
    }


type Msg
    = None


main : Program () Model Msg
main =
    Browser.element
        { init = \() -> init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


init : ( Model, Cmd Msg )
init =
    ( { selectedCourse = Nothing
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ table [] simpleDataHeader
        , div []
            [ text
                "Work in progress \\(•◡•)/"
            ]
        ]
