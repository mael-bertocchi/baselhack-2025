import { RequestError } from '@core/errors';
import { FastifyReply, FastifyRequest } from 'fastify';
import { SigninBody, SignupBody, RefreshBody } from './auth.types';
import authService from './auth.service';

/**
 * @function signin
 * @description This function handles user signin
 */
async function signin(
    request: FastifyRequest<{ Body: SigninBody }>,
    reply: FastifyReply
): Promise<void> {
    const { accessToken, refreshToken, user } = await authService.signin(request.body, request.server);

    reply.status(200).send({
        message: 'Signin successful',
        data: {
            user,
            accessToken,
            refreshToken
        }
    });
}

/**
 * @function signup
 * @description This function handles user signup
 */
async function signup(
    request: FastifyRequest<{ Body: SignupBody }>,
    reply: FastifyReply
): Promise<void> {
    const { accessToken, refreshToken, user } = await authService.signup(request.body, request.server);

    reply.status(201).send({
        message: 'Signup successful',
        data: {
            user,
            accessToken,
            refreshToken
        }
    });
}

/**
 * @function refresh
 * @description This function handles user token refresh
 */
async function refresh(
    request: FastifyRequest<{ Body: RefreshBody }>,
    reply: FastifyReply
): Promise<void> {
    const { refreshToken } = request.body;

    if (!refreshToken) {
        throw new RequestError('Refresh token is required', 400);
    }

    const { accessToken: newAccessToken, refreshToken: newRefreshToken } = await authService.refresh(
        { refreshToken },
        request.server
    );

    reply.status(200).send({
        message: 'Token refresh successful',
        data: {
            accessToken: newAccessToken,
            refreshToken: newRefreshToken
        }
    });
}

export default {
    signin,
    signup,
    refresh
};
