import { Maybe } from '@core/models';

/**
 * @interface TopicResult
 * @description Represents aggregated results for a discussion topic.
 */
export interface TopicResult {
    topicId: string; /*!> Identifier of the related topic */
    content: string; /*!> Aggregated content from submissions */
    createdAt: Date; /*!> Timestamp when the topic result was created */
    updatedAt: Date; /*!> Timestamp when the topic result was last updated */
};
