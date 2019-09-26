module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Data exposing (Class, Course, availableCourses, courseToString)
import Decoder exposing (decodeCsv)
import Html exposing (Html, div, h2, option, select, span, table, text)
import Html.Attributes exposing (id)
import Html.Events exposing (onClick)
import Requests exposing (CsvResponse(..), stripCSVParameterString)
import Table exposing (classToCompactDataElement, compactDataHeader, placeholderClass)
import Utils exposing (semesterList)


type alias Model =
    { error : Maybe String
    , selectedCourse : Maybe Course
    , selectedSemester : Maybe String
    , csvString : Maybe String
    , classList : Maybe (List Class)
    }


type Msg
    = None
    | SelectCourse
    | SelectSemester
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

        SelectSemester ->
            -- Implement select semester
            ( model, Cmd.none )

        SelectCourse ->
            -- Implement select course
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


errorStr : Maybe String -> String
errorStr err =
    case err of
        Just str ->
            "Error: " ++ str

        Nothing ->
            ""


view : Model -> Html Msg
view model =
    let
        classesRows =
            List.map classToCompactDataElement
                (Maybe.withDefault [ placeholderClass ] model.classList)

        statusText =
            if List.isEmpty (Maybe.withDefault [] model.classList) then
                "Fetching CSV data..."

            else
                ""

        errorHeader =
            if List.isEmpty (Maybe.withDefault [] model.classList) then
                h2 [] [ text (errorStr model.csvString) ]

            else
                case model.error of
                    Just _ ->
                        h2 [] [ text (errorStr model.error) ]

                    Nothing ->
                        span [] []

        availableCoursesSelect =
            let
                courseNames =
                    List.map courseToString availableCourses
            in
            select [ onClick SelectCourse ] (List.map (\course -> option [] [ text course ]) courseNames)

        availableSemestersSelect =
            let
                semesters =
                    semesterList 2009 2019
            in
            select [ onClick SelectSemester ] (List.map (\s -> option [] [ text s ]) semesters)

        mainTable =
            table [] (compactDataHeader :: classesRows)
    in
    div []
        [ errorHeader
        , div [] [ text "Work in progress \\(•◡•)/" ]
        , div [] [ text statusText ]
        , div [ id "filterPanel" ] [ availableCoursesSelect, availableSemestersSelect ]
        , div [] [ mainTable ]
        ]
