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
  // pristine, submitting...
  return (
    <form onSubmit={onSubmit} className="row">
      <div className="form-field col-sm-12">
        <label>First Name</label>
        <Input
          name={model.firstName.name}
          value={model.firstName.value}
          onChange={({target}) => onChange(model.firstName.name, target.value)}
          placeholder="First name"
        />
			</div>
      <div className="form-field col-sm-12">
        <label>Last Name</label>
        <Input
          name={model.lastName.name}
          value={model.lastName.value}
          onChange={({target}) => onChange(model.lastName.name, target.value)}
          placeholder="Second name"
        />
			</div>

    {/*
      <div className="form-field col-sm-12">
				<label>Last Name</label>
				<input name="lastName" type="text" placeholder="Last Name"/>
      </div>
      <div className="form-field col-sm-12">
				<label>Email</label>
				<input name="email" type="email" placeholder="Email"/>
      </div>
      <div className="form-field col-sm-12">
				<label>Description</label>
				<input name="description" type="text" placeholder="Description"/>
      </div>
      <div className="form-field col-sm-12">
				<label>Balance</label>
				<input name="balance" type="number" placeholder="Balance"/>
      </div>
      */}
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
