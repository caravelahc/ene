module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Decoder exposing (Course)
import Html exposing (Html, div, table, text)
import Table exposing (simpleDataHeader)


type alias Model =
    { selectedCourse : Maybe Course
    , selectedSemester : Maybe String
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
      , selectedSemester = Nothing
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
    let
        mainTable =
            table [] []

        -- (List.map classToSimpleDataElement decodeCsv)
    in
    div []
        [ div [] [ simpleDataHeader, mainTable ]
        , div []
            [ text
                ("Work in progress \\(•◡•)/"
                    ++ Maybe.withDefault "" model.selectedSemester
                )
            ]
        ]
