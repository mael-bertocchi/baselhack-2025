import 'fastify';
import type { AuthenticatedUser } from '@modules/auth/auth.types';

declare module 'fastify' {
    interface FastifyRequest {
        authUser?: AuthenticatedUser;
    }

    interface FastifyInstance {
        authGuard: typeof jwtGuard;
    }
}
