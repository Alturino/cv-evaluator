class SkillResult {
    score int
    feedback string
}

class OverallResult {
    cv_match_rate float
    cv_feedback string
    project_score float
    project_feedback string
    overall_summary string
    technical_skills_match SkillResult
    experience_level SkillResult
    project_match SkillResult
    relevant_achievements SkillResult
    cultural_fit SkillResult
}

function EvaluateAll(cv: CVExtractionResult,  job_description: JobDescription, project_evaluation: ProjectEvaluationResult) -> OverallResult {
    client CustomGemini
    prompt #"
        **Instructions:**
        You are an expert HR and Technical Recruiter. Your task is to evaluate a candidate's CV against a job description, providing a score and feedback for each of the following criteria.

        **Job Description:**
        {{job_description}}

        **Candidate's CV:**
        {{ cv }}
        
        **Candiate's Project Evaluation:**
        {{project_evaluation}}

        **Evaluation Criteria:**

        1.  **Technical Skills Match (1-5):**
            * **Description:** How well do the candidate's backend, databases, APIs, cloud, and AI/LLM skills align with the job description?
            * **Score:** (1-5, where 1 is "Irrelevant skills" and 5 is "Excellent match + AI/LLM exposure")
            * **Feedback:** [Provide a brief justification for the score, highlighting key strengths or gaps in skills.]

        2.  **Experience Level (1-5):**
            * **Description:** Assess the candidate's years of experience and the complexity of their past projects.
            * **Score:** (1-5, where 1 is "<1 yr / trivial projects" and 5 is "5+ yrs / high-impact projects")
            * **Feedback:** [Provide a brief justification for the score, mentioning project scope or years of experience.]

        3.  **Relevant Achievements (1-5):**
            * **Description:** Evaluate the impact and scale of the candidate's past work. Look for measurable outcomes.
            * **Score:** (1-5, where 1 is "No clear achievements" and 5 is "Major measurable impact")
            * **Feedback:** [Provide a brief justification for the score, citing specific achievements or noting their absence.]

        4.  **Cultural Fit (1-5):**
            * **Description:** Based on the CV's tone and content, assess the candidate's communication skills and learning attitude.
            * **Score:** (1-5, where 1 is "Not demonstrated" and 5 is "Excellent and well-demonstrated")
            * **Feedback:** [Provide a brief justification for the score, commenting on clarity, detail, or demonstrated a growth mindset.]

        {{ ctx.output_format }}
    "#
}


test evaluate_all {
  functions [EvaluateAll]
  args {
        cv {
            name: "Ricky Alturino",
            address: "Palembang, Indonesia",
            projects: [
                {
                name: "Hedonify",
                description: "Scalable ecommerce microservices-based backend system, implemented a queue and batch processing to handle competing orders efficiently.",
                technologies: [
                    "Go",
                    "Docker",
                    "Microservice",
                    "PostgreSQL",
                    "Redis",
                    "OpenTelemetry"
                ],
                tools: [],
                duration_in_year: 0.92
                },
                {
                name: "Open Music API",
                description: "Music backend server for dicoding course.",
                technologies: [
                    "JavaScript (Hapi)",
                    "Java (Spring Boot)",
                    "PostgreSQL",
                    "RabbitMQ"
                ],
                tools: [],
                duration_in_year: 0.5
                },
                {
                name: "Learn Kubernetes",
                description: "Learn kubernetes deployment and database replication of MongoDB, PostgreSQL, and Redis by using Docker Compose and Kubernetes StatefulSet.",
                technologies: [
                    "MongoDB",
                    "PostgreSQL",
                    "Redis",
                    "Docker",
                    "Kubernetes"
                ],
                tools: [],
                duration_in_year: 0.08
                }
            ],
            educations: [
                {
                school: "Sriwijaya University",
                gpa: 3.6,
                max_gpa: 4
                }
            ],
            experience: [
                {
                company: "Brick",
                position: "L1 Engineer",
                location: "(Remote) Jakarta, Indonesia",
                start_date: "May 2024",
                end_date: "May 2025",
                duration_in_year: 1.08,
                description: "",
                responsibilities: [
                    "Provide cross-divisional support both in data updates and data retrieval.",
                    "Developed, maintained applications/services."
                ]
                },
                {
                company: "Campaign",
                position: "Android Developer Intern",
                location: "(Remote) Jakarta, Indonesia",
                start_date: "January 2023",
                end_date: "July 2023",
                duration_in_year: 0.58,
                description: "",
                responsibilities: [
                    "Collaborated with teams to ensure features are meeting expectations.",
                    "Developed, maintained, and tested new features."
                ]
                },
                {
                company: "Indosat Ooredoo Hutchison",
                position: "Android Developer Intern",
                location: "(Remote) Jakarta, Indonesia",
                start_date: "May 2022",
                end_date: "June 2022",
                duration_in_year: 0.17,
                description: "",
                responsibilities: [
                    "Lead Mobile Development Team to develop Hy.Ponics application.",
                    "Researched, developed, and tested features of Hy.Ponics application."
                ]
                }
            ],
            skills: [
                "Go",
                "Java",
                "Kotlin",
                "TypeScript",
                "Python",
                "OOP",
                "Design Pattern",
                "TDD",
                "Gin",
                "Fiber",
                "Echo",
                "Spring Boot",
                "Express",
                "Hapi",
                "NestJS",
                "React",
                "Github Actions",
                "Circle CI",
                "PostgreSQL",
                "MySQL",
                "MongoDB",
                "Redis",
                "Memcached",
                "Firebase",
                "RabbitMQ",
                "Kafka",
                "NATS",
                "Firebase Cloud Messaging",
                "Git",
                "Linux",
                "Docker",
                "Kubernetes",
                "k6",
                "Testcontainers",
                "Prometheus",
                "Grafana",
                "Nginx",
                "AWS",
                "GCP"
            ]
} 
    job_description {
        description: "You'll be building new product features alongside a frontend engineer and product manager using our Agile methodology, as well as addressing issues to ensure our apps are robust and our codebase is clean. As a Product Engineer, you'll write clean, efficient code to enhance our product's codebase in meaningful ways. In addition to classic backend work, this role also touches on building AI-powered systems, where you’ll design and orchestrate how large language models (LLMs) integrate into Rakamin’s product ecosystem.",
        qualifications: [
            "Strong track record of working on backend technologies of web apps",
            "Exposure to AI/LLM development or a strong desire to learn",
            "Experience with backend languages and frameworks (Node.js, Django, Rails)",
            "Experience with Database management (MySQL, PostgreSQL, MongoDB)",
            "Experience with RESTful APIs",
            "Experience with Security compliance",
            "Experience with Cloud technologies (AWS, Google Cloud, Azure)",
            "Experience with Server-side languages (Java, Python, Ruby, or JavaScript)",
            "Understanding of frontend technologies",
            "Experience with User authentication and authorization between multiple systems, servers, and environments",
            "Knowledge of Scalable application design principles",
            "Experience creating database schemas that represent and support business processes",
            "Experience implementing automated testing platforms and unit tests",
            "Familiarity with LLM APIs, embeddings, vector databases and prompt design best practices",
            "Ability to demonstrate practical skills and how work is done, rather than solely relying on academic credentials (e.g., Computer Science degree or prestigious university)"
        ],
        tools: [
            "Node.js",
            "Ruby on Rails",
            "LLM",
            "Docker",
            "Kubernetes",
            "Django",
            "MySQL",
            "PostgreSQL",
            "MongoDB",
            "AWS",
            "Google Cloud",
            "Azure",
            "Java",
            "Python",
            "Ruby",
            "JavaScript",
            "RSpec",
            "Vector databases"
        ],
        real_work_examples: [
            "Collaborating with frontend engineers and 3rd parties to build robust backend solutions that support highly configurable platforms and cross-platform integration.",
            "Developing and maintaining server-side logic for central database, ensuring high performance throughput and response time.",
            "Designing and fine-tuning AI prompts that align with product requirements and user contexts.",
            "Building LLM chaining flows, where the output from one model is reliably passed to and enriched by another.",
            "Implementing Retrieval-Augmented Generation (RAG) by embedding and retrieving context from vector databases, then injecting it into AI prompts to improve accuracy and relevance.",
            "Handling long-running AI processes gracefully — including job orchestration, async background workers, and retry mechanisms.",
            "Designing safeguards for uncontrolled scenarios: managing failure cases from 3rd party APIs and mitigating the randomness/nondeterminism of LLM outputs.",
            "Leveraging AI tools and workflows to increase team productivity (e.g., AI-assisted code generation, automated QA, internal bots).",
            "Writing reusable, testable, and efficient code to improve the functionality of our existing systems.",
            "Strengthening our test coverage with RSpec to build robust and reliable web apps.",
            "Conducting full product lifecycles, from idea generation to design, implementation, testing, deployment, and maintenance.",
            "Providing input on technical feasibility, timelines, and potential product trade-offs, working with business divisions.",
            "Actively engaging with users and stakeholders to understand their needs and translate them into backend and AI-driven improvements."
        ]
    } 
    project_evaluation {
        overall 4.7
        correctness 2
        code_quality 4
        resilience 2,
        documentation 1
        creativity_and_bonus 2.5
        feedback "This project provides a basic FastAPI application for uploading documents and triggering a conversion process. While the code structure is generally clean and utilizes good practices in some areas, there are critical issues in correctness, resilience, and a complete lack of external documentation.\n\n### Detailed Feedback:\n\n**1. Correctness (2.0/5)**\n*   **`/upload` Endpoint:** This endpoint correctly handles file uploads, validates extensions, generates a unique ID, stores the file on disk, encodes its content to base64, and saves metadata to the database. Error handling for missing filenames and disallowed extensions is present.\n*   **`/evaluate` Endpoint - Critical Logic Flaw:** The most significant correctness issue lies within the `/evaluate` endpoint's database query logic. The query for both the `cv` and `project` documents uses `Document.id == req_body.id`. However, the `/upload` endpoint assigns a *new, unique* `uuid.uuid4()` to each `Document` when it's uploaded. This means it's highly unlikely that a separate `cv` file and `project` file would ever share the same `Document.id`. Consequently, the query for the `project` document will almost always fail (`project` will be `None`), unless the `cv_file` and `project_file` refer to the same physical document, or there's an unstated linking mechanism. This design flaw makes it impossible to correctly retrieve and process two distinct documents (CV and project) in the `evaluate` endpoint as currently implemented.\n*   **`/evaluate` Endpoint - Incomplete Processing Feedback:** The `doc_converter.convert(path)` method is called, but its return value (`conv_res`) is ignored. More critically, the endpoint *always* returns `JSONResponse({\"status\": \"ok\", \"message\": \"ok\"})`, regardless of whether `doc_converter.convert` succeeded or failed. If the conversion fails or throws an exception, the client receives a misleading 'ok' status or a 500 error, without any specific error reporting.\n*   **LLM/RAG/Prompt Design:** These aspects were not applicable as the provided code does not demonstrate any LLM interaction, RAG, or prompt design.\n\n**2. Code Quality (4.0/5)**\n*   **Cleanliness & Readability:** The code is generally clean, well-formatted, and uses descriptive variable and function names. Imports are grouped logically.\n*   **Modularity:** The separation of database models (`model.db`, `model.document`), request bodies (`model.requests.body`), and the use of external libraries (`docling`, `FastAPI`, `SQLModel`) demonstrate good modular design.\n*   **Best Practices:** Uses `async/await` for I/O, `pathlib` for robust path handling, context managers for database sessions, and `logging`. Environment variables are loaded via `dotenv`. SQLModel usage is appropriate.\n*   **Minor Issues:** `MAX_REQUEST_SIZE` is declared but unused. The file content is read into memory, base64 encoded for DB storage, and then the original content is written to disk. For very large files, this could be slightly inefficient by holding the full file content in memory twice.\n\n**3. Resilience (2.0/5)**\n*   **Basic Error Handling:** Input validation for filenames and extensions is present in `/upload`, and missing CV files are handled in `/evaluate`. FastAPI's `HTTPException` is used correctly for these cases.\n*   **Lack of Robust Error Handling for Processing:** The `evaluate` endpoint lacks robust error handling for the `DocumentConverter`. Any failure during conversion will either lead to a silent success message or a 500 Internal Server Error, rather than a graceful and informative response to the client.\n*   **No Request Size Enforcement:** The `MAX_REQUEST_SIZE` constant is defined but not enforced in the `/upload` endpoint. This makes the service vulnerable to Denial-of-Service (DoS) attacks via excessively large file uploads.\n*   **No Retries/Circuit Breakers:** There are no explicit retry mechanisms for external dependencies (like database connections or the `DocumentConverter`) or any form of circuit breaking for transient failures.\n*   **Limited Monitoring:** Basic logging is implemented, but there's no evidence of more advanced monitoring, metrics, or tracing.\n\n**4. Documentation (1.0/5)**\n*   **Internal Documentation:** The provided source file contains almost no comments or docstrings explaining the purpose of functions, classes, or complex logic. This makes the code harder to understand and maintain without prior knowledge of the system.\n*   **External Documentation:** There is no README file, API documentation (e.g., OpenAPI specification beyond what FastAPI generates automatically), architectural decisions, or trade-offs explained. For an 'expert technical reviewer', this is a significant oversight.\n\n**5. Creativity/Bonus (2.5/5)**\n*   **Library Choices:** The use of modern libraries like `FastAPI`, `SQLModel`, and `pathlib` is a positive aspect.\n*   **Database Migrations:** The `migrations()` call suggests a proper database migration setup, which is good practice.\n*   **Base64 Encoding:** Storing base64 encoded content directly in the database is a design choice. While it might be convenient for smaller files, it can be inefficient for larger documents in terms of database size, query performance, and memory usage. Storing a reference and retrieving from disk on demand is often preferred for larger binaries.\n*   **Missed Opportunities:** The unused `MAX_REQUEST_SIZE` is a missed opportunity for a crucial security/resilience feature. There are no advanced security considerations (e.g., authentication, authorization beyond simple input validation), performance optimizations (e.g., async processing, caching), or deployment considerations evident in the provided code.\n\n### Overall Summary:\n\nThe project provides a functional skeleton for document processing. The code quality is reasonable for its scope, but the fundamental logic for retrieving and processing multiple documents in the `evaluate` endpoint is flawed. The lack of robust error handling for the core business logic (document conversion), combined with a total absence of documentation, significantly impacts its production readiness and maintainability. Addressing the correctness issues in `/evaluate` and enhancing resilience and documentation should be top priorities."
    } 
  }
}