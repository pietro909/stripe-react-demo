import React, { Component } from 'react'

/* eslint-disable import/no-unresolved */
/* eslint-disable import/extensions */
import Elm from '../elm/Main'
/* eslint-enable import/no-unresolved */

const bootstrapElm = elmApp =>
  new Promise(resolve => {
    const app = elmApp.worker()
    resolve(app)
  })

/* eslint-disable no-console */
const genericLogger = logger => (label, data) => {
  console.group(label)
  if (typeof data === 'object' && typeof data.forEach === 'function') {
    data.forEach(a => logger(a))
  } else {
    logger(data)
  }
  console.groupEnd()
}
/* eslint-enable no-console */

const noop = () => null

const appWithElm =
  ({ startMessage, debug }) => (WrappedComponent) => {
    /* eslint-disable no-console */
    const log = debug ? genericLogger(console.log) : noop
    const warn = debug ? genericLogger(console.warn) : noop
    /* eslint-enable no-console */

    console.log('CHIAMA UNO!!!')

    return class extends Component {
      constructor(props) {
        super(props)
        this.state = {
          ports: {},
          ready: false,
          incoming: {},
          outgoing: {},
        }
        const elmApp = Elm.ElmApp
        bootstrapElm(elmApp).then(app => {
          const portsOut = []
          const portsIn = []
          Object.keys(app.ports).forEach(portId => {
            const port = app.ports[portId]
            if (portId === 'started') {
              const callback = data =>
                /* eslint-disable no-undef */
                requestAnimationFrame(() => {
                  /* eslint-enable no-undef */
                  log(`receive ${portId}`, data)
                  this.setState(() => ({
                    ports: app.ports,
                    ready: true,
                  }))
                  port.unsubscribe(callback)
                })
              port.subscribe(callback)
            } else if (port.subscribe) {
              portsOut.push(portId)
              if (portId === 'errors') {
                port.subscribe(data => this.setState(() => {
                  warn(`receive ${portId}`, data)
                  return {
                    incoming: {
                      ...this.state.incoming,
                      [portId]: data,
                    },
                  }
                }))
              } else {
                port.subscribe(data => this.setState(() => {
                  log(`receive ${portId}`, data)
                  return {
                    incoming: {
                      ...this.state.incoming,
                      [portId]: data,
                    },
                  }
                }))
              }
            } else if (port.send) {
              portsIn.push(portId)
              this.setState(() => ({
                outgoing: {
                  ...this.state.outgoing,
                  [portId]: (...args) => {
                    log(`send ${portId}`, args)
                    port.send(...args)
                  },
                },
              }))
            }
          })
          log('Outgoing ports', portsOut)
          log('Incoming ports', portsIn)
          log('send start', startMessage)
          app.ports.start.send(startMessage)
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

export default appWithElm
