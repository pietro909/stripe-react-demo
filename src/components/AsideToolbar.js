import React, { Component, PropTypes } from 'react'
//import CustomerForm from './CustomerForm'

export default class AsideToolbar extends Component {

  static propTypes = {
		deleteCustomer: PropTypes.func.isRequired,
		selectedCustomer: PropTypes.object.isRequired,
  }
 
  render() {
		const {
			deleteCustomer,
			selectedCustomer,
		} = this.props
    return (
      <aside className="col-sm-4">
        <p>{selectedCustomer.id}</p>
      {/*

        <CustomerForm
					selectedCustomer={selectedCustomer} 
					cleanFields={unselectCustomer}
					onSubmit={handleSubmit}
					deleteCustomer={deleteCustomer}
				/>
      */}
     </aside>
    )
  }
}

