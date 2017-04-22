import React, { Component } from 'react'
import PropTypes from 'prop-types'

import Header from './components/Header'
import AsideToolbar from './components/AsideToolbar'
import MainSection from './components/MainSection'

import appWithElm from './framework/ElmApp'
import { buildState } from './framework/appState'

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
    } = this.state

    console.log(`destination: ${destination.path} ${destination.component}`)

    return (
        <article>
          <ul>
            <li><Link to="/">List</Link></li>
            <li><Link to="/edit/1234">Form</Link></li>
          </ul>

          <Header message={statusMessage.message} level={statusMessage.level} />

          <div className="row">

            { switch(destination.component) {

                case 'List':
                  <MainSection
                    customers={customers}
                    selectCustomer={selectCustomer}
                  />
                  break

                case 'Form':
                  <AsideToolbar
                    createCustomer={createCustomer}
                    deleteCustomer={deleteCustomer}
                    selectedCustomer={formUpdated}
                    unselectCustomer={unselectCustomer}
                    updateCustomer={updateCustomer}
                    updateForm={updateFormField}
                  />
                  break

                case 'NotFound':
                  <h1>404 Not found</h1>
                  break

                default:
                  throw new Error(`Component ${destination.component}`)
            }}

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
}

const App = appWithElm(options)(TheApp)

export default App
