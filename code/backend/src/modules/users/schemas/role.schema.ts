export const roleSchema = {
    params: {
        type: 'object',
        required: ['id'],
        properties: {
            id: {
                type: 'string',
                pattern: '^[0-9a-fA-F]{24}$',
                description: 'User ID (MongoDB ObjectId)'
            }
        }
    },
    body: {
        type: 'object',
        required: ['role'],
        properties: {
            role: {
                type: 'string',
                enum: ['Administrator', 'Manager', 'User'],
                description: 'Role of the user'
            },
        },
        additionalProperties: false
    }
} as const;