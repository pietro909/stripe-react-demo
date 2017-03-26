import React, { Component, PropTypes } from 'react'
import Header from './components/Header'
import AsideToolbar from './components/AsideToolbar'
import MainSection from './components/MainSection'

import { appWithElm } from './ElmApp'


class TheApp extends Component {
  static propTypes = {
    incoming: PropTypes.object.isRequired,
    outgoing: PropTypes.object.isRequired,
    ports: PropTypes.object.isRequired
  }

  render() {
    const {
      createCustomer,
      deleteCustomer,
      selectCustomer,
      updateCustomer,
      updateForm,
      updateList,
    } = this.props.outgoing
    const { 
      customers,
      formUpdated,
      statusMessages,
    } = this.props.incoming
    const updateFormField = (name, value) => updateForm([name, value])
    const statusMessage = statusMessages || {}
    return (
      <article>
        <Header message={statusMessages.message} level={statusMessage.level}/>
        <div className="row">
          <AsideToolbar
            createCustomer={createCustomer}
            deleteCustomer={deleteCustomer}
            selectedCustomer={formUpdated}
            unselectCustomer={() => selectCustomer('')}
            updateCustomer={updateCustomer}
            updateForm={updateFormField}
          />
          <MainSection
            customers={customers || []}
            selectCustomer={selectCustomer}
           />
          <button onClick={() => updateList(null)}>update list</button>
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

if (!process.env.REACT_APP_API_KEY) {
  throw new Error("Cannot find REACT_APP_API_KEY. Please read the README.")
}

const App = appWithElm(options)(TheApp)

export default App 
