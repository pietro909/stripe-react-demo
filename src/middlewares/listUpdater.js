import { reset, initialize, autofill } from 'redux-form'

import * as API from '../constants/API'
import {
  CREATE_CUSTOMER,
  DELETE_CUSTOMER,
  UPDATE_CUSTOMER, 
  UPDATE_LIST,
	SELECT_CUSTOMER,
	UNSELECT_CUSTOMER,
} from '../constants/ActionTypes' 
import { updateList, resultOk, resultError, listUpdated } from '../actions'
import * as selectors from '../selectors'

const listUpdater = ({ dispatch, getState }) => next => action => {
  const result = next(action)
	switch(action.type) {

		case UPDATE_LIST:
			dispatch(reset('customer'))
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

		case UNSELECT_CUSTOMER:
			dispatch(initialize('customer'))
	}
  return result
}

export default listUpdater
