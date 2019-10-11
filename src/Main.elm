module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Data exposing (Class, Course, availableCourses, courseToString, defaultCourse, lastSemesterFromCourse, stringToCourse)
import Decoder exposing (decodeCsv)
import Html exposing (Html, div, h2, option, select, span, table, text, th, tr)
import Html.Attributes exposing (id, value)
import Html.Events exposing (onClick, onInput)
import Requests exposing (CsvResponse(..), fetchCourseSemesterCSV, stripCSVParameterString)
import Table exposing (classToCompactDataElement, placeholderClass)
import Utils exposing (errorToString)


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
    | OrderApproved
    | OrderDisapprovedSP
    | OrderDisapprovedIP
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
    let
        lastSemester =
            lastSemesterFromCourse defaultCourse
    in
    ( { error = Nothing
      , selectedCourse = defaultCourse
      , selectedSemester = lastSemester
      , csvString = Nothing
      , classList = Nothing
      }
    , Cmd.map CSV (Requests.fetchCourseSemesterCSV defaultCourse.code lastSemester)
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

        OrderApproved ->
            ( { model | classList = orderClassListBy model.classList .approved }
            , Cmd.none
            )

        OrderDisapprovedSP ->
            ( { model | classList = orderClassListBy model.classList .disapprovedSP }
            , Cmd.none
            )

        OrderDisapprovedIP ->
            ( { model | classList = orderClassListBy model.classList .disapprovedIP }
            , Cmd.none
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
                                    errorToString err

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


orderClassListBy : Maybe (List Class) -> (Class -> comparable) -> Maybe (List Class)
orderClassListBy l sortKey =
    let
        sortedList =
            List.sortBy sortKey (Maybe.withDefault [] l)
    in
    if Just sortedList == l then
        Just (List.reverse sortedList)

    else
        Just sortedList


compactDataHeader : Html Msg
compactDataHeader =
    tr []
        [ th [] [ text "Centro" ]
        , th [] [ text "Departamento" ]
        , th [] [ text "Curso" ]
        , th [] [ text "Disciplina" ]
        , th [] [ text "Nome Disciplina" ]
        , th [] [ text "Alunos Total" ]
        , th [ onClick OrderApproved ] [ text "Aprovados" ]
        , th [ onClick OrderDisapprovedSP ] [ text "Reprovados FS" ]
        , th [ onClick OrderDisapprovedIP ] [ text "Reprovados FI" ]
        ]


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
