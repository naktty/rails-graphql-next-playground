import {
  ApolloClient,
  InMemoryCache,
  HttpLink,
  NormalizedCacheObject,
} from '@apollo/client'

const GRAPHQL_ENDPOINT = 'http://localhost:3000/graphql'

const createApolloClient = () => {
  return new ApolloClient({
    link: new HttpLink({
      uri: GRAPHQL_ENDPOINT,
    }),
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
