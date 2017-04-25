port module Router.Ports exposing (..)


import Router.Types exposing (..)


-- IN
port navigateToUrl : (String -> msg) -> Sub msg

-- OUT
port destination : ModelOut -> Cmd msg

