import React, { PropTypes } from 'react'

const alertLevels = ['success', 'warning', 'danger']

const Header =
  ({ message = '', level = 1 }) =>
    <header className="header row">
      <h1 className="col-sm-4">Customers</h1>
      { message &&
        <div className="col-sm-4">
          <div
            className={`alert alert-${alertLevels[level - 1]}`}
          >{ message }</div>
        </div>
      }
    </header>

Header.propTypes = {
  message: PropTypes.string,
  level: PropTypes.number,
}

export default Header
