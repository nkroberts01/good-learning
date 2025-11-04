export interface Profile {
  id: string
  name: string | null
  created_at: string
}

export interface UserPreference {
  user_id: string
  category: string
  enabled: boolean
  difficulty_level: string | null
}

export interface ContentItem {
  id: string
  title: string
  content: string
  category: string
  source_url: string | null
  difficulty_level: string | null
  embedding: number[] | null
  created_at: string
}

export interface LearningSession {
  id: string
  user_id: string
  started_at: string
  ended_at: string | null
  duration_minutes: number | null
  items_completed: any
}

export interface UserInteraction {
  id: string
  user_id: string
  content_id: string
  interaction_type: 'read' | 'completed' | 'skipped'
  time_spent_seconds: number | null
  created_at: string
}

export type LearningCategory = 
  | 'geography'
  | 'vocabulary'
  | 'ai_articles'
  | 'history'
  | 'science'
  | 'technology'

