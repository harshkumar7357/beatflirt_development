# beatflirt_backend1

Node.js + Express backend with MongoDB for BeatFlirt.

## Setup

1. Copy env file:

```bash
cp .env.example .env
```

2. Update `.env` with your MongoDB connection string.

3. Run backend:

```bash
npm run dev
```

## API Endpoints

- `GET /api/health`
- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/auth/profile` (Bearer token required)
- `GET /api/cards`
- `POST /api/cards` (Bearer token required)
