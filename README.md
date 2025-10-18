# Good Learning - Personal Learning Platform

A tailored personal learning web app designed for 20-30 minute daily learning sessions.

## 🚀 Features

- **AI-Powered Personalization**: Vector-based recommendations using embeddings
- **Flexible Learning Modules**: Geography, vocabulary, technical articles, and custom topics
- **Progress Tracking**: Visual analytics and streak tracking
- **Morning Routine Integration**: Quick, focused learning sessions
- **Smart Recommendations**: Content matching based on user interests and learning patterns

## 🛠 Tech Stack

- **Frontend**: React 18 + TypeScript + Tailwind CSS
- **Backend**: Next.js 14 (App Router) + API Routes
- **Database**: PostgreSQL + Prisma ORM
- **Vector Database**: Chroma (development) / Pinecone (production)
- **Authentication**: NextAuth.js with Google OAuth
- **Deployment**: Vercel

## 📋 Prerequisites

- Node.js 18+ 
- PostgreSQL database
- Google OAuth credentials
- (Optional) OpenAI API key for content processing

## 🚀 Quick Start

### 1. Clone and Install

```bash
git clone <your-repo-url>
cd good-learning
npm install
```

### 2. Environment Setup

Copy the example environment file and fill in your credentials:

```bash
cp env.example .env.local
```

Required environment variables:

```env
# Database
DATABASE_URL="postgresql://username:password@localhost:5432/goodlearning"

# NextAuth.js
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET="your-secret-key-here"

# Google OAuth (get from Google Cloud Console)
GOOGLE_CLIENT_ID="your-google-client-id"
GOOGLE_CLIENT_SECRET="your-google-client-secret"

# Optional: Vector Database
PINECONE_API_KEY="your-pinecone-api-key"
PINECONE_ENVIRONMENT="your-pinecone-environment"

# Optional: OpenAI for content processing
OPENAI_API_KEY="your-openai-api-key"
```

### 3. Database Setup

```bash
# Generate Prisma client
npx prisma generate

# Run database migrations
npx prisma db push

# (Optional) Seed with sample data
npx prisma db seed
```

### 4. Start Development Server

```bash
npm run dev
```

Visit [http://localhost:3000](http://localhost:3000) to see your app!

## 🏗 Architecture Overview

### Recommendation System

The app uses a hybrid recommendation approach:

1. **Content-Based Filtering**: Vector embeddings for semantic content matching
2. **Collaborative Filtering**: User behavior and preference analysis
3. **Knowledge-Based**: Explicit user preferences and learning goals

### Data Model

- **Users**: Authentication and profile data
- **Topics**: Learning categories (geography, vocabulary, etc.)
- **Content**: Articles, videos, quizzes with vector embeddings
- **Learning Sessions**: Track user progress and engagement
- **User Interests**: Dynamic interest strength based on behavior

### Key Components

- **Dashboard**: Main learning interface with progress tracking
- **Recommendation Engine**: AI-powered content suggestions
- **Learning Modules**: Different content types and interactions
- **Analytics**: Progress visualization and insights

## 🔧 Development

### Adding New Learning Modules

1. Create content in the database with appropriate embeddings
2. Add UI components for the content type
3. Update the recommendation service to handle the new type

### Customizing Recommendations

The recommendation system can be customized by modifying:
- `src/lib/recommendations.ts` - Core recommendation logic
- `src/types/index.ts` - Type definitions
- Database schema in `prisma/schema.prisma`

### Vector Embeddings

For production, integrate with:
- **Pinecone**: Managed vector database
- **OpenAI Embeddings**: For content processing
- **Chroma**: Local development alternative

## 📊 Analytics & Insights

The platform tracks:
- Learning streaks and consistency
- Topic mastery levels
- Session engagement scores
- Content preference patterns
- Time-based learning analytics

## 🚀 Deployment

### Vercel (Recommended)

1. Connect your GitHub repository to Vercel
2. Set environment variables in Vercel dashboard
3. Deploy automatically on push to main branch

### Database Setup

For production, use a managed PostgreSQL service:
- **Vercel Postgres**
- **Supabase**
- **PlanetScale**
- **Railway**

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For questions or issues:
- Check the [Issues](https://github.com/your-username/good-learning/issues) page
- Create a new issue with detailed information
- Join our community discussions

## 🔮 Future Enhancements

- **Spaced Repetition**: Optimize learning retention
- **Social Learning**: Share progress and compete with friends
- **Mobile App**: React Native companion app
- **Advanced Analytics**: Machine learning insights
- **Content Creation**: User-generated learning materials
- **Voice Integration**: Audio-based learning modules

---

Built with ❤️ for lifelong learners everywhere.