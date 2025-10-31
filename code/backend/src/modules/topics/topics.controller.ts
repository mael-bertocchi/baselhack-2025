import { FastifyReply, FastifyRequest } from 'fastify';

interface TopicParams {
    id: string;
}

/**
 * @function getAllTopics
 * @description Return the list of the all topics.
 */
function getAllTopics(request: FastifyRequest, reply: FastifyReply): void {
    reply.status(200).send({
        message: 'All topics.',
        data: {
            uptime: process.uptime()
        }
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
