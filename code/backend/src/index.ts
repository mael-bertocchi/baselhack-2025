import environment from "@core/environment";
import { RequestError } from "@core/errors";
import topicsRoutes from "@modules/topics/topics.routes";
import healthRoutes from "@modules/health/health.routes";
import corsPlugin from "@plugins/cors";
import authRoutes from "@modules/auth/auth.route";
import dbPlugin from "@plugins/database";
import rateLimiterPlugin from "@plugins/rate-limiter";
import jwtPlugin from "@plugins/jwt";
import authGuardPlugin from "@plugins/auth-guard";
import fastify, { FastifyInstance, FastifyReply, FastifyRequest } from "fastify";

/**
 * @constant API_VERSION
 * @description The version of the application
 */
const API_VERSION: string = '/api/v1';

/**
 * @function startApp
 * @dsecription Starts the Fastify application with all necessary plugins and routes.
 *
 * @returns {Promise<void>} A promise that resolves when the application has started.
 */
async function startApp(): Promise<void> {
    const app: FastifyInstance = fastify({
        logger: true,
        bodyLimit: 10 * 1024 * 1024,
        connectionTimeout: 10 * 1000
    });

    await app.register(rateLimiterPlugin);
    await app.register(corsPlugin);
    await app.register(dbPlugin);
    await app.register(jwtPlugin);
    await app.register(authGuardPlugin);

    app.setErrorHandler((err: unknown, request: FastifyRequest, reply: FastifyReply) => {
        if (err instanceof RequestError) {
            if (err.data) {
                reply.status(err.code).send({ message: err.message, data: err.data });
            } else {
                reply.status(err.code).send({ message: err.message });
            }
        } else {
            const details = err instanceof Error ? { message: err.message, stack: err.stack, name: err.name } : err;

            app.log.error({ error: details, path: request.url, method: request.method }, 'An error occurred while processing the request');

            const message = err instanceof Error ? err.message : 'An unexpected error occurred';
            reply.status(500).send({ error: message });
        }
    });

    await app.register(healthRoutes, { prefix: `${API_VERSION}/health` });
	await app.register(authRoutes, { prefix: `${API_VERSION}/auth` });
    await app.register(topicsRoutes, { prefix: `${API_VERSION}/topics` });

    app.setNotFoundHandler((request: FastifyRequest, reply: FastifyReply) => {
        reply.status(404).send({
            message: "The resource you are looking for doesn't exist",
            data: {
                method: request.method,
                path: request.url
            }
        });
    });

    await app.listen({
        port: environment.PORT,
        host: '0.0.0.0'
    });

    for (const signal of ['SIGINT', 'SIGTERM']) {
        process.on(signal, async () => {
            await app.close();

            app.log.info('Goodbye');
            process.exit(0);
        });
    }
}

startApp();
