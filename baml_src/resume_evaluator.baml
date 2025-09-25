class SkillResult {
    score int
    feedback string
}

class EvaluationResult {
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

function EvaluateResume(resume: Resume, job_description: JobDescription) -> EvaluationResult {
    client CustomGemini
    prompt #"
        **Instructions:**
        You are an expert HR and Technical Recruiter. Your task is to evaluate a candidate's CV against a job description, providing a score and feedback for each of the following criteria.

        **Job Description:**
        {{job_description}}

        **Candidate's CV:**
        {{resume}}

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


test rakamin_job_description {
  functions [EvaluateResume]
  args {
        resume {
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
  }
}