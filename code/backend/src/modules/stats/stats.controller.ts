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
        message: 'The count of Topics is good brother !',
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
        message: 'The count of Users is good brother !',
        data: result
    });
}

/**
 * @function nbSubmission
 * @description Return the logged in user information
 */
async function nbSubmission(request: FastifyRequest, reply: FastifyReply): Promise<void> {

    const result = await statsService.nbSubmission(request.server);

    reply.status(200).send({
        message: 'The count of Submission is good brother !',
        data: result
    });
}

/**
 * @function sortTopics
 * @description Returns a sorted list of topics with their submission counts
 */
async function sortTopics(request: FastifyRequest, reply: FastifyReply): Promise<void> {

    const result = await statsService.sortTopics(request.server);

    reply.status(200).send({
        message: 'The count of Submission is good brother !',
        data: result
    });
}

export default {
    nbTopics,
    nbUsers,
    nbSubmission,
    sortTopics
};
