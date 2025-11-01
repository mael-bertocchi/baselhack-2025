import environment from '@core/environment';
import { RequestError } from '@core/errors';
import { Maybe } from '@core/models';
import { Submission } from '@modules/submissions/submissions.model';
import { AgentAnalysisRequest, AgentAnalysisResponse, TopicResult } from '@modules/topic-result/topic-result.models';
import { Topic } from '@modules/topics/topics.model';
import { FastifyInstance } from 'fastify';
import fs from 'fs';
import jwt from 'jsonwebtoken';
import { Collection, InsertOneResult, UpdateResult, WithId } from 'mongodb';

/**
 * @function generateAgentToken
 * @description Generates a JWT token for authenticating with the Agent using RS256 algorithm
 * @returns token string
 * @throws Error if private key cannot be read
 */
function generateAgentToken(): string {
    try {
        const key: string = fs.readFileSync(environment.AGENT_AUTHENTICATION_PRIVATE_KEY_PATH, 'utf8');
        const now: number = Math.floor(Date.now() / 1000);
        const payload: object = {
            iss: 'fastify-api',
            aud: 'python-agent',
            iat: now,
            exp: now + 300,
            sub: 'fastify-service',
            scope: 'agent:use'
        };

        const token = jwt.sign(payload, key, { algorithm: 'RS256' });

        return token;
    } catch (error) {
        throw new Error(`Failed to generate agent token: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
}

/**
 * @function callAIAgent
 * @description Calls the Agent to analyze submissions
 * @param prompt - The prompt to send to the agent
 * @returns The AI-generated analysis
 * @throws Error if the agent call fails
 */
export async function callAgent(prompt: string): Promise<string> {
    try {
        const token: string = generateAgentToken();
        const response: Response = await fetch(`${environment.AGENT_URL}/analyze`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`
            },
            body: JSON.stringify({ prompt } as AgentAnalysisRequest)
        });

        if (!response.ok) {
            const errorText: string = await response.text();
            throw new Error(`Agent returned status ${response.status}: ${errorText}`);
        }

        const data: AgentAnalysisResponse = await response.json();

        return data.response;
    } catch (error: unknown) {
        throw error;
    }
}

/**
 * @function aggregateSubmissions
 * @description Aggregates submissions into a prompt for the Agent
 * @param submissions - Array of submissions to aggregate
 * @param topicTitle - Title of the topic
 * @param topicDescription - Description of the topic
 * @returns Formatted prompt for the Agent
 */
export function aggregateSubmissions(submissions: Submission[], topicTitle: string, topicDescription: string): string {
    const submissionsText: string = submissions.map((sub, index) => `${index + 1}. ${sub.text} (${sub.likes || 0} likes)`).join('\n\n');

    return `Topic: ${topicTitle}\n\nDescription: ${topicDescription}\n\nUser Submissions:\n${submissionsText}\n\nPlease analyze these submissions and provide a comprehensive summary of the crowd's opinions.`;
}

/**
 * @function getTopicResultsCollection
 * @description Retrieves the topic results collection from the MongoDB instance
 */
function getTopicResultsCollection(fastify: FastifyInstance): Collection<TopicResult> {
    const db = fastify.mongo.db;

    if (!db) {
        throw new Error('Database connection is not available');
    }

    return db.collection<TopicResult>('topic-results');
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
 * @function getSubmissionsCollection
 * @description Retrieves the submissions collection from the MongoDB instance
 */
function getSubmissionsCollection(fastify: FastifyInstance): Collection<Submission> {
    const db = fastify.mongo.db;

    if (!db) {
        throw new Error('Database connection is not available');
    }

    return db.collection<Submission>('submission');
}

/**
 * @function getAllTopicResults
 * @description Get all topic results
 */
async function getAllTopicResults(fastify: FastifyInstance) {
    const topicResultsCollection = getTopicResultsCollection(fastify);
    const topicResults: WithId<TopicResult>[] = await topicResultsCollection.find({}).toArray();

    return topicResults;
}

/**
 * @function getTopicResultById
 * @description Get a topic result by topicId (string)
 */
async function getTopicResultById(id: string, fastify: FastifyInstance) {
    const topicResultsCollection = getTopicResultsCollection(fastify);
    const topicResult: Maybe<WithId<TopicResult>> = await topicResultsCollection.findOne({ topicId: id });

    if (!topicResult) {
        throw new RequestError('Topic result not found', 404);
    }
    return topicResult;
}

/**
 * @function analyzeTopic
 * @description Analyze a topic by aggregating submissions and calling the AI agent.
 * If a result already exists for the topic, it will be updated instead of creating a new one.
 */
async function analyzeTopic(topicId: string, fastify: FastifyInstance) {
    const topicsCollection = getTopicsCollection(fastify);
    const submissionsCollection = getSubmissionsCollection(fastify);
    const topicResultsCollection = getTopicResultsCollection(fastify);

    const topic: Maybe<WithId<Topic>> = await topicsCollection.findOne({ _id: new (fastify.mongo).ObjectId(topicId) });

    if (!topic) {
        throw new RequestError('Topic not found', 404);
    }

    const submissions: WithId<Submission>[] = await submissionsCollection.find({ topicId }).toArray();

    if (submissions.length === 0) {
        throw new RequestError('No submissions found for this topic', 404);
    }

    const prompt: string = aggregateSubmissions(submissions, topic.title, topic.description);
    const analysisContent: string = await callAgent(prompt);
    const now: Date = new Date();

    const existingTopicResult: Maybe<WithId<TopicResult>> = await topicResultsCollection.findOne({ topicId });
    if (existingTopicResult) {
        const updateResult: UpdateResult<TopicResult> = await topicResultsCollection.updateOne({ topicId }, {
            $set: {
                content: analysisContent,
                updatedAt: now
            }}
        );

        if (!updateResult.acknowledged) {
            throw new RequestError('Failed to update topic result', 500);
        }

        const updatedTopicResult: Maybe<WithId<TopicResult>> = await topicResultsCollection.findOne({ topicId });
        return updatedTopicResult;
    } else {
        const topicResult: TopicResult = {
            topicId,
            content: analysisContent,
            createdAt: now,
            updatedAt: now,
        };

        const insertResult: InsertOneResult<TopicResult> = await topicResultsCollection.insertOne(topicResult);
        if (!insertResult.acknowledged) {
            throw new RequestError('Failed to save topic result', 500);
        }

        const savedTopicResult: Maybe<WithId<TopicResult>> = await topicResultsCollection.findOne({ _id: insertResult.insertedId });
        return savedTopicResult;
    }
}

export default {
    getAllTopicResults,
    getTopicResultById,
    analyzeTopic
};
