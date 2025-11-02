import { Collection, WithId } from 'mongodb';
import { FastifyInstance } from 'fastify';
import { Topic, User } from '@modules/stats/stats.model';
import { Submission } from '@modules/submissions/submissions.model';


/**
 * @function getUsersCollection
 * @description Retrieves the users collection from the MongoDB instance
 */
function getUsersCollection(fastify: FastifyInstance): Collection<User> {
    const db = fastify.mongo.db;

    if (!db) {
        throw new Error('Database connection is not available');
    }

    return db.collection<User>('users');
}

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

    const count = await topicsCollection.countDocuments({ status: "open" });

    return count;
}

/**
 * @function nbUsers
 * @description Return the good number of user
 */
async function nbUsers(fastify: FastifyInstance) {
    const usersCollection = getUsersCollection(fastify);

    const count = await usersCollection.countDocuments();

    return count;
}

/**
 * @function getSubmissionCollection
 * @param fastify
 * @returns db collection
 * @description Return the submission collection of the table on db
 */
function getSubmissionCollection(fastify: FastifyInstance): Collection<Submission> {
    const db = fastify.mongo.db;

    if (!db) {
        throw new Error('Database connection is not available');
    }

    return db.collection<Submission>('submission');
}

/**
 * @function nbSubmission
 * @description Return the good number of user
 */
async function nbSubmission(fastify: FastifyInstance) {
    const submissionCollection = getSubmissionCollection(fastify);

    const count = await submissionCollection.countDocuments();

    return count;
}

export default {
    nbTopics,
    nbUsers,
    nbSubmission
};
