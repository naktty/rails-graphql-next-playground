import { gql, useMutation, useQuery } from '@apollo/client'
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

interface GithubAuthData {
  githubAuth: {
    authPayload: {
      token: string
    }
  }
}

interface MeData {
  me: {
    name: string
    avatar: string
  } | null
}

const CurrentUser = ({
  name,
  avatar,
  logout,
}: {
  name: string
  avatar: string
  logout: () => void
}) => (
  <div>
    <img src={avatar} width={48} height={48} alt="" />
    <h1>{name}</h1>
    <button onClick={logout}>logout</button>
  </div>
)

const AuthorizedUser: NextPage = () => {
  const [signingIn, setSigningIn] = useState(false)
  const [initialLoading, setInitialLoading] = useState(true)
  const router = useRouter()
  const { loading, data, refetch, client } = useQuery<MeData>(ROOT_QUERY)

  // ローカルストレージのトークンをチェックして初期状態を設定
  useEffect(() => {
    const token = localStorage.getItem('token')
    if (token) {
      setSigningIn(true)
    }
    // 初期チェックが完了したらinitialLoadingをfalseに
    setInitialLoading(false)
  }, [])

  const [githubAuth] = useMutation(GITHUB_AUTH_MUTATION, {
    onCompleted: (data: GithubAuthData) => {
      localStorage.setItem('token', data.githubAuth.authPayload.token)
      // キャッシュをリセットして新しいクエリを強制的に実行
      client.resetStore().then(() => {
        refetch()
        router.replace('/')
      })
    },
    refetchQueries: [{ query: ROOT_QUERY }],
  })

  useEffect(() => {
    if (window.location.search.match(/code=/)) {
      setSigningIn(true)
      const code = window.location.search.replace('?code=', '')
      githubAuth({ variables: { input: { code } } })
    }
  }, [githubAuth])

  const requestCode = (): void => {
    // サインインボタンを押した時点でsigningInをtrueに設定
    setSigningIn(true)
    const clientId = process.env.NEXT_PUBLIC_GITHUB_CLIENT_ID
    if (!clientId) {
      console.error('GitHub Client ID is not set.')
      setSigningIn(false) // エラー時はfalseに戻す
      return
    }
    window.location.href = `https://github.com/login/oauth/authorize?client_id=${clientId}&scope=user`
  }

  const logout = () => {
    localStorage.removeItem('token')
    setSigningIn(false)

    // キャッシュ全体をリセットする代わりに、meフィールドのみnullに更新
    client.writeQuery({
      query: ROOT_QUERY,
      data: {
        me: null,
      },
    })

    router.replace('/')
  }

  // 初期ロード中またはGraphQLロード中はローディング表示
  if (initialLoading || loading) {
    return <p>loading... </p>
  }

  // meデータがある場合はCurrentUserを表示
  if (data?.me) {
    return <CurrentUser {...data.me} logout={logout} />
  }

  // サインイン中の場合もローディング表示
  if (signingIn) {
    return <p>Signing in... </p>
  }

  // それ以外の場合はサインインボタンを表示
  return <button onClick={requestCode}>Sign In with GitHub</button>
}

export default AuthorizedUser
