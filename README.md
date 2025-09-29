# CV Evaluator API

## How to Run

- change the GOOGLE_API_KEY in .env.example
- rename .env.example to .env
- execute the command below

```bash
# install uv first if you haven't installed it
uv sync

docling-tools models download --output-dir=./docling_models/

uv run fastapi run main.py --host="0.0.0.0" --port="8000" --log-config=./log_conf.yaml
```

## Features

- **File Upload Support**: Accepts CV files in multiple formats (TXT, PDF, DOCX)
- **Real AI Integration**: Uses Gemini 2.5 flash for evaluation and extraction
- **PDF/DOCX/TXT/MD Processing**: Real text extraction from PDF and Word documents
- **Standardized Scoring**: AI-powered consistent evaluation parameters

## API Endpoints

### Core Endpoints

- `POST /api/v1/upload` - Upload CV files and job description files
- `POST /api/v1/evaluate` - Start evaluation process
- `GET /api/v1/result/{id}` - Get evaluation results

### Evaluation Request Format

```json
{ "id": "uuid", "job_description": "job_description" }
```

**Required Fields:**

- `id`: uuid that is received when you've uploaded file
- `job_description`: detailed job description

## Usage Examples

### 1. Upload Files

```bash
# Upload CV file
curl -X POST -F "cv=@cv.pdf" -F "project=@main.py" http://localhost:8000/api/v1/upload

```

Response:

```json
{
  "id": "eafcf307-26c4-4824-abd8-272f39c7c7d8",
  "status": "queued"
}
```

### 2. Start Evaluation

```bash
curl 'http://localhost:8000/evaluate' \
     -H 'Content-Type: application/json' \
     -d '{"id":"uuid","job_description":"job_description"}'
```

Response:

```json
{
  "id": "eafcf307-26c4-4824-abd8-272f39c7c7d8",
  "status": "queued"
}
```

### 3. Check Results

```bash
curl http://localhost:8000/api/v1/result/123e4567-e89b-12d3-a456-426614174000
```

Responses:

**Completed:**

```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "status": "completed",
  "result": {
    "cv_match_rate": 0.82,
    "cv_feedback": "Strong in backend and cloud, limited AI integration experience.",
    "project_score": 7.5,
    "project_feedback": "Meets prompt chaining requirements, lacks error handling robustness.",
    "overall_summary": "Good candidate fit, would benefit from deeper RAG knowledge."
  }
}
```

## Evaluation Criteria

1.  **Technical Skills Match (1-5):**
    - **Description:** How well do the candidate's backend, databases, APIs, cloud, and AI/LLM skills align with the job description?
    - **Score:** (1-5, where 1 is "Irrelevant skills" and 5 is "Excellent match + AI/LLM exposure")
    - **Feedback:** [Provide a brief justification for the score, highlighting key strengths or gaps in skills.]

2.  **Experience Level (1-5):**
    - **Description:** Assess the candidate's years of experience and the complexity of their past projects.
    - **Score:** (1-5, where 1 is "<1 yr / trivial projects" and 5 is "5+ yrs / high-impact projects")
    - **Feedback:** [Provide a brief justification for the score, mentioning project scope or years of experience.]

3.  **Relevant Achievements (1-5):**
    - **Description:** Evaluate the impact and scale of the candidate's past work. Look for measurable outcomes.
    - **Score:** (1-5, where 1 is "No clear achievements" and 5 is "Major measurable impact")
    - **Feedback:** [Provide a brief justification for the score, citing specific achievements or noting their absence.]

4.  **Cultural Fit (1-5):**
    - **Description:** Based on the CV's tone and content, assess the candidate's communication skills and learning attitude.
    - **Score:** (1-5, where 1 is "Not demonstrated" and 5 is "Excellent and well-demonstrated")
    - **Feedback:** [Provide a brief justification for the score, commenting on clarity, detail, or demonstrated a growth mindset.]

### Project Assessment (Score 1-10)

Project information is automatically extracted from the CV file, analyzing any project descriptions, portfolios, or technical work mentioned:

- **Correctness (25% weight)**
  - Meets stated requirements
  - Proper technical implementation
  - Problem-solving approach
  - Requirements fulfillment

- **Code Quality (20% weight)**
  - Clean, readable code
  - Modular architecture
  - Proper abstractions
  - Following best practices

- **Technical Complexity (20% weight)**
  - System design skills
  - Technology choices
  - Architecture decisions
  - Scalability considerations

- **Documentation (15% weight)**
  - Project descriptions
  - Technical explanations
  - Problem statement clarity
  - Solution documentation

- **Impact/Innovation (20% weight)**
  - Business impact
  - Technical innovation
  - Performance improvements
  - Creative solutions

## Future Enhancements

- **Rate Limiting**: API throttling and quota management
- **Webhooks**: Callback notifications for completed evaluations
- **Metrics**: Prometheus integration for operational metrics
- **Caching**: Redis integration for performance notifications
- **Circuit Breaker**: Prevents cascading failures when LLM APIs are down
- **Exponential Backoff**: Intelligent retry mechanism for transient failures
- **Graceful Degradation**: Continues operation with reduced functionality
- **Comprehensive Logging**: Detailed error tracking and monitoring
