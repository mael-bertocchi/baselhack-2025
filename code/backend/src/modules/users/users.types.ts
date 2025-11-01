import { UserRole } from './users.model'

export interface PasswordBody {
    password: string
}

export interface RoleBody {
    role: UserRole
}

export interface UserParams {
    id: string;
}
