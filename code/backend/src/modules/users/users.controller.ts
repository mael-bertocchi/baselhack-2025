import usersService from '@modules/users/users.service';
import { PasswordBody, RoleBody, UserParams } from '@modules/users/users.types';
import { FastifyReply, FastifyRequest } from 'fastify';

/**
 * @function getCurrentUser
 * @description Return the logged in user information
 */
async function getCurrentUser(request: FastifyRequest, reply: FastifyReply): Promise<void> {
    if (request.authUser) {
        const result = await usersService.getCurrentUser(request.authUser, request.server);

        reply.status(200).send({
            message: 'Successfully retrieved logged user',
            data: result
        });
    } else {
        reply.status(501).send({
            message: 'No logged user found',
        });
    }
}

/**
 * @function getUsers
 * @description Return all user on the db
 */
async function getUsers(request: FastifyRequest, reply: FastifyReply): Promise<void> {
    const result = await usersService.getUsers(request, request.server);

    reply.status(200).send({
        message: 'Successfully retrieved users',
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

async function changeRole(
    request: FastifyRequest<{
        Body: RoleBody,
        Params: { id: string }
    }>,
    reply: FastifyReply
): Promise<void> {
    const result = await usersService.changeRole(
        request.params.id,
        request.body,
        request.server
    );

    reply.status(200).send({
        message: 'Successfully changed the role of user',
        data: result
    });
}

/**
 * @function deleteUser
 * @description Delete a user by id
 */
async function deleteUser(request: FastifyRequest<{ Params: UserParams }>, reply: FastifyReply): Promise<void> {
    await usersService.deleteUser(request.params.id, request.server);

    reply.status(200).send({
        message: 'Successfully deleted user',
    });
}

export default {
    getCurrentUser,
    getUsers,
    changePassword,
    changeRole,
    deleteUser
};
