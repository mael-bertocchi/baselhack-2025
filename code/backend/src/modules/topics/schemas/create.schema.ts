export const createSchema = {
    body: {
        type: 'object',
        required: [
            'title',
            'short_description',
            'description',
            'startDate',
            'endDate',
            'authorId'
        ],
        properties: {
            title: {
                type: 'string',
                minLength: 3,
                maxLength: 255,
                description: 'Title of the discussion topic'
            },
            short_description: {
                type: 'string',
                minLength: 5,
                maxLength: 500,
                description: 'Short description providing context'
            },
            description: {
                type: 'string',
                minLength: 10,
                description: 'Long description providing more information about the topic'
            },
            startDate: {
                type: 'string',
                format: 'date-time',
                description: 'Date when the topic becomes active (ISO 8601)'
            },
            endDate: {
                type: 'string',
                format: 'date-time',
                description: 'Date when the topic closes (ISO 8601)'
            },
            status: {
                type: 'string',
                enum: ['scheduled', 'open', 'closed'],
                description: 'Current state of the topic',
                default: 'open'
            },
            authorId: {
                type: 'string',
                minLength: 1,
                description: 'Identifier of the user who created the topic'
            }
        },
        additionalProperties: false
    }
} as const;
