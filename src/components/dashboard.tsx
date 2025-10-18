"use client"

import { useState } from "react"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import { Progress } from "@/components/ui/progress"
import { 
  BookOpen, 
  Clock, 
  TrendingUp, 
  Target, 
  Play, 
  CheckCircle,
  Globe,
  Brain,
  Lightbulb,
  Calendar
} from "lucide-react"

interface User {
  id: string
  email: string
  name?: string
  image?: string
}

interface DashboardProps {
  user: User
}

export function Dashboard({ user }: DashboardProps) {
  const [currentStreak] = useState(7)
  const [todayGoal] = useState(25)
  const [todayProgress] = useState(0)
  const [weeklyGoal] = useState(150)
  const [weeklyProgress] = useState(95)

  // Mock data - in real app, this would come from API
  const todayRecommendations = [
    {
      id: "1",
      title: "Understanding Vector Databases",
      type: "article",
      topic: "Technology",
      estimatedMinutes: 8,
      difficulty: "intermediate",
      description: "Learn how vector databases power modern AI applications"
    },
    {
      id: "2", 
      title: "Geography Quiz: European Capitals",
      type: "quiz",
      topic: "Geography",
      estimatedMinutes: 5,
      difficulty: "beginner",
      description: "Test your knowledge of European capital cities"
    },
    {
      id: "3",
      title: "Word of the Day: Serendipity",
      type: "flashcard",
      topic: "Vocabulary", 
      estimatedMinutes: 3,
      difficulty: "beginner",
      description: "Discover the meaning and usage of this beautiful word"
    }
  ]

  const morningRoutine = [
    { topic: "Geography", minutes: 8, completed: true },
    { topic: "Vocabulary", minutes: 5, completed: true },
    { topic: "Technology", minutes: 12, completed: false }
  ]

  const recentProgress = [
    { topic: "Geography", sessions: 12, mastery: 75 },
    { topic: "Vocabulary", sessions: 8, mastery: 60 },
    { topic: "Technology", sessions: 15, mastery: 85 }
  ]

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      {/* Header */}
      <header className="bg-white shadow-sm border-b">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <Brain className="h-8 w-8 text-blue-600" />
              <div>
                <h1 className="text-xl font-bold text-gray-900">Good Learning</h1>
                <p className="text-sm text-gray-600">Welcome back, {user.name || user.email}</p>
              </div>
            </div>
            <div className="flex items-center space-x-4">
              <div className="text-right">
                <p className="text-sm text-gray-600">Current Streak</p>
                <p className="text-2xl font-bold text-orange-500">{currentStreak} days</p>
              </div>
              <Button variant="outline" size="sm">
                Settings
              </Button>
            </div>
          </div>
        </div>
      </header>

      <div className="container mx-auto px-4 py-8">
        <div className="grid lg:grid-cols-3 gap-8">
          {/* Main Content */}
          <div className="lg:col-span-2 space-y-8">
            {/* Today's Progress */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center space-x-2">
                  <Target className="h-5 w-5" />
                  <span>Today&apos;s Learning Goal</span>
                </CardTitle>
                <CardDescription>
                  {todayProgress} of {todayGoal} minutes completed
                </CardDescription>
              </CardHeader>
              <CardContent>
                <Progress value={(todayProgress / todayGoal) * 100} className="mb-4" />
                <div className="flex justify-between text-sm text-gray-600">
                  <span>{todayProgress} minutes</span>
                  <span>{todayGoal} minutes</span>
                </div>
              </CardContent>
            </Card>

            {/* Morning Routine */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center space-x-2">
                  <Calendar className="h-5 w-5" />
                  <span>Morning Routine</span>
                </CardTitle>
                <CardDescription>
                  Your personalized learning routine for today
                </CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-3">
                  {morningRoutine.map((item, index) => (
                    <div key={index} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                      <div className="flex items-center space-x-3">
                        {item.completed ? (
                          <CheckCircle className="h-5 w-5 text-green-500" />
                        ) : (
                          <div className="h-5 w-5 border-2 border-gray-300 rounded-full" />
                        )}
                        <div>
                          <p className="font-medium">{item.topic}</p>
                          <p className="text-sm text-gray-600">{item.minutes} minutes</p>
                        </div>
                      </div>
                      {!item.completed && (
                        <Button size="sm">
                          <Play className="h-4 w-4 mr-1" />
                          Start
                        </Button>
                      )}
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>

            {/* Today's Recommendations */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center space-x-2">
                  <Lightbulb className="h-5 w-5" />
                  <span>Recommended for You</span>
                </CardTitle>
                <CardDescription>
                  AI-curated content based on your interests and learning patterns
                </CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  {todayRecommendations.map((item) => (
                    <div key={item.id} className="flex items-center justify-between p-4 border rounded-lg hover:bg-gray-50 transition-colors">
                      <div className="flex-1">
                        <div className="flex items-center space-x-2 mb-2">
                          <h3 className="font-medium">{item.title}</h3>
                          <Badge variant="secondary">{item.topic}</Badge>
                          <Badge variant="outline">{item.difficulty}</Badge>
                        </div>
                        <p className="text-sm text-gray-600 mb-2">{item.description}</p>
                        <div className="flex items-center space-x-4 text-xs text-gray-500">
                          <span className="flex items-center space-x-1">
                            <Clock className="h-3 w-3" />
                            <span>{item.estimatedMinutes} min</span>
                          </span>
                          <span className="capitalize">{item.type}</span>
                        </div>
                      </div>
                      <Button size="sm">
                        <Play className="h-4 w-4 mr-1" />
                        Start
                      </Button>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Sidebar */}
          <div className="space-y-6">
            {/* Weekly Progress */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center space-x-2">
                  <TrendingUp className="h-5 w-5" />
                  <span>Weekly Progress</span>
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="text-center mb-4">
                  <p className="text-3xl font-bold text-blue-600">{weeklyProgress}</p>
                  <p className="text-sm text-gray-600">of {weeklyGoal} minutes</p>
                </div>
                <Progress value={(weeklyProgress / weeklyGoal) * 100} />
              </CardContent>
            </Card>

            {/* Learning Topics */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center space-x-2">
                  <BookOpen className="h-5 w-5" />
                  <span>Your Topics</span>
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-3">
                  {recentProgress.map((topic, index) => (
                    <div key={index} className="flex items-center justify-between">
                      <div>
                        <p className="font-medium">{topic.topic}</p>
                        <p className="text-sm text-gray-600">{topic.sessions} sessions</p>
                      </div>
                      <div className="text-right">
                        <p className="text-sm font-medium">{topic.mastery}%</p>
                        <div className="w-16 bg-gray-200 rounded-full h-2">
                          <div 
                            className="bg-blue-600 h-2 rounded-full" 
                            style={{ width: `${topic.mastery}%` }}
                          />
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>

            {/* Quick Actions */}
            <Card>
              <CardHeader>
                <CardTitle>Quick Actions</CardTitle>
              </CardHeader>
              <CardContent className="space-y-2">
                <Button className="w-full justify-start" variant="outline">
                  <Globe className="h-4 w-4 mr-2" />
                  Browse Topics
                </Button>
                <Button className="w-full justify-start" variant="outline">
                  <Brain className="h-4 w-4 mr-2" />
                  View Analytics
                </Button>
                <Button className="w-full justify-start" variant="outline">
                  <Target className="h-4 w-4 mr-2" />
                  Set Goals
                </Button>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </div>
  )
}
