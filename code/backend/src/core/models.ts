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
}
