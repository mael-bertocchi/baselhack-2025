import { jwtGuard } from '@modules/auth/auth.guard';
import { FastifyInstance } from 'fastify';
import fp from 'fastify-plugin';

declare module 'fastify' {
    interface FastifyInstance {
        authGuard: typeof jwtGuard;
    }
}

async function authGuardPlugin(fastify: FastifyInstance): Promise<void> {
    fastify.decorate('authGuard', jwtGuard);
}

export default fp(authGuardPlugin, {
    name: 'auth-guard'
});
