import React, { PropTypes, Component } from 'react'

export default class Header extends Component {
  static propTypes = {
    message: PropTypes.string,
    level: PropTypes.number
  }

  render() {
    const message = this.props.message || '' 
    return (
      <header className="header row">
        <h1 className="col-sm-4">Customers</h1>
        <input disabled type="input" value={message}/>
      </header>
    )
  }
}
