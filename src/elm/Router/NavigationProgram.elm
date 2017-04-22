module Router.NavigationProgram exposing (headlessProgram)


import Navigation exposing (..)
import Platform


headlessProgram
  : (Location -> msg)
   ->
     { init : Location -> (model, Cmd msg)
     , update : msg -> model -> (model, Cmd msg)
     , subscriptions : model -> Sub msg
     }
   -> Platform.Program Never model msg
headlessProgram locationToMessage stuff =
  let
      subs model =
        Sub.batch
          [ subscription (Monitor locationToMessage)
          , stuff.subscriptions model
          ]

      init = stuff.init (Native.Navigation.getLocation ())
  in
      Platform.program
      { init = init
      , update = stuff.update
      , subscriptions = subs
      }

