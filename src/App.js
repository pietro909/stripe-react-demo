 /*global Elm*/
import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import Header from './components/Header'
import AsideToolbar from './components/AsideToolbar'
import MainSection from './components/MainSection'
import * as Actions from './actions'

const bootstrapElm = (elmApp, flags) =>
  new Promise((resolve, reject) => {
    const node = document.createElement('div')
    let app = null
    const observer = new MutationObserver(function(mutations) {
      for (let i = 0; i < mutations.length; i += 1) {
        if (mutations[i].addedNodes.length > 0) {
          observer.disconnect();
          resolve(app)
          return
        }
      }
    });
    const config = { attributes: true, childList: true, characterData: true };
    observer.observe(node, config);
    app = elmApp.embed(node, flags)
  })

export function appWithElm(WrappedComponent, flags) { //, data) {
  return class extends Component {
    constructor(props) {
      super(props)
      // const dataIds = data.map(id => ({ id }))
      this.state = {
        ports: {},
        ready: false,
        incoming: {},
        outgoing: {}
        // ...dataIds
      }
      const elmApp = Elm.ElmApp
      bootstrapElm(elmApp, flags).then(app => {
        Object.keys(app.ports).forEach(portId => {
          const port = app.ports[portId]
          if (port.subscribe) {
            console.log(`${portId} OUT`)
            port.subscribe(data => this.setState((prevState, props) => {
              console.group(`receive ${portId}`)
              console.log(data)
              console.groupEnd()
              return{
              incoming: {
                ...this.state.incoming,
                [portId]: data
              }
            }}))
          } else if (port.send) {
            console.log(`${portId} IN`)
            this.setState((prevState, props) => ({
              outgoing: {
                ...this.state.outgoing,
                [portId]: (...args) => {
                  console.group(`call ${portId}`)
                  args.forEach(a => console.log(a))
                  console.groupEnd()
                  port.send(...args)
                }
              }
            }))
          }
        })
        this.setState((prevState, props) => ({
          ports: app.ports,
          ready: true
        }))
      })
    }

    render() {
      if (this.state.ready) {
        return (
          <WrappedComponent
            ports={this.state.ports}
            incoming={this.state.incoming}
            outgoing={this.state.outgoing}
          />
        )
      }
      return (<div>Loading...</div>)
    }
  }
}

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
    } = this.props.outgoing
    const { 
      customerInTheEditor,
      customers,
    } = this.props.incoming
    const next = (customers && customers.length+1) || 0
    return (
      <article>
        <Header/>
        <div className="row">
          <AsideToolbar
            deleteCustomer={deleteCustomer}
            selectedCustomer={customerInTheEditor || {}}
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

console.log(process.env)
 
const App = appWithElm(TheApp, { apiKey: process.env.REACT_APP_API_KEY })
export default App 
