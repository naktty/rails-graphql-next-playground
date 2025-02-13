import type { NextPage } from 'next'
import SimpleButton from '@/components/SimpleButton'

const HelloWorld: NextPage = () => {
  return (
    <>
      <h1>Title</h1>
      <p>content</p>
      <SimpleButton text={'From HelloWorld'} />
    </>
  )
}

export default HelloWorld
