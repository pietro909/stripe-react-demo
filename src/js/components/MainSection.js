import React from 'react'
import PropTypes from 'prop-types'

import Customer from './Customer'

const MainSection =
  ({ customers, navigateToUrl }) =>
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
            navigateToUrl={navigateToUrl}
          />
        )}
      </ul>
    </section>

MainSection.propTypes = {
  customers: PropTypes.array.isRequired,
  navigateToUrl: PropTypes.func.isRequired,
}

export default MainSection
