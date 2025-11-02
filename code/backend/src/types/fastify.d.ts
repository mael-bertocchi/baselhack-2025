import type { jwtGuard } from '@modules/auth/auth.guard';
import type { AuthenticatedUser } from '@modules/auth/auth.models';
import 'fastify';

declare module 'fastify' {
    interface FastifyRequest {
        authUser?: AuthenticatedUser;
    }

    interface FastifyInstance {
        authGuard: typeof jwtGuard;
    }
}
