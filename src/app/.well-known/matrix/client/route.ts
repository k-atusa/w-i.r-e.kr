import { NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json({
    "m.homeserver": {
      "base_url": "https://wire.remotewire.net"
    },
    "org.matrix.msc2965.authentication": {
      "issuer": "https://wire.remotewire.net"
    }
  });
}