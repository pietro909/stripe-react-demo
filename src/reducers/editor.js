import {
  UPDATE_FIELD
} from '../constants/ActionTypes'

const initialState = {
  id: '', 
  firstName: '', 
  lastName: '', 
  description: '', 
  email: '', 
  balance: 0, 
  firstName: ''
}

export default function editor(state = initialState, action) {
  switch (action.type) {

    case UPDATE_FIELD:
      const newState = Object.assign(state)
      newState[action.payload.name] = action.payload.value
      return newState

    default:
      return state
  }
}

