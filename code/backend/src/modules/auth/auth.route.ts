import authController from '@modules/auth/auth.controller';
import { refreshSchema } from '@modules/auth/schemas/refresh.schema';
import { signinSchema } from '@modules/auth/schemas/signin.schema';
import { signupSchema } from '@modules/auth/schemas/signup.schema';
import { FastifyInstance } from 'fastify';

/**
 * @function authRoutes
 * @description This function sets up the auth routes for the application
 */
async function authRoutes(app: FastifyInstance): Promise<void> {
    app.post('/signin', {
        schema: signinSchema
    }, authController.signin);
    app.post('/signup', {
		schema: signupSchema
	}, authController.signup);
    app.post('/refresh', {
        schema: refreshSchema
    }, authController.refresh);
}

export default authRoutes;
