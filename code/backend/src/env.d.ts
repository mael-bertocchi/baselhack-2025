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
        DB_URI: string;
        JWT_ACCESS_EXPIRES_IN: string;
        JWT_REFRESH_EXPIRES_IN: string;
        JWT_SECRET: string;
        AGENT_AUTHENTICATION_PRIVATE_KEY_PATH: string;
        AGENT_URL: string;
        DEFAULT_ADMIN_EMAIL?: string;
        DEFAULT_ADMIN_PASSWORD?: string;
        DEFAULT_ADMIN_FIRST_NAME?: string;
        DEFAULT_ADMIN_LAST_NAME?: string;
    }
}
