
export const getCustomers = state =>
  state.customers

export const getCustomerById = (id, state) =>
  getCustomers(state).find(c => c.id === id)

export const getActiveCustomer = state => {
  if (state.selectedCustomer) {
    return getCustomerById(state.selectedCustomer, state)
  }
}
