import React from 'react'
import PropTypes from 'prop-types'
import {
  Page,
  Toolbar,
  Button,
  BackButton,
  ToolbarButton,
  Icon,
} from 'react-onsenui'

const alertLevels = ['success', 'warning', 'danger']
/*
          <ul>
            <li><Link to="/" onUrl={navigateToUrl}>List</Link></li>
            <li><Link to="/create" onUrl={navigateToUrl}>Create</Link></li>
            <li><Link to="/edit/1234" onUrl={navigateToUrl}>Failing Edit</Link></li>
          </ul>
  */

const Header =
  ({ message = '', level = 1 }) => {

  return (
    <Toolbar>
      <div className="left">
        <BackButton>Back</BackButton>
      </div>
      <div className="center">{message}</div>
      <div className="right">
        <ToolbarButton>
          <Icon icon="md-menu" />
        </ToolbarButton>
      </div>
    </Toolbar>
  )
}

Header.propTypes = {
  message: PropTypes.string,
  level: PropTypes.number,
}

export default Header
