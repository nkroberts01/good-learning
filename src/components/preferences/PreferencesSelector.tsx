import { useState, useEffect } from 'react'
import { supabase } from '../../lib/supabase'
import type { LearningCategory } from '../../lib/types'

const CATEGORIES: { value: LearningCategory; label: string; description: string }[] = [
  { value: 'geography', label: 'Geography', description: 'Learn about countries, cities, and places' },
  { value: 'vocabulary', label: 'Vocabulary', description: 'Expand your vocabulary with new words' },
  { value: 'ai_articles', label: 'AI Articles', description: 'Read technical AI articles and blog posts' },
  { value: 'history', label: 'History', description: 'Explore historical events and figures' },
  { value: 'science', label: 'Science', description: 'Discover scientific concepts and discoveries' },
  { value: 'technology', label: 'Technology', description: 'Stay updated with tech trends and news' },
]

export default function PreferencesSelector() {
  const [preferences, setPreferences] = useState<Record<string, boolean>>({})
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [success, setSuccess] = useState(false)

  useEffect(() => {
    loadPreferences()
  }, [])

  const loadPreferences = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return

      const { data, error } = await supabase
        .from('user_preferences')
        .select('category, enabled')
        .eq('user_id', user.id)

      if (error) throw error

      const prefs: Record<string, boolean> = {}
      CATEGORIES.forEach(cat => {
        const existing = data?.find((p: { category: any; enabled: any; }) => p.category === cat.value)
        prefs[cat.value] = existing?.enabled ?? false
      })

      setPreferences(prefs)
    } catch (err: any) {
      setError(err.message)
    } finally {
      setLoading(false)
    }
  }

  const toggleCategory = (category: LearningCategory) => {
    setPreferences(prev => ({
      ...prev,
      [category]: !prev[category]
    }))
  }

  const savePreferences = async () => {
    setSaving(true)
    setError(null)
    setSuccess(false)

    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) {
        throw new Error('Not authenticated')
      }

      // Delete all existing preferences
      await supabase
        .from('user_preferences')
        .delete()
        .eq('user_id', user.id)

      // Insert new preferences for enabled categories
      const enabledCategories = Object.entries(preferences)
        .filter(([_, enabled]) => enabled)
        .map(([category]) => ({
          user_id: user.id,
          category,
          enabled: true,
        }))

      if (enabledCategories.length > 0) {
        const { error } = await supabase
          .from('user_preferences')
          .insert(enabledCategories)

        if (error) throw error
      }

      setSuccess(true)
      setTimeout(() => setSuccess(false), 3000)
    } catch (err: any) {
      setError(err.message)
    } finally {
      setSaving(false)
    }
  }

  if (loading) {
    return (
      <div className="flex justify-center items-center min-h-[400px]">
        <div className="text-gray-600">Loading preferences...</div>
      </div>
    )
  }

  return (
    <div className="max-w-2xl mx-auto p-6">
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">Learning Preferences</h1>
        <p className="text-gray-600">Select what you'd like to learn during your morning routine</p>
      </div>

      {error && (
        <div className="mb-4 bg-red-50 border border-red-400 text-red-700 px-4 py-3 rounded">
          {error}
        </div>
      )}

      {success && (
        <div className="mb-4 bg-green-50 border border-green-400 text-green-700 px-4 py-3 rounded">
          Preferences saved successfully!
        </div>
      )}

      <div className="space-y-3 mb-6">
        {CATEGORIES.map((category) => (
          <label
            key={category.value}
            className="flex items-start p-4 border border-gray-200 rounded-lg cursor-pointer hover:bg-gray-50 transition-colors"
          >
            <input
              type="checkbox"
              checked={preferences[category.value] || false}
              onChange={() => toggleCategory(category.value)}
              className="mt-1 h-5 w-5 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
            />
            <div className="ml-3 flex-1">
              <div className="font-medium text-gray-900">{category.label}</div>
              <div className="text-sm text-gray-500">{category.description}</div>
            </div>
          </label>
        ))}
      </div>

      <button
        onClick={savePreferences}
        disabled={saving}
        className="w-full py-3 px-4 bg-indigo-600 text-white font-medium rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed"
      >
        {saving ? 'Saving...' : 'Save Preferences'}
      </button>
    </div>
  )
}

