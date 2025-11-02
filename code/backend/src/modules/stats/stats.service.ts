import { Collection, WithId } from 'mongodb';
import { FastifyInstance } from 'fastify';
import { Topic, User } from './stats.model';
import { Submission } from '../submissions/submissions.model';
import { TopicWithSubmissionCount } from './stats.types';


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
 * @description Return the good number of submission
 */
async function nbSubmission(fastify: FastifyInstance) {
    const submissionCollection = getSubmissionCollection(fastify);

    const count = await submissionCollection.countDocuments();

    return count;
}

/**
 * @function sortTopics
 * @description Return a sorted list of topics with their submission counts,
 * ordered from most submissions to least
 */
async function sortTopics(fastify: FastifyInstance): Promise<TopicWithSubmissionCount[]> {
    const submissionCollection = getSubmissionCollection(fastify);
    const topicsCollection = getTopicsCollection(fastify);

    const topics = await topicsCollection.find({ status: 'open' }).toArray();

    const topicsWithCounts = await Promise.all(
        topics.map(async (topic) => {
            const submissionCount = await submissionCollection.countDocuments({
                topicId: topic._id.toString()
            });

            return {
                topicId: topic._id.toString(),
                title: topic.title,
                submissionCount
            };
        })
    );

    // Sort by descending submission count
    topicsWithCounts.sort((a, b) => b.submissionCount - a.submissionCount);

    return topicsWithCounts;
}

export default {
    nbTopics,
    nbUsers,
    nbSubmission,
    sortTopics
};
