import { gql, useMutation } from '@apollo/client'
import Image from 'next/image'
import React from 'react'
import { ROOT_QUERY } from '../pages'

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

const UserList: React.FC<UserListProps> = ({ count, users, refetchUsers }) => {
  const [addFakeUsers] = useMutation(ADD_FAKE_USERS_MUTATION, {
    refetchQueries: [{ query: ROOT_QUERY }],
  })

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
