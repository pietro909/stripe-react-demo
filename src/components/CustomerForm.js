import React, { Component } from 'react'

class Input extends Component {
  
  constructor(props) {
    super(props)
    this.state = {
      attributes: {
        id: props.name,
        name: props.name,
        placeholder: props.placeholder,
        type: props.type || 'text',
        value: props.value,
        onChange: props.onChange,
      }
    }
  }

  shouldComponentUpdate(nextProps, nextState) {
    return (this.state.value !== nextProps.value)
  }

  componentWillReceiveProps(nextProps) {
    this.setState((prevState, props) => ({
      ...prevState,
      attributes: {
        ...prevState.attributes,
        value: props.value
      }
    }))
  }

  render() {
    return(
      <input 
        {...this.state.attributes}
      />)
  }
}

const CustomerForm = (props) => {
  const {
		cleanFields,
		deleteCustomer,
		model,
    onSubmit,
    onChange,
	} = props
  const { fields } = model
  // pristine, submitting...
  return (
    <form onSubmit={onSubmit} className="row">
      <div className="form-field col-sm-12">
        <label>First Name</label>
        <Input
          name={fields.firstName.name}
          value={fields.firstName.value}
          onChange={({target}) => onChange(fields.firstName.name, target.value)}
          placeholder="First name"
        />
			</div>
      <div className="form-field col-sm-12">
        <label>Last Name</label>
        <Input
          name={fields.lastName.name}
          value={fields.lastName.value}
          onChange={({target}) => onChange(fields.lastName.name, target.value)}
          placeholder="Second name"
        />
			</div>
      <div className="form-field col-sm-12">
        <label>Balance</label>
        <Input
          type="number"
          step="0.1"
          min="0"
          name={fields.balance.name}
          value={fields.balance.value}
          onChange={({target}) => onChange(fields.balance.name, target.value)}
        />
			</div>
      <div className="form-field col-sm-12">
        <label>Email</label>
        <Input
          type="email"
          name={fields.email.name}
          value={fields.email.value}
          onChange={({target}) => onChange(fields.email.name, target.value)}
          placeholder="your@e.mail"
        />
			</div>
      <div className="form-field col-sm-12">
        <label>Description</label>
        <Input
          name={fields.description.name}
          value={fields.description.value}
          onChange={({target}) => onChange(fields.description.name, target.value)}
          placeholder="Description"
        />
			</div>
      <div className="buttons col-sm-12">
        <button type="onSubmit" className="btn btn-default"
          onClick={onSubmit}>Submit</button>
        <button type="button" className="btn btn-primary"
          onClick={cleanFields}>Clear Values</button>
        <button type="button" className="btn btn-danger"
          onClick={deleteCustomer}>Delete</button>
      </div>
    </form>
  )
}

export default CustomerForm
