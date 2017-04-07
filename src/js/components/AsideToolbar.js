import React, { PropTypes } from 'react'
import CustomerForm from './CustomerForm'

const AsideToolbar = ({
  createCustomer,
  deleteCustomer,
  selectedCustomer,
  unselectCustomer,
  updateCustomer,
  updateForm,
}) => {
  const handleSubmit = () => console.log('submit!')
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

AsideToolbar.propTypes = {
  createCustomer: PropTypes.func.isRequired,
  deleteCustomer: PropTypes.func.isRequired,
  selectedCustomer: PropTypes.object.isRequired,
  unselectCustomer: PropTypes.func.isRequired,
  updateCustomer: PropTypes.func.isRequired,
  updateForm: PropTypes.func.isRequired,
}

export default AsideToolbar
