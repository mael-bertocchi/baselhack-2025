import { generateAccessToken, generateRefreshToken, verifyRefreshToken } from '@plugins/jwt';
import { RefreshBody, SigninBody, SignupBody } from "./auth.types";
import { FastifyInstance } from 'fastify';

/**
 * @function signin
 * @description Authenticates a user and returns tokens
 */
async function signin(data: SigninBody, fastify: FastifyInstance) {
    const { email, password } = data;

    // TODO: Verify user credentials from database

    const payload = { email };
    const accessToken = generateAccessToken(payload, fastify);
    const refreshToken = generateRefreshToken(payload, fastify);

    return {
        accessToken,
        refreshToken,
        user: { email }
    };
}

/**
 * @function signup
 * @description Creates a new user account
 */
async function signup(data: SignupBody, fastify: FastifyInstance) {
    const { email, password, confirmPassword } = data;

    // TODO: Validate passwords match
    // TODO: Hash password
    // TODO: Create user in database

    const payload = { email };
    const accessToken = generateAccessToken(payload, fastify);
    const refreshToken = generateRefreshToken(payload, fastify);

    return {
        accessToken,
        refreshToken,
        user: { email }
    };
}

/**
 * @function refresh
 * @description Refreshes access token using refresh token
 */
async function refresh(data: RefreshBody, fastify: FastifyInstance) {
    const { refreshToken } = data;

    const decoded = await verifyRefreshToken(refreshToken, fastify);

    if (!decoded) {
        throw new Error('Invalid refresh token');
    }

    const payload = { email: decoded.email };
    const newAccessToken = generateAccessToken(payload, fastify);

    return {
        accessToken: newAccessToken,
        refreshToken
    };
}

export default {
    signin,
    signup,
    refresh
};
