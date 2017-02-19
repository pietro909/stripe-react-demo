import React, { Component, PropTypes } from 'react'
import { compose } from 'redux'
import { connect } from 'react-redux'

import { createCustomer, updateCustomer } from '../actions'
import CustomerForm from './CustomerForm'

const mapStateToProps = (state, ownProps) => {
	const id = state.selectedCustomerId
	const actions = ownProps.actions
	return {	
		createCustomer: () => actions.createCustomer(id),
		deleteCustomer: () => actions.deleteCustomer(id),
		handleSubmit: values => {
			if (id) {
				ownProps.actions.updateCustomer(id, values)
			} else {
				ownProps.actions.createCustomer(values)
			}
		},
		openEditor: () => actions.openEditor(id),
		updateCustomer: () => actions.updateCustomer(id),
		updateList: () => actions.updateList(),
	}
}

class AsideToolbar extends Component {

  static propTypes = {
		actions: PropTypes.object.isRequired,
		createCustomer: PropTypes.func.isRequired,
		deleteCustomer: PropTypes.func.isRequired,
		handleSubmit: PropTypes.func.isRequired,
		openEditor: PropTypes.func.isRequired,
		selectedCustomerId: PropTypes.string,
		updateCustomer: PropTypes.func.isRequired,
    customers: PropTypes.array.isRequired,
  }
 
  render() {
		const {
			actions,
			customers,
			deleteCustomer,
			handleSubmit,
			openEditor,
			selectedCustomerId,
			updateCustomer,
			updateList,
		} = this.props
    return (
      <aside className="col-sm-4">
        <div className="button-group server-controls">
          <button onClick={openEditor} className="btn btn-default">
            <span className="glyphicon glyphicon-plus-sign"></span>
            <p>Create customer</p>
          </button>
        </div>
        <CustomerForm onSubmit={handleSubmit} deleteCustomer={deleteCustomer}/>
     </aside>
    )
  }
}

export default compose(
	connect(mapStateToProps),
)(AsideToolbar)



