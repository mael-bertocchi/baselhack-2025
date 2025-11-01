import { AnalyzeTopicParams, TopicResultParams } from '@modules/topic-result/topic-result.models';
import topicResultService from '@modules/topic-result/topic-result.service';
import { FastifyReply, FastifyRequest } from 'fastify';

/**
 * @function getAllTopicResults
 * @description Return the list of all the topic results.
 */
async function getAllTopicResults(request: FastifyRequest, reply: FastifyReply): Promise<void> {
    const result = await topicResultService.getAllTopicResults(request.server);

    reply.status(200).send({
        message: 'Successfully retrieved topic results',
        data: result
    });
}

/**
 * @function getTopicResultById
 * @description Return the TopicResult by the id given on the url
 */
async function getTopicResultById(request: FastifyRequest<{ Params: TopicResultParams }>, reply: FastifyReply): Promise<void> {
    const result = await topicResultService.getTopicResultById(request.params.id, request.server);

    reply.status(200).send({
        message: 'Successfully retrieved topic result',
        data: result
    });
}

/**
 * @function analyzeTopic
 * @description Analyze a topic by aggregating submissions and calling the AI agent
 */
async function analyzeTopic(request: FastifyRequest<{ Params: AnalyzeTopicParams }>, reply: FastifyReply): Promise<void> {
    const result = await topicResultService.analyzeTopic(request.params.topicId, request.server);

    reply.status(200).send({
        message: 'Successfully analyzed topic',
        data: result
    });
}

export default {
    getAllTopicResults,
    getTopicResultById,
    analyzeTopic
};
