import { useEffect, useState } from 'react'
import { supabase } from '../lib/supabase'
import { useNavigate } from 'react-router-dom'
import type { Profile } from '../lib/types'

export default function Dashboard() {
  const [user, setUser] = useState<any>(null)
  const [profile, setProfile] = useState<Profile | null>(null)
  const [loading, setLoading] = useState(true)
  const navigate = useNavigate()

  useEffect(() => {
    checkUser()
  }, [])

  const checkUser = async () => {
    const { data: { user } } = await supabase.auth.getUser()
    setUser(user)

    if (user) {
      const { data } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', user.id)
        .single()
      setProfile(data)
    }

    setLoading(false)
  }

  const handleSignOut = async () => {
    await supabase.auth.signOut()
    navigate('/login')
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-gray-600">Loading...</div>
      </div>
    )
  }

  if (!user) {
    navigate('/login')
    return null
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <nav className="bg-white shadow">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16">
            <div className="flex items-center">
              <h1 className="text-xl font-semibold text-gray-900">Good Learning</h1>
            </div>
            <div className="flex items-center space-x-4">
              <span className="text-gray-700">{profile?.name || user.email}</span>
              <button
                onClick={handleSignOut}
                className="text-gray-700 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium"
              >
                Sign Out
              </button>
            </div>
          </div>
        </div>
      </nav>

      <main className="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
        <div className="px-4 py-6 sm:px-0">
          <div className="bg-white overflow-hidden shadow rounded-lg">
            <div className="p-6">
              <h2 className="text-2xl font-bold text-gray-900 mb-4">Welcome back!</h2>
              <p className="text-gray-600 mb-6">
                Ready to start your learning session? Configure your preferences or begin learning.
              </p>
              <div className="flex space-x-4">
                <button
                  onClick={() => navigate('/preferences')}
                  className="px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700"
                >
                  Manage Preferences
                </button>
                <button
                  onClick={() => navigate('/session')}
                  className="px-4 py-2 bg-gray-600 text-white rounded-md hover:bg-gray-700"
                  disabled
                >
                  Start Learning Session
                  <span className="ml-2 text-xs opacity-75">(Coming soon)</span>
                </button>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  )
}

