import React, { Component } from 'react'
import PropTypes from 'prop-types'
// import ons from 'onsenui'
import {
  Page,
  Toolbar,
  Button,
  BackButton,
  ToolbarButton,
  Icon,
} from 'react-onsenui'

import Header from './components/Header'
import Edit from './pages/Edit'
import CustomersList from './pages/CustomersList'

import appWithElm from './framework/ElmApp'
import { buildState, expectedPorts } from './framework/appState'
import Link from './framework/Link'


class TheApp extends Component {
  static propTypes = {
    incoming: PropTypes.object.isRequired,
    outgoing: PropTypes.object.isRequired,
  }

  constructor(props) {
    super(props)
    this.state = buildState(props)
  }

  componentWillReceiveProps(nextProps) {
    const nextState = buildState(nextProps)
    this.setState(() => nextState)
  }

  render() {
    const {
      createCustomer,
      customers,
      deleteCustomer,
      formUpdated,
      statusMessage,
      updateCustomer,
      updateFormField,
      destination,
      navigateToUrl,
    } = this.state
    const { page } = destination || {}

    return (
        <Page renderToolbar={Header} >

          <div className="row">

            { !page &&
              <h1>Component is undefined</h1>
            }

            { page === 'List' &&
                  <CustomersList
                    customers={customers}
                    navigateToUrl={navigateToUrl}
                  />
            }

            { page === 'Form' && formUpdated &&
                  <Edit
                    createCustomer={createCustomer}
                    deleteCustomer={deleteCustomer}
                    selectedCustomer={formUpdated}
                    updateCustomer={updateCustomer}
                    updateForm={updateFormField}
                  />
            }

            { page === 'NotFound' &&
                  <h1>404 Not found</h1>
            }

          </div>
        </Page>
    )
  }
}

const options = {
  startMessage: {
    apiKey: process.env.REACT_APP_API_KEY,
  },
  debug: true,
  expectedPorts,
}

const App = appWithElm(options)(TheApp)

export default App
