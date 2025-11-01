import { RequestError } from '@core/errors';
import { Collection, WithId } from 'mongodb';
import { FastifyInstance } from 'fastify';
import { User } from '@modules/users/users.model';
import { AuthenticatedUser } from '@modules/auth/auth.types';

/**
 * @function getUsersCollection
 * @description Retrieves the users collection from the MongoDB instance
 */
function getUsersCollection(fastify: FastifyInstance): Collection<User> {
    const db = fastify.mongo.db;

    if (!db) {
        throw new Error('Database connection is not available');
    }

    return db.collection<User>('users');
}

/**
 * @function getCurrentUser
 * @description Retrieves the information of the currently authenticated user
 */
async function getCurrentUser(authUser: AuthenticatedUser, fastify: FastifyInstance) {
    const usersCollection = getUsersCollection(fastify);

    const user: WithId<User> | null = await usersCollection.findOne({ _id: new (fastify.mongo).ObjectId(authUser.id) });

    if (!user) {
        throw new RequestError('User not found', 404);
    }

    return user;
}


export default {
    getCurrentUser
};
