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
        preHandler: app.authenticate
    }, topicsController.getAllTopics);
    app.post('/', {
        preHandler: app.authenticate,
        schema: createSchema,
    }, topicsController.createTopic as any);
    app.put('/:id', {
        preHandler: app.authenticate,
        schema: createSchema
    }, topicsController.modifyTopic as any);
    app.get('/:id', {
        preHandler: app.authenticate
    }, topicsController.getTopicById as any);
    app.get('/:id/summary', {
        preHandler: app.authenticate
    }, topicsController.getSummaryTopic as any);
    app.get('/:id/submissions', {
        preHandler: app.authenticate
    }, topicsController.getSubmissions as any);
    app.post('/:id/submissions', {
        preHandler: app.authenticate,
        schema: submissionSchema
    }, topicsController.sendSubmission as any);
}

export default topicsRoutes;
