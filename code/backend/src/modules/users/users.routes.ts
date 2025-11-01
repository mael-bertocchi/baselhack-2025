import usersController from '@modules/users/users.controller';
import { FastifyInstance } from 'fastify';
import { passwordSchema } from './schemas/password.schema'
import { roleSchema } from './schemas/role.schema';

/**
 * @function usersRoutes
 * @description This function handles the user routes
 */
async function usersRoutes(app: FastifyInstance): Promise<void> {
    app.patch('/changePassword/:id', {
        onRequest: [app.authGuard],
        schema: passwordSchema,
    }, usersController.changePassword as any);
    app.patch('/changeRole/:id', {
        onRequest: [app.authGuard],
        schema: roleSchema,
    }, usersController.changeRole as any);
    app.get('/me', {
        onRequest: [app.authGuard]
    }, usersController.getCurrentUser);
    app.get('/', {
        onRequest: [app.authGuard]
    }, usersController.getUsers);
    app.delete('/:id', {
        onRequest: [app.authGuard]
    }, usersController.deleteUser as any);
}

export default usersRoutes;
