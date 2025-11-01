import statsController from '@modules/stats/stats.controller';
import { FastifyInstance } from 'fastify';

/**
 * @function statsRoutes
 * @description This function handles the stats routes
 */
async function statsRoutes(app: FastifyInstance): Promise<void> {
    app.get('/nbTopics', statsController.nbTopics);
    app.get('/nbUsers', statsController.nbUsers);
    app.get('/nbSubmission', statsController.nbSubmission)
}

export default statsRoutes;
