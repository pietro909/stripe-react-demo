import React, { Component, PropTypes } from 'react'

export default class MainSection extends Component {
  static propTypes = {
    customers: PropTypes.array.isRequired,
    actions: PropTypes.object.isRequired
  }

  render() {
    const { customers, actions } = this.props

    return (
      <section className="col-sm-8 main">
        <ul className="server-list">
          {customers.map(customer =>
            <Customer
              key={customer.id}
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
