/**
 * @interface TopicResult
 * @description Represents aggregated results for a discussion topic.
 */
export interface TopicResult {
    topicId: string; /*!> Identifier of the related topic */
    content: string; /*!> Aggregated content from submissions */
    createdAt: Date; /*!> Timestamp when the topic result was created */
    updatedAt: Date; /*!> Timestamp when the topic result was last updated */
};

/**
 * @interface AgentAnalysisRequest
 * @description Request payload for agent analysis
 */
export interface AgentAnalysisRequest {
    prompt: string; /*!> The prompt to send to the AI agent */
}

/**
 * @interface AgentAnalysisResponse
 * @description Response from agent analysis
 */
export interface AgentAnalysisResponse {
    response: string; /*!> The AI-generated response */
}

/**
 * @interface TopicResultParams
 * @description Parameters for topic result routes
 */
export interface TopicResultParams {
    id: string; /*!> Identifier of the topic result */
}

/**
 * @interface AnalyzeTopicParams
 * @description Parameters for analyzing a topic
 */
export interface AnalyzeTopicParams {
    topicId: string; /*!> Identifier of the topic to analyze */
}
