import React, { Component, PropTypes } from 'react'
import moment from  'moment'

export default class Customer extends Component {

  static propTypes = {
    balance: Props.required.string
    description: Props.required.string, 
    email: Props.required.string, 
    id: Props.required.string,
    lastName: Props.required.string, 
    name: Props.required.string, 
    onClick: Props.function.required
  }

  render() {
    const { id, name, lastName, email, description, balance, onClick } = this.props

    return (
      <li className="server" onClick={onClick}>
        <span>{name}</span>
        <span>{lastName}</span>
        <span>{balance}</span>
        <span>{email}</span>
        <span>{description}</span>
      </li>
    )
  }
}
