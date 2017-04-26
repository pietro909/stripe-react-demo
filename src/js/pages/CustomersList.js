import React from 'react'
import PropTypes from 'prop-types'
import {
  Page,
  Toolbar,
  Button,
  BackButton,
  ToolbarButton,
  Icon,
  ListItem,
  List,
} from 'react-onsenui'

import Customer from '../components/Customer'

const CustomersList =
  ({ customers, navigateToUrl }) =>
  <List
    dataSource={customers}
    renderRow={(customer, idx) => (
      <ListItem key={customer.id} modifier={idx === customers.length - 1 ? 'longdivider' : null}>
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
      </ListItem>
    )}
  />

CustomersList.propTypes = {
  customers: PropTypes.array.isRequired,
  navigateToUrl: PropTypes.func.isRequired,
}

export default CustomersList
