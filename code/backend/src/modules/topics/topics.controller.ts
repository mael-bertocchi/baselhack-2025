import { FastifyReply, FastifyRequest } from 'fastify';

/**
 * @function checkAppHealth
 * @description This function checks the health of the application
 */
function getAllTopics(request: FastifyRequest, reply: FastifyReply): void {
    reply.status(200).send({
        message: 'All topics.',
        data: {
            uptime: process.uptime()
        }
    });
}

export default {
    getAllTopics
};
