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
    start_date: Date; /*!> Date when the topic becomes active */
    end_date: Date; /*!> Date when the topic closes */
    created_at: Date; /*!> Timestamp when the topic was created */
    updated_at: Date; /*!> Timestamp of the last topic update */
    status: TopicStatus; /*!> The current state of the topic */
    author_id: string; /*!> Identifier of the user who created the topic */
};