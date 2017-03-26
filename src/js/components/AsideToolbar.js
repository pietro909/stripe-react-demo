import React, { Component, PropTypes } from 'react'
import CustomerForm from './CustomerForm'

export default class AsideToolbar extends Component {

  static propTypes = {
		deleteCustomer: PropTypes.func.isRequired,
		selectedCustomer: PropTypes.object.isRequired,
  }
 
  render() {
		const {
			deleteCustomer,
			selectedCustomer,
      createCustomer,
      unselectCustomer,
      updateCustomer,
      updateForm,
		} = this.props
    const handleSubmit = () => console.log(`submit!`)
    return (
      <aside className="col-sm-4">
        <CustomerForm
					cleanFields={unselectCustomer}
					deleteCustomer={deleteCustomer}
					model={selectedCustomer} 
					onSubmit={handleSubmit}
          createCustomer={createCustomer}
          onChange={updateForm}
          updateCustomer={updateCustomer}
				/>
     </aside>
    )
  }
}

