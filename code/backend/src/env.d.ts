/**
 * @namespace NodeJS
 * @description This namespace extends the NodeJS ProcessEnv interface to include our custom environment variables.
 */
declare namespace NodeJS {
    /**
     * @interface ProcessEnv
     * @description This interface defines the environment variables used in the application.
     */
    interface ProcessEnv {
        PORT: string;
    }
}
