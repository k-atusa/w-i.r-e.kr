import { NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json({
    "m.server": "wire.remotewire.net:443"
  });
}