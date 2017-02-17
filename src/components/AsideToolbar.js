import React, { Component, PropTypes } from 'react'

import Editor from './Editor'

export default class AsideToolbar extends Component {
  static propTypes = {
    customers: PropTypes.array.isRequired,
    actions: PropTypes.object.isRequired,
    selectedCustomerId: PropTypes.string
    editorContent: PropTypes.object.isRequired
  }

  submitCustomer() {
    this.props.actions.createCustomer(this.props.editorContent)
  }

  render() {
    const { actions, customers, selectedCustomerId } = this.props
    const selectedCustomer = customers.find(c => c.id === selectedCustomerId)
    const onFieldUpdate = (e) => actions.updateField(e.target.name, e.target.value)
    
    return (
      <aside className="col-sm-4">
        <div className="button-group server-controls">
          <button onClick={() => actions.openEditor(selectedCustomerId)} className="btn btn-default">
            <span className="glyphicon glyphicon-plus-sign"></span>
            <p>Add Server</p>
          </button>
          <button onClick={() => actions.deleteCustomer(selectedCustomerId)} className="btn btn-default">
            <span className="glyphicon glyphicon-minus-sign"></span>
            <p>Remove Server</p>
          </button>
        </div>
        <Editor
          balance={selectedCustomer && selectedCustomer.balance}
          description={selectedCustomer && selectedCustomer.description}
          email={selectedCustomer && selectedCustomer.email}
          firstName={selectedCustomer && selectedCustomer.firstName}
          lastName={selectedCustomer && selectedCustomer.lastName}
          onFieldUpdate={onFieldUpdate}
          onSubmit={submitCustomer}
        />
     </aside>
    )
  }
}
