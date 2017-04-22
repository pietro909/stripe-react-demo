port module Form.Ports exposing (..)

import Form.Types exposing (..)


-- IN
port updateForm : (FormInput -> msg) -> Sub msg


-- OUT
port formUpdated : ModelOut -> Cmd msg


