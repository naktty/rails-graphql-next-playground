import {
  ApolloClient,
  InMemoryCache,
  HttpLink,
  NormalizedCacheObject,
} from '@apollo/client'
import { setContext } from '@apollo/client/link/context'

const GRAPHQL_ENDPOINT = 'http://localhost:3000/graphql'

const createApolloClient = () => {
  const httpLink = new HttpLink({
    uri: GRAPHQL_ENDPOINT,
  })

  // 認証ヘッダーを追加するためのコンテキストリンク
  const authLink = setContext((_, { headers }) => {
    // クライアントサイドでのみlocalStorageを使用
    const token =
      typeof window !== 'undefined' ? localStorage.getItem('token') : null

    return {
      headers: {
        ...headers,
        authorization: token || '',
      },
    }
  })

  return new ApolloClient({
    link: authLink.concat(httpLink),
    cache: new InMemoryCache(),
  })
}

let apolloClient: ApolloClient<NormalizedCacheObject> | null = null

export const getApolloClient = () => {
  if (!apolloClient) {
    apolloClient = createApolloClient()
  }
  return apolloClient
}
