export const refreshSchema = {
    body: {
        type: 'object',
        required: ['accessToken', 'refreshToken'],
        properties: {
            accessToken: {
                type: 'string',
                minLength: 8,
                description: 'Current access token'
            },
            refreshToken: {
                type: 'string',
                minLength: 8,
                description: 'Refresh token used to generate new access token'
            }
        }
    }
} as const;
