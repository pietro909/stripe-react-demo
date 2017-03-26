import React, { Component } from 'react'

export default class Input extends Component {
  
  constructor(props) {
    super(props)
    const isNumber = props.type === 'number'
    this.state = {
      attributes: {
        id: props.name,
        name: props.name,
        placeholder: props.placeholder,
        type: props.type || 'text',
        step: isNumber && props.step, 
        min: isNumber && props.min, 
        max: isNumber && props.max, 
        value: props.value,
        onChange: props.onChange,
      }
    }
  }

  shouldComponentUpdate(nextProps, nextState) {
    return (this.state.value !== nextProps.value)
  }

  componentWillReceiveProps(nextProps) {
    this.setState((prevState, props) => ({
      ...prevState,
      attributes: {
        ...prevState.attributes,
        value: nextProps.value
      }
    }))
  }

  render() {
    return(
      <input 
        {...this.state.attributes}
      />)
  }
}


