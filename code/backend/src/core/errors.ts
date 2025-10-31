import { Maybe } from '@core/models';

/**
 * @class RequestError
 * @description This class represent an error with a code.
 *
 * @extends Error
 */
export class RequestError extends Error {
    public data: Maybe<Object>; /*!> Additional error data */
    public code: number; /*!> The error code */

    /**
     * @constructor
     * @description Send an error message with code
     *
     * @param {string} message The error message
     * @param {number} code The error code
     */
    constructor(message: string, code: number, data: Maybe<Object> = null) {
        super(message);

        this.code = code;
        this.data = data;
    }
}
