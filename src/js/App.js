import React, { Component } from 'react'
import PropTypes from 'prop-types'
import {
  BrowserRouter as Router,
  Route,
  Redirect,
  Link,
  withRouter,
  HashRouter,
} from 'react-router-dom'
//import { withRouter } from 'react-router'

class Appa extends Component {
  static propTypes = {
    match: PropTypes.object.isRequired,
    location: PropTypes.object.isRequired,
    history: PropTypes.object.isRequired,
  }

  render() {
    console.log(`yay`)
    return <App />
  }
}



import Header from './components/Header'
import AsideToolbar from './components/AsideToolbar'
import MainSection from './components/MainSection'

import appWithElm from './framework/ElmApp'
import routerComponentFactory from './framework/routerComponent'

function buildState({ incoming, outgoing }) {
  if (!incoming || !outgoing) {
    return {}
  }
  const {
    createCustomer,
    deleteCustomer,
    selectCustomer,
    setRoute,
    updateCustomer,
    updateForm,
    updateList,
  } = outgoing
  const {
    customers,
    formUpdated,
    navigateTo,
    statusMessages,
  } = incoming
  return {
    createCustomer,
    customers: customers || [],
    deleteCustomer,
    formUpdated,
    navigateTo,
    selectCustomer,
    setRoute: setRoute,
    statusMessage: statusMessages || {},
    statusMessages,
    unselectCustomer: () => selectCustomer(''),
    updateCustomer,
    updateFormField: updateForm ? (name, value) => updateForm([name, value]) : null,
    updateList,
  }
}

const routerComponent =
  (Component, props) => routerProps => {

    <Component {...props} {...routerProps} />
  }

class TheApp extends Component {
  static propTypes = {
    incoming: PropTypes.object.isRequired,
    outgoing: PropTypes.object.isRequired,
    /*
    match: PropTypes.object.isRequired,
    location: PropTypes.object.isRequired,
    history: PropTypes.object.isRequired,
    */
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
      setRoute,
      statusMessage,
      unselectCustomer,
      updateCustomer,
      updateFormField,
      navigateTo,
    } = this.state
    const routerComponent = routerComponentFactory(setRoute)

    console.log(`navigateTo: ${navigateTo}`)
    return (
      <Router onChange>
        <article>
          <ul>
            <li><Link to="/">List</Link></li>
            <li><Link to="/edit/1234">Form</Link></li>
          </ul>

          <Header message={statusMessage.message} level={statusMessage.level} />
          <div className="row">

            <Route
              path="/edit/:id"
              component={ props => {
                const { id } = props.match.params
                if (navigateTo) {
                  return <Redirect to="/404"/>
                }
                if (id !== formUpdated.fields.id.value) {
                  selectCustomer(id)
                  return <h2>No customer {id}</h2>
                }
                return <AsideToolbar
                  createCustomer={createCustomer}
                  deleteCustomer={deleteCustomer}
                  selectedCustomer={formUpdated}
                  unselectCustomer={unselectCustomer}
                  updateCustomer={updateCustomer}
                  updateForm={updateFormField}
                  {...props}
                />
              }}
              onEnter={() => { console.log('FUCK') }}
            />

            <Route
              exact
              path="/"
              component={routerComponent(MainSection, {customers, selectCustomer})}
            />

            <Route
              path="/404"
              component={ props => <h1>404 Not found</h1> }
            />

          </div>
        </article>
      </Router>
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

// A simple component that shows the pathname of the current location
class ShowTheLocation extends React.Component {
  static propTypes = {
    match: PropTypes.object.isRequired,
    location: PropTypes.object.isRequired,
    history: PropTypes.object.isRequired
  }

  render() {
    const { match, location, history } = this.props

    return (
      <HashRouter>
      <div>You are now at {location.pathname}</div>
      </HashRouter>
    )
  }
}

// Create a new component that is "connected" (to borrow redux
// terminology) to the router.
const ShowTheLocationWithRouter = withRouter(ShowTheLocation)

export default ShowTheLocationWithRouter
