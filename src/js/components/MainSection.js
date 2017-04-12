import React from 'react'
import PropTypes from 'prop-types'

import Customer from './Customer'

const MainSection =
  ({ customers, selectCustomer }) =>
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
            onClick={() => selectCustomer(customer.id)}
          />
        )}
      </ul>
    </section>

MainSection.propTypes = {
  customers: PropTypes.array.isRequired,
  selectCustomer: PropTypes.func.isRequired,
}

export default MainSection
