import React, { Component } from 'react'
import PropTypes from 'prop-types'

import Header from './components/Header'
import AsideToolbar from './components/AsideToolbar'
import MainSection from './components/MainSection'

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
      selectCustomer,
      statusMessage,
      unselectCustomer,
      updateCustomer,
      updateFormField,
      destination,
      navigateToUrl,
    } = this.state
    const { page } = destination || {}

    return (
        <article>
          <ul>
            <li><Link to="/" onUrl={navigateToUrl}>List</Link></li>
            <li><Link to="/edit/1234" onUrl={navigateToUrl}>Form</Link></li>
          </ul>

          <Header message={statusMessage.message} level={statusMessage.level} />

          <div className="row">

            { !page &&
              <h1>Component is undefined</h1>
            }

            { page === 'List' &&
                  <MainSection
                    customers={customers}
                    navigateToUrl={navigateToUrl}
                  />
            }

            { page === 'Form' &&
                  <AsideToolbar
                    createCustomer={createCustomer}
                    deleteCustomer={deleteCustomer}
                    selectedCustomer={formUpdated}
                    unselectCustomer={unselectCustomer}
                    updateCustomer={updateCustomer}
                    updateForm={updateFormField}
                  />
            }

            { page === 'NotFound' &&
                  <h1>404 Not found</h1>
            }

          </div>
        </article>
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
