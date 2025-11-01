import { Environment, Maybe } from '@core/models';
import dotenv from 'dotenv';

dotenv.config();

/**
 * @function validateVariable
 * @description Validates that a string environment variable is defined and not empty
 */
function validateVariable(name: string, value: Maybe<string>): string {
    if (value !== undefined && value !== null && value !== '') {
        return value;
    }
    console.error(`\r\x1b[31mError:\x1b[0m Environment variable ${name} is not defined`);
    process.exit(1);
}

/**
 * @function validateNumber
 * @description Validates that a string environment variable is a valid number
 */
function validateNumber(name: string, value: Maybe<string>): number {
    const stringValue: string = validateVariable(name, value);
    const numValue: number = parseInt(stringValue, 10);

    if (isNaN(numValue)) {
        console.error(`\r\x1b[31mError:\x1b[0m Environment variable ${name} must be a valid number`);
        process.exit(1);
    }
    return numValue;
}

/**
 * @function validateBoolean
 * @description Validates that a string environment variable is a valid boolean
 */
function validateBoolean(name: string, value: Maybe<string>): boolean {
    const stringValue: string = validateVariable(name, value);
    const lowerValue: string = stringValue.toLowerCase();

    if (lowerValue === 'true') {
        return true;
    } else if (lowerValue === 'false') {
        return false;
    }
    console.error(`\r\x1b[31mError:\x1b[0m Environment variable ${name} must be a valid boolean (true/false, 1/0)`);
    process.exit(1);
}

/**
 * @constant environment
 * @description Contains the validated environment variables for the application
 */
function parseOptionalBoolean(name: string, value: Maybe<string>): boolean | undefined {
    if (value === undefined || value === null || value === '') {
        return undefined;
    }

    return validateBoolean(name, value);
}

function parseSameSite(value: Maybe<string>): 'Strict' | 'Lax' | 'None' {
    const normalized = value?.trim().toLowerCase();

    switch (normalized) {
        case 'strict':
            return 'Strict';
        case 'none':
            return 'None';
        case 'lax':
        default:
            return 'Lax';
    }
}

const normalizeOrigin = (origin: string): string => origin.replace(/\/$/, '');

const environment: Environment = {
    PORT: validateNumber('PORT', process.env.PORT),
    DB_URI: validateVariable('DB_URI', process.env.DB_URI),
    JWT_ACCESS_EXPIRES_IN: validateVariable('JWT_ACCESS_EXPIRES_IN', process.env.JWT_ACCESS_EXPIRES_IN),
    JWT_REFRESH_EXPIRES_IN: validateVariable('JWT_REFRESH_EXPIRES_IN', process.env.JWT_REFRESH_EXPIRES_IN),
    JWT_SECRET: validateVariable('JWT_SECRET', process.env.JWT_SECRET),
    CORS_ALLOWED_ORIGINS: (process.env.CORS_ALLOWED_ORIGINS ?? 'http://localhost:5173')
        .split(',')
        .map((origin) => normalizeOrigin(origin.trim()))
        .filter((origin) => origin.length > 0),
    COOKIE_SAME_SITE: parseSameSite(process.env.COOKIE_SAME_SITE ?? ((process.env.NODE_ENV ?? 'development') === 'production' ? 'None' : 'Lax')),
    COOKIE_SECURE:
        parseOptionalBoolean('COOKIE_SECURE', process.env.COOKIE_SECURE) ??
        ((process.env.NODE_ENV ?? 'development') === 'production'),
    COOKIE_DOMAIN: process.env.COOKIE_DOMAIN?.trim() || undefined
};

export default environment;
