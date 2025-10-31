import environment from "@core/environment";
import { FastifyInstance } from "fastify";
import fp from 'fastify-plugin';
import fastifyJwt from '@fastify/jwt';

/**
 * @function jwtPlugin
 * @description Configures the JWT plugin
 */
async function jwtPlugin(fastify: FastifyInstance): Promise<void> {
    await fastify.register(fastifyJwt, {
        secret: environment.JWT_SECRET,
        sign: {
            expiresIn: environment.JWT_ACCESS_EXPIRES_IN || '15m'
        }
    });

    fastify.addHook('onReady', async () => {
        fastify.log.info('JWT plugin registered');
    });
}

/**
 * @function generateAccessToken
 * @description Generates an access token
 * @param payload - The payload to encode in the token
 * @param fastify - The Fastify instance
 * @returns The access token
 */
export function generateAccessToken(payload: object, fastify: FastifyInstance): string {
    return fastify.jwt.sign(payload, {
        expiresIn: environment.JWT_ACCESS_EXPIRES_IN || '15m'
    });
}

/**
 * @function generateRefreshToken
 * @description Generates a refresh token
 * @param payload - The payload to encode in the token
 * @param fastify - The Fastify instance
 * @returns The refresh token
 */
export function generateRefreshToken(payload: object, fastify: FastifyInstance): string {
    return fastify.jwt.sign(payload, {
        expiresIn: environment.JWT_REFRESH_EXPIRES_IN || '7d'
    });
}

/**
 * @function verifyAccessToken
 * @description Verifies an access token
 * @param token - The token to verify
 * @param fastify - The Fastify instance
 * @returns The decoded payload or null if invalid
 */
export async function verifyAccessToken(token: string, fastify: FastifyInstance): Promise<any | null> {
    try {
        const decoded = await fastify.jwt.verify(token);
        return decoded;
    } catch (error) {
        fastify.log.error({error}, 'Access token verification failed:');
        return null;
    }
}

/**
 * @function verifyRefreshToken
 * @description Verifies a refresh token
 * @param token - The token to verify
 * @param fastify - The Fastify instance
 * @returns The decoded payload or null if invalid
 */
export async function verifyRefreshToken(token: string, fastify: FastifyInstance): Promise<any | null> {
    try {
        const decoded = await fastify.jwt.verify(token);
        return decoded;
    } catch (error) {
        fastify.log.error({ error }, 'Refresh token verification failed:');
        return null;
    }
}

export default fp(jwtPlugin, {
    name: 'jwt'
});
