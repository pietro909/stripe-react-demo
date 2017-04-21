port module Ports exposing (..)

-- Outbound ports
port customers : List Customer -> Cmd msg

-- Inbound ports
port updateList : (() -> msg) -> Sub msg
