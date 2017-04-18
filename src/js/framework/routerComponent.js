import React from 'react'

const routerComponentFactory =
  setRoute => (Component, props) => routerProps => {
    setRoute(routerProps.match.path)
    return <Component {...props} {...routerProps} />
  }

export default routerComponentFactory
