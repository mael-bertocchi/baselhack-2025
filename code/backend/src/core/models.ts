/**
 * @type Maybe
 * @description Type representing a nullable value
 */
export type Maybe<T> = T | null | undefined;

/**
 * @interface Environment
 * @description This interface defines the structure of the environment variables used in the application
 */
export interface Environment {
    PORT: number; /*!< Port for the server */
    DB_URI: string; /*!< MongoDB connection URI */
    JWT_ACCESS_EXPIRES_IN: string; /*!< JWT access token expiration time */
    JWT_REFRESH_EXPIRES_IN: string; /*!< JWT refresh token expiration time */
    JWT_SECRET: string; /*!< JWT secret key (optional) */
    CORS_ALLOWED_ORIGINS: string[]; /*!< List of allowed origins for CORS */
    COOKIE_SAME_SITE: 'Strict' | 'Lax' | 'None'; /*!< SameSite policy for auth cookies */
    COOKIE_SECURE: boolean; /*!< Whether auth cookies require a secure context */
    COOKIE_DOMAIN?: string; /*!< Optional cookie domain override */
}
