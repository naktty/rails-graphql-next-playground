import { NextPage } from 'next'
import { useRouter } from 'next/router'
import { useEffect, useState } from 'react'

const AuthorizedUser: NextPage = () => {
  const [signingIn, setSigningIn] = useState(false)
  const router = useRouter()

  useEffect(() => {
    if (window.location.search.match(/code=/)) {
      setSigningIn(true)
      const code = window.location.search.replace('?code=', '')
      alert(code)
      router.replace('/')
    }
  }, [router])

  const requestCode = (): void => {
    const clientId = process.env.NEXT_PUBLIC_GITHUB_CLIENT_ID
    if (!clientId) {
      console.error('GitHub Client ID is not set.')
      return
    }
    window.location.href = `https://github.com/login/oauth/authorize?client_id=${clientId}&scope=user`
  }

  return (
    <button onClick={requestCode} disabled={signingIn}>
      Sign In with GitHub
    </button>
  )
}

export default AuthorizedUser
