export const passwordSchema = {
    params: {
        type: 'object',
        required: ['id'],
        properties: {
            id: {
                type: 'string',
                pattern: '^[0-9a-fA-F]{24}$',  // Valide un ObjectId MongoDB
                description: 'User ID (MongoDB ObjectId)'
            }
        }
    },
    body: {
        type: 'object',
        required: ['password'],
        properties: {
            password: {
                type: 'string',
                minLength: 7,
                description: 'Password of the user'
            },
        },
        additionalProperties: false
    }
} as const;