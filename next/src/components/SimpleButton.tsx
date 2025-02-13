import React from 'react'

const SimpleButton: React.FC = () => {
  const handleClick = () => {
    console.log('Button clicked')
  }

  return <button onClick={handleClick}>Click me</button>
}

export default SimpleButton
