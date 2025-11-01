import { Result } from './../../../node_modules/arg/index.d';
import { FastifyReply, FastifyRequest } from 'fastify';
import statsService from './stats.service';

/**
 * @function nbTopics
 * @description Return the logged in user information
 */
async function nbTopics(request: FastifyRequest, reply: FastifyReply): Promise<void> {

    const result = await statsService.nbTopics(request.server);

    reply.status(200).send({
        message: 'The count is good brother !',
        data: result
    });
}

/**
 * @function nbUsers
 * @description Return the logged in user information
 */
async function nbUsers(request: FastifyRequest, reply: FastifyReply): Promise<void> {

    const result = await statsService.nbUsers(request.server);

    reply.status(200).send({
        message: 'The count is good brother !',
        data: result
    });
}

export default {
    nbTopics,
    nbUsers
};
