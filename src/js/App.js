import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Header from './components/Header'
import AsideToolbar from './components/AsideToolbar'
import MainSection from './components/MainSection'

import appWithElm from './ElmApp'

function buildState({ incoming, outgoing }) {
  if (!incoming || !outgoing) {
    return {}
  }
  const {
    createCustomer,
    deleteCustomer,
    selectCustomer,
    updateCustomer,
    updateForm,
    updateList,
  } = outgoing
  const {
    customers,
    formUpdated,
    statusMessages,
  } = incoming
  return {
    customers: customers || [],
    deleteCustomer,
    formUpdated,
    selectCustomer,
    statusMessages,
    updateCustomer,
    updateFormField: updateForm ? (name, value) => updateForm([name, value]) : null,
    updateList,
    createCustomer,
    statusMessage: statusMessages || {},
    unselectCustomer: () => selectCustomer(''),
  }
}

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
    this.setState(() => buildState(nextProps))
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
    } = this.state
    return (
      <article>
        <Header message={statusMessage.message} level={statusMessage.level} />
        <div className="row">
          <AsideToolbar
            createCustomer={createCustomer}
            deleteCustomer={deleteCustomer}
            selectedCustomer={formUpdated}
            unselectCustomer={unselectCustomer}
            updateCustomer={updateCustomer}
            updateForm={updateFormField}
          />
          <MainSection
            customers={customers}
            selectCustomer={selectCustomer}
          />
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
