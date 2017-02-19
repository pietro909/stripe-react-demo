import React from 'react'
import { Provider } from 'react-redux'
import { applyMiddleware, combineReducers, createStore } from 'redux';
import { reducer as formReducer } from 'redux-form'
import { render } from 'react-dom'
import thunkMiddleware from 'redux-thunk'
import createLogger from 'redux-logger'

import customers from './reducers/customers'
import App from './containers/App'
import listUpdater from './middlewares/listUpdater'
import {OK} from './constants/ActionTypes'

import 'bootstrap/dist/css/bootstrap.min.css'
import './styles.css'

const loggerMiddleware = createLogger()

const reducers = combineReducers({
	customers,
	form: formReducer.plugin({
		customer: (state, action) => {
			switch(action.type) {
				case OK:
					return undefined;       // <--- blow away form data
				default:
					return state;
			}
		}
	})
})
 
const store = createStore(
  reducers,
  applyMiddleware(
    thunkMiddleware,
    loggerMiddleware,
		listUpdater,
  )
);

render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('root')
)

