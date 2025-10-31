export const signinSchema = {
    body: {
        type: 'object',
        required: ['email', 'password'],
        properties: {
            email: {
                type: 'string',
                format: 'email',
                description: 'User email address'
            },
            password: {
                type: 'string',
                minLength: 8,
                description: 'User password (minimum 8 characters)'
            }
        }
    }
} as const;
