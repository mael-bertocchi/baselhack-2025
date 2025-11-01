import { fastifyCors } from '@fastify/cors';
import { FastifyInstance } from 'fastify';
import fp from 'fastify-plugin';

/**
 * @function corsPlugin
 * @description Configures the CORS plugin to allow requests from specific origins
 */
async function corsPlugin(fastify: FastifyInstance): Promise<void> {
    await fastify.register(fastifyCors, {
        origin: ['*'],
        methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'],
        allowedHeaders: ['Content-Type', 'Authorization'],
        credentials: true
    });
}

export default fp(corsPlugin, {
    name: 'cors'
});
