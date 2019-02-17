port module Main exposing
    ( Model
    , Msg(..)
    , init
    , main
    , read
    , signedIn
    , update
    , view
    )

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Encode as E



-- ---------------------------
-- PORTS
-- ---------------------------


port signIn : () -> Cmd msg


port push : String -> Cmd msg


port read : (String -> msg) -> Sub msg


port signedIn : (Bool -> msg) -> Sub msg



-- ---------------------------
-- MODEL
-- ---------------------------


type alias Model =
    { pushText : String
    , isSignedIn : Bool
    }


init : () -> ( Model, Cmd Msg )
init isSignedIn =
    ( { pushText = "", isSignedIn = False }, Cmd.none )



-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = SignIn
    | Push String
    | Read String
    | SignedIn Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SignIn ->
            ( model, signIn () )

        SignedIn isSignedIn ->
            ( { model | isSignedIn = isSignedIn }, Cmd.none )

        Push text ->
            ( { model | pushText = text }, push text )

        Read text ->
            ( { model | pushText = text }, Cmd.none )



-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> Html Msg
view { pushText, isSignedIn } =
    div [ class "container" ]
        [ button [ onClick SignIn ] [ text "Google サインイン" ]
        , if isSignedIn then
            input [ type_ "input", value pushText, onInput Push ] []

          else
            text ""
        ]



-- ---------------------------
-- MAIN
-- ---------------------------


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ signedIn SignedIn, read Read ]


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view =
            \m ->
                { title = "Elm Firebase"
                , body = [ view m ]
                }
        , subscriptions = subscriptions
        }
