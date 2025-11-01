import { RequestError } from '@core/errors';
import { FastifyReply, FastifyRequest } from 'fastify';
import { AuthenticatedUser } from './auth.types';

function extractTokenFromAuthorizationHeader(request: FastifyRequest): string | null {
    const authorization = request.headers['authorization'] ?? request.headers['Authorization'];

    if (typeof authorization !== 'string') {
        return null;
    }

    const [scheme, token] = authorization.split(' ');

    if (!token || scheme?.toLowerCase() !== 'bearer') {
        return null;
    }

    return token;
}

function getAccessToken(request: FastifyRequest): string | null {
    return extractTokenFromAuthorizationHeader(request);
}

export async function jwtGuard(request: FastifyRequest, _reply: FastifyReply): Promise<void> {
    const token = getAccessToken(request);

    if (!token) {
        throw new RequestError('Unauthorized: missing access token', 401);
    }

    let decoded: unknown;

    try {
        decoded = await request.server.jwt.verify(token);
    } catch (error) {
        request.log.debug({ error }, 'Access token verification failed');
        decoded = null;
    }

    if (!decoded || typeof decoded !== 'object') {
        throw new RequestError('Unauthorized: invalid access token', 401);
    }

    const { sub, email, ...rest } = decoded as Record<string, unknown>;

    if (typeof sub !== 'string' || typeof email !== 'string') {
        throw new RequestError('Unauthorized: malformed access token payload', 401);
    }

    const authUser: AuthenticatedUser = {
        id: sub,
        email,
        payload: {
            sub,
            email,
            ...rest
        }
    };

    request.authUser = authUser;
}

export default jwtGuard;
