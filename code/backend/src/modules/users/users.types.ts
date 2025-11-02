import { UserRole } from '@modules/users/users.model';

/**
 * @interface PasswordBody
 * @description Body schema for changing a user's password
 */
export interface PasswordBody {
    password: string; /*!< The new password for the user */
}

/**
 * @interface RoleBody
 * @description Body schema for changing a user's role
 */
export interface RoleBody {
    role: UserRole; /*!< The new role for the user */
}

/**
 * @interface UserParams
 * @description Parameters schema for user-related routes
 */
export interface UserParams {
    id: string; /*!< The unique identifier of the user */
}
