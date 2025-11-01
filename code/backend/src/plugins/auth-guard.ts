import { jwtGuard } from '@modules/auth/auth.guard';
import { FastifyInstance } from 'fastify';
import fp from 'fastify-plugin';

async function authGuardPlugin(fastify: FastifyInstance): Promise<void> {
    fastify.decorate('authenticate', jwtGuard);
}

export default fp(authGuardPlugin, {
    name: 'auth-guard'
});
