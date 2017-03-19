import React, { Component, PropTypes } from 'react'
import { compose } from 'redux'
import { connect } from 'react-redux'

export default class Customer extends Component {

  static propTypes = {
    balance: PropTypes.number.isRequired,
    clickHandler: PropTypes.func,
    description: PropTypes.string.isRequired, 
    email: PropTypes.string.isRequired, 
    id: PropTypes.string.isRequired,
    lastName: PropTypes.string.isRequired, 
    name: PropTypes.string.isRequired, 
    onClick: PropTypes.func,
  }

  render() {
    const { name, lastName, email, description, balance, clickHandler } = this.props

    return (
      <li className="customer" onClick={clickHandler}>
        <span>{name}</span>
        <span>{lastName}</span>
        <span>{balance}</span>
        <span>{email}</span>
        <span>{description}</span>
      </li>
    )
  }
}
