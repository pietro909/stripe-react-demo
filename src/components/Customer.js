import React, { Component, PropTypes } from 'react'
import { compose } from 'redux'
import { connect } from 'react-redux'

const mapDispatchToProps = (dispatch, ownProps) => ({
	clickHandler: () => ownProps.onClick(ownProps.id)
})

export class Customer extends Component {

  static propTypes = {
    balance: PropTypes.number.isRequired,
    clickHandler: PropTypes.func.isRequired,
    description: PropTypes.string.isRequired, 
    email: PropTypes.string.isRequired, 
    id: PropTypes.string.isRequired,
    lastName: PropTypes.string.isRequired, 
    name: PropTypes.string.isRequired, 
    onClick: PropTypes.func.isRequired,
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

export default compose(
	connect(mapDispatchToProps),
)(Customer)
