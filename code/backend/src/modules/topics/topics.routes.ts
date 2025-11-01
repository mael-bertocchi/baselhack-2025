import topicsController from '@modules/topics/topics.controller';
import { FastifyInstance } from 'fastify';
import { createSchema } from './schemas/create.schema';
import { submissionSchema } from './schemas/submission.schema';

/**
 * @function topicsRoutes
 * @description This function handles topics routes
 */
async function topicsRoutes(app: FastifyInstance): Promise<void> {
    app.get('/', {
        onRequest: [app.authGuard]
    }, topicsController.getAllTopics);
    app.post('/', {
        onRequest: [app.authGuard],
        schema: createSchema,
    }, topicsController.createTopic as any);
    app.get('/:id', {
        onRequest: [app.authGuard]
    }, topicsController.getTopicById as any);
    app.put('/:id', {
        onRequest: [app.authGuard],
        schema: createSchema
    }, topicsController.modifyTopic as any);
    app.delete('/:id', {
        onRequest: [app.authGuard]
    }, topicsController.deleteTopicById as any);
    app.get('/:id/summary', {
        onRequest: [app.authGuard]
    }, topicsController.getSummaryTopic as any);
    app.get('/:id/submissions', {
        onRequest: [app.authGuard]
    }, topicsController.getSubmissions as any);
    app.post('/:id/submissions', {
        onRequest: [app.authGuard],
        schema: submissionSchema
    }, topicsController.sendSubmission as any);
}

export default topicsRoutes;
