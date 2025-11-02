import { createSchema } from '@modules/topics/schemas/create.schema';
import { submissionSchema } from '@modules/topics/schemas/submission.schema';
import topicsController from '@modules/topics/topics.controller';
import { FastifyInstance } from 'fastify';

/**
 * @function topicsRoutes
 * @description This function handles topics routes
 */
async function topicsRoutes(app: FastifyInstance): Promise<void> {
    app.get('/', {
        onRequest: [app.authGuard('User')]
    }, topicsController.getAllTopics);
    app.post('/', {
        onRequest: [app.authGuard('User')],
        schema: createSchema,
    }, topicsController.createTopic as any);
    app.get('/:id', {
        onRequest: [app.authGuard('User')]
    }, topicsController.getTopicById as any);
    app.put('/:id', {
        onRequest: [app.authGuard('User')],
        schema: createSchema
    }, topicsController.modifyTopic as any);
    app.delete('/:id', {
        onRequest: [app.authGuard('Manager')]
    }, topicsController.deleteTopicById as any);
    app.get('/:id/summary', {
        onRequest: [app.authGuard('User')]
    }, topicsController.getSummaryTopic as any);
    app.get('/:id/submissions', {
        onRequest: [app.authGuard('User')]
    }, topicsController.getSubmissions as any);
    app.post('/:id/submissions', {
        onRequest: [app.authGuard('Manager')],
        schema: submissionSchema
    }, topicsController.sendSubmission as any);
}

export default topicsRoutes;
