import { FastifyReply, FastifyRequest } from 'fastify';
import { RequestError } from '@core/errors';
import { Collection, WithId } from 'mongodb';
import { FastifyInstance } from 'fastify';
import { User } from '@modules/users/users.model';
import { AuthenticatedUser } from '@modules/auth/auth.types';
import { PasswordBody } from './users.types';
import bcrypt from 'bcrypt';


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

/**
 * @function getUsers
 * @description Return all user on the db
 */
async function getUsers(request: FastifyRequest, fastify: FastifyInstance) {
    const usersCollection = getUsersCollection(fastify);

    const users: WithId<User>[] = await usersCollection.find({}).toArray();

    return users;
}

/**
 * @function changePassword
 * @description Change the password of the user who he want to change
 */
async function changePassword(id: string, data: PasswordBody, fastify: FastifyInstance) {
    const usersCollection = getUsersCollection(fastify);

    const user: WithId<User> | null = await usersCollection.findOne({
        _id: new (fastify.mongo).ObjectId(id)
    });

    if (!user) {
        throw new Error('User not found');
    }

    const hashedPassword = await bcrypt.hash(data.password, 10);

    await usersCollection.updateOne(
        { _id: new (fastify.mongo).ObjectId(id) },
        { $set: { password: hashedPassword } }
    );

    user.password = hashedPassword;
    return user;
}

/**
 * @function deleteUser
 * @description Delete a user by id
 */
async function deleteUser(id: string, fastify: FastifyInstance) {
    const usersCollection = getUsersCollection(fastify);

    const result = await usersCollection.deleteOne({ _id: new (fastify.mongo).ObjectId(id) });

    if (!result.acknowledged) {
        throw new RequestError('Failed to delete user', 500);
    }
}

export default {
    getCurrentUser,
    getUsers,
    changePassword,
    deleteUser
};
