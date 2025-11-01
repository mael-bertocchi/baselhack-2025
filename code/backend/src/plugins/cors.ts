import { fastifyCors } from '@fastify/cors';
import { FastifyInstance } from 'fastify';
import fp from 'fastify-plugin';
import environment from '@core/environment';

/**
 * @function corsPlugin
 * @description Configures the CORS plugin to allow requests from specific origins
 */
async function corsPlugin(fastify: FastifyInstance): Promise<void> {
    const allowedOrigins = environment.CORS_ALLOWED_ORIGINS;

    await fastify.register(fastifyCors, {
        origin: (origin, cb) => {
            if (!origin) {
                // Allow same-origin or server-to-server requests
                return cb(null, true);
            }

            if (allowedOrigins.includes('*') || allowedOrigins.includes(origin)) {
                return cb(null, true);
            }

            cb(new Error(`Origin ${origin} is not allowed by CORS policy`), false);
        },
        methods: ['GET', 'POST', 'PATCH', 'DELETE'],
        allowedHeaders: ['Content-Type', 'Authorization'],
        credentials: true
    });
}

export default fp(corsPlugin, {
    name: 'cors'
});
