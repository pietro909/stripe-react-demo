import React, { Component, PropTypes } from 'react'

export default class Customer extends Component {

  static propTypes = {
    balance: PropTypes.number.isRequired,
    description: PropTypes.string.isRequired, 
    email: PropTypes.string.isRequired, 
    id: PropTypes.string.isRequired,
    lastName: PropTypes.string.isRequired, 
    name: PropTypes.string.isRequired, 
    onClick: PropTypes.func,
  }

  render() {
    const { 
      name,
      lastName,
      email,
      description,
      balance,
      onClick,
    } = this.props

    return (
      <li className="customer" onClick={onClick}>
        <span>{name}</span>
        <span>{lastName}</span>
        <span>{balance}</span>
        <span>{email}</span>
        <span>{description}</span>
      </li>
    )
  }
}
