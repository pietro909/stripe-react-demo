import React, { Component, PropTypes } from 'react'
import { compose } from 'redux'
import { connect } from 'react-redux'
import { initialize } from 'redux-form'

import { createCustomer, updateCustomer } from '../actions'
import CustomerForm from './CustomerForm'

const mapStateToProps = (state, ownProps) => {
	const id = state.customers.selectedCustomer
	const actions = ownProps.actions
	return {	
		selectedCustomerId: id,
		deleteCustomer: () =>	actions.deleteCustomer(id),
		unselectCustomer: () => actions.unselectCustomer(),
		handleSubmit: values => {
			if (id) {
				ownProps.actions.updateCustomer(id, values)
			} else {
				ownProps.actions.createCustomer(values)
			}
		},
	}
}

class AsideToolbar extends Component {

  static propTypes = {
		handleSubmit: PropTypes.func.isRequired,
		deleteCustomer: PropTypes.func.isRequired,
		unselectCustomer: PropTypes.func.isRequired,
		selectedCustomerId: PropTypes.string.isRequired,
  }
 
  render() {
		const {
			deleteCustomer,
			handleSubmit,
			unselectCustomer,
			selectedCustomerId,
		} = this.props
    return (
      <aside className="col-sm-4">
        <CustomerForm
					selectedCustomerId={selectedCustomerId}
					cleanFields={unselectCustomer}
					onSubmit={handleSubmit}
					deleteCustomer={deleteCustomer}
				/>
     </aside>
    )
  }
}

export default compose(
	connect(mapStateToProps),
)(AsideToolbar)



