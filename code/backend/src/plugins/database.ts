import environment from "@core/environment";
import mongodb from "@fastify/mongodb";
import { FastifyInstance } from "fastify";
import fp from 'fastify-plugin';

/**
 * @function dbPlugin
 * @description Configures the Mongo database plugin
 */
async function dbPlugin(fastify: FastifyInstance): Promise<void> {
    await fastify.register(mongodb, {
        url: environment.DB_URI,
        forceClose: true
    });

    fastify.addHook('onReady', async () => {
        fastify.log.info('Connected to database');
    });

    fastify.addHook('onClose', async (instance) => {
        await instance.mongo.client.close();
    });
}

export default fp(dbPlugin, {
    name: 'db'
});
