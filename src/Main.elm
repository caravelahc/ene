module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Data exposing (Class, Course, availableCourses, courseToString, defaultCourse, stringToCourse)
import Decoder exposing (decodeCsv)
import Html exposing (Html, div, h2, option, select, span, table, text)
import Html.Attributes exposing (id, value)
import Html.Events exposing (onInput)
import Requests exposing (CsvResponse(..), fetchCourseSemesterCSV, stripCSVParameterString)
import Table exposing (classToCompactDataElement, compactDataHeader, placeholderClass)
import Utils exposing (semesterList)


type alias Model =
    { error : Maybe String
    , selectedCourse : Course
    , selectedSemester : String
    , csvString : Maybe String
    , classList : Maybe (List Class)
    }


type Msg
    = SelectCourse String
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
      , selectedCourse = defaultCourse
      , selectedSemester = Maybe.withDefault "error" (List.head defaultCourse.availableSemesters)
      , csvString = Nothing
      , classList = Nothing
      }
      -- Remove hardcoded fetch csv
    , Cmd.map CSV (Requests.fetchCourseSemesterCSV "208" "20191")
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectCourse course ->
            ( { model
                | selectedCourse =
                    case stringToCourse course availableCourses of
                        Just c ->
                            c

                        Nothing ->
                            defaultCourse
              }
            , Cmd.map CSV (fetchCourseSemesterCSV model.selectedCourse.code model.selectedSemester)
            )

        SelectSemester semester ->
            ( { model | selectedSemester = semester }
            , Cmd.map CSV (fetchCourseSemesterCSV model.selectedCourse.code semester)
            )

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
        -- Auxiliary --
        opt s =
            option [ value s ] [ text s ]

        errorHeader =
            if List.isEmpty (Maybe.withDefault [] model.classList) then
                h2 [] [ text (errorStr model.csvString) ]

            else
                case model.error of
                    Just _ ->
                        h2 [] [ text (errorStr model.error) ]

                    Nothing ->
                        span [] []

        -- View --
        classesRows =
            List.map classToCompactDataElement
                (Maybe.withDefault [ placeholderClass ] model.classList)

        statusText =
            if List.isEmpty (Maybe.withDefault [] model.classList) then
                "Fetching CSV data..."

            else
                ""

        availableCoursesSelect =
            let
                courseNames =
                    List.map courseToString availableCourses

                courseCode str =
                    String.slice 0 3 str
            in
            select
                [ onInput SelectCourse ]
                (List.map (\course -> option [ value (courseCode course) ] [ text course ]) courseNames)

        availableSemestersSelect =
            let
                semesters =
                    model.selectedCourse.availableSemesters
            in
            select
                [ onInput SelectSemester ]
                (List.map (\s -> opt s) semesters)

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
