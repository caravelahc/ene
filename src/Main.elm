module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Decoder exposing (Class, Course, decodeCsv)
import Html exposing (Html, div, h2, span, table, text)
import Requests exposing (CsvResponse(..), stripCSVParameterString)
import Table exposing (classToSimpleDataElement, placeholderClass, simpleDataHeader)


type alias Model =
    { error : Maybe String
    , selectedCourse : Maybe Course
    , selectedSemester : Maybe String
    , csvString : Maybe String
    , classList : Maybe (List Class)
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
    ( { error = Nothing
      , selectedCourse = Nothing
      , selectedSemester = Nothing
      , csvString = Nothing
      , classList = Nothing
      }
      -- Remove hardcoded fetch csv
    , Cmd.map CSV (Requests.fetchCourseSemesterCSV "208" "20191")
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        SelectSemester _ ->
            -- Implement select semester
            ( model, Cmd.none )

        CSV response ->
            case response of
                GotCSV result ->
                    let
                        filteredResult =
                            case result of
                                Ok value ->
                                    stripCSVParameterString value

                                Err err ->
                                    Debug.toString err

                        classesResult =
                            decodeCsv filteredResult

                        classes =
                            Result.toMaybe classesResult
                    in
                    ( { model
                        | csvString = Just filteredResult
                        , classList = classes
                      }
                    , Cmd.none
                    )


view : Model -> Html Msg
view model =
    let
        classesRows =
            List.map classToSimpleDataElement
                (Maybe.withDefault [ placeholderClass ] model.classList)

        statusText =
            if List.isEmpty (Maybe.withDefault [] model.classList) then
                "Fetching CSV data..."

            else
                ""

        mainTable =
            table [] (simpleDataHeader :: classesRows)

        errorHeader =
            case model.error of
                Just err ->
                    h2 [] [ text err ]

                Nothing ->
                    span [] []
    in
    div []
        [ errorHeader
        , div [] [ text "Work in progress \\(•◡•)/" ]
        , div [] [ text statusText ]
        , div [] [ mainTable ]
        ]
