import type { NextPage } from 'next'
import SimpleButton from '@/components/SimpleButton'

const HelloWorld: NextPage = () => {
  const handleOnClick = () => {
    console.log('Clicked from hello_world')
  }

  return (
    <>
      <h1 className="underline">Title</h1>
      <p className="text-red-800">content</p>
      <SimpleButton text={'From HelloWorld'} onClick={handleOnClick} />
    </>
  )
}

export default HelloWorld
