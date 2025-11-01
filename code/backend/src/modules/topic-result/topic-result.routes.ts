import topicResultController from '@modules/topic-result/topic-result.controller';
import { FastifyInstance } from 'fastify';

/**
 * @function topicResultRoutes
 * @description This function handles topic result routes
 */
async function topicResultRoutes(app: FastifyInstance): Promise<void> {
    app.get('/', {
        onRequest: [app.authGuard]
    }, topicResultController.getAllTopicResults);

    app.get('/:id', {
        onRequest: [app.authGuard]
    }, topicResultController.getTopicResultById as any);

    app.post('/analyze/:topicId', {
        onRequest: [app.authGuard]
    }, topicResultController.analyzeTopic as any);
}

export default topicResultRoutes;
