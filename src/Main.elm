port module Main exposing (Model, Msg(..), init, main, update, view)

import BarGraph exposing (renderGradesChart)
import Browser
import Data
    exposing
        ( Class
        , ClassCourse
        , Course
        , CourseCode
        , CourseName
        , availableCourses
        , classToChartTupleArray
        , classToString
        , courseToString
        , defaultCourse
        , findClassByCode
        , findCourse
        , lastSemesterFromCourse
        , placeholderClass
        )
import Decoder exposing (decodeCsv)
import Html exposing (Html, a, datalist, div, h2, h3, img, input, option, select, span, table, td, text, th, tr)
import Html.Attributes exposing (class, href, id, list, placeholder, src, value)
import Html.Events exposing (onClick, onInput)
import List.Extra
import PieChart exposing (renderPieGraph)
import Requests exposing (CsvResponse(..), fetchCourseSemesterCSV, stripCSVParameterString)
import Url
import Utils exposing (defaultURL, errorToString)


type alias Model =
    { error : Maybe String
    , selectedCourse : Course
    , selectedSemester : String
    , selectedClass : Maybe Class
    , csvString : Maybe String
    , gradePopupOpen : Bool
    , classList : Maybe (List Class)
    , shareQueryString : Maybe String
    }


type Msg
    = SelectCourse String
    | SelectSemester String
    | ChangeCourseQuery CourseName
    | Order String
    | ToggleGradePopup ClassCourse CourseCode
    | CSV CsvResponse
    | LoadClassFromQuery String
    | CopyURL


port sendSetPageQuery : String -> Cmd msg


port sendSetClipboard : () -> Cmd msg


port urlReceiver : (String -> msg) -> Sub msg


main : Program () Model Msg
main =
    Browser.element
        { init = \() -> init
        , update = update
        , subscriptions = subscriptions
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
      , shareQueryString = Nothing
      }
    , Cmd.map CSV (Requests.fetchCourseSemesterCSV defaultCourse.code lastSemester)
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectCourse course ->
            let
                courseRecord =
                    case findCourse course availableCourses of
                        Just c ->
                            c

                        Nothing ->
                            defaultCourse
            in
            ( { model
                | selectedCourse = courseRecord
              }
            , Cmd.map CSV (fetchCourseSemesterCSV courseRecord.code model.selectedSemester)
            )

        SelectSemester semester ->
            ( { model | selectedSemester = semester }
            , Cmd.map CSV (fetchCourseSemesterCSV model.selectedCourse.code semester)
            )

        ChangeCourseQuery queryName ->
            case
                List.head (List.filter (\c -> queryName == c.courseName) (getClassList model))
            of
                Just course ->
                    ( { model | classList = Just [ course ] }, Cmd.none )

                Nothing ->
                    -- Reset search
                    ( model
                    , Cmd.map CSV
                        (Requests.fetchCourseSemesterCSV model.selectedCourse.code model.selectedSemester)
                    )

        Order str ->
            case str of
                "center" ->
                    ( { model | classList = orderClassListBy .center model.classList }, Cmd.none )

                "department" ->
                    ( { model | classList = orderClassListBy .department model.classList }, Cmd.none )

                "classCourse" ->
                    ( { model | classList = orderClassListBy .classCourse model.classList }, Cmd.none )

                "courseCode" ->
                    ( { model | classList = orderClassListBy .courseCode model.classList }, Cmd.none )

                "courseName" ->
                    ( { model | classList = orderClassListBy .courseName model.classList }, Cmd.none )

                "studentsWithGrades" ->
                    ( { model | classList = orderClassListBy .studentsWithGrades model.classList }, Cmd.none )

                "approved" ->
                    ( { model | classList = orderClassListBy .approved model.classList }, Cmd.none )

                "failedSP" ->
                    ( { model | classList = orderClassListBy .failedSP model.classList }, Cmd.none )

                "failedIP" ->
                    ( { model | classList = orderClassListBy .failedIP model.classList }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ToggleGradePopup classCourse classCourseCode ->
            let
                popupOpened =
                    not model.gradePopupOpen

                shareQueryPath =
                    if not popupOpened then
                        ""

                    else
                        model.selectedCourse.code ++ "/" ++ model.selectedSemester ++ "/" ++ classCourseCode

                shareQueryString =
                    if shareQueryPath == "" then
                        Nothing

                    else
                        Just shareQueryPath

                cmd =
                    sendSetPageQuery shareQueryPath
            in
            ( { model
                | gradePopupOpen = not model.gradePopupOpen
                , shareQueryString = shareQueryString
                , selectedClass = findClassByCode classCourse classCourseCode (getClassList model)
              }
            , cmd
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
                                |> orderClassListBy .studentsWithGrades

                        defaultOrderedClasses =
                            List.reverse (Maybe.withDefault [] classes)

                        -- Check query string logic
                        splitQuery =
                            String.split "/" (Maybe.withDefault "" model.shareQueryString)

                        availableQuery =
                            List.length splitQuery > 1

                        courseCode =
                            List.Extra.getAt 0 splitQuery
                                |> Maybe.withDefault defaultCourse.code

                        course =
                            findCourse courseCode availableCourses
                                |> Maybe.withDefault defaultCourse

                        semester =
                            List.Extra.getAt 1 splitQuery
                                |> Maybe.withDefault (lastSemesterFromCourse defaultCourse)

                        classCourseCode =
                            List.Extra.getAt 2 splitQuery
                                |> Maybe.withDefault "INE5401"

                        class =
                            findClassByCode course.name classCourseCode defaultOrderedClasses

                        updatedModel =
                            if availableQuery then
                                { model
                                    | csvString = Just filteredResult
                                    , classList = Just defaultOrderedClasses
                                    , selectedCourse = course
                                    , selectedSemester = semester
                                    , selectedClass = class
                                    , gradePopupOpen = True
                                }

                            else
                                { model
                                    | csvString = Just filteredResult
                                    , classList = Just defaultOrderedClasses
                                }
                    in
                    ( updatedModel
                    , Cmd.none
                    )

        LoadClassFromQuery url ->
            let
                sharePrefixLength =
                    6

                query =
                    Url.fromString url
                        |> Maybe.withDefault defaultURL
                        |> .query
                        |> Maybe.withDefault ""
                        |> String.dropLeft sharePrefixLength
            in
            ( { model | shareQueryString = Just query }, Cmd.none )

        CopyURL ->
            ( model, sendSetClipboard () )


subscriptions : Model -> Sub Msg
subscriptions _ =
    urlReceiver LoadClassFromQuery


errorStr : Maybe String -> String
errorStr err =
    case err of
        Just str ->
            "Error: " ++ str

        Nothing ->
            ""


getClassList : Model -> List Class
getClassList model =
    Maybe.withDefault [] model.classList


orderClassListBy : (Class -> comparable) -> Maybe (List Class) -> Maybe (List Class)
orderClassListBy sortKey l =
    let
        sortedList =
            List.sortBy sortKey (Maybe.withDefault [] l)
    in
    if Just sortedList == l then
        Just (List.reverse sortedList)

    else
        Just sortedList


dataHeader : Html Msg
dataHeader =
    tr []
        [ th [ onClick (Order "center") ] [ text "Centro" ]
        , th [ onClick (Order "department") ] [ text "Departamento" ]
        , th [ onClick (Order "classCourse") ] [ text "Curso" ]
        , th [ onClick (Order "courseCode") ] [ text "Disciplina" ]
        , th [ onClick (Order "courseName") ] [ text "Nome Disciplina" ]
        , th [ onClick (Order "studentsWithGrades") ] [ text "Alunos" ]
        , th [ onClick (Order "approved") ] [ text "Aprovados" ]
        , th [ onClick (Order "failedSP") ] [ text "Reprovados FS" ]
        , th [ onClick (Order "failedIP") ] [ text "Reprovados FI" ]
        ]


dataRow : Class -> Html Msg
dataRow class =
    tr [ onClick (ToggleGradePopup class.classCourse class.courseCode) ]
        [ td [] [ text class.center ]
        , td [] [ text class.department ]
        , td [] [ text class.classCourse ]
        , td [] [ text class.courseCode ]
        , td [] [ text class.courseName ]
        , td [] [ text (String.fromInt class.studentsWithGrades) ]
        , td [] [ text (String.fromInt class.approved) ]
        , td [] [ text (String.fromInt class.failedSP) ]
        , td [] [ text (String.fromInt class.failedIP) ]
        ]


gradePopupHeader : Html Msg
gradePopupHeader =
    span []
        [ span [ class "close-button", onClick (ToggleGradePopup "" "") ] [ text "X" ]
        , span [ class "share-button", onClick CopyURL ] [ text "Copy URL" ]
        ]


renderGradesModal : Model -> Html Msg
renderGradesModal model =
    let
        s =
            " | "

        currentClass =
            Maybe.withDefault placeholderClass model.selectedClass
    in
    div [ id "modal", class "modal" ]
        [ div [ class "modal-content" ]
            [ gradePopupHeader
            , h2 [] [ text ("UFSC - " ++ currentClass.classCourse) ]
            , h3 [] [ text (currentClass.courseCode ++ s ++ currentClass.courseName ++ s ++ model.selectedSemester) ]
            , div []
                [ renderGradesChart (classToChartTupleArray model.selectedClass)
                , renderPieGraph [ currentClass.approved, currentClass.failedSP, currentClass.failedIP ]
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    let
        -- Auxiliary --
        opt s =
            option [ value s ] [ text s ]

        errorHeader =
            if List.isEmpty (getClassList model) then
                h2 [] [ text (errorStr model.csvString) ]

            else
                case model.error of
                    Just _ ->
                        h2 [] [ text (errorStr model.error) ]

                    Nothing ->
                        span [] []

        classes =
            Maybe.withDefault [ placeholderClass ] model.classList

        filteredClasses =
            List.filter (\class -> class.studentsWithGrades > 0) classes

        -- View --
        classesRows =
            List.map dataRow filteredClasses

        statusText =
            if List.isEmpty (getClassList model) then
                "Fetching CSV data..."

            else
                ""

        caravelaImg =
            a [ href "https://caravela.club" ]
                [ img [ id "caravela-logo", src "./img/logo_horizontal.png" ] [] ]

        courseSearchField =
            input
                [ id "search"
                , list "courses"
                , placeholder "Nome da disciplina"
                , onInput ChangeCourseQuery
                ]
                [ datalist [ id "courses" ]
                    (List.map (opt << classToString) (getClassList model))
                ]

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

        githubImg =
            a [ href "https://github.com/caravelahc/ene" ]
                [ img [ id "github-logo", src "./img/github.png" ] [] ]

        caravelaHeader =
            div [ id "caravela-header" ]
                [ div [ class "wrapper" ]
                    [ caravelaImg
                    , courseSearchField
                    , availableCoursesSelect
                    , availableSemestersSelect
                    , githubImg
                    ]
                ]

        mainTable =
            table [] (dataHeader :: classesRows)
    in
    div []
        [ errorHeader
        , div [ id "status-text " ] [ text statusText ]
        , caravelaHeader
        , div [] [ mainTable ]
        , if model.gradePopupOpen then
            renderGradesModal model

          else
            text ""
        ]
