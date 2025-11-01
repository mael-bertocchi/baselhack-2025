import { Result } from './../../../node_modules/arg/index.d';
import { FastifyReply, FastifyRequest } from 'fastify';
import usersService from './users.service';
import { PasswordBody } from './users.types';

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


/**
 * @function getUsers
 * @description Return all user on the db
 */
async function getUsers(request: FastifyRequest, reply: FastifyReply): Promise<void> {
    const result = await usersService.getUsers(request, request.server);

    reply.status(200).send({
        message: 'Successfully drop all user',
        data: result
    });
}

async function changePassword(
    request: FastifyRequest<{
        Body: PasswordBody,
        Params: { id: string }
    }>, 
    reply: FastifyReply
): Promise<void> {
    const result = await usersService.changePassword(
        request.params.id,
        request.body, 
        request.server
    );

    reply.status(200).send({
        message: 'Successfully changed the password of user',
        data: result
    });
}

export default {
    getCurrentUser,
    getUsers,
    changePassword
};
