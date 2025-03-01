import {
  ApolloClient,
  InMemoryCache,
  HttpLink,
  NormalizedCacheObject,
  ApolloLink,
  DocumentNode,
} from '@apollo/client'
import { setContext } from '@apollo/client/link/context'
import { createConsumer } from '@rails/actioncable'
import { persistCache } from 'apollo3-cache-persist'
import { DefinitionNode, OperationDefinitionNode } from 'graphql'
import ActionCableLink from 'graphql-ruby-client/subscriptions/ActionCableLink'

const GRAPHQL_ENDPOINT = 'http://localhost:3000/graphql'
const ACTIONCABLE_ENDPOINT = 'ws://localhost:3000/cable'

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

  // サブスクリプション操作を判別する関数
  const hasSubscriptionOperation = ({ query }: { query: DocumentNode }) => {
    return query.definitions.some(
      (definition: DefinitionNode) =>
        definition.kind === 'OperationDefinition' &&
        (definition as OperationDefinitionNode).operation === 'subscription',
    )
  }

  // ActionCableリンクの作成（クライアントサイドでのみ）
  let actionCableLink
  if (typeof window !== 'undefined') {
    const cable = createConsumer(ACTIONCABLE_ENDPOINT)
    actionCableLink = new ActionCableLink({ cable })
  }

  // リンクの分割（サブスクリプションとHTTPリクエスト）
  const splitLink =
    typeof window !== 'undefined'
      ? ApolloLink.split(
          hasSubscriptionOperation,
          actionCableLink,
          authLink.concat(httpLink),
        )
      : authLink.concat(httpLink)

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
    link: splitLink,
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
