import usersController from '@modules/users/users.controller';
import { FastifyInstance } from 'fastify';

/**
 * @function usersRoutes
 * @description This function handles the user routes
 */
async function usersRoutes(app: FastifyInstance): Promise<void> {
    app.get('/me', {
        preHandler: app.authenticate
    }, usersController.getCurrentUser);
}

export default usersRoutes;
