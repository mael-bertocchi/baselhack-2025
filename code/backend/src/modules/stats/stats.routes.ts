import statsController from '@modules/stats/stats.controller';
import { FastifyInstance } from 'fastify';

/**
 * @function statsRoutes
 * @description This function handles the stats routes
 */
async function statsRoutes(app: FastifyInstance): Promise<void> {
    app.get('/nbTopics', {
        onRequest: [app.authGuard('User')]
    }, statsController.nbTopics);
    app.get('/nbUsers', {
        onRequest: [app.authGuard('User')]
    }, statsController.nbUsers);
    app.get('/nbSubmission', {
        onRequest: [app.authGuard('User')]
    }, statsController.nbSubmission);
    app.get('/sortTopics', {
        onRequest: [app.authGuard('User')]
    }, statsController.sortTopics);
}

export default statsRoutes;
