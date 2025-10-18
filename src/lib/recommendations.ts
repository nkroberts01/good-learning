import { prisma } from "@/lib/prisma"
import { Recommendation, RecommendationRequest, Content } from "@/types"

export class RecommendationService {
  /**
   * Generate personalized content recommendations for a user
   */
  static async getRecommendations(request: RecommendationRequest): Promise<Recommendation[]> {
    const { userId, limit = 5, excludeCompleted = true, preferredTypes } = request

    // Get user preferences and interests
    const userPreferences = await prisma.userPreferences.findUnique({
      where: { userId },
      include: { user: true }
    })

    const userInterests = await prisma.userInterest.findMany({
      where: { userId },
      include: { topic: true }
    })

    // Get user's learning history
    const completedSessions = await prisma.learningSession.findMany({
      where: { 
        userId,
        completed: true
      },
      select: { contentId: true }
    })

    const completedContentIds = completedSessions.map((s: { contentId: string }) => s.contentId)

    // Build recommendation query
    const whereClause: Record<string, unknown> = {
      topic: {
        id: {
          in: userInterests.map((interest: { topicId: string }) => interest.topicId)
        }
      }
    }

    if (excludeCompleted) {
      whereClause.id = {
        notIn: completedContentIds
      }
    }

    if (preferredTypes && preferredTypes.length > 0) {
      whereClause.type = {
        in: preferredTypes
      }
    }

    // Get content based on user interests
    const content = await prisma.content.findMany({
      where: whereClause,
      include: {
        topic: true
      },
      take: limit * 2, // Get more to allow for scoring
      orderBy: {
        rating: 'desc'
      }
    })

    // Score and rank recommendations
    const recommendations = await this.scoreRecommendations(
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      content as any,
      userInterests,
      userPreferences
    )

    return recommendations.slice(0, limit)
  }

  /**
   * Score content based on user interests and preferences
   */
  private static async scoreRecommendations(
    content: Array<{
      id: string
      topicId: string
      topic: { name: string }
      difficulty: string
      type: string
      rating?: number
      createdAt: Date
      estimatedMinutes: number
      title: string
      tags: string[]
      viewCount: number
      updatedAt: Date
    }>,
    userInterests: Array<{
      topicId: string
      strength: number
    }>,
    userPreferences: {
      difficultyLevel?: string
      learningStyle?: string
      dailyGoalMinutes?: number
    } | null
  ): Promise<Recommendation[]> {
    const recommendations: Recommendation[] = []

    for (const item of content) {
      let score = 0
      const reasons: string[] = []

      // Interest strength scoring
      const interest = userInterests.find(i => i.topicId === item.topicId)
      if (interest) {
        score += interest.strength * 40 // Up to 40 points for interest strength
        reasons.push(`Matches your interest in ${item.topic.name}`)
      }

      // Difficulty preference scoring
      if (userPreferences?.difficultyLevel === item.difficulty) {
        score += 20
        reasons.push(`Matches your preferred difficulty level`)
      }

      // Content type preference scoring
      if (userPreferences?.learningStyle === 'visual' && item.type === 'video') {
        score += 15
        reasons.push('Visual content matches your learning style')
      } else if (userPreferences?.learningStyle === 'reading' && item.type === 'article') {
        score += 15
        reasons.push('Reading content matches your learning style')
      }

      // Popularity and quality scoring
      if (item.rating && item.rating > 4.0) {
        score += 10
        reasons.push('Highly rated content')
      }

      // Recency scoring (newer content gets slight boost)
      const daysSinceCreated = (Date.now() - item.createdAt.getTime()) / (1000 * 60 * 60 * 24)
      if (daysSinceCreated < 7) {
        score += 5
        reasons.push('Recently added content')
      }

      // Time-based scoring (prefer content that fits user's session length)
      if (userPreferences?.dailyGoalMinutes) {
        const timeDiff = Math.abs(item.estimatedMinutes - (userPreferences.dailyGoalMinutes / 3))
        if (timeDiff <= 5) {
          score += 10
          reasons.push('Perfect length for your learning sessions')
        }
      }

      recommendations.push({
        content: item as Content,
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        topic: item.topic as any,
        score: Math.min(score, 100), // Cap at 100
        reason: reasons.join(', ')
      })
    }

    // Sort by score descending
    return recommendations.sort((a, b) => b.score - a.score)
  }

  /**
   * Update user interests based on learning behavior
   */
  static async updateUserInterests(userId: string, topicId: string, engagementScore: number) {
    const existingInterest = await prisma.userInterest.findUnique({
      where: {
        userId_topicId: {
          userId,
          topicId
        }
      }
    })

    if (existingInterest) {
      // Update existing interest strength based on engagement
      const newStrength = Math.min(existingInterest.strength + (engagementScore / 100) * 0.1, 1.0)
      
      await prisma.userInterest.update({
        where: {
          userId_topicId: {
            userId,
            topicId
          }
        },
        data: {
          strength: newStrength
        }
      })
    } else {
      // Create new interest
      await prisma.userInterest.create({
        data: {
          userId,
          topicId,
          strength: Math.max(engagementScore / 100, 0.1)
        }
      })
    }
  }

  /**
   * Generate morning routine recommendations
   */
  static async generateMorningRoutine(userId: string, totalMinutes: number = 25) {
    const userInterests = await prisma.userInterest.findMany({
      where: { userId },
      include: { topic: true },
      orderBy: { strength: 'desc' }
    })

    const routine = []
    let remainingMinutes = totalMinutes

    // Prioritize high-interest topics
    for (const interest of userInterests.slice(0, 3)) {
      if (remainingMinutes <= 0) break

      const content = await prisma.content.findFirst({
        where: {
          topicId: interest.topicId,
          estimatedMinutes: {
            lte: remainingMinutes
          }
        },
        orderBy: {
          rating: 'desc'
        }
      })

      if (content) {
        routine.push({
          topic: interest.topic.name,
          content: content.title,
          estimatedMinutes: content.estimatedMinutes,
          contentId: content.id
        })
        remainingMinutes -= content.estimatedMinutes
      }
    }

    return routine
  }
}
