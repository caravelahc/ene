module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Chart exposing (renderGradesChart)
import Data
    exposing
        ( Class
        , Course
        , availableCourses
        , classToChartTupleArray
        , courseToString
        , defaultCourse
        , findClassByCode
        , findCourseByCode
        , lastSemesterFromCourse
        , placeholderClass
        )
import Decoder exposing (decodeCsv)
import Html exposing (Html, div, h1, h2, option, select, span, table, td, text, th, tr)
import Html.Attributes exposing (class, id, value)
import Html.Events exposing (onClick, onInput)
import Requests exposing (CsvResponse(..), fetchCourseSemesterCSV, stripCSVParameterString)
import Utils exposing (errorToString)


type alias Model =
    { error : Maybe String
    , selectedCourse : Course
    , selectedSemester : String
    , selectedClass : Maybe Class
    , csvString : Maybe String
    , gradePopupOpen : Bool
    , classList : Maybe (List Class)
    }


type Msg
    = SelectCourse String
    | SelectSemester String
    | Order String
    | ToggleGradePopup String
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
      , selectedClass = Nothing
      , csvString = Nothing
      , gradePopupOpen = False
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
                    case findCourseByCode course availableCourses of
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

        Order str ->
            case str of
                "classCourse" ->
                    ( { model | classList = orderClassListBy model.classList .classCourse }, Cmd.none )

                "courseCode" ->
                    ( { model | classList = orderClassListBy model.classList .courseCode }, Cmd.none )

                "studentsWithGrades" ->
                    ( { model | classList = orderClassListBy model.classList .studentsWithGrades }, Cmd.none )

                "approved" ->
                    ( { model | classList = orderClassListBy model.classList .approved }, Cmd.none )

                "disapprovedSP" ->
                    ( { model | classList = orderClassListBy model.classList .disapprovedSP }, Cmd.none )

                "disapprovedIP" ->
                    ( { model | classList = orderClassListBy model.classList .disapprovedIP }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ToggleGradePopup classCourseCode ->
            ( { model
                | gradePopupOpen = not model.gradePopupOpen
                , selectedClass = findClassByCode classCourseCode (Maybe.withDefault [] model.classList)
              }
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
        , th [ onClick (Order "classCourse") ] [ text "Curso" ]
        , th [ onClick (Order "courseCode") ] [ text "Disciplina" ]
        , th [] [ text "Nome Disciplina" ]
        , th [ onClick (Order "studentsWithGrades") ] [ text "Alunos Total" ]
        , th [ onClick (Order "approved") ] [ text "Aprovados" ]
        , th [ onClick (Order "disapprovedSP") ] [ text "Reprovados FS" ]
        , th [ onClick (Order "disapprovedIP") ] [ text "Reprovados FI" ]
        ]


classToCompactDataElement : Class -> Html Msg
classToCompactDataElement class =
    tr [ onClick (ToggleGradePopup class.courseCode) ]
        [ td [] [ text class.center ]
        , td [] [ text class.department ]
        , td [] [ text class.classCourse ]
        , td [] [ text class.courseCode ]
        , td [] [ text class.courseName ]
        , td [] [ text (String.fromInt class.studentsWithGrades) ]
        , td [] [ text (String.fromInt class.approved) ]
        , td [] [ text (String.fromInt class.disapprovedSP) ]
        , td [] [ text (String.fromInt class.disapprovedIP) ]
        ]


renderGradesModal : Model -> Html Msg
renderGradesModal model =
    let
        s =
            " | "

        currentClass =
            Maybe.withDefault placeholderClass model.selectedClass
    in
    div [ id "modal", class "modal", onClick (ToggleGradePopup "") ]
        [ div [ class "modal-content" ]
            [ span [ class "close-modal" ] [ text "X" ]
            , h1 [] [ text "Distribuição de notas" ]
            , h2 [] [ text (currentClass.courseCode ++ s ++ currentClass.classCourse ++ s ++ currentClass.courseName) ]
            , div [] [ renderGradesChart (classToChartTupleArray model.selectedClass) ]
            ]
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
        , if model.gradePopupOpen then
            renderGradesModal model

          else
            text ""
        ]
