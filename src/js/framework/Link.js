import React from 'react'

const clickHandler = href => e  => {
  e.preventDefault()
  console.log(`clicked ${href}`)
  console.log(e.target.href)
}

const Link = ({
  text,
  to,
  children,
}) => {
  if (text) {
    return <a href={to} onClick={clickHandler(to)}>{text}</a>
  }
  if (children) {
    return (
      <a href={to} onClick={clickHandler(to)}>
        {children}
      </a>
    )
  }
}

export default Link
