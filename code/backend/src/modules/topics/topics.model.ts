/**
 * @type TopicStatus
 * @description Represents the current state of a topic discussion.
 */
export type TopicStatus = 'scheduled' | 'open' | 'closed';

/**
 * @interface Topic
 * @description Represents a discussion topic in the system.
 */
export interface Topic {
    title: string; /*!> Title of the discussion topic */
    short_description: string; /*!> Short description providing context */
    description: string; /*!> Long description providing more information about the topic */
    startDate: Date; /*!> Date when the topic becomes active */
    endDate: Date; /*!> Date when the topic closes */
    status: TopicStatus; /*!> The current state of the topic */
    authorId: string; /*!> Identifier of the user who created the topic */
    createdAt: Date; /*!> Timestamp when the topic was created */
    updatedAt: Date; /*!> Timestamp of the last topic update */
};

/**
 * @interface Summary
 * @description Represents a summary of a discussion topic.
 */
export interface Summary {
    title: string; /*!> Title of the discussion topic */
    short_description: string; /*!> Short description providing context */
    description: string; /*!> Long description providing more information about the topic */
    startDate: Date; /*!> Date when the topic becomes active */
    endDate: Date; /*!> Date when the topic closes */
    createdAt: Date; /*!> Timestamp when the topic was created */
    updatedAt: Date; /*!> Timestamp of the last topic update */
    status: TopicStatus; /*!> The current state of the topic */
    authorId: string; /*!> Identifier of the user who created the topic */
};

/**
 * @interface Submission
 * @description Represents a submission made to a discussion topic.
 */
export interface Submission {
    topicId: string; /*!> Identifier of the related topic */
    createdAt: Date; /*!> Timestamp when the submission was created */
    updatedAt: Date; /*!> Timestamp when the submission was last updated */
    text: string; /*!> The textual content of the submission */
};
