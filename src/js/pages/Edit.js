import React from 'react'
import PropTypes from 'prop-types'
import CustomerForm from '../components/CustomerForm'

const Edit = ({
  createCustomer,
  deleteCustomer,
  selectedCustomer,
  updateCustomer,
  updateForm,
}) =>
  <aside className="col-sm-4">
    <CustomerForm
      deleteCustomer={deleteCustomer}
      model={selectedCustomer}
      createCustomer={createCustomer}
      onChange={updateForm}
      updateCustomer={updateCustomer}
    />
  </aside>

Edit.propTypes = {
  createCustomer: PropTypes.func.isRequired,
  deleteCustomer: PropTypes.func.isRequired,
  selectedCustomer: PropTypes.object.isRequired,
  updateCustomer: PropTypes.func.isRequired,
  updateForm: PropTypes.func.isRequired,
}

export default Edit
