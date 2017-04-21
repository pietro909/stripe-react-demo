module Messages exposing (..)

import Http

import Models exposing (..)
import Form

type Msg
  = CreateCustomer
  | CustomerCreated (Result Http.Error Customer)
  | CustomerDeleted (Result Http.Error String)
  | CustomerUpdated (Result Http.Error Customer)
  | DeleteCustomer
  | UpdateCustomer
  | FormMessage Form.Msg
  | Start Config
  | SetRoute String
