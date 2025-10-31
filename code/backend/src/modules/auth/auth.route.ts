import authController from '@modules/auth/auth.controller';
import { FastifyInstance } from 'fastify';
import { signinSchema } from './schemas/signin.schema';
import { signupSchema } from './schemas/signup.schema';
import { refreshSchema } from './schemas/refresh.schema';

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
