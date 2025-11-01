import { Maybe } from '@core/models';

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
 * @type UserRole
 * @description Represents the possible roles a user can have in the system.
 */
export type UserRole = 'Administrator' | 'Manager' | 'User';

/**
 * @interface User
 * @description Represents a user in the system.
 */
export interface User {
    firstName: string; /*!> The user's first name */
    lastName: string; /*!> The user's last name */
    email: string; /*!> The user's email address */
    role: UserRole; /*!> The user's role in the system */
    password: string; /*!> The user's hashed password */
    createdAt: Date; /*!> The creation timestamp for the user document */
    updatedAt: Date; /*!> The last update timestamp for the user document */
};

/**
 * @interface Submission
 * @description Represents a user's submission or opinion on a topic.
 */
export interface Submission {
    topicId: string; /*!> Identifier of the related topic */
    text: string; /*!> The textual content of the submission */
    submittedDate: Date; /*!> Timestamp when the submission was made */
    likes: number; /*!> Number of likes the submission has received */
    createdAt: Date; /*!> Timestamp when the submission was created */
    updatedAt: Date; /*!> Timestamp when the submission was last updated */
};
