import { Maybe } from '@core/models';

/**
 * @type TopicStatus
 * @description Represents the current state of a topic discussion.
 */
export type TopicStatus = 'open' | 'closed' | 'archived';

/**
 * @interface Topic
 * @description Represents a discussion topic in the system.
 */
export interface Topic {
    title: string; /*!> Title of the discussion topic */
    description: string; /*!> Description providing context */
    startDate: Date; /*!> Date when the topic becomes active */
    endDate: Date; /*!> Date when the topic closes */
    createdAt: Date; /*!> Timestamp when the topic was created */
    updatedAt: Date; /*!> Timestamp of the last topic update */
    status: TopicStatus; /*!> The current state of the topic */
    authorId: string; /*!> Identifier of the user who created the topic */
};