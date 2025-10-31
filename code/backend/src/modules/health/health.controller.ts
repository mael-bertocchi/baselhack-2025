import { FastifyReply, FastifyRequest } from 'fastify';

/**
 * @function checkAppHealth
 * @description This function checks the health of the application
 */
function checkAppHealth(request: FastifyRequest, reply: FastifyReply): void {
    reply.status(200).send({
        message: 'Application is healthy.',
        data: {
            uptime: process.uptime()
        }
    });
}

export default {
    checkAppHealth
};
