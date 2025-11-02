import environment from '@core/environment';
import { User } from '@modules/users/users.model';
import bcrypt from 'bcrypt';
import { FastifyInstance } from 'fastify';
import fp from 'fastify-plugin';

/**
 * @function ensureDefaultAdmin
 * @description Ensures that a default administrator account exists when credentials are provided
 */
async function ensureDefaultAdmin(fastify: FastifyInstance): Promise<void> {
    const {
        DEFAULT_ADMIN_EMAIL,
        DEFAULT_ADMIN_PASSWORD,
        DEFAULT_ADMIN_FIRST_NAME,
        DEFAULT_ADMIN_LAST_NAME
    } = environment;

    if (!DEFAULT_ADMIN_EMAIL || !DEFAULT_ADMIN_PASSWORD) {
        fastify.log.info('Default administrator credentials not provided, skipping seeding');
        return;
    }

    const db = fastify.mongo.db;

    if (!db) {
        throw new Error('Database connection is not available');
    }

    const usersCollection = db.collection<User>('users');
    const normalizedEmail = DEFAULT_ADMIN_EMAIL.trim().toLowerCase();
    const existingUser = await usersCollection.findOne({ email: normalizedEmail });

    if (existingUser) {
        if (existingUser.role !== 'Administrator') {
            await usersCollection.updateOne(
                { _id: existingUser._id },
                {
                    $set: {
                        role: 'Administrator',
                        updatedAt: new Date()
                    }
                }
            );
            fastify.log.info('Updated existing default admin user role to Administrator');
        } else {
            fastify.log.info('Default admin user already exists, skipping creation');
        }
        return;
    }

    const hashedPassword = await bcrypt.hash(DEFAULT_ADMIN_PASSWORD, 10);
    const now = new Date();

    const user: User = {
        firstName: (DEFAULT_ADMIN_FIRST_NAME ?? 'Admin').trim(),
        lastName: (DEFAULT_ADMIN_LAST_NAME ?? 'User').trim(),
        email: normalizedEmail,
        password: hashedPassword,
        role: 'Administrator',
        createdAt: now,
        updatedAt: now
    };

    await usersCollection.insertOne(user);
    fastify.log.info({ email: normalizedEmail }, 'Default admin user created');
}

async function defaultAdminPlugin(fastify: FastifyInstance): Promise<void> {
    fastify.addHook('onReady', async () => {
        try {
            await ensureDefaultAdmin(fastify);
        } catch (error) {
            fastify.log.error({ error }, 'Failed to ensure default admin user');
            throw error;
        }
    });
}

export default fp(defaultAdminPlugin, {
    name: 'default-admin',
    dependencies: ['db']
});
