module Messages exposing (..)

import Http
import Navigation

import Models exposing (..)
import Form.Types as FormTypes
import CustomersList.Types as CustomersListTypes
import Router.Types as RouterTypes


type Msg
  = CreateCustomer
  | CustomerCreated (Result Http.Error Customer)
  | CustomerDeleted (Result Http.Error String)
  | CustomerUpdated (Result Http.Error Customer)
  | CustomersListMsg CustomersListTypes.Msg
  | DeleteCustomer
  | FormMsg FormTypes.Msg
  | Start Config
  | UpdateCustomer
  | RouterMsg RouterTypes.Msg
