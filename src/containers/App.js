import React, { PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import Header from '../components/Header'
import AsideToolbar from '../components/AsideToolbar'
import MainSection from '../components/MainSection'
import * as Actions from '../actions'

const App = ({customers, actions, message, selectedCustomer}) => {
  const msgText = message && message.message
  const msgLevel = message && message.level
  return (
    <article>
      <Header message={msgText} level={msgLevel} />
      <div className="row">
        <AsideToolbar customers={customers} actions={actions} selectedCustomerId={selectedCustomer} />
        <MainSection customers={customers} actions={actions} />
      </div>
    </article>
  )
}

App.propTypes = {
  actions: PropTypes.object.isRequired,
  customers: PropTypes.array.isRequired,
  message: PropTypes.object,
  selectedCustomer: PropTypes.string
}

const mapStateToProps = state => ({
  customers: state.customers.customers,
  message: state.customers.message,
  selectedCustomer: state.customers.selectedCustomer
})

const mapDispatchToProps = dispatch => ({
  actions: bindActionCreators(Actions, dispatch)
})

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(App)
