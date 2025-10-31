import { Maybe } from '@core/models';

/**
 * @interface Submission
 * @description Represents a user's submission or opinion on a topic.
 */
export interface Submission {
    topic_id: string; /*!> Identifier of the related topic */
    submitted_date: Date; /*!> Timestamp when the submission was made */
    created_at: Date; /*!> Timestamp when the submission was created */
    updated_at: Date; /*!> Timestamp when the submission was last updated */
    text: string; /*!> The textual content of the submission */
};