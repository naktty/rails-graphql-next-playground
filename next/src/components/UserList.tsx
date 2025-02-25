import Image from 'next/image'
import React from 'react'

interface User {
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

const UserList: React.FC<UserListProps> = ({ count, users, refetchUsers }) => {
  return (
    <div>
      <p>{count} Users</p>
      <button onClick={() => refetchUsers()}>Refetch</button>
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
