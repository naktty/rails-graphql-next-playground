import {
  gql,
  useMutation,
  useSubscription,
  useApolloClient,
} from '@apollo/client'
import Image from 'next/image'
import React, { useEffect } from 'react'
import { ROOT_QUERY, RootQueryResult } from '../pages'

export interface User {
  id: string
  name: string
  githubLogin: string
  avatar: string
}

interface UserListProps {
  count: number
  users: User[]
  refetchUsers: () => void
}

interface UserListItemProps {
  name: string
  avatar: string
}

const ADD_FAKE_USERS_MUTATION = gql`
  mutation addFakeUsers($input: AddFakeUsersInput!) {
    addFakeUsers(input: $input) {
      users {
        githubLogin
        name
        avatar
      }
    }
  }
`

// 新しいユーザーを監視するサブスクリプション
const NEW_USER_SUBSCRIPTION = gql`
  subscription OnNewUser {
    newUser {
      id
      name
      githubLogin
      avatar
    }
  }
`

const UserList: React.FC<UserListProps> = ({ count, users, refetchUsers }) => {
  const client = useApolloClient()

  const [addFakeUsers] = useMutation(ADD_FAKE_USERS_MUTATION, {
    update(cache, { data }) {
      const existingData = cache.readQuery<RootQueryResult>({
        query: ROOT_QUERY,
      })
      cache.writeQuery({
        query: ROOT_QUERY,
        data: {
          totalUsers: existingData.totalUsers + data.addFakeUsers.users.length,
          allUsers: [...existingData.allUsers, ...data.addFakeUsers.users],
        },
      })
    },
  })

  // サブスクリプションを設定
  const { data: subscriptionData } = useSubscription(NEW_USER_SUBSCRIPTION)

  // サブスクリプションからデータが来たときにキャッシュを更新
  useEffect(() => {
    if (subscriptionData && subscriptionData.newUser) {
      const cache = client.cache
      const existingData = cache.readQuery<RootQueryResult>({
        query: ROOT_QUERY,
      })

      // 新しいユーザーが既に存在しないことを確認
      const userExists = existingData.allUsers.some(
        (user: User) =>
          user.githubLogin === subscriptionData.newUser.githubLogin,
      )

      if (!userExists) {
        // キャッシュを更新
        cache.writeQuery({
          query: ROOT_QUERY,
          data: {
            totalUsers: existingData.totalUsers + 1,
            allUsers: [...existingData.allUsers, subscriptionData.newUser],
          },
        })
      }
    }
  }, [subscriptionData, client])

  const handleAddFakeUsers = () => {
    addFakeUsers({ variables: { input: { count: 1 } } })
    refetchUsers()
  }

  return (
    <div>
      <p>{count} Users</p>
      <button onClick={() => refetchUsers()}>Refetch</button>
      <br />
      <button onClick={handleAddFakeUsers}>Add Fake Users</button>
      <ul>
        {users.map((user) => (
          <UserListItem
            key={user.githubLogin}
            name={user.name}
            avatar={user.avatar}
          />
        ))}
      </ul>
    </div>
  )
}

const UserListItem: React.FC<UserListItemProps> = ({ name, avatar }) => {
  return (
    <li>
      <Image src={avatar} width={48} height={48} alt={name} />
      {name}
    </li>
  )
}

export default UserList
