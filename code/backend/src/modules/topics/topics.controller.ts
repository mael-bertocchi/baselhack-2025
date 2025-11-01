import { FastifyReply, FastifyRequest } from 'fastify';
import { TopicParams } from './topics.types';
import topicsService from './topics.service';

/**
 * @function getAllTopics
 * @description Return the list of the all topics.
 */
async function getAllTopics(request: FastifyRequest, reply: FastifyReply): Promise<void> {
    const result = await topicsService.getAllTopics(request.server);

    reply.status(200).send({
        message: 'All topics.',
        data: result
    });
}

/**
 * @function getTopicById
 * @description Return the Topic by the id given on the url
 */
function getTopicById(request: FastifyRequest<{ Params: TopicParams }>, reply: FastifyReply): void {
    const { id } = request.params;

    reply.status(200).send({
        message: `Topic with id: ${id}`,
        data: {
            id,
            uptime: process.uptime()
        }
    });
}

export default {
    getAllTopics,
    getTopicById
};
