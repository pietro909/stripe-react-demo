import * as types from '../constants/ActionTypes'
import * as API from '../constants/API'

export const selectCustomer = (id) => ({
	type: types.SELECT_CUSTOMER,
	id
})

export const openEditor = (id) => ({
	type: types.OPEN_EDITOR,
	id
})

export const listUpdated = data => ({
	type: types.LIST_UPDATED,
	data
})

export const resultOk = (message) => ({ type: types.OK, message })

export const resultError = (message) => ({ type: types.ERROR, message })

export const createCustomer = customer => ({
	type: types.CREATE_CUSTOMER,
	customer,
})

export const updateCustomer = (id,  customer) => ({
	type: types.UPDATE_CUSTOMER,
	customer, id
})
	/*
	dispatch({ type: types.UPDATE_CUSTOMER })
	return API.update(id, customer)
		.then(response => {
			if (response.ok) {
				return response.json()
			}
			throw new Error('Update failed!')
		})
		.then(response => dispatch(resultOk('Customer updated')))
		.catch(reason => dispatch(resultError(reason)))
}
		*/

export const deleteCustomer = id => dispatch => {
	dispatch({ type: types.DELETE_CUSTOMER })
	return API.remove(id)
		.then(response => {
			if (response.ok) {
				return response.json()
			}
			throw new Error('Deletion failed!')
		})
		.then(response => dispatch(resultOk('Customer deleted')))
		.catch(reason => dispatch(resultError(reason)))
}

export const updateList = () => ({ type: types.UPDATE_LIST })

