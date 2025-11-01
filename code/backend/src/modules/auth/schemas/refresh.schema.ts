export const refreshSchema = {
    body: {
        type: 'object',
        required: ['refreshToken'],
        properties: {
            refreshToken: {
                type: 'string',
                minLength: 8,
                description: 'Refresh token used to generate new access token'
            }
        },
        additionalProperties: false
    }
} as const;
