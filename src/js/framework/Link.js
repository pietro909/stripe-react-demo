import React from 'react'



const Link = ({
  text,
  to,
  children,
  onUrl,
}) => {
  const clickHandler = href => e  => {
    e.preventDefault()
    onUrl(e.target.href)
  }
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
