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
      addCustomer,
      deleteCustomer,
      selectCustomer,
      updateCustomer,
      updateList,
      updateForm,
    } = this.props.outgoing
    const { 
      customerInTheEditor,
      customers,
      formUpdated,
    } = this.props.incoming
    const updateFormField = (name, value) => updateForm([name, value])
    return (
      <article>
        <Header/>
        <div className="row">
          <AsideToolbar
            deleteCustomer={deleteCustomer}
            selectedCustomer={formUpdated}
            unselectCustomer={() => selectCustomer('')}
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

const options = { debug: true }
const App = appWithElm(options)(TheApp, { apiKey: process.env.REACT_APP_API_KEY })

export default App 
