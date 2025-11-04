# Good Learning - Personal Learning App

A tailored personal learning web app designed for daily 20-30 minute morning learning sessions.

## Tech Stack

- **Frontend:** React + TypeScript + Vite
- **Styling:** Tailwind CSS
- **Backend:** Supabase (Postgres + Auth)
- **Vector DB:** pgvector extension on Supabase
- **Routing:** React Router

## Setup Instructions

### 1. Install Dependencies

```bash
npm install
```

### 2. Set Up Supabase

1. Create a new project at [supabase.com](https://supabase.com)
2. Go to Project Settings > API to get your project URL and anon key
3. Create a `.env` file in the root directory:

```env
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

### 3. Set Up Database Schema

1. In your Supabase project, go to SQL Editor
2. Run the migration file: `supabase/migrations/001_initial_schema.sql`
3. This will create:
   - `profiles` table (extends auth.users)
   - `user_preferences` table
   - `content_items` table (with pgvector support)
   - `learning_sessions` table
   - `user_interactions` table
   - Row Level Security policies
   - Triggers for automatic profile creation

### 4. Enable pgvector Extension

The migration will automatically enable the pgvector extension. If you need to enable it manually:

```sql
CREATE EXTENSION IF NOT EXISTS vector;
```

### 5. Run Development Server

```bash
npm run dev
```

The app will be available at `http://localhost:5173`

## Features Implemented

### Phase 1: Foundation ✅

- ✅ User authentication (Sign up / Sign in)
- ✅ User profile management
- ✅ Preferences selection (geography, vocabulary, AI articles, etc.)
- ✅ Database schema with pgvector support
- ✅ Row Level Security policies

### Phase 2: Coming Soon

- Daily learning session page
- Content display and filtering
- Session tracking
- Content management

### Phase 3: Future Enhancements

- Vector embeddings for personalized recommendations
- User interaction tracking
- Advanced recommendation system

## Project Structure

```
good-learning/
├── src/
│   ├── components/
│   │   ├── auth/
│   │   │   ├── Login.tsx
│   │   │   └── Signup.tsx
│   │   └── preferences/
│   │       └── PreferencesSelector.tsx
│   ├── pages/
│   │   ├── Dashboard.tsx
│   │   └── Preferences.tsx
│   ├── lib/
│   │   ├── supabase.ts
│   │   └── types.ts
│   ├── App.tsx
│   └── main.tsx
├── supabase/
│   └── migrations/
│       └── 001_initial_schema.sql
└── package.json
```

## Next Steps

1. Set up your Supabase project and run the migration
2. Create a `.env` file with your Supabase credentials
3. Start the dev server and test authentication
4. Configure your learning preferences
5. Build the content delivery system (Phase 2)
