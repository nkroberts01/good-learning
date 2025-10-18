import { NextRequest, NextResponse } from "next/server"
import { getServerSession } from "next-auth"
import { authOptions } from "@/lib/auth"
import { RecommendationService } from "@/lib/recommendations"

export async function GET(request: NextRequest) {
  try {
    const session = await getServerSession(authOptions)
    
    if (!session?.user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 })
    }

    const { searchParams } = new URL(request.url)
    const limit = parseInt(searchParams.get("limit") || "5")
    const excludeCompleted = searchParams.get("excludeCompleted") !== "false"
    const preferredTypes = searchParams.get("types")?.split(",")

    const recommendations = await RecommendationService.getRecommendations({
      userId: session.user.email!, // Using email as user identifier for now
      limit,
      excludeCompleted,
      preferredTypes
    })

    return NextResponse.json({ recommendations })
  } catch (error) {
    console.error("Error fetching recommendations:", error)
    return NextResponse.json(
      { error: "Failed to fetch recommendations" },
      { status: 500 }
    )
  }
}
