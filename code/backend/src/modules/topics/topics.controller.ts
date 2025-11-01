import { FastifyReply, FastifyRequest } from 'fastify';
import { TopicParams, CreateBody } from './topics.types';
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

export default {
    getAllTopics,
    getTopicById,
    createTopic
};
