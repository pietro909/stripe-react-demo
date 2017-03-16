 /*global Elm*/
import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import Header from './components/Header'
import AsideToolbar from './components/AsideToolbar'
import MainSection from './components/MainSection'
import * as Actions from './actions'

const bootstrapElm = (elmApp) =>
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
    app = elmApp.embed(node, ' ')
  })

export function appWithElm(WrappedComponent) { //, data) {
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
      bootstrapElm(elmApp).then(app => {
        this.setState((prevState, props) => ({
          ports: app.ports,
          ready: true
        }))
        console.log(app)
        Object.keys(app.ports).forEach(portId => {
          const port = app.ports[portId]
          console.log(port)
          if (port.subscribe) {
            port.subscribe(data => this.setState({
              incoming: {
                ...this.state.incoming,
                [portId]: data
              }
            }))
          } else if (port.send) {
            this.setState({
              outgoing: {
                ...this.state.outgoing,
                [portId]: port.send
              }
            })
          }
        })
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
    const outgoing = this.props.outgoing
    return (
      <article>
        <Header/>
        <div className="row">
          <MainSection
            customers={this.props.incoming.customers || []}
            actions={{}}
           />
          <button onClick={() => outgoing.addCustomer('Vafffa')}>Click me</button>
        </div>
      </article>
    )
  }
}
 
const App = appWithElm(TheApp)
export default App 
