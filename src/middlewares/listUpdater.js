import { initialize, autofill } from 'redux-form'

import * as API from '../constants/API'
import {
  CREATE_CUSTOMER,
  DELETE_CUSTOMER,
  UPDATE_CUSTOMER, 
  UPDATE_LIST,
	SELECT_CUSTOMER,
} from '../constants/ActionTypes' 
import { updateList, resultOk, resultError, listUpdated } from '../actions'
import * as selectors from '../selectors'

const listUpdater = ({ dispatch, getState }) => next => action => {
  const result = next(action)
	switch(action.type) {

		case CREATE_CUSTOMER:
      API.create(action.customer)
        .then(response => {
          if (response.ok) {
            dispatch(updateList())
            return response.json()
          }
          throw new Error('Creation failed!')
        })
        .then(response => dispatch(resultOk('Customer created')))
        .catch(reason => dispatch(resultError(reason)))
      break

		case UPDATE_CUSTOMER:
      API.update(action.id, action.customer)
        .then(response => {
          if (response.ok) {
            return response.json()
          }
          throw new Error('Update failed!')
        })
        .then(response => dispatch(resultOk('Customer updated')))
        .catch(reason => dispatch(resultError(reason)))
      break

		case UPDATE_LIST:
      API.list()
        .then(response => {
          if (response.ok) {
            return response.json()
          }
          throw new Error('Network error.')
        })
        .then(response => {
          dispatch(listUpdated(response.data))
        })
        .catch(reason => dispatch(resultError(reason)))
      break

    case SELECT_CUSTOMER:
			const selectedCustomer = selectors.getActiveCustomer(getState().customers)
			dispatch(initialize('customer', selectedCustomer))
			break

	}
  return result
}

export default listUpdater
