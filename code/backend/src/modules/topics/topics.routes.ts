import topicsController from '@modules/topics/topics.controller';
import { FastifyInstance } from 'fastify';
import { createSchema } from './schemas/create.schema';
import { submissionSchema } from './schemas/submission.schema';

/**
 * @function healthRoutes
 * @description This function sets up the health routes for the application
 */
async function topicsRoutes(app: FastifyInstance): Promise<void> {
    app.get('/', topicsController.getAllTopics);
    app.post('/', {
            schema: createSchema
        }, topicsController.createTopic);
    app.get('/:id', topicsController.getTopicById);
    app.get('/:id/summary', topicsController.getSummaryTopic);
    app.post('/:id/submission', {
            schema: submissionSchema
    }, topicsController.sendSubmission);
}

export default topicsRoutes;
