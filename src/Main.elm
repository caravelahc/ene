module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Decoder exposing (Course)
import Html exposing (Html, div, table, text)
import Requests exposing (CsvResponse(..))
import Table exposing (simpleDataHeader)


type alias Model =
    { selectedCourse : Maybe Course
    , selectedSemester : Maybe String
    , csvString : Maybe String
    }


type Msg
    = None
    | SelectSemester String
    | CSV CsvResponse


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
      , csvString = Nothing
      }
    , Cmd.map CSV (Requests.fetchCourseSemesterCSV "208" "20091")
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        SelectSemester semester ->
            ( model, Cmd.map CSV (Requests.fetchCourseSemesterCSV "208" semester) )

        CSV response ->
            case response of
                GotCSV r ->
                    ( { model | csvString = Result.toMaybe r }
                    , Cmd.none
                    )


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
                    ++ Maybe.withDefault "" model.csvString
                )
            ]
        ]
