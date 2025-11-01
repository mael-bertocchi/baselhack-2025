export const submissionSchema = {
    body: {
        type: 'object',
        required: [
            'text',
        ],
        properties: {
            text: {
                type: 'string',
                minLength: 1,
                description: 'Review of the user on topic'
            },
        },
        additionalProperties: false
    }
} as const;
