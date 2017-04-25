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
		'setRoute',
    'navigateToUrl',
	],
}

export function buildState({ incoming, outgoing }) {
  if (!incoming || !outgoing) {
    return {}
  }
  const {
    createCustomer,
    deleteCustomer,
    setRoute,
    updateCustomer,
    updateForm,
    updateList,
    navigateToUrl,
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
    setRoute: setRoute,
    statusMessage: statusMessages || {},
    statusMessages,
    updateCustomer,
    updateFormField: updateForm ? (name, value) => updateForm([name, value]) : null,
    updateList,
    navigateToUrl,
  }
}
