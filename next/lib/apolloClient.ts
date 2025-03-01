import {
  ApolloClient,
  InMemoryCache,
  HttpLink,
  NormalizedCacheObject,
} from '@apollo/client'
import { setContext } from '@apollo/client/link/context'
import { persistCache } from 'apollo3-cache-persist'

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

  const cache = new InMemoryCache()

  // クライアントサイドでのみpersistCacheとキャッシュの復元を実行
  if (typeof window !== 'undefined') {
    // persistCacheを非同期で実行
    persistCache({
      cache,
      storage: window.localStorage,
    })
      .then(() => {
        // キャッシュデータが存在する場合は復元
        if (localStorage['apollo-cache-persist']) {
          const cacheData = JSON.parse(localStorage['apollo-cache-persist'])
          cache.restore(cacheData)
        }
      })
      .catch((error) => {
        console.error('Error persisting cache:', error)
      })
  }

  return new ApolloClient({
    link: authLink.concat(httpLink),
    cache,
  })
}

let apolloClient: ApolloClient<NormalizedCacheObject> | null = null

export const getApolloClient = () => {
  if (!apolloClient) {
    apolloClient = createApolloClient()
  }
  return apolloClient
}
