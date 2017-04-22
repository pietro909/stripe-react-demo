module Messages exposing (..)

import Http

import Models exposing (..)
import Form.Types as FormTypes
import CustomersList.Types as CustomersListTypes

type Msg
  = CreateCustomer
  | CustomerCreated (Result Http.Error Customer)
  | CustomerDeleted (Result Http.Error String)
  | CustomerUpdated (Result Http.Error Customer)
  | CustomersListMsg CustomersListTypes.Msg
  | DeleteCustomer
  | FormMsg FormTypes.Msg
  | SelectCustomer String
  | SetRoute String
  | Start Config
  | UpdateCustomer
