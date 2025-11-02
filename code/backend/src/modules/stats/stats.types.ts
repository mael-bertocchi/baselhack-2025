/**
 * @interface TopicWithSubmissionCount
 * @description Represents a topic with its submission count
 */
export interface TopicWithSubmissionCount {
    topicId: string; /*!< The unique identifier of the topic */
    title: string; /*!< The title of the topic */
    submissionCount: number; /*!< The number of submissions for the topic */
}
