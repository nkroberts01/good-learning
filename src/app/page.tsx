import { Suspense } from "react"
import { getServerSession } from "next-auth"
import { authOptions } from "@/lib/auth"
import { Dashboard } from "@/components/dashboard"
import { LandingPage } from "@/components/landing-page"

export default async function Home() {
  const session = await getServerSession(authOptions)

  if (!session) {
    return <LandingPage />
  }

  return (
    <main className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      <Suspense fallback={<div className="flex items-center justify-center min-h-screen">Loading...</div>}>
        <Dashboard user={session.user as { id: string; email: string; name?: string; image?: string }} />
      </Suspense>
    </main>
  )
}