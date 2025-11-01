import { RequestError } from '@core/errors';
import { FastifyReply, FastifyRequest } from 'fastify';
import { SigninBody, SignupBody, RefreshBody } from './auth.types';
import authService from './auth.service';
import { extractAuthCookies, setAuthCookies } from './auth.cookies';

/**
 * @function signin
 * @description This function handles user signin
 */
async function signin(
    request: FastifyRequest<{ Body: SigninBody }>,
    reply: FastifyReply
): Promise<void> {
    const { accessToken, refreshToken, user } = await authService.signin(request.body, request.server);

    setAuthCookies(reply, accessToken, refreshToken);

    reply.status(200).send({
        message: 'Signin successful',
        data: {
            user
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

    setAuthCookies(reply, accessToken, refreshToken);

    reply.status(201).send({
        message: 'Signup successful',
        data: {
            user
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
    const cookies = extractAuthCookies(request.headers.cookie);
    const refreshToken = request.body.refreshToken ?? cookies.refreshToken;
    const accessToken = request.body.accessToken ?? cookies.accessToken;

    if (!refreshToken) {
        throw new RequestError('Refresh token is required', 400);
    }

    const { accessToken: newAccessToken, refreshToken: newRefreshToken } = await authService.refresh(
        {
            refreshToken,
            accessToken
        },
        request.server
    );

    setAuthCookies(reply, newAccessToken, newRefreshToken);

    reply.status(200).send({
        message: 'Token refresh successful'
    });
}

export default {
    signin,
    signup,
    refresh
};
