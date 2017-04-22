import React from 'react'
import PropTypes from 'prop-types'

const Customer =
  ({
    balance,
    description,
    email,
    id,
    lastName,
    name,
  }) => {
    const route = `/edit/${id}`
    return <li className="customer">
      <a href={route}>Edit</a>
      <span>{name}</span>
      <span>{lastName}</span>
      <span>{balance}</span>
      <span>{email}</span>
      <span>{description}</span>
    </li>
  }

Customer.propTypes = {
  balance: PropTypes.number.isRequired,
  description: PropTypes.string.isRequired,
  email: PropTypes.string.isRequired,
  id: PropTypes.string.isRequired,
  lastName: PropTypes.string.isRequired,
  name: PropTypes.string.isRequired,
  onClick: PropTypes.func,
}

export default Customer
