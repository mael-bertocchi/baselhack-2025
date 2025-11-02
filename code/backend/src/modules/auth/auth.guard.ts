import { RequestError } from '@core/errors';
import { AuthenticatedUser } from '@modules/auth/auth.models';
import { UserRole } from '@modules/users/users.model';
import { FastifyReply, FastifyRequest } from 'fastify';

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

const ROLE_ORDER: UserRole[] = ['User', 'Manager', 'Administrator'];

function isValidUserRole(val: unknown): val is UserRole {
    return val === 'Administrator' || val === 'Manager' || val === 'User';
}

function roleSatisfies(userRole: UserRole, minRole: UserRole): boolean {
    return ROLE_ORDER.indexOf(userRole) >= ROLE_ORDER.indexOf(minRole);
}

async function verifyAndAttach(request: FastifyRequest): Promise<AuthenticatedUser> {
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
    return authUser;
}

export function jwtGuard(minRole: UserRole): (request: FastifyRequest, reply: FastifyReply) => Promise<void> {
    return async function (request: FastifyRequest, _reply: FastifyReply): Promise<void> {
        const authUser: AuthenticatedUser = await verifyAndAttach(request);
        const roleRaw: any = (authUser.payload as Record<string, unknown>)?.role;

        if (typeof roleRaw !== 'string' || !isValidUserRole(roleRaw)) {
            throw new RequestError('Forbidden: invalid user role', 403);
        }

        if (!roleSatisfies(roleRaw as UserRole, minRole)) {
            throw new RequestError('Forbidden: insufficient role', 403);
        }
    };
}

export default jwtGuard;
