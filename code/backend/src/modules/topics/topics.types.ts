import { TopicStatus } from './topics.model';

export interface TopicParams {
    id: string;
}

export interface CreateBody {
    title: string;
    short_description: string;
    description: string;
    startDate: string;
    endDate: string;
    status?: TopicStatus;
    authorId: string;
}

export interface SubmissionBody {
    text: string;
}
