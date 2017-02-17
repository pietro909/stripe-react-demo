import React, { Component, PropTypes } from 'react'

export default class Editor extends Component {
  static propTypes = {
    balance: PropTypes.string,
    description: PropTypes.string,
    email: PropTypes.string,
    firstName: PropTypes.string,
    lastName: PropTypes.string,
    onFieldUpdate: PropTypes.func.isRequired
  }

  makeTextInput = (name, label, value, onChange) => {
    return (
      <div className="form-field">
        <label htmlFor={name}>{label}</label>
        <input type="text" name={name} value={value} onChange={onChange} />
      </div>
    )
  }

  render() {
    const { balance, description, email, firstName, lastName } = this.props
    const onChange = this.props.onFieldUpdate
    const makeTextInput = this.makeTextInput
    return (
      <div className="form">
      {
        makeTextInput("firstName", "First name", firstName, onChange)
      }
      {
        makeTextInput("lastName", "Last name", lastName, onChange)
      }
      {
        makeTextInput("email", "Email", email, onChange)
      }
      {
        makeTextInput("description", "Description", description, onChange)
      }
      {
        makeTextInput("balance", "Balance", balance, onChange)
      }
      </div>
    )
  }
}
