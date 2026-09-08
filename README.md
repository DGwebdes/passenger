# Project Idein

...

passenger/
├── app/
│   ├── frontend/          # React/Next.js app
│   └── backend/           # Node/Express API
├── infra/
│   ├── terraform/         # provisioning: VPC, servers, DB, DNS, etc.
│   │   ├── modules/
│   │   └── envs/
│   │       ├── staging/
│   │       └── production/
│   ├── ansible/           # configuration management: server setup, deploy tasks
│   │   ├── playbooks/
│   │   └── inventories/
│   └── docker/            # Dockerfiles, docker-compose for local dev
├── .github/workflows/     # or gitlab-ci, etc. — CI/CD pipelines
├── docs/
└── README.md