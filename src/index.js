import React from 'react'
import { Provider } from 'react-redux'
import { applyMiddleware, combineReducers, createStore } from 'redux';
import { reducer as formReducer } from 'redux-form'
import { render } from 'react-dom'

import {logger} from './middlewares/logging'
import customers from './reducers/customers'
import editor from './reducers/editor'
import App from './containers/App'

import 'bootstrap/dist/css/bootstrap.min.css'
import './styles.css'

const reducers = combineReducers({
  customers,
  editor,
  formReducer
})

 
const store = createStore(
  reducers,
  applyMiddleware(logger)
);

render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('root')
)

