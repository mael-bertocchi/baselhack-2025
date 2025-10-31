export const signupSchema = {
    body: {
        type: 'object',
        required: ['email', 'password', 'confirmPassword'],
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
            },
            confirmPassword: {
                type: 'string',
                minLength: 8,
                description: 'Confirmation of the user password (must match password)'
            }
        }
    }
} as const;
