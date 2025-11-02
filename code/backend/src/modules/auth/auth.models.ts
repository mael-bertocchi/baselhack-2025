/**
 * @module AuthModels
 * @description Defines TypeScript interfaces for authentication request bodies and authenticated user representation.
 */
export interface SigninBody {
    email: string; /*!< User's email address */
    password: string; /*!< User's password */
}

/**
 * @interface SignupBody
 * @description Represents the data required for user signup.
 */
export interface SignupBody {
    firstName: string; /*!< User's first name */
    lastName: string; /*!< User's last name */
    email: string; /*!< User's email address */
    password: string; /*!< User's password */
    confirmPassword: string; /*!< Confirmation of the user's password */
}

/**
 * @interface RefreshBody
 * @description Represents the data required to refresh authentication tokens.
 */
export interface RefreshBody {
    refreshToken: string; /*!< The refresh token used to obtain new authentication tokens */
}

/**
 * @interface AuthenticatedUser
 * @description Represents an authenticated user in the system.
 */
export interface AuthenticatedUser {
    id: string; /*!< Unique identifier of the user */
    email: string; /*!< User's email address */
    payload: Record<string, unknown>; /*!< Additional payload data from the authentication token */
}
