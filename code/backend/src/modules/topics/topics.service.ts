import { RequestError } from '@core/errors';
import { Collection, WithId } from 'mongodb';
import { FastifyInstance } from 'fastify';
import { Topic } from '@modules/topics/topics.model';

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
 * @function getAllTopics
 * @description Get all topics
 */
async function getAllTopics(fastify: FastifyInstance) {
    const topicsCollection = getTopicsCollection(fastify);

    const topics: WithId<Topic>[] = await topicsCollection.find({}).toArray();

    return {
        topics
    };
}

export default {
    getAllTopics
};
