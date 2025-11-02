import topicResultController from '@modules/topic-result/topic-result.controller';
import { FastifyInstance } from 'fastify';

/**
 * @function topicResultRoutes
 * @description This function handles topic result routes
 */
async function topicResultRoutes(app: FastifyInstance): Promise<void> {
    app.get('/', {
        onRequest: [app.authGuard('Manager')]
    }, topicResultController.getAllTopicResults);

    app.get('/:id', {
        onRequest: [app.authGuard('Manager')]
    }, topicResultController.getTopicResultById as any);

    app.post('/analyze/:topicId', {
        onRequest: [app.authGuard('Manager')]
    }, topicResultController.analyzeTopic as any);
}

export default topicResultRoutes;
