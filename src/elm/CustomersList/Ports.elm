port module CustomersList.Ports exposing (..)

import Models exposing (Customer)


-- IN
port updateList : (() -> msg) -> Sub msg


-- OUT
port customers : List Customer -> Cmd msg
