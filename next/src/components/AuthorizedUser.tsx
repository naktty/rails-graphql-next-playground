import { gql, useMutation } from '@apollo/client'
import { NextPage } from 'next'
import { useRouter } from 'next/router'
import { useEffect, useState } from 'react'
import { ROOT_QUERY } from '../pages'

const GITHUB_AUTH_MUTATION = gql`
  mutation githubAuth($input: GithubAuthInput!) {
    githubAuth(input: $input) {
      authPayload {
        token
      }
    }
  }
`

const AuthorizedUser: NextPage = () => {
  const [signingIn, setSigningIn] = useState(false)
  const router = useRouter()

  const authorizationComplete = () => {
    router.replace('/')
    setSigningIn(false)
  }

  const [githubAuth] = useMutation(GITHUB_AUTH_MUTATION, {
    update: authorizationComplete,
    refetchQueries: [{ query: ROOT_QUERY }],
  })

  useEffect(() => {
    if (window.location.search.match(/code=/)) {
      setSigningIn(true)
      const code = window.location.search.replace('?code=', '')
      githubAuth({ variables: { input: { code } } })
    }
  }, [githubAuth, router])

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
