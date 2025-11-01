import healthController from '@modules/health/health.controller';
import { FastifyInstance } from 'fastify';

/**
 * @function healthRoutes
 * @description This function sets up the health routes for the application
 */
async function healthRoutes(app: FastifyInstance): Promise<void> {
    app.get('/', {
        onRequest: [app.authGuard]
    }, healthController.checkAppHealth);
}

export default healthRoutes;
