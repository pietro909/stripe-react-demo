import {
	LIST_UPDATED,
  CREATE_CUSTOMER,
  DELETE_CUSTOMER,
  ERROR,
  OK,
  SELECT_CUSTOMER,
  UNSELECT_CUSTOMER,
  UPDATE_CUSTOMER, 
} from '../constants/ActionTypes' 
import * as Utils from './utils' 

/*
 * show a list of customers
 * create button always active
 *  open blank form when pressed
 *    show cancel and submit
 *      cancel closes the form
 *      submit send CREATE_CUSTOMER with customer's data
 * update button active if list nonEmpty
 *  open form filled with customer's data when pressed
 *    show cancel and submit
 *      cancel closes the form
 *      submit send UPDATE_CUSTOMER with customer's data
 * delete button active if list nonEmpty
 *  send DELETE_CUSTOMER action with customer's id
 *
 * HTTP actions:
 *  OK with message
 *  ERROR with message
 */ 

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
        message: Utils.makeInfo(`Creating new customer...`)
      })

    case UPDATE_CUSTOMER: {
      const id = action.id
      return Object.assign({}, state, {
        message: Utils.makeInfo(`Updating customer ${id}...`)
      })
    }

    case DELETE_CUSTOMER: {
      const id = action.id
      return Object.assign({}, state, {
        message: Utils.makeWarning(`Deleting customer ${id}...`)
      })
    }

		case LIST_UPDATED:
			const customers = action.data.map(item => ({
				balance: item.account_balance,
				description: item.description,
				email: item.email,
				firstName: item.metadata.firstName,
				id: item.id,
				lastName: item.metadata.lastName,
			}))
			return Object.assign({}, state, { customers })

    case OK:
      return Object.assign({}, state, {
        message: Utils.makeError(action.message)
      })

    case ERROR:
      return Object.assign({}, state, {
        message: Utils.makeError(action.message)
      })

    default:
      return state
  }
}
