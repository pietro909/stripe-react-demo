import React from 'react'
import PropTypes from 'prop-types'

const Customer =
  ({
    balance,
    description,
    email,
    lastName,
    name,
    onClick,
  }) =>
    <li className="customer">
      <button onClick={onClick}>
        <span>{name}</span>
        <span>{lastName}</span>
        <span>{balance}</span>
        <span>{email}</span>
        <span>{description}</span>
      </button>
    </li>

Customer.propTypes = {
  balance: PropTypes.number.isRequired,
  description: PropTypes.string.isRequired,
  email: PropTypes.string.isRequired,
  lastName: PropTypes.string.isRequired,
  name: PropTypes.string.isRequired,
  onClick: PropTypes.func,
}

export default Customer
