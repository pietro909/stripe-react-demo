export const expectedPorts = {
	out: [
		'customers',
		'formUpdated',
		'statusMessages',
		'errors',
		'destination',
		'customerInTheEditor',
		'navigateTo',
		'selectors',
	],
	in: [
		'updateList',
		'updateForm',
		'start',
		'createCustomer',
		'updateCustomer',
		'deleteCustomer',
		'selectCustomer',
		'setRoute',
	],
}

export function buildState({ incoming, outgoing }) {
  if (!incoming || !outgoing) {
    return {}
  }
  const {
    createCustomer,
    deleteCustomer,
    selectCustomer,
    setRoute,
    updateCustomer,
    updateForm,
    updateList,
  } = outgoing
  const {
    customers,
    formUpdated,
    destination,
    statusMessages,
  } = incoming
  return {
    createCustomer,
    customers: customers || [],
    deleteCustomer,
    formUpdated,
    destination,
    selectCustomer,
    setRoute: setRoute,
    statusMessage: statusMessages || {},
    statusMessages,
    unselectCustomer: () => selectCustomer(''),
    updateCustomer,
    updateFormField: updateForm ? (name, value) => updateForm([name, value]) : null,
    updateList,
  }
}
