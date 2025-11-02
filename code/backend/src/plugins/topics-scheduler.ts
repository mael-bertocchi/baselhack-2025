import { FastifyInstance } from 'fastify';
import fp from 'fastify-plugin';
import { Collection } from 'mongodb';
import { Topic } from '@modules/topics/topics.model';

/**
 * @function topicsSchedulerPlugin
 * @description Periodically updates topic statuses based on start and end dates
 */
async function topicsSchedulerPlugin(fastify: FastifyInstance): Promise<void> {
    let interval: NodeJS.Timeout | null = null;

    const runScheduler = async () => {
        const db = fastify.mongo.db;

        if (!db) {
            fastify.log.error('Database connection is not available for topics scheduler');
            return;
        }

        const topicsCollection: Collection<Topic> = db.collection<Topic>('topics');
        const now = new Date();

        try {
            const scheduledToOpen = await topicsCollection.updateMany(
                { status: 'scheduled', startDate: { $lte: now } },
                { $set: { status: 'open', updatedAt: now } }
            );

            if (scheduledToOpen.modifiedCount > 0) {
                fastify.log.info({ count: scheduledToOpen.modifiedCount }, 'Topics moved from scheduled to open');
            }

            const openToClosed = await topicsCollection.updateMany(
                { status: 'open', endDate: { $lte: now } },
                { $set: { status: 'closed', updatedAt: now } }
            );

            if (openToClosed.modifiedCount > 0) {
                fastify.log.info({ count: openToClosed.modifiedCount }, 'Topics moved from open to closed');
            }
        } catch (error) {
            const details = error instanceof Error ? { message: error.message, stack: error.stack, name: error.name } : error;
            fastify.log.error({ error: details }, 'Failed to run topics scheduler');
        }
    };

    fastify.addHook('onReady', async () => {
        await runScheduler();

        interval = setInterval(runScheduler, 60_000);
    });

    fastify.addHook('onClose', async () => {
        if (interval) {
            clearInterval(interval);
        }
    });
}

export default fp(topicsSchedulerPlugin, {
    name: 'topics-scheduler'
});
