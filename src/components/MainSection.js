import React, { Component, PropTypes } from 'react'

import Customer from './Customer'

export default class MainSection extends Component {
  static propTypes = {
    customers: PropTypes.array.isRequired,
    actions: PropTypes.object.isRequired
  }

	componentDidMount() {
		this.props.actions.updateList()
	}

  render() {
    const { customers, actions } = this.props
			
    return (
      <section className="col-sm-8 main">
        <ul>
          {customers.map(customer =>
            <Customer
              key={customer.id}
              id={customer.id}
              name={customer.firstName}
              lastName={customer.lastName}
              email={customer.email}
              description={customer.description}
              balance={customer.balance}
              onClick={actions.selectCustomer}
            />
          )}
        </ul>
      </section>
    )
  }
}
