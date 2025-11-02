import { TopicStatus } from '@modules/topics/topics.model';

/**
 * @interface TopicParams
 * @description Parameters for topic-related requests
 */
export interface TopicParams {
    id: string; /*!< The unique identifier of the topic */
}

/**
 * @interface CreateBody
 * @description Body for creating or modifying a topic
 */
export interface CreateBody {
    title: string; /*!< The title of the topic */
    short_description: string; /*!< A short description of the topic */
    description: string; /*!< A detailed description of the topic */
    startDate: string; /*!< The start date of the topic */
    endDate: string; /*!< The end date of the topic */
    status?: TopicStatus; /*!< The status of the topic */
    authorId: string; /*!< The ID of the author creating the topic */
}

/**
 * @interface TopicQuery
 * @description Query parameters for fetching topics
 */
export interface SubmissionBody {
    text: string; /*!< The text content of the submission */
}
