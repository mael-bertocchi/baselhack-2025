import 'fastify';
import type { AuthenticatedUser } from '@modules/auth/auth.types';
import type { jwtGuard } from '@modules/auth/auth.guard';

declare module 'fastify' {
    interface FastifyRequest {
        authUser?: AuthenticatedUser;
    }

    interface FastifyInstance {
        authGuard: typeof jwtGuard;
    }
}
