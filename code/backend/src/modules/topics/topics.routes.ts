import topicsController from '@modules/topics/topics.controller';
import { FastifyInstance } from 'fastify';

/**
 * @function healthRoutes
 * @description This function sets up the health routes for the application
 */
async function topicsRoutes(app: FastifyInstance): Promise<void> {
    app.get('/', topicsController.getAllTopics);
    app.get('/:id', topicsController.getTopicById);
}

export default topicsRoutes;
