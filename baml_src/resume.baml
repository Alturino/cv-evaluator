// Defining a data model.
class Education {
  school string
  gpa float
  max_gpa float
}

class Experience {
  company string
  position string
  location string
  start_date string
  end_date string
  description string
  responsibilities string[]
}

class Resume {
  name string
  address string
  projects string[]
  educations Education[]
  experience Experience[]
  skills string[]
}

// Create a function to extract the resume from a string.
function ExtractResume(resume: string) -> Resume {
  client "google-ai/gemini-2.5-flash"
  prompt #"
    Extract from this content:
    {{ resume }}

    {{ ctx.output_format }}
  "#
}

// Test the function with a sample resume. Open the VSCode playground to run this.
test ricky_alturino_resume {
  functions [ExtractResume]
  args {
    resume #"
      Ricky Alturino
      Software Engineer
      Palembang, Indonesia | +6285156906761 | rickyalturino001@gmail.com | LinkedIn | Github
      EXPERIENCE
      Brick
      (Remote) Jakarta, Indonesia
      L1 Engineer
      May 2024 – May 2025
      Provide cross-divisional support both in data updates and data retrieval.
       Developed, maintained applications/services.
      Campaign
      (Remote) Jakarta, Indonesia
      Android Developer Intern
      January 2023 – July 2023
       Collaborated with teams to ensure features are meeting expectations.
       Developed, maintained, and tested new features.
      Indosat Ooredoo Hutchison
      (Remote) Jakarta, Indonesia
      Android Developer Intern
      May 2022 – June 2022
      ●Lead Mobile Development Team to develop Hy.Ponics application.
      ●Researched, developed, and tested features of Hy.Ponics application.
      SKILLS
      Programming: Go, Java, Kotlin, TypeScript, Python, OOP, Design Pattern, TDD.
      Framework: Gin, Fiber, Echo, Spring Boot, Express, Hapi, NestJS, React.
      CI/CD: Github Actions, Circle CI.
      Database: PostgreSQL, MySQL, MongoDB, Redis, Memcached, Firebase.
      Message Queue/PubSub: RabbitMQ, Kafka, NATS, Firebase Cloud Messaging.
      Others: Git, Linux, Docker, Kubernetes, k6, Testcontainers, Prometheus, Grafana, Nginx, AWS, GCP.
      AWARDS
      Best Team Company Capstone, Bangkit Academy, July 2022.
      Best Team Member Company Capstone, Bangkit Academy, July 2022.
      EDUCATION
      Sriwijaya University
      Palembang, Indonesia
      Bachelor of Computer Science (GPA 3.60/4.00)
      2019 – 2023
      Coursework: Algorithm & Data Structures, Software Engineering, Database, Operating Systems
      GoTo Impact Foundation (Generasi Gigih 3.0)
      Fullstack Engineering Track(Remote) Jakarta, Indonesia
      June 2023 – December 2023
      Hacktiv8
      Backend Engineering Go(Remote) Jakarta, Indonesia
      March 2023 – April 2023
      PROJECTS
      Hedonify
      April 2024 - February 2025
      Scalable ecommerce microservices-based backend system, implemented a queue and batch processing to
      handle competing orders efficiently.
      Tech stack: Go, Docker, Microservice, PostgreSQL, Redis, OpenTelemetry.
      Open Music API
      April 2024 - September 2024
      Music backend server for dicoding course.
      Tech stack: JavaScript (Hapi), Java (Spring Boot), PostgreSQL, RabbitMQ.
      Learn Kubernetes
      April 2024 - April 2024
      Learn kubernetes deployment and database replication of MongoDB, PostgreSQL, and Redis by using
      Docker Compose and Kubernetes StatefulSet.
      Tech stack: MongoDB, PostgreSQL, Redis, Docker, Kubernetes.
      CERTIFICATIONS
      ●Google Developer: Associate Android Developer
      ●Dicoding: Android Expert | Backend Fundamental | React Fundamental | Machine Learning
      ●Hackerrank: SQL (Advanced) | Software Engineer | Problem Solving (Intermediate) | Go
      (Intermediate) | Javascript (Intermediate)
      ●Others: Android Performance.
    "#
  }
}
