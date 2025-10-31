import { Maybe } from '@core/models';

/**
 * @type UserRole
 * @description Represents the possible roles a user can have in the system.
 */
export type UserRole = 'Administrator' | 'Manager' | 'User';

/**
 * @interface User
 * @description Represents a user in the system.
 */
export interface User {
    firstname: string; /*!> The user's first name */
    lastname: string; /*!> The user's last name */
    email: string; /*!> The user's email address */
    role: UserRole; /*!> The user's role in the system */
    password: string; /*!> The user's hashed password */
    created_at: Date; /*!> The creation timestamp for the user document */
    updated_at: Date; /*!> The last update timestamp for the user document */
};