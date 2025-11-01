import { RequestError } from '@core/errors';
import { Collection, WithId } from 'mongodb';
import { FastifyInstance } from 'fastify';
import { Topic, TopicStatus, Summary, Submission} from '@modules/topics/topics.model';
import { CreateBody, SubmissionBody } from './topics.types';

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

    return topics;
}

/**
 * @function getAllTopics
 * @description Get all topics
 */
async function getTopicById(id: string, fastify: FastifyInstance) {
    const topicsCollection = getTopicsCollection(fastify);

    const topic: WithId<Topic> | null = await topicsCollection.findOne({ _id: new (fastify.mongo).ObjectId(id) });

    if (!topic) {
        throw new RequestError('Topic not found', 404);
    }

    return topic;
}

/**
 * @function createTopic
 * @description Create a new topic
 */
async function createTopic(data: CreateBody, fastify: FastifyInstance) {
    const topicsCollection = getTopicsCollection(fastify);

    const now = new Date();
    const newTopic = {
        title: data.title,
        short_description: data.short_description,
        description: data.description,
        startDate: new Date(data.startDate),
        endDate: new Date(data.endDate),
        status: new Date(data.startDate) > now ? 'scheduled' : 'open' as TopicStatus,
        authorId: data.authorId,
        createdAt: now,
        updatedAt: now,
    }

    const result = await topicsCollection.insertOne(newTopic);

    const topic = await topicsCollection.findOne({ _id: result.insertedId });

    if (!topic) {
        throw new RequestError('Failed to create topic', 500);
    }

    return topic;
}

/**
 * @function getSummaryCollection
 * @param fastify 
 * @returns db collection
 * @description Return the summary collection of the table on db
 */
function getSummaryCollection(fastify: FastifyInstance): Collection<Topic> {
    const db = fastify.mongo.db;

    if (!db) {
        throw new Error('Database connection is not available');
    }

    return db.collection<Topic>('Summary');
}

/**
 * @function getSummaryById
 * @description Get all topics
 */
async function getSummaryById(id: string, fastify: FastifyInstance) {
    const db = fastify.mongo.db;
    const summaryCollection = getSummaryCollection(fastify);

    const Summary: WithId<Summary> | null = await summaryCollection.findOne({ _id: new (fastify.mongo).ObjectId(id) });

    if (!Summary) {
        throw new RequestError('Topic not found', 404);
    }

    return Summary;
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
 * @function sendSubmission
 * @description send Submission to an ID 
 */
async function sendSubmission(id: string, data: SubmissionBody, fastify: FastifyInstance) {
    const submissionCollection = getSubmissionCollection(fastify);

    const now = new Date();
    const newSubmission = {
        topicId: id,
        createdAt: now,
        updatedAt: now,
        text: data.text
    }

    const result = await submissionCollection.insertOne(newSubmission);

    const submission = await submissionCollection.findOne({ _id: result.insertedId });

    if (!submission) {
        throw new RequestError('Failed to send submission', 500);
    }

    return submission;
}

export default {
    getAllTopics,
    getTopicById,
    createTopic,
    getSummaryById,
    sendSubmission
};
