// Core types for the learning platform

export interface User {
  id: string
  email: string
  name?: string
  image?: string
  createdAt: Date
  updatedAt: Date
}

export interface UserPreferences {
  id: string
  userId: string
  dailyGoalMinutes: number
  preferredTopics: string[]
  difficultyLevel: 'beginner' | 'intermediate' | 'advanced'
  learningStyle: 'visual' | 'auditory' | 'reading' | 'mixed'
  morningReminder: boolean
  reminderTime: string
  createdAt: Date
  updatedAt: Date
}

export interface Topic {
  id: string
  name: string
  description?: string
  category: 'geography' | 'vocabulary' | 'technology' | 'custom'
  difficulty: 'beginner' | 'intermediate' | 'advanced'
  estimatedMinutes: number
  createdAt: Date
  updatedAt: Date
}

export interface Content {
  id: string
  topicId: string
  title: string
  description?: string
  type: 'article' | 'video' | 'quiz' | 'interactive' | 'flashcard'
  url?: string
  content?: string
  difficulty: 'beginner' | 'intermediate' | 'advanced'
  estimatedMinutes: number
  tags: string[]
  embedding?: number[]
  viewCount: number
  rating?: number
  createdAt: Date
  updatedAt: Date
}

export interface LearningSession {
  id: string
  userId: string
  topicId: string
  contentId: string
  contentType: string
  durationMinutes: number
  completed: boolean
  score?: number
  engagementScore?: number
  difficultyRating?: number
  createdAt: Date
  updatedAt: Date
}

export interface LearningProgress {
  id: string
  userId: string
  topicId: string
  totalSessions: number
  totalMinutes: number
  streakDays: number
  lastLearnedAt?: Date
  masteryLevel: number
  createdAt: Date
  updatedAt: Date
}

export interface UserInterest {
  id: string
  userId: string
  topicId: string
  strength: number
  preferredContentTypes: string[]
  averageSessionLength?: number
  createdAt: Date
  updatedAt: Date
}

// Recommendation system types
export interface RecommendationRequest {
  userId: string
  limit?: number
  excludeCompleted?: boolean
  preferredTypes?: string[]
}

export interface Recommendation {
  content: Content
  topic: Topic
  score: number
  reason: string
}

// Learning analytics types
export interface LearningAnalytics {
  totalSessions: number
  totalMinutes: number
  currentStreak: number
  longestStreak: number
  averageSessionLength: number
  topicsLearned: number
  masteryDistribution: {
    beginner: number
    intermediate: number
    advanced: number
  }
}

// Morning routine types
export interface MorningRoutine {
  id: string
  userId: string
  name: string
  topics: string[]
  totalEstimatedMinutes: number
  isActive: boolean
  createdAt: Date
  updatedAt: Date
}
