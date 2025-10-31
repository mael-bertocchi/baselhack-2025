import { RequestError } from '@core/errors';
import { generateAccessToken, generateRefreshToken, verifyRefreshToken } from '@plugins/jwt';
import { User } from '@modules/users/users.model';
import bcrypt from 'bcrypt';
import { Collection, WithId } from 'mongodb';
import { FastifyInstance } from 'fastify';
import { RefreshBody, SigninBody, SignupBody } from "./auth.types";

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
 * @function signin
 * @description Authenticates a user and returns tokens
 */
async function signin(data: SigninBody, fastify: FastifyInstance) {
    const { email, password } = data;
    const usersCollection = getUsersCollection(fastify);
    const normalizedEmail = email.trim().toLowerCase();

    const user: WithId<User> | null = await usersCollection.findOne({ email: normalizedEmail });

    if (!user) {
        throw new RequestError('Invalid email or password', 401);
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
        throw new RequestError('Invalid email or password', 401);
    }

    const payload = { email: user.email, sub: user._id.toString() };
    const accessToken = generateAccessToken(payload, fastify);
    const refreshToken = generateRefreshToken(payload, fastify);

    return {
        accessToken,
        refreshToken,
        user: {
            id: user._id.toString(),
            email: user.email,
            firstName: user.firstName,
            lastName: user.lastName,
            role: user.role
        }
    };
}

/**
 * @function signup
 * @description Creates a new user account
 */
async function signup(data: SignupBody, fastify: FastifyInstance) {
    const {
        firstName = '',
        lastName = '',
        email,
        password,
        confirmPassword
    } = data;

    if (password !== confirmPassword) {
        throw new RequestError('Passwords do not match', 400);
    }

    const usersCollection = getUsersCollection(fastify);
    const normalizedEmail = email.trim().toLowerCase();

    const existingUser = await usersCollection.findOne({ email: normalizedEmail });

    if (existingUser) {
        throw new RequestError('User already exists', 409);
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const now = new Date();

    const user: User = {
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        email: normalizedEmail,
        password: hashedPassword,
        role: 'User',
        createdAt: now,
        updatedAt: now
    };

    const insertResult = await usersCollection.insertOne(user);

    const payload = { email: user.email, sub: insertResult.insertedId.toString() };
    const accessToken = generateAccessToken(payload, fastify);
    const refreshToken = generateRefreshToken(payload, fastify);

    return {
        accessToken,
        refreshToken,
        user: {
            id: insertResult.insertedId.toString(),
            email: user.email,
            firstName: user.firstName,
            lastName: user.lastName,
            role: user.role
        }
    };
}

/**
 * @function refresh
 * @description Refreshes access token using refresh token
 */
async function refresh(data: RefreshBody, fastify: FastifyInstance) {
    const { refreshToken } = data;

    const decoded = await verifyRefreshToken(refreshToken, fastify);

    if (!decoded) {
        throw new Error('Invalid refresh token');
    }

    const payload = { email: decoded.email };
    const newAccessToken = generateAccessToken(payload, fastify);

    return {
        accessToken: newAccessToken,
        refreshToken
    };
}

export default {
    signin,
    signup,
    refresh
};
