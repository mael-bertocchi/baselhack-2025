import { Maybe } from '@core/models';

/**
 * @interface Submission
 * @description Represents a user's submission or opinion on a topic.
 */
export interface Submission {
    topicId: string; /*!> Identifier of the related topic */
    submittedDate: Date; /*!> Timestamp when the submission was made */
    createdAt: Date; /*!> Timestamp when the submission was created */
    updatedAt: Date; /*!> Timestamp when the submission was last updated */
    text: string; /*!> The textual content of the submission */
};