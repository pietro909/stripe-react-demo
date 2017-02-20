import {
	LIST_UPDATED,
	UPDATE_LIST,
  CREATE_CUSTOMER,
  DELETE_CUSTOMER,
  ERROR,
  OK,
  SELECT_CUSTOMER,
  UNSELECT_CUSTOMER,
  UPDATE_CUSTOMER, 
} from '../constants' 
import * as Utils from './utils' 

const initialState = {
  customers: [],
  message: null,
  selectedCustomer: null
}

export default function customers(state = initialState, action) {
  switch (action.type) {

    case SELECT_CUSTOMER:
      return Object.assign({}, state, {
        selectedCustomer: action.id
      })

    case UNSELECT_CUSTOMER:
      return Object.assign({}, state, {
        selectedCustomer: null
      })

    case CREATE_CUSTOMER:
      return Object.assign({}, state, {
        message: Utils.makeWarning(`Creating new customer...`)
      })

    case UPDATE_CUSTOMER: {
      const id = action.id
      return Object.assign({}, state, {
        message: Utils.makeWarning(`Updating customer ${id}...`)
      })
    }

    case DELETE_CUSTOMER: {
      const id = action.id
      return Object.assign({}, state, {
        message: Utils.makeWarning(`Deleting customer ${id}...`)
      })
    }

		case UPDATE_LIST:
			return Object.assign({}, state, {
				message: Utils.makeWarning('Fetching customers...')
			})

		case LIST_UPDATED:
			const customers = action.data.map(item => ({
				balance: item.account_balance/1000,
				description: item.description,
				email: item.email,
				firstName: item.metadata.firstName,
				id: item.id,
				lastName: item.metadata.lastName,
			}))
			return Object.assign({}, state, {
        message: Utils.makeInfo(`Read ${customers.length} customers.`),
				customers,
			})

    case OK:
      return Object.assign({}, state, {
        message: Utils.makeInfo(action.message)
      })

    case ERROR:
      return Object.assign({}, state, {
        message: Utils.makeError(action.message)
      })

    default:
      return state
  }
}
