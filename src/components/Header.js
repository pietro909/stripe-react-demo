import React, { PropTypes, Component } from 'react'

export default class Header extends Component {
  static propTypes = {
    message: PropTypes.string,
    level: PropTypes.number,
  }

  render() {
    const { message, level } = this.props
		let alertClass = 'success'
		if (level === 2) {
			alertClass = 'warning'
		} else if (level === 3) {
			alertClass = 'danger'
		}
		
    return (
      <header className="header row">
        <h1 className="col-sm-4">Customers</h1>
				<div className="col-sm-4">
					<div className={`alert alert-${alertClass}`}>{message || ''}</div>
				</div>
      </header>
    )
  }
}
