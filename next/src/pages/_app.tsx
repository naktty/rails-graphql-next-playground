import '@/styles/globals.css'
import { ApolloProvider } from '@apollo/client'
import type { AppProps } from 'next/app'
import { getApolloClient } from '../../lib/apolloClient'

export default function App({ Component, pageProps }: AppProps) {
  return (
    <ApolloProvider client={getApolloClient()}>
      <Component {...pageProps} />
    </ApolloProvider>
  )
}
