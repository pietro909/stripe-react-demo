module Messages exposing (..)

import Http

import Models exposing (..)
import Form.Types as FormTypes

type Msg
  = Customers (Result Http.Error (List Customer))
  | CreateCustomer
  | CustomerCreated (Result Http.Error Customer)
  | CustomerDeleted (Result Http.Error String)
  | CustomerUpdated (Result Http.Error Customer)
  | DeleteCustomer
  | SelectCustomer String
  | UpdateCustomer
  | UpdateList
  | Start Config
  | SetRoute String
  | FormMsg FormTypes.Msg
