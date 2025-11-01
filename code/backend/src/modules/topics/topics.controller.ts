import { FastifyReply, FastifyRequest } from 'fastify';
import { TopicParams, CreateBody, SubmissionBody } from './topics.types';
import topicsService from './topics.service';

/**
 * @function getAllTopics
 * @description Return the list of all the topics.
 */
async function getAllTopics(request: FastifyRequest, reply: FastifyReply): Promise<void> {
    const result = await topicsService.getAllTopics(request.server);

    reply.status(200).send({
        message: 'Successfully retrieved topics',
        data: result
    });
}

/**
 * @function getTopicById
 * @description Return the Topic by the id given on the url
 */
async function getTopicById(request: FastifyRequest<{ Params: TopicParams }>, reply: FastifyReply): Promise<void> {
    const result = await topicsService.getTopicById(request.params.id, request.server);

    reply.status(200).send({
        message: 'Successfully retrieved topic',
        data: result
    });
}

/**
 * @function createTopic
 * @description Create a new topic
 */
async function createTopic(request: FastifyRequest<{ Body: CreateBody }>, reply: FastifyReply): Promise<void> {
    const result = await topicsService.createTopic(request.body, request.server);

    reply.status(200).send({
        message: 'Successfully created a topic',
        data: result
    });
}

/**
 * @function modifyTopic
 * @description Modify an existing topic
 */
async function modifyTopic(request: FastifyRequest<{ Params: TopicParams, Body: CreateBody }>, reply: FastifyReply): Promise<void> {
    const result = await topicsService.modifyTopic(request.params.id, request.body, request.server);

    reply.status(200).send({
        message: 'Successfully updated the topic',
        data: result
    });
}

/**
 * @function getSummaryTopic
 * @description Return the Topic by the id given on the url
 */
async function getSummaryTopic(request: FastifyRequest<{ Params: TopicParams }>, reply: FastifyReply): Promise<void> {
    const result = await topicsService.getTopicById(request.params.id, request.server);

    reply.status(200).send({
        message: 'Successfully retrieved topic',
        data: result
    });
}

/**
 * @function getSubmissions
 * @description Return the list of all submissions for a topic
 */
async function getSubmissions(request: FastifyRequest<{ Params: TopicParams }>, reply: FastifyReply): Promise<void> {
    const result = await topicsService.getSubmissions(request.params.id, request.server);

    reply.status(200).send({
        message: 'Successfully retrieved submissions',
        data: result
    });
}

/**
 * @function sendSubmission
 * @description Return the Topic by the id given on the url
 */
async function sendSubmission(request: FastifyRequest<{ Params: TopicParams, Body: SubmissionBody }>, reply: FastifyReply): Promise<void> {
    const result = await topicsService.sendSubmission(request.params.id, request.body, request.server);

    reply.status(200).send({
        message: 'Successfully sent submission',
        data: result
    });
}

export default {
    getAllTopics,
    getTopicById,
    createTopic,
    modifyTopic,
    getSummaryTopic,
    getSubmissions,
    sendSubmission
};
