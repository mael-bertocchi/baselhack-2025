import fastifyRateLimit, { errorResponseBuilderContext } from '@fastify/rate-limit';
import { FastifyInstance, FastifyRequest } from 'fastify';
import fp from 'fastify-plugin';

/**
 * @function rateLimiterPlugin
 * @description Configures rate limiting plugin
 */
async function rateLimiterPlugin(fastify: FastifyInstance): Promise<void> {
    await fastify.register(fastifyRateLimit, {
        max: 100,
        timeWindow: '1 minute',

        allowList: (request: FastifyRequest) => {
            return request.url.startsWith('/api/files/');
        },

        errorResponseBuilder: (request: FastifyRequest, context: errorResponseBuilderContext) => ({
            message: `Rate limit exceeded. Try again in ${context.after}`,
            statusCode: 429
        })
    });
}

export default fp(rateLimiterPlugin, {
    name: 'rate-limiter'
});
