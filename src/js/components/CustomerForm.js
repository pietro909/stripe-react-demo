import React from 'react'
import PropTypes from 'prop-types'
import Input from './Input'

const CustomerForm = ({
  cleanFields,
  createCustomer,
  deleteCustomer,
  model,
  onChange,
  updateCustomer,
}) => {
  const { fields } = model
  const isUpdate = !!fields.id.value
  const onSubmit = e => {
    e.preventDefault()
    if (isUpdate) {
      updateCustomer(null)
    } else {
      createCustomer(null)
    }
  }
  return (
    <form onSubmit={onSubmit} className="row">
      <div className="form-field col-sm-12">
        <label htmlFor="name">First Name</label>
        <Input
          id="name"
          name={fields.firstName.name}
          onChange={({ target }) => onChange(fields.firstName.name, target.value)}
          placeholder="First name"
          value={fields.firstName.value}
        />
      </div>
      <div className="form-field col-sm-12">
        <label htmlFor="lastName">Last Name</label>
        <Input
          id="lastName"
          name={fields.lastName.name}
          onChange={({ target }) => onChange(fields.lastName.name, target.value)}
          placeholder="Second name"
          value={fields.lastName.value}
        />
      </div>
      <div className="form-field col-sm-12">
        <label htmlFor="balance">Balance</label>
        <Input
          id="balance"
          min="0.0"
          name={fields.balance.name}
          onChange={({ target }) => onChange(fields.balance.name, target.value)}
          step="0.1"
          type="number"
          value={fields.balance.value.toString()}
        />
      </div>
      <div className="form-field col-sm-12">
        <label htmlFor="email">Email</label>
        <Input
          id="email"
          name={fields.email.name}
          onChange={({ target }) => onChange(fields.email.name, target.value)}
          placeholder="your@e.mail"
          type="email"
          value={fields.email.value}
        />
      </div>
      <div className="form-field col-sm-12">
        <label htmlFor="description">Description</label>
        <Input
          id="description"
          name={fields.description.name}
          onChange={({ target }) => onChange(fields.description.name, target.value)}
          placeholder="Description"
          value={fields.description.value}
        />
      </div>
      <div className="buttons col-sm-12">
        <button type="submit" className="btn btn-default">
          {isUpdate ? 'Update' : 'Submit'}
        </button>
        <button type="button" className="btn btn-primary" onClick={cleanFields}>
          Clear Values
        </button>
        <button
          className="btn btn-danger"
          disabled={!isUpdate}
          onClick={() => deleteCustomer(null)}
          type="button"
        > Delete </button>
      </div>
    </form>
  )
}

CustomerForm.propTypes = {
  cleanFields: PropTypes.func.isRequired,
  createCustomer: PropTypes.func.isRequired,
  deleteCustomer: PropTypes.func.isRequired,
  model: PropTypes.object.isRequired,
  onChange: PropTypes.func.isRequired,
  updateCustomer: PropTypes.func.isRequired,
}

export default CustomerForm
