import { FastifyReply, FastifyRequest } from 'fastify';
import usersService from './users.service';

/**
 * @function getCurrentUser
 * @description Return the logged in user information
 */
async function getCurrentUser(request: FastifyRequest, reply: FastifyReply): Promise<void> {
    if (!request.authUser) {
        throw new Error('User is not authenticated');
    }

    const result = await usersService.getCurrentUser(request.authUser, request.server);

    reply.status(200).send({
        message: 'Successfully retrieved logged user',
        data: result
    });
}

async function getUsers(request: FastifyRequest, reply: FastifyReply): Promise<void> {
    const result = await usersService.getUsers(request, request.server);

    reply.status(200).send({
        message: 'Successfully retrieved logged user',
        data: result
    });
}


export default {
    getCurrentUser,
    getUsers
};
