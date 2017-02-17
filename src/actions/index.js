import * as types from '../constants/ActionTypes'

export const selectCustomer = (id) => ({
  type: types.SELECT_CUSTOMER,
  payload: { id: id }
})

export const openEditor = (id) => ({
  type: types.OPEN_EDITOR,
  payload: { id: id }
})

export const updateField = (name, value) => ({
  type: types.UPDATE_FIELD,
  payload: { name, value }
})

export const createCustomer = (customer) => ({ 
  type: types.CREATE_CUSTOMER,
  payload: { customer: customer }
})

export const updateCustomer = (id, customer) => ({
  type: types.UPDATE_CUSTOMER,
  payload: {
    id: id,
    customer: customer
  }
})

export const deleteCustomer = (id) => ({ type: types.DELETE_CUSTOMER, payload: { id: id }})

export const resultOk = (message) => ({ type: types.OK, payload: { message: message }})

export const resultError = (message) => ({ type: types.ERROR, payload: { message: message }})
