"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Card, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { BookOpen, Brain, Globe, Lightbulb, TrendingUp, Clock } from "lucide-react"

// eslint-disable-next-line @typescript-eslint/no-empty-object-type
interface LandingPageProps {
  // Props can be added here in the future
}

export function LandingPage({}: LandingPageProps) {
  const [isSigningIn, setIsSigningIn] = useState(false)

  const handleSignIn = () => {
    setIsSigningIn(true)
    // This will be handled by NextAuth
    window.location.href = "/api/auth/signin"
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-indigo-50">
      {/* Header */}
      <header className="container mx-auto px-4 py-6">
        <nav className="flex items-center justify-between">
          <div className="flex items-center space-x-2">
            <Brain className="h-8 w-8 text-blue-600" />
            <span className="text-2xl font-bold text-gray-900">Good Learning</span>
          </div>
          <Button onClick={handleSignIn} disabled={isSigningIn}>
            {isSigningIn ? "Signing in..." : "Get Started"}
          </Button>
        </nav>
      </header>

      {/* Hero Section */}
      <section className="container mx-auto px-4 py-16 text-center">
        <div className="max-w-4xl mx-auto">
          <h1 className="text-5xl font-bold text-gray-900 mb-6">
            Learn Something New Every Morning
          </h1>
          <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
            A personalized learning platform that adapts to your interests and learning style. 
            Spend 20-30 minutes each morning building knowledge that matters to you.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Button size="lg" onClick={handleSignIn} disabled={isSigningIn}>
              Start Learning Today
            </Button>
            <Button size="lg" variant="outline">
              Learn More
            </Button>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="container mx-auto px-4 py-16">
        <div className="text-center mb-12">
          <h2 className="text-3xl font-bold text-gray-900 mb-4">
            Why Good Learning Works
          </h2>
          <p className="text-lg text-gray-600 max-w-2xl mx-auto">
            Our AI-powered platform creates personalized learning experiences that fit your schedule and interests.
          </p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          <Card className="border-0 shadow-lg">
            <CardHeader>
              <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mb-4">
                <Brain className="h-6 w-6 text-blue-600" />
              </div>
              <CardTitle>AI-Powered Personalization</CardTitle>
              <CardDescription>
                Our system learns your preferences and recommends content that matches your learning style and interests.
              </CardDescription>
            </CardHeader>
          </Card>

          <Card className="border-0 shadow-lg">
            <CardHeader>
              <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mb-4">
                <Clock className="h-6 w-6 text-green-600" />
              </div>
              <CardTitle>Perfect for Morning Routines</CardTitle>
              <CardDescription>
                Designed for 20-30 minute sessions that fit perfectly into your morning routine.
              </CardDescription>
            </CardHeader>
          </Card>

          <Card className="border-0 shadow-lg">
            <CardHeader>
              <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mb-4">
                <Globe className="h-6 w-6 text-purple-600" />
              </div>
              <CardTitle>Diverse Learning Topics</CardTitle>
              <CardDescription>
                From geography and vocabulary to technical articles and custom topics - learn what interests you.
              </CardDescription>
            </CardHeader>
          </Card>

          <Card className="border-0 shadow-lg">
            <CardHeader>
              <div className="w-12 h-12 bg-orange-100 rounded-lg flex items-center justify-center mb-4">
                <TrendingUp className="h-6 w-6 text-orange-600" />
              </div>
              <CardTitle>Track Your Progress</CardTitle>
              <CardDescription>
                Visual progress tracking and analytics help you see your learning journey and stay motivated.
              </CardDescription>
            </CardHeader>
          </Card>

          <Card className="border-0 shadow-lg">
            <CardHeader>
              <div className="w-12 h-12 bg-red-100 rounded-lg flex items-center justify-center mb-4">
                <BookOpen className="h-6 w-6 text-red-600" />
              </div>
              <CardTitle>Multiple Content Types</CardTitle>
              <CardDescription>
                Articles, videos, quizzes, and interactive content keep your learning engaging and varied.
              </CardDescription>
            </CardHeader>
          </Card>

          <Card className="border-0 shadow-lg">
            <CardHeader>
              <div className="w-12 h-12 bg-yellow-100 rounded-lg flex items-center justify-center mb-4">
                <Lightbulb className="h-6 w-6 text-yellow-600" />
              </div>
              <CardTitle>Smart Recommendations</CardTitle>
              <CardDescription>
                Vector-based content matching ensures you discover relevant and interesting learning materials.
              </CardDescription>
            </CardHeader>
          </Card>
        </div>
      </section>

      {/* CTA Section */}
      <section className="bg-blue-600 text-white py-16">
        <div className="container mx-auto px-4 text-center">
          <h2 className="text-3xl font-bold mb-4">
            Ready to Transform Your Learning?
          </h2>
          <p className="text-xl mb-8 opacity-90">
            Join thousands of learners who start their day with Good Learning.
          </p>
          <Button size="lg" variant="secondary" onClick={handleSignIn} disabled={isSigningIn}>
            {isSigningIn ? "Signing in..." : "Start Your Learning Journey"}
          </Button>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-8">
        <div className="container mx-auto px-4 text-center">
          <div className="flex items-center justify-center space-x-2 mb-4">
            <Brain className="h-6 w-6" />
            <span className="text-xl font-bold">Good Learning</span>
          </div>
          <p className="text-gray-400">
            © 2024 Good Learning. All rights reserved.
          </p>
        </div>
      </footer>
    </div>
  )
}
