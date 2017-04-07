import React, { Component, PropTypes } from 'react'

export default class Input extends Component {

  static propTypes = {
    name: PropTypes.string.isRequired,
    placeholder: PropTypes.string,
    type: PropTypes.string,
    step: PropTypes.string,
    min: PropTypes.string,
    max: PropTypes.string,
    value: PropTypes.string,
    onChange: PropTypes.func.isRequired,
  }

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
      },
    }
  }

  componentWillReceiveProps(nextProps) {
    this.setState(prevState => ({
      ...prevState,
      attributes: {
        ...prevState.attributes,
        value: nextProps.value,
      },
    }))
  }

  shouldComponentUpdate(nextProps) {
    return (this.state.value !== nextProps.value)
  }

  render() {
    return (
      <input
        {...this.state.attributes}
      />)
  }
}
