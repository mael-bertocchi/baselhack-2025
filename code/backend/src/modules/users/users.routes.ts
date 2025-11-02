import { passwordSchema } from '@modules/users/schemas/password.schema';
import { roleSchema } from '@modules/users/schemas/role.schema';
import usersController from '@modules/users/users.controller';
import { FastifyInstance } from 'fastify';

/**
 * @function usersRoutes
 * @description This function handles the user routes
 */
async function usersRoutes(app: FastifyInstance): Promise<void> {
    app.patch('/changePassword/:id', {
        onRequest: [app.authGuard('Administrator')],
        schema: passwordSchema,
    }, usersController.changePassword as any);
    app.patch('/changeRole/:id', {
        onRequest: [app.authGuard('Administrator')],
        schema: roleSchema,
    }, usersController.changeRole as any);
    app.get('/me', {
        onRequest: [app.authGuard('User')]
    }, usersController.getCurrentUser);
    app.get('/', {
        onRequest: [app.authGuard('Administrator')]
    }, usersController.getUsers);
    app.delete('/:id', {
        onRequest: [app.authGuard('Administrator')]
    }, usersController.deleteUser as any);
}

export default usersRoutes;
