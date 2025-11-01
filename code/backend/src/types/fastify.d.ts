import 'fastify';
import type { AuthenticatedUser } from '@modules/auth/auth.types';

declare module 'fastify' {
    interface FastifyRequest {
        authUser?: AuthenticatedUser;
    }

    // `authenticate` is a decorator added by our auth plugin. Use a concrete
    // function signature instead of `typeof jwtGuard` to avoid value/type
    // resolution issues in declaration files.
    interface FastifyInstance {
        authenticate: (
            request: import('fastify').FastifyRequest,
            reply: import('fastify').FastifyReply
        ) => Promise<void> | void;
    }
}
