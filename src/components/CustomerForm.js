import React from 'react'
import { Field, reduxForm } from 'redux-form'

const CustomerForm = (props) => {
  const {
		handleSubmit,
		pristine,
		submitting,
		deleteCustomer,
		cleanFields,
		selectedCustomerId,
	} = props
  return (
    <form onSubmit={handleSubmit} className="row">
      <div className="form-field col-sm-12">
				<label>First Name</label>
				<Field name="firstName" component="input" type="text" placeholder="First Name"/>
      </div>
      <div className="form-field col-sm-12">
				<label>Last Name</label>
				<Field name="lastName" component="input" type="text" placeholder="Last Name"/>
      </div>
      <div className="form-field col-sm-12">
				<label>Email</label>
				<Field name="email" component="input" type="email" placeholder="Email"/>
      </div>
      <div className="form-field col-sm-12">
				<label>Description</label>
				<Field name="description" component="input" type="text" placeholder="Description"/>
      </div>
      <div className="form-field col-sm-12">
				<label>Balance</label>
				<Field name="balance" component="input" type="number" placeholder="Balance"/>
      </div>
      <div className="buttons col-sm-12">
        <button type="submit" className="btn btn-default" disabled={pristine || submitting}>Submit</button>
        <button type="button" className="btn btn-primary" disabled={submitting} onClick={cleanFields}>Clear Values</button>
        <button type="button" className="btn btn-danger" disabled={submitting || !selectedCustomerId} onClick={deleteCustomer}>Delete</button>
      </div>
    </form>
  )
}

export default reduxForm({
	form: 'customer'
})(CustomerForm)

