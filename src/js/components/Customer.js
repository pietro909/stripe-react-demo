import React from 'react'
import PropTypes from 'prop-types'
import {
  Page,
  Toolbar,
  Button,
  BackButton,
  ToolbarButton,
  Icon,
  Switch,
} from 'react-onsenui'
import Link from '../framework/Link'

const Customer =
  ({
    balance,
    description,
    email,
    id,
    lastName,
    name,
    navigateToUrl,
  }) => {
    const route = `/edit/${id}`
    return (
      <Link to={route} onUrl={() => navigateToUrl(route)} id={id}>
        <div className="left">
          <Icon icon="md-face" className="list-item__icon" />
        </div>
        <div className="center">
          <span className="list-item__title">{name}</span>
          <span className="list-item__subtitle">lastName</span>
        </div>
        <label className="right">
          <span className="list-item__subtitle">{balance}</span>
        </label>
      </Link>
    )
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
