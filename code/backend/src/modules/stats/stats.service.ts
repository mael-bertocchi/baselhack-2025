import { FastifyReply, FastifyRequest } from 'fastify';
import { RequestError } from '@core/errors';
import { Collection, WithId } from 'mongodb';
import { FastifyInstance } from 'fastify';
import { Topic } from '@modules/stats/stats.model';
import { AuthenticatedUser } from '@modules/auth/auth.types';
import bcrypt from 'bcrypt';


/**
 * @function getTopicsCollection
 * @description Retrieves the topics collection from the MongoDB instance
 */
function getTopicsCollection(fastify: FastifyInstance): Collection<Topic> {
    const db = fastify.mongo.db;

    if (!db) {
        throw new Error('Database connection is not available');
    }

    return db.collection<Topic>('topics');
}

/**
 * @function nbTopics
 * @description Return the good number of topics
 */
async function nbTopics(fastify: FastifyInstance) {
    const topicsCollection = getTopicsCollection(fastify);

    const count = await topicsCollection.countDocuments();

    return count;
}

export default {
    nbTopics
};
